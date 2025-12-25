import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:kitap/models/book.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Timer tetiklendiğinde kitabın hala favoride olup olmadığını sorar
  bool Function(Book book)? isStillFavorite;

  bool _initialized = false;
  static const String _channelId = 'book_reminders_channel';
  static const String _channelName = 'Kitap Hatırlatıcıları';
  static const String _channelDescription =
      'Favorilere eklenen kitaplar için bildirimler';

  // Uygulama AÇIKKEN 1 dk gibi kısa süreli hatırlatmaları garanti etmek için.
  // (Bazı cihazlarda Android planlı bildirimleri geciktirebiliyor.)
  final Map<int, Timer> _inAppTimers = {};

  Future<void> init() async {
    if (_initialized) return;

    // Timezone init
    tz.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      // Eğer timezone alınamazsa default tz.local kullanılır (bazı cihazlarda UTC kalabilir).
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_book_notification', // kendi dosya adın
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _initialized = true;
  }

  /// Android 13+ ve iOS için bildirim iznini ister.
  /// İzin verildiyse `true`, reddedildiyse `false` döner.
  Future<bool> requestPermission() async {
    if (!_initialized) {
      await init();
    }

    final androidImpl = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosImpl = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final macImpl = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macImpl != null) {
      final granted = await macImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    // Diğer platformlarda (web vb.) burada false dönmek daha güvenli.
    return false;
  }

  /// Kitap favoriye eklendiğinde anında bildirim gösterir.
  /// İzin yoksa `false` döner.
  Future<bool> showFavoriteAddedNotification({required Book book}) async {
    if (!_initialized) {
      await init();
    }

    final granted = await requestPermission();
    if (!granted) return false;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await _flutterLocalNotificationsPlugin.show(
        // Her kitap için benzersiz ID (isbn varsa)
        book.isbn.hashCode,
        'Favorilere eklendi',
        '"${book.title}" favorilere eklendi.',
        details,
        payload: book.isbn.toString(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Uygulama açıkken belirli bir süre sonra hatırlatma bildirimi gösterir.
  /// Not: Uygulama kapatılırsa/OS durdurursa timer çalışmayabilir.
  void scheduleInAppBookReminder({
    required Book book,
    Duration delay = const Duration(minutes: 1),
  }) {
    final id = book.isbn.hashCode;

    // Aynı kitap için önceki timer varsa iptal et
    _inAppTimers[id]?.cancel();

    _inAppTimers[id] = Timer(delay, () async {
      try {
        // KRİTİK KONTROL
        if (isStillFavorite != null && !isStillFavorite!(book)) {
          if (kDebugMode) {
            debugPrint(
              '[NotificationService] In-app reminder canceled (not favorite): ${book.title}',
            );
          }
          return;
        }

        await init();

        const androidDetails = AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        );

        const details = NotificationDetails(android: androidDetails);

        await _flutterLocalNotificationsPlugin.show(
          id,
          'Hatırlatıcı',
          '"${book.title}" Kitabını Okumayı Unutma!',
          details,
          payload: book.isbn.toString(),
        );
      } catch (_) {
        // sessizce yut
      } finally {
        _inAppTimers.remove(id);
      }
    });
  }

  Future<bool> scheduleBookReminder({
    required Book book,
    Duration delay = const Duration(minutes: 1),
  }) async {
    if (!_initialized) {
      await init();
    }

    final scheduledDate = tz.TZDateTime.now(tz.local).add(delay);
    if (kDebugMode) {
      debugPrint(
        '[NotificationService] scheduleBookReminder tz=${tz.local.name} now=${tz.TZDateTime.now(tz.local)} scheduled=$scheduledDate delay=$delay',
      );
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    final details = const NotificationDetails(android: androidDetails);

    // Android 12+ (API 31+) exact alarm izni gerektirebilir.
    // İzin yoksa uygulamayı çökertmek yerine inexact schedule'a düşeriz.
    AndroidScheduleMode scheduleMode =
        AndroidScheduleMode.inexactAllowWhileIdle;
    final androidImpl = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImpl != null) {
      try {
        // Kullanıcı/OS uygulama bildirimlerini komple kapattıysa burada yakalayalım.
        final enabled = await androidImpl.areNotificationsEnabled();
        if (enabled != true) {
          return false;
        }

        final canExact = await androidImpl.canScheduleExactNotifications();
        if (canExact == true) {
          scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
        } else {
          // Bazı cihazlarda/ROM'larda manifest izni olsa bile kullanıcı onayı gerekir.
          final requested = await androidImpl.requestExactAlarmsPermission();
          if (requested == true) {
            scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
          }
        }
      } catch (_) {
        // Güvenli fallback: inexactAllowWhileIdle
        scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
      }
    }

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        // Her kitap için benzersiz ID (isbn varsa)
        book.isbn.hashCode,
        'Okumayı unutma',
        '"${book.title}" kitabını okumayı unutma!',
        scheduledDate,
        details,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: book.isbn.toString(),
      );
      if (kDebugMode) {
        final pending = await _flutterLocalNotificationsPlugin
            .pendingNotificationRequests();
        debugPrint(
          '[NotificationService] zonedSchedule OK. pending=${pending.length} (ids=${pending.map((e) => e.id).toList()})',
        );
      }
      return true;
    } on PlatformException catch (e) {
      // Android 12+ exact alarm izni yoksa: exact_alarms_not_permitted
      // Fallback olarak inexact schedule ile tekrar dene.
      if (e.code == 'exact_alarms_not_permitted') {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          book.isbn.hashCode,
          'Okumayı unutma',
          '"${book.title}" kitabını okumayı unutma!',
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: book.isbn.toString(),
        );
        if (kDebugMode) {
          final pending = await _flutterLocalNotificationsPlugin
              .pendingNotificationRequests();
          debugPrint(
            '[NotificationService] fallback inexact OK. pending=${pending.length} (ids=${pending.map((e) => e.id).toList()})',
          );
        }
        return true;
      }
      if (kDebugMode) {
        debugPrint(
          '[NotificationService] zonedSchedule PlatformException code=${e.code} message=${e.message}',
        );
      }
      return false;
    } catch (_) {
      if (kDebugMode) {
        debugPrint('[NotificationService] zonedSchedule failed (unknown).');
      }
      return false;
    }
  }

  /// Belirli bir kitap için planlanmış tüm bildirimleri iptal eder
  Future<void> cancelBookNotifications(Book book) async {
    final id = book.isbn.hashCode;

    // Planlanmış sistem bildirimini iptal et
    await _flutterLocalNotificationsPlugin.cancel(id);

    // Uygulama içi timer varsa iptal et
    _inAppTimers[id]?.cancel();
    _inAppTimers.remove(id);
  }

  /// Tüm bildirimleri iptal eder
  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    for (final timer in _inAppTimers.values) {
      timer.cancel();
    }
    _inAppTimers.clear();
  }
}

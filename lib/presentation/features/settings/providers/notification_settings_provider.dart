import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsNotifier extends StateNotifier<bool> {
  NotificationSettingsNotifier() : super(false) {
    _loadSetting();
  }

  static const _key = 'notifications_enabled';

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_key);
    state = enabled ?? false;
  }

  Future<void> toggle() async {
    final newValue = !state;
    state = newValue;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, newValue);
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, enabled);
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, bool>(
      (ref) => NotificationSettingsNotifier(),
    );

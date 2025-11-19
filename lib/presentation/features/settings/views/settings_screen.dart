import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitap/core/theme/app_theme.dart';
import 'package:kitap/core/theme/provider/theme_provider.dart';
import 'package:kitap/presentation/features/auth/providers/auth_provider.dart';
import 'package:kitap/presentation/common/custom_button.dart';
import 'package:kitap/presentation/common/custom_snackbar.dart';
import 'package:kitap/presentation/features/settings/widgets/setting_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final isDarkMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı Bilgileri
            if (user != null) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        radius: 30,
                        child: Text(
                          user.email![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Hoşgeldiniz",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Görünüm Ayarları
            const Text(
              "Görünüm",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.color_lens_outlined,
                    title: "Koyu Mod",
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        themeNotifier.toggleTheme();
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Hakkında
            const Text(
              "Hakkında",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: "Uygulama Hakkında",
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),

                  SettingsTile(
                    icon: Icons.help_outline,
                    title: "Yardım ve Destek",
                    onTap: () {
                      // context.push('/help');
                      _showComingSoon(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Çıkış Butonu
            if (user != null) ...[
              CustomButton(
                text: "Çıkış Yap",
                onPressed: () {
                  _showLogoutDialog(context, ref);
                },
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundColor,
          title: const Text("Çıkış Yap"),
          content: const Text(
            "Hesabınızdan çıkış yapmak istediğinize emin misiniz?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(authRepositoryProvider).logout();

                if (context.mounted) {
                  CustomSnackbar.show(
                    context,
                    message: "Başarıyla çıkış yapıldı",
                    type: SnackbarType.success,
                  );
                  context.go("/login");
                }
              },
              child: const Text(
                "Çıkış Yap",
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundColor,
          title: const Text("Uygulama Hakkında"),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Kitap Özetleme Uygulaması",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Bu uygulama, kitapların özetlerine hızlıca erişmenizi sağlar. "
                  "ISBN tarama, anlık özetleme ve favori kitaplarınızı kaydetme gibi özellikler sunar.",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Kapat"),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    CustomSnackbar.show(
      context,
      message: "Bu özellik yakında eklenecek",
      type: SnackbarType.info,
    );
  }
}

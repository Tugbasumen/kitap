import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitap/core/theme/app_theme.dart';
import 'package:kitap/presentation/features/auth/providers/auth_provider.dart';
import 'package:kitap/presentation/common/custom_button.dart';
import 'package:kitap/presentation/common/custom_snackbar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (user != null) ...[
              const SizedBox(height: 60),

              Center(
                child: Text(
                  "Hoşgeldin ${user.email}",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 60),

            // Çıkış Butonu
            CustomButton(
              text: "Çıkış Yap",
              onPressed: () async {
                await ref.read(authRepositoryProvider).logout();

                if (context.mounted) {
                  CustomSnackbar.show(
                    context,
                    message: "Başarıyla çıkış yapıldı",
                    type: SnackbarType.success,
                  );

                  // Giriş sayfasına yönlendir
                  context.go("/login");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

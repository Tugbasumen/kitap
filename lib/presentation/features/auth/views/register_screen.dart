import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitap/core/validators/validators.dart';
import 'package:kitap/presentation/common/custom_button.dart';
import 'package:kitap/presentation/common/custom_snackbar.dart';
import 'package:kitap/presentation/common/custom_textFormField.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).register("User", email, password);

      if (mounted) {
        CustomSnackbar.show(
          context,
          message: "Kayıt başarılı!",
          type: SnackbarType.success,
        );
        context.go('/login');
      }
    } on FirebaseAuthException catch (e) {
      // <-- Sadece FirebaseAuth hatalarını yakala
      String errorMessage;

      // Hata koduna göre kullanıcı dostu mesaj belirleme
      if (e.code == 'email-already-in-use') {
        errorMessage =
            "Bu e-posta adresi zaten kullanımda. Lütfen giriş yapın veya başka bir e-posta kullanın.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Şifreniz çok zayıf. Daha güçlü bir şifre seçin.";
      } else {
        // Diğer bilinmeyen/genel hatalar için
        errorMessage = "Bilinmeyen bir hata oluştu: ${e.message}";
      }

      CustomSnackbar.show(
        context,
        message: "$errorMessage", // <-- Kullanıcı dostu mesajı göster
        type: SnackbarType.error,
      );
    } catch (e) {
      // <-- Diğer tüm hatalar için genel yakalama
      CustomSnackbar.show(
        context,
        message: "Beklenmeyen bir hata oluştu: $e",
        type: SnackbarType.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),

              //  Email
              CustomTextFormField(
                controller: _emailController,
                label: "E-posta",
                icon: Icons.email,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 12),

              //  Şifre
              CustomTextFormField(
                controller: _passwordController,
                label: "Şifre",
                icon: Icons.lock,
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 12),

              //  Şifre Onay
              CustomTextFormField(
                controller: _confirmPasswordController,
                label: "Şifreyi Onayla",
                icon: Icons.lock,
                obscureText: true,
                validator: (value) => Validators.validateConfirmPassword(
                  value,
                  _passwordController.text,
                ),
              ),
              const SizedBox(height: 20),

              //  Kayıt butonu
              CustomButton(
                isLoading: _isLoading,
                text: "Kayıt Ol",
                onPressed: _register,
                type: ButtonType.primary,
              ),
              const SizedBox(height: 12),

              //  Login yönlendirme
              CustomButton(
                text: "Zaten hesabın var mı? Giriş Yap",
                onPressed: () => context.go('/login'),
                type: ButtonType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

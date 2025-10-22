import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitap/core/validators/validators.dart';
import 'package:kitap/presentation/common/custom_button.dart';
import 'package:kitap/presentation/common/custom_snackbar.dart';
import 'package:kitap/presentation/common/custom_textFormField.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authRepositoryProvider)
          .login(_emailController.text.trim(), _passwordController.text.trim());

      if (mounted) {
        CustomSnackbar.show(
          context,
          message: "Giriş başarılı",
          type: SnackbarType.success,
        );
        context.go('/dashboard');
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: "Hata: $e",
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
              const SizedBox(height: 80),

              //  Email alanı
              CustomTextFormField(
                controller: _emailController,
                label: "E-posta",
                icon: Icons.email,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 12),

              //  Şifre alanı
              CustomTextFormField(
                controller: _passwordController,
                label: "Şifre",
                icon: Icons.lock,
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 20),

              //  Login butonu
              CustomButton(
                isLoading: _isLoading,
                text: "Giriş Yap",
                onPressed: _login,
                type: ButtonType.primary,
              ),
              const SizedBox(height: 12),

              //  Kayıt yönlendirme
              CustomButton(
                text: "Hesabın yok mu? Kayıt Ol",
                onPressed: () => context.go('/register'),
                type: ButtonType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

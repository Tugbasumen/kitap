class Validators {
  /// E-posta doğrulama
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "E-posta adresi gerekli";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Geçersiz e-posta adresi";
    }
    return null;
  }

  /// Şifre doğrulama
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Şifre gerekli";
    }
    if (value.length < 6) {
      return "Şifre en az 6 karakter olmalı";
    }
    return null;
  }

  /// Şifre tekrar doğrulama
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Şifre tekrar gerekli";
    }
    if (value != password) {
      return "Şifreler eşleşmiyor";
    }
    return null;
  }

  /// İsim doğrulama
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Ad soyad gerekli";
    }
    if (value.length < 3) {
      return "Ad soyad en az 3 karakter olmalı";
    }
    return null;
  }
}

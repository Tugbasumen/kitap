import 'package:flutter/material.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryColor = Color(0xFF552013); // Koyu kahve-kırmızı
  static const Color secondaryColor = Color(0xFFD9A441); // Daha sıcak amber
  static const Color backgroundColor = Color(0xFFF5E5E0); // Açık krem-pembe
  static const Color cardColor = Color(0xFF8B5E5E); // Orta ton kahverengi

  // Dark Mode Özel Renkler
  static const Color darkScaffoldColor = Color(0xFF1C1C1E); // Koyu arka plan
  static const Color darkCardColor = Color(0xFF2C2C2E); // Orta koyu kart/yüzey
  static const Color darkInputFillColor = Color(0xFF3A3A3C); // Input arka plan

  // Text theme (Light/Varsayılan)
  static final TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  // ThemeData (Light Theme)
  static ThemeData lightTheme = ThemeData(
    // ... (Light Theme kısmı değişmedi)
    primaryColor: primaryColor,
    primarySwatch: Colors.blue, // MaterialColor'u override etmek için
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      // const kaldırıldı
      color: AppTheme.cardColor,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      // const eklendi
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor, // İmleç rengi
      selectionHandleColor: primaryColor,
    ),
    textTheme: textTheme,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
  );

  // ThemeData (Dark Theme)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // Renkleri kendi belirlediğimiz dark mode renklerine göre ayarlayalım
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: const MaterialColor(
        // primarySwatch için uyumlu bir MaterialColor
        0xFF552013,
        <int, Color>{
          50: Color(0xFFEBE0DD),
          100: Color(0xFFC9B3AD),
          200: Color(0xFFA38075),
          300: Color(0xFF7D4D3D),
          400: Color(0xFF643026),
          500: primaryColor,
          600: Color(0xFF4D1D11),
          700: Color(0xFF43180F),
          800: Color(0xFF3A140D),
          900: Color(0xFF2C0B08),
        },
      ),
      accentColor: secondaryColor, // Vurgu rengi
      cardColor: darkCardColor,
      backgroundColor: darkScaffoldColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkScaffoldColor,
    cardColor: darkCardColor, // cardTheme'da da kullanılacak
    // Koyu temaya uygun TextTheme
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Beyaz
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Beyaz
      ),
      bodyLarge: const TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: const TextStyle(fontSize: 14, color: Colors.white60),
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Buton metin rengi için beyaz
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),

    cardTheme: const CardThemeData(
      // Yeni darkCardColor kullanılacak
      color: darkCardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkInputFillColor,
      labelStyle: const TextStyle(color: Colors.white70), // Label rengi
      hintStyle: const TextStyle(color: Colors.white54), // Hint rengi
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkCardColor),
      ), // Kenarlık rengi
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkCardColor),
      ), // Kenarlık rengi
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Buton arka planı
        foregroundColor: Colors.white, // Buton metin rengi
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          // darkTheme'daki labelLarge'a göre ayarlandı
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkCardColor, // Kart rengiyle aynı, daha koyu bir yüzey
      selectedItemColor: secondaryColor, // Vurgu rengi
      unselectedItemColor: Colors.grey,
    ),
  );
}

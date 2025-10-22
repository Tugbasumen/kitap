import 'package:flutter/material.dart';
import 'package:kitap/core/theme/app_theme.dart';
import 'package:kitap/presentation/features/book/views/book_detail_screen.dart';
import 'package:kitap/presentation/features/book/views/isbn_screen.dart';
import 'package:kitap/presentation/features/favori/views/favorites_screen.dart';
import 'package:kitap/presentation/features/settings/views/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    IsbnScreen(),
    BookDetailScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_outlined),
            label: "QR Okut",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Kitap Detay"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoriler",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
        ],
      ),
    );
  }
}

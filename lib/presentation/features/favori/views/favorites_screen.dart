import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitap/core/theme/app_theme.dart';
import 'package:kitap/models/book.dart';
import 'package:kitap/presentation/common/custom_snackbar.dart';
import 'package:kitap/presentation/features/book/providers/book_providers.dart';
import 'package:kitap/presentation/features/book/views/book_detail_screen.dart';
import 'package:kitap/presentation/features/favori/provider/favori_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorilerim')),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Henüz favori kitap eklenmedi.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final Book book = favorites[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      book.author,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: AppTheme.primaryColor,
                      ),
                      onPressed: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(book);

                        CustomSnackbar.show(
                          context,
                          message: '${book.title} favorilerden kaldırıldı',
                          type: SnackbarType.error,
                        );
                      },
                    ),

                    //  Tıklayınca detay sayfasına git
                    onTap: () {
                      ref.read(scannedIsbnProvider.notifier).state = book.isbn
                          .toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookDetailScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

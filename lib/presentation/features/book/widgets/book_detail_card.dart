import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitap/core/theme/app_theme.dart';
import 'package:kitap/models/book.dart';
import 'package:kitap/presentation/common/custom_snackbar.dart';
import 'package:kitap/presentation/features/favori/provider/favori_provider.dart';

class BookDetailCard extends ConsumerWidget {
  final Book book;

  const BookDetailCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = ref.read(favoritesProvider.notifier).isFavorite(book);

    return Center(
      child: Card(
        color: AppTheme.cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                book.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              // Yazar
              Row(
                children: [
                  const Icon(Icons.person, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      book.author,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Özet
              const Text(
                'Özet:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book.summary,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              // Alt köşeye favori butonu
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppTheme.primaryColor : Colors.grey,
                      size: 28,
                    ),
                    onPressed: () {
                      final wasFavorite = ref
                          .read(favoritesProvider.notifier)
                          .isFavorite(book);
                      ref.read(favoritesProvider.notifier).toggleFavorite(book);

                      CustomSnackbar.show(
                        context,
                        message: wasFavorite
                            ? '${book.title} favorilerden kaldırıldı'
                            : '${book.title} favorilere eklendi',
                        type: wasFavorite
                            ? SnackbarType.error
                            : SnackbarType.success,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

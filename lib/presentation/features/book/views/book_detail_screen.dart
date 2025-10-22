import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitap/core/theme/app_theme.dart';
import 'package:kitap/presentation/common/custom_button.dart';
import '../providers/book_providers.dart';
import '../widgets/book_detail_card.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kitap Bilgileri')),
      body: bookAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, _) => Center(child: Text('Hata: $err')),
        data: (book) {
          if (book == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.highlight_off,
                      size: 70,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Kitap bulunamadı',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        text: 'Kitap Özeti Oluşturmak İçin Tıkla',
                        onPressed: () {
                          context.go('/summary');
                        },
                        type: ButtonType.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: BookDetailCard(book: book),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

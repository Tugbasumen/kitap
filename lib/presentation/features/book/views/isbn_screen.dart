import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kitap/presentation/common/custom_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/book_providers.dart';
import 'book_detail_screen.dart';

class IsbnScreen extends ConsumerStatefulWidget {
  const IsbnScreen({super.key});

  @override
  ConsumerState<IsbnScreen> createState() => _ScanBookScreenState();
}

class _ScanBookScreenState extends ConsumerState<IsbnScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    final isbn = ref.watch(scannedIsbnProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap QR Okuma'),
        leading: IconButton(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          // Kamera alanı
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MobileScanner(
                  onDetect: (capture) async {
                    if (capture.barcodes.isEmpty) return;
                    final code = capture.barcodes.first.rawValue;
                    if (code != null && !scanned) {
                      scanned = true;
                      ref.read(scannedIsbnProvider.notifier).state = code;

                      // await ile navigator'ı beklet, geri dönünce scanned sıfırlanacak
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookDetailScreen(),
                        ),
                      );

                      // Geri döndüğünde scanned'ı tekrar false yap
                      setState(() {
                        scanned = false;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          // Alt bilgi alanı sadece ISBN okutulduysa göster
          if (isbn != null && isbn.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Okunan ISBN:',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isbn,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "Kitap Bilgilerini Göster",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookDetailScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitap/models/book.dart';

class BookRepository {
  final FirebaseFirestore firestore;

  BookRepository({required this.firestore});

  Future<Book?> getBookByIsbn(String isbn) async {
    int retries = 3;
    int delayMs = 500;

    for (int i = 0; i < retries; i++) {
      try {
        final doc = await firestore.collection('kitaplar2').doc(isbn).get();
        if (!doc.exists) return null;

        final data = doc.data()!..['isbn'] = doc.id;
        return Book.fromMap(data);
      } catch (e) {
        if (i == retries - 1) rethrow; // Son denemede hatayı fırlat
        await Future.delayed(Duration(milliseconds: delayMs));
        delayMs *= 2;
      }
    }
    return null;
  }
}

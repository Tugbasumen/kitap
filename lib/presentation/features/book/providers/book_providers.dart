import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/book_repository.dart';
import '../../../../models/book.dart';

final bookRepositoryProvider = Provider(
  (ref) => BookRepository(firestore: FirebaseFirestore.instance),
);

final scannedIsbnProvider = StateProvider<String?>((ref) => null);

final bookDetailProvider = FutureProvider<Book?>((ref) {
  final isbn = ref.watch(scannedIsbnProvider);
  final repo = ref.watch(bookRepositoryProvider);

  if (isbn == null) return Future.value(null);
  return repo.getBookByIsbn(isbn);
});

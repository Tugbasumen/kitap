import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitap/models/book.dart';

class FavoritesNotifier extends StateNotifier<List<Book>> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FavoritesNotifier(this.firestore, this.auth) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = auth.currentUser;
    if (user == null) return;

    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    state = snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList();
  }

  Future<void> _saveFavorite(Book book) async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(book.isbn.toString())
        .set(book.toJson());
  }

  Future<void> _removeFavorite(Book book) async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(book.isbn.toString())
        .delete();
  }

  void toggleFavorite(Book book) {
    if (state.any((b) => b.isbn == book.isbn)) {
      state = state.where((b) => b.isbn != book.isbn).toList();
      _removeFavorite(book);
    } else {
      state = [...state, book];
      _saveFavorite(book);
    }
  }

  bool isFavorite(Book book) {
    return state.any((b) => b.isbn == book.isbn);
  }
}

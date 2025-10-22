import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitap/models/book.dart';
import 'package:kitap/presentation/features/favori/repository/favori_repository.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Book>>((
  ref,
) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  return FavoritesNotifier(firestore, auth);
});

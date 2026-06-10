import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../models/app_user_model.dart';

/// Reads and writes the `users` collection.
class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestoreCollections.users);

  /// Creates or updates the user's profile document. Preserves the original
  /// `createdAt` if the document already exists.
  Future<void> saveUser({required String uid, String? email}) async {
    final ref = _users.doc(uid);
    final snapshot = await ref.get();

    final existingCreatedAt = snapshot.data()?[UserFields.createdAt];
    final createdAt = existingCreatedAt is Timestamp
        ? existingCreatedAt.toDate()
        : DateTime.now();

    final user = AppUser(userId: uid, email: email, createdAt: createdAt);
    await ref.set(user.toJson(), SetOptions(merge: true));
  }
}

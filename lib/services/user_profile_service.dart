import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  UserProfileService._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  static Future<bool> usernameExists(String username) async {
    final normalized = username.trim().toLowerCase();

    if (normalized.isEmpty) {
      return false;
    }

    final result = await _users
        .where('usernameLower', isEqualTo: normalized)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  static Future<void> createProfile({
    required String uid,
    required String username,
    required String email,
    String? displayName,
  }) async {
    final cleanUsername = username.trim();
    final normalizedUsername = cleanUsername.toLowerCase();
    final cleanEmail = email.trim();

    if (cleanUsername.isEmpty) {
      throw Exception('Username cannot be empty.');
    }

    if (cleanEmail.isEmpty) {
      throw Exception('Email cannot be empty.');
    }

    final alreadyExists = await usernameExists(cleanUsername);

    if (alreadyExists) {
      throw Exception('Username is already taken.');
    }

    await _users.doc(uid).set({
      'uid': uid,
      'username': cleanUsername,
      'usernameLower': normalizedUsername,
      'email': cleanEmail,
      'displayName': displayName?.trim().isEmpty == true
          ? null
          : displayName?.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getProfile(
    String uid,
  ) {
    return _users.doc(uid).get();
  }

  static Future<bool> profileExists(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists;
  }

  static Future<void> updateUsername({
    required String uid,
    required String username,
  }) async {
    final cleanUsername = username.trim();
    final normalizedUsername = cleanUsername.toLowerCase();

    if (cleanUsername.isEmpty) {
      throw Exception('Username cannot be empty.');
    }

    final result = await _users
        .where('usernameLower', isEqualTo: normalizedUsername)
        .limit(1)
        .get();

    for (final doc in result.docs) {
      if (doc.id != uid) {
        throw Exception('Username is already taken.');
      }
    }

    await _users.doc(uid).update({
      'username': cleanUsername,
      'usernameLower': normalizedUsername,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}


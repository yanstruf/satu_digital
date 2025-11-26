// file: lib/service/firebase.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:satu_digital/model/user_firebase_model.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<UserFirebaseModel> registerUser({
    required String email,
    required String username,
    required String password,
    required String noHp,
    required String kota,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;
    final now = DateTime.now().toIso8601String();

    final model = UserFirebaseModel(
      uid: uid,
      username: username,
      email: email,
      noHp: noHp,
      kota: kota,
      role: "user", // penting
      createdAt: now,
      updatedAt: now,
    );

    await firestore.collection('users').doc(uid).set(model.toMap());
    return model;
  }

  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final snap = await firestore.collection('users').doc(cred.user!.uid).get();
    if (!snap.exists) return null;

    return UserFirebaseModel.fromMap({'uid': cred.user!.uid, ...snap.data()!});
  }

  static Future<void> updateUser({
    required String uid,
    required String username,
    required String noHp,
    required String kota,
  }) async {
    await firestore.collection('users').doc(uid).update({
      'username': username,
      'noHp': noHp,
      'kota': kota,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> deleteUser(String uid) async {
    await firestore.collection('users').doc(uid).delete();
    // delete auth user (must be currently signed-in user)
    if (auth.currentUser != null && auth.currentUser!.uid == uid) {
      await auth.currentUser!.delete();
    }
  }
}

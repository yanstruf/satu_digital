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
    print("========================================");
    print("🔥 [REGISTER] Mulai proses registrasi...");
    print("Email      : $email");
    print("Username   : $username");
    print("No HP      : $noHp");
    print("Kota       : $kota");
    print("----------------------------------------");

    try {
      print("📌 Project Firebase: ${firestore.app.options.projectId}");
      print("📌 API Key         : ${firestore.app.options.apiKey}");
      print("📌 App ID          : ${firestore.app.options.appId}");
      print("----------------------------------------");

      print("🚀 Step 1: Create user with email & password...");
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user!;
      print("✅ Berhasil createUser!");
      print("→ UID: ${user.uid}");
      print("----------------------------------------");

      final now = DateTime.now().toIso8601String();

      final model = UserFirebaseModel(
        uid: user.uid,
        username: username,
        email: email,
        noHp: noHp,
        kota: kota,
        createdAt: now,
        updatedAt: now,
      );

      print("🚀 Step 2: Simpan ke Firestore...");
      print("Data yg dikirim:");
      print(model.toMap());
      print("----------------------------------------");

      await firestore.collection('users').doc(user.uid).set(model.toMap());

      print("✅ Data tersimpan di Firestore!");
      print("→ Collection : users");
      print("→ Document   : ${user.uid}");
      print("========================================");

      return model;
    } catch (e) {
      print("❌ ERROR SAAT REGISTER");
      print("Error detail: $e");
      print("========================================");
      rethrow;
    }
  }

  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    print("========================================");
    print("🔐 [LOGIN] Proses login dimulai...");
    print("Email : $email");
    print("----------------------------------------");

    try {
      print("🚀 Step 1: signInWithEmailAndPassword...");
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) {
        print("❌ User null setelah login.");
        return null;
      }

      print("✅ Login berhasil! UID: ${user.uid}");
      print("----------------------------------------");

      print("🚀 Step 2: Ambil data Firestore...");
      final snap = await firestore.collection('users').doc(user.uid).get();

      if (!snap.exists) {
        print("❌ Document user tidak ditemukan di Firestore!");
        return null;
      }

      print("✅ Data user ditemukan!");
      print("Data: ${snap.data()}");
      print("========================================");

      return UserFirebaseModel.fromMap({'uid': user.uid, ...snap.data()!});
    } catch (e) {
      print("❌ ERROR SAAT LOGIN");
      print("Error detail: $e");
      print("========================================");

      return null;
    }
  }
}

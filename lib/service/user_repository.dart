// file: lib/service/user_repository.dart

import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/user_firebase_model.dart';
import 'package:satu_digital/model/user_model.dart';
import 'package:satu_digital/service/firebase.dart';
import 'package:satu_digital/service/preference_handler.dart';

class UserRepository {
  final DbHelper _db = DbHelper();

  // REGISTER → Firebase + SQLite
  Future<UserFirebaseModel> register({
    required String email,
    required String username,
    required String password,
    required String noHp,
    required String kota,
  }) async {
    final firebaseUser = await FirebaseService.registerUser(
      email: email,
      username: username,
      password: password,
      noHp: noHp,
      kota: kota,
    );

    // insert local (SQLite) - store minimal data including password for local login
    await _db.insertUser(
      UserModel(
        nama: username,
        email: email,
        noHp: noHp,
        password: password,
        kota: kota,
        role: firebaseUser.role ?? "user",
      ),
    );

    return firebaseUser;
  }

  // LOGIN → Firebase then sync to SQLite
  Future<UserFirebaseModel?> login({
    required String email,
    required String password,
  }) async {
    final user = await FirebaseService.loginUser(
      email: email,
      password: password,
    );
    if (user == null) return null;

    // clear old local users and insert the logged in user
    await _db.clearUsers();
    await _db.insertUser(
      UserModel(
        nama: user.username ?? '',
        email: user.email ?? '',
        noHp: user.noHp ?? '',
        password: password,
        kota: user.kota ?? '',
        role: user.role ?? 'user',
      ),
    );

    // save session
    await SharedPrefService.saveLogin(user.email ?? '', user.role ?? 'user');

    return user;
  }

  // get latest local user (for UI)
  Future<UserModel?> getLocalUser() async {
    return await _db.getLatestUser();
  }

  // update profile both sides
  Future<void> updateProfile({
    required String uid,
    required String username,
    required String noHp,
    required String kota,
  }) async {
    // update firebase
    await FirebaseService.updateUser(
      uid: uid,
      username: username,
      noHp: noHp,
      kota: kota,
    );

    // update local SQLite - need the local id
    final local = await _db.getLatestUser();
    if (local == null) return;

    await _db.updateUserLocal(
      id: local.id!,
      username: username,
      noHp: noHp,
      kota: kota,
    );
  }

  // delete account (firebase + local) and clear session
  Future<void> deleteAccount(String uid) async {
    await FirebaseService.deleteUser(uid);
    await _db.clearUsers();
    await SharedPrefService.clearLogin();
  }
}

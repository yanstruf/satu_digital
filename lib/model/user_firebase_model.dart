class UserFirebaseModel {
  String? uid;
  String? username;
  String? email;
  String? noHp;
  String? kota;
  String? role;
  String? createdAt;
  String? updatedAt;

  UserFirebaseModel({
    this.uid,
    this.username,
    this.email,
    this.noHp,
    this.kota,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserFirebaseModel.fromMap(Map<String, dynamic> map) {
    return UserFirebaseModel(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
      noHp: map['noHp'],
      kota: map['kota'],
      role: map['role'] ?? "user",
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "noHp": noHp,
      "kota": kota,
      "role": role,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

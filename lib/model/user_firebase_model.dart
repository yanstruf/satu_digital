class UserFirebaseModel {
  String? uid;
  String username;
  String email;
  String noHp;
  String kota;
  String role;
  String? createdAt;
  String? updatedAt;

  UserFirebaseModel({
    this.uid,
    required this.username,
    required this.email,
    required this.noHp,
    required this.kota,
    this.role = "user",
    this.createdAt,
    this.updatedAt,
  });

  factory UserFirebaseModel.fromMap(Map<String, dynamic> map) {
    return UserFirebaseModel(
      uid: map['uid'],
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      noHp: map['noHp']?.toString() ?? '',
      kota: map['kota'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'noHp': noHp,
      'kota': kota,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

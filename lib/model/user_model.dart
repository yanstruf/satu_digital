class UserModel {
  final int? id;
  final String nama; // username
  final String email;
  final String noHp;
  final String password; // WAJIB, karena login lokal
  final String kota;
  final String role;

  UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.password,
    required this.kota,
    this.role = "user",
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      noHp: map['noHp']?.toString() ?? '',
      password: map['password'] ?? '',
      kota: map['kota'] ?? '',
      role: map['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'noHp': noHp,
      'password': password,
      'kota': kota,
      'role': role,
    };
  }
}

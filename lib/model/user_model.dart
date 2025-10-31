class UserModel {
  final int? id;
  final String nama;
  final String email;
  final String noHp;
  final String password;
  final String kota;
  final String? role;

  UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.password,
    required this.kota,
    this.role,
  });

  // Konversi dari Map ke Object
 factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      noHp: map['noHp'] ?? '',
      password: map['password'] ?? '',
      kota: map['kota'] ?? '',
      role: map['role'] ?? 'user',
    );
  }


  // Konversi dari Object ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'noHp': noHp,
      'password': password,
      'kota': kota,
      'role': role ?? 'user',
    };
  }
}

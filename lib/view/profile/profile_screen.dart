import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/user_model.dart';
import 'package:satu_digital/view/login_screen.dart';
import 'package:satu_digital/view/profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DbHelper dbHelper = DbHelper();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final users = await dbHelper.getUsers();
    if (users.isNotEmpty) {
      setState(() {
        _user = users.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8F8),
      appBar: AppBar(
        // backgroundColor: const Color(0xFF007C82),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Color(0xFF007C82),
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
        elevation: 0,
      ),
      body: _user == null
          ? const Center(child: Text('Belum ada data pengguna.'))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal[100],
                    child: const Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama
                  Text(
                    _user!.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _user!.email,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  // Info Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.phone, "No HP", _user!.noHp),
                          const Divider(),
                          _buildInfoRow(
                            Icons.location_on,
                            "Kota Asal",
                            _user!.kota,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilePage(user: _user!),
                            ),
                          );
                          if (result == true) _loadUser();
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text(
                          'Edit Profil',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // ==========================
                      // Tombol Hapus Akun (REVISI)
                      // ==========================
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          // Dialog Konfirmasi
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Konfirmasi Hapus"),
                              content: const Text(
                                "Apakah Anda yakin ingin menghapus akun ini? Tindakan ini tidak dapat dibatalkan.",
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Batal"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            // Hapus user dari database
                            await dbHelper.deleteUser(_user!.id!);

                            // Set state null sementara agar UI kosong
                            setState(() => _user = null);

                            // Bersihkan SharedPreferences jika auto login
                            // (hapus jika tidak pakai sharedpref)
                            final pref = await SharedPreferences.getInstance();
                            await pref.clear();

                            // Kembali ke halaman login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Akun berhasil dihapus!'),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text(
                          'Hapus Akun',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tombol Logout
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        const SizedBox(width: 10),
        Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}

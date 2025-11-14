import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/user_model.dart';
import 'package:satu_digital/view/login_screen.dart';
import 'package:satu_digital/view/profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text(
          "Pengaturan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER PROFILE
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.teal.shade200,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user!.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _user!.email,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _buildSection("Akun Saya"),
            _menuTile(Icons.person_outline, "Profil Saya", () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(user: _user!),
                ),
              );
              if (result == true) _loadUser();
            }),
            _menuTile(Icons.shopping_bag_rounded, "Tambah Produk", () {}),
            _menuTile(Icons.shopping_cart_outlined, "Pesanan Saya", () {}),
            _menuTile(Icons.favorite_border, "Wishlist", () {}),
            _menuTile(Icons.reviews, "Ulasan", () {}),

            _buildSection("Pengaturan"),
            _menuTile(Icons.lock_outline, "Keamanan Akun", () {}),
            _menuTile(Icons.notifications_none, "Notifikasi", () {}),
            _menuTile(Icons.location_on_outlined, "Alamat Pengiriman", () {}),
            _menuTile(Icons.payment, "Metode Pembayaran", () {}),

            _buildSection("Bantuan"),
            _menuTile(Icons.help_outline, "Pusat Bantuan", () {}),
            _menuTile(Icons.chat_bubble_outline, "Chat Admin", () {}),
            _menuTile(Icons.info_outline, "Tentang Aplikasi", () {}),

            const SizedBox(height: 20),

            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final pref = await SharedPreferences.getInstance();
                  await pref.clear();

                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // COMPONENT

  Widget _menuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      tileColor: Colors.white,
    );
  }

  Widget _buildSection(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade200,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}

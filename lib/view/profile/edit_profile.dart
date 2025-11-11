import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final DbHelper dbHelper = DbHelper();
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController hpController;
  late TextEditingController kotaController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.user.nama);
    emailController = TextEditingController(text: widget.user.email);
    hpController = TextEditingController(text: widget.user.noHp);
    kotaController = TextEditingController(text: widget.user.kota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF007C82),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField("Nama", namaController),
            _buildField("Email", emailController),
            _buildField("No HP", hpController),
            _buildField("Kota Asal", kotaController),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final updatedUser = UserModel(
                  id: widget.user.id,
                  nama: namaController.text,
                  email: emailController.text,
                  noHp: hpController.text,
                  password: widget.user.password,
                  kota: kotaController.text,
                );
                await dbHelper.updateUser(updatedUser);
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.save, color: Colors.white),
              label: Text(
                "Simpan Perubahan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

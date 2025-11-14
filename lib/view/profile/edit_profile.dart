import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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

            //Tombol Simpan
            ElevatedButton.icon(
              onPressed: _save,
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

            const SizedBox(height: 30),

            //Tombol Hapus Akun
            TextButton.icon(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text(
                "Hapus Akun",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //SAVE FUNCTION
  void _save() async {
    final updatedUser = UserModel(
      id: widget.user.id,
      nama: namaController.text,
      email: emailController.text,
      noHp: hpController.text,
      password: widget.user.password,
      kota: kotaController.text,
      role: widget.user.role,
    );

    await dbHelper.updateUser(updatedUser);
    Navigator.pop(context, true);
  }

  //DELETE ACCOUNT
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Akun?"),
          content: const Text(
            "Akun Anda akan dihapus permanen. Apakah Anda yakin?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                await dbHelper.deleteUser(widget.user.id!);

                Navigator.pop(context); // tutup dialog
                Navigator.pop(context, "deleted"); // kembali ke profile_screen
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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

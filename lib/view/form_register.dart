import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/user_model.dart';
import 'package:satu_digital/view/register_success.dart';
// import 'package:google_fonts/google_fonts.dart';

class FormPendaftaran extends StatefulWidget {
  const FormPendaftaran({super.key});

  @override
  State<FormPendaftaran> createState() => _FormPendaftaranState();
}

class _FormPendaftaranState extends State<FormPendaftaran> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _kotaController = TextEditingController();

  final db = DbHelper();
  List<UserModel> _listUser = [];

  UserModel? _selectedUser;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await db.getUsers();
    setState(() {
      _listUser = data.cast<UserModel>();
    });
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedUser == null) {
        // CREATE

        final newUser = UserModel(
          nama: _namaController.text,
          email: _emailController.text,
          noHp: _noHpController.text,
          password: _passwordController.text,
          kota: _kotaController.text,
          role: 'user',
        );
        await db.insertUser(newUser);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessRegister()),
        );
      } else {
        // UPDATE
        final updatedUser = UserModel(
          id: _selectedUser!.id,
          nama: _namaController.text,
          email: _emailController.text,
          noHp: _noHpController.text,
          password: _passwordController.text,
          kota: _kotaController.text,
        );
        await db.updateUser(updatedUser);
        _selectedUser = null;
      }

      _namaController.clear();
      _emailController.clear();
      _noHpController.clear();
      _passwordController.clear();
      _kotaController.clear();

      _loadUsers();
    }
  }

  void _editUser(UserModel user) {
    setState(() {
      _selectedUser = user;
      _namaController.text = user.nama;
      _emailController.text = user.email;
      _noHpController.text = user.noHp;
      _passwordController.text = user.password;
      _kotaController.text = user.kota;
    });
  }

  void _hapusUser(int id) async {
    await db.deleteUser(id);
    _loadUsers();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data berhasil dihapus ')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF007C82),
      appBar: AppBar(
        title: Text(
          _selectedUser == null ? "Form Pendaftaran" : "Edit Data Peserta",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF007C82),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Data Peserta Satu Digital",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput("Nama", _namaController),
                  _buildInput(
                    "Email",
                    _emailController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Email wajib diisi";
                      if (!v.contains('@')) return "Email tidak valid";
                      return null;
                    },
                  ),
                  _buildInput("Nomor HP", _noHpController),
                  _buildInput('Password', _passwordController),
                  _buildInput("Asal Kota", _kotaController),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _simpanData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _selectedUser == null ? "Daftar" : "Update",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Divider(color: Colors.white54),
            const SizedBox(height: 10),

            Text(
              "Peserta Terdaftar:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _listUser.isEmpty
                ? Text(
                    "Belum ada peserta.",
                    style: TextStyle(color: Colors.white),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _listUser.length,
                    itemBuilder: (context, index) {
                      final user = _listUser[index];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Text(
                              user.nama[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(user.nama),
                          subtitle: Text(
                            "${user.email}\n${user.noHp} - ${user.kota}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _editUser(user),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _hapusUser(user.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator:
            validator ??
            (v) => (v == null || v.isEmpty) ? "$label wajib diisi" : null,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

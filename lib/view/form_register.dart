import 'package:flutter/material.dart';
// import 'package:satu_digital/service/firebase.dart';
import 'package:satu_digital/service/user_repository.dart';
import 'package:satu_digital/view/register_success.dart';

class FormPendaftaranFirebase extends StatefulWidget {
  const FormPendaftaranFirebase({super.key});

  @override
  State<FormPendaftaranFirebase> createState() =>
      _FormPendaftaranFirebaseState();
}

class _FormPendaftaranFirebaseState extends State<FormPendaftaranFirebase> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _kotaController = TextEditingController();

  bool _obscurePassword = true; // 👈 visibility state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF007C82),
      appBar: AppBar(
        title: const Text(
          "Form Pendaftaran Firebase",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF007C82),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
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

              //        PASSWORD DENGAN TOGGLE
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword, // 👈 APPLY
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Password wajib diisi" : null,
                ),
              ),

              _buildInput("Asal Kota", _kotaController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Daftar",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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

  Future<void> _registerFirebase() async {
    if (_formKey.currentState!.validate()) {
      try {
        final repo = UserRepository();

        final result = await repo.register(
          email: _emailController.text.trim(),
          username: _namaController.text.trim(),
          password: _passwordController.text.trim(),
          noHp: _noHpController.text.trim(),
          kota: _kotaController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil daftar: ${result.email}")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessRegister()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal daftar: $e")));
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/product_model.dart';
import 'package:intl/intl.dart';

class ProductAddScreen extends StatefulWidget {
  final int? currentUserId;
  const ProductAddScreen({super.key, this.currentUserId});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _image = TextEditingController();

  final DbHelper db = DbHelper();
  final _formatter = NumberFormat('#,###', 'id_ID');

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    _image.dispose();
    super.dispose();
  }

  void _formatPrice(String value) {
    // Hilangkan semua karakter selain angka
    String digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      _price.value = TextEditingValue(text: '');
      return;
    }

    String formatted = _formatter.format(int.parse(digits));

    _price.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final p = ProductModel(
      name: _name.text.trim(),
      description: _desc.text.trim(),
      price:
          int.tryParse(_price.text.replaceAll('.', '').replaceAll(',', '')) ??
          0,
      image: _image.text.trim(),
      ownerId: widget.currentUserId,
      location: "Unknown",
      rating: 0.0,
    );

    await db.insertProduct(p);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: const Color(0xFF007C82),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Produk',
                ),
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Deskripsi wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _price,
                decoration: const InputDecoration(labelText: 'Harga (angka)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _formatPrice,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Harga wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _image,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar Produk',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'URL gambar wajib' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007C82),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

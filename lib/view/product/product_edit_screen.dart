import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/product_model.dart';

class ProductEditScreen extends StatefulWidget {
  final ProductModel product;
  const ProductEditScreen({super.key, required this.product});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name, _desc, _price, _image;
  final DbHelper db = DbHelper();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product.name);
    _desc = TextEditingController(text: widget.product.description);
    _price = TextEditingController(text: widget.product.price.toString());
    _image = TextEditingController(text: widget.product.image);
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    _image.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final updated = ProductModel(
      id: widget.product.id,
      name: _name.text,
      description: _desc.text,
      price: int.tryParse(_price.text) ?? widget.product.price,
      image: _image.text,
      ownerId: widget.product.ownerId,
      location: widget.product.location,
      rating: widget.product.rating,  
    );
    await db.updateProduct(updated);
    Navigator.pop(context, true);
  }

  void _delete() async {
    if (widget.product.id != null) {
      await db.deleteProduct(widget.product.id!);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk'), backgroundColor: const Color(0xFF007C82), actions: [
        IconButton(onPressed: _delete, icon: const Icon(Icons.delete, color: Colors.red))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Nama Produk'), validator: (v) => v == null || v.isEmpty ? 'Nama wajib' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 3),
              const SizedBox(height: 12),
              TextFormField(controller: _price, decoration: const InputDecoration(labelText: 'Harga (angka)'), keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Harga wajib' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _image, decoration: const InputDecoration(labelText: 'URL Gambar'), validator: (v) => v == null || v.isEmpty ? 'URL wajib' : null),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 48)), child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}

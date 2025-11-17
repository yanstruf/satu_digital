import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  final int userId;
  final int totalAmount;
  const CheckoutScreen({super.key, required this.userId, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final DbHelper db = DbHelper();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    final order = OrderModel(
      userId: widget.userId,
      customerName: _name.text,
      address: _address.text,
      phone: _phone.text,
      total: widget.totalAmount,
      createdAt: DateTime.now().toIso8601String(),
    );
    await db.createOrder(order);
    // clear cart in calling page (CartScreen handles)
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout berhasil. Terima kasih!')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), backgroundColor: const Color(0xFF007C82)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Text('Total: ${widget.totalAmount}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Nama Penerima'), validator: (v) => v == null || v.isEmpty ? 'Nama wajib' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Nomor HP'), validator: (v) => v == null || v.isEmpty ? 'Nomor wajib' : null, keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Alamat Lengkap'), maxLines: 3, validator: (v) => v == null || v.isEmpty ? 'Alamat wajib' : null),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 48)), child: const Text('Bayar / Selesaikan Order')),
            ],
          ),
        ),
      ),
    );
  }
}

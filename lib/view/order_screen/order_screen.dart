import 'package:flutter/material.dart';
import 'package:satu_digital/view/order_screen/order_card.dart';
import 'package:satu_digital/view/order_screen/order_model.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});

  // Dummy local data
  final List<OrderModel> orders = [
    OrderModel(
      id: "1",
      title: "Iklan Premium 30 Hari",
      price: "Rp 50.000",
      status: "Selesai",
      date: "12 Nov 2024",
      image: "https://via.placeholder.com/150",
    ),
    OrderModel(
      id: "2",
      title: "Boost Iklan 7 Hari",
      price: "Rp 20.000",
      status: "Dikirim",
      date: "10 Nov 2024",
      image: "https://via.placeholder.com/150",
    ),
    OrderModel(
      id: "3",
      title: "Upgrade Akun Pro",
      price: "Rp 120.000",
      status: "Menunggu Pembayaran",
      date: "5 Nov 2024",
      image: "https://via.placeholder.com/150",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF007C82),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index]);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:satu_digital/model/order_model.dart';
import 'package:satu_digital/service/order_service.dart';
import 'package:satu_digital/view/order_screen/order_card.dart';

class OrderScreen extends StatelessWidget {
  final String userId;

  OrderScreen({super.key, required this.userId});

  final orderService = OrderService();

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

      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.streamOrders(userId),
        builder: (context, snapshot) {
          /// ==================
          /// Loading
          /// ==================
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ==================
          /// No orders
          /// ==================
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada pesanan.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderCard(order: orders[index]);
            },
          );
        },
      ),
    );
  }
}

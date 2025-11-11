import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        "image": "assets/images/buah.jpg",
        "title": "Bibit Padi Premium",
        "price": "Rp 850.000",
        "status": "Dikirim",
        "date": "27 Okt 2025",
      },
      {
        "image": "assets/images/sayur.jpg",
        "title": "Pupuk Organik Cair",
        "price": "Rp 120.000",
        "status": "Selesai",
        "date": "24 Okt 2025",
      },
      {
        "image": "assets/images/elektronik.jpg",
        "title": "Alat Semprot Hama",
        "price": "Rp 320.000",
        "status": "Menunggu Pembayaran",
        "date": "26 Okt 2025",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            image: order["image"]!,
            title: order["title"]!,
            price: order["price"]!,
            status: order["status"]!,
            date: order["date"]!,
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String status;
  final String date;

  const OrderCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.status,
    required this.date,
  });

  Color _statusColor() {
    switch (status) {
      case "Selesai":
        return Colors.green;
      case "Dikirim":
        return Colors.orange;
      case "Menunggu Pembayaran":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            //Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Detail produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: _statusColor()),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: _statusColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusBox(),
          const SizedBox(height: 16),
          _buildTimeline(),
          const SizedBox(height: 16),
          _buildStoreInfo(),
          const SizedBox(height: 16),
          _buildProductInfo(),
          const SizedBox(height: 16),
          _buildShippingInfo(),
          const SizedBox(height: 16),
          _buildPaymentDetails(),
        ],
      ),

      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  // STATUS BOX
  Widget _buildStatusBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping_rounded,
            color: Colors.orange[700],
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order["status"] ?? "Status Tidak Diketahui",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(order["date"] ?? "Tanggal Tidak Tersedia"),
            ],
          ),
        ],
      ),
    );
  }

  // TIMELINE
  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _timelineItem("Pesanan Dibuat", order["createdAt"] ?? "-"),
          _divider(),
          _timelineItem("Pesanan Dikemas", order["packedAt"] ?? "-"),
          _divider(),
          _timelineItem("Dalam Pengiriman", order["shippedAt"] ?? "-"),
          _divider(),
          _timelineItem("Pesanan Selesai", order["doneAt"] ?? "-"),
        ],
      ),
    );
  }

  Widget _timelineItem(String title, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Container(height: 1, color: Colors.grey[300]),
  );

  // TOKO
  Widget _buildStoreInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront, color: Colors.teal, size: 28),
          const SizedBox(width: 12),
          Text(
            order["storeName"] ?? "Nama Toko",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // PRODUK
  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                order["image"] != null &&
                    order["image"].toString().startsWith("http")
                ? Image.network(
                    order["image"],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
          ),

          const SizedBox(width: 12),

          // Info produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order["title"] ?? "-",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Harga: ${order["price"] ?? "-"}",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Jumlah: ${order["qty"] ?? 1}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PENGIRIMAN
  Widget _buildShippingInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Pengiriman",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          _infoRow("Kurir", order["courier"] ?? "-"),
          _infoRow("No. Resi", order["trackingNumber"] ?? "-"),
          _infoRow("Alamat", order["address"] ?? "-"),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // PEMBAYARAN
  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rincian Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),

          _infoRow("Subtotal", order["subtotal"] ?? "-"),
          _infoRow("Ongkir", order["shippingCost"] ?? "-"),
          _infoRow("Diskon", order["discount"] ?? "0"),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontSize: 16)),
              Text(
                order["total"] ?? "-",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // BOTTOM BUTTON
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.teal),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Hubungi Penjual",
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Lihat Invoice"),
            ),
          ),
        ],
      ),
    );
  }
}

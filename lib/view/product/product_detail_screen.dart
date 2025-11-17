import 'package:flutter/material.dart';
import 'package:satu_digital/model/product_model.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/view/product/product_edit_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final int? currentUserId;
  final String? currentUserRole;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.currentUserId,
    this.currentUserRole,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final DbHelper db = DbHelper();
  bool _adding = false;

  Future<void> _addToCart() async {
    if (widget.currentUserId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Harus login terlebih dahulu")));
      return;
    }

    setState(() => _adding = true);

    await db.addToCart(widget.product.id!, widget.currentUserId!, qty: 1);

    setState(() => _adding = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Ditambahkan ke keranjang")));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    final bool isOwner =
        widget.currentUserId != null && widget.currentUserId == p.ownerId;

    final bool isAdmin = widget.currentUserRole == "admin";

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        backgroundColor: const Color(0xFF007C82),
        actions: [
          if (isAdmin || isOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductEditScreen(product: p),
                  ),
                );

                if (res == true) Navigator.pop(context, true);
              },
            ),
        ],
      ),
      body: ListView(
        children: [
          // GAMBAR PRODUK
          Image.network(
            p.image,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 240,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, size: 50),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAMA PRODUK
                Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // HARGA STRING (SUDAH “Rp …”)
                Text(
                  p.price as String,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // LOKASI
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      p.location,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // RATING
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      p.rating.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // DESKRIPSI
                Text(
                  p.description,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 25),

                // TOMBOL ADD CART (Admin tidak perlu)
                if (!isAdmin)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _adding ? null : _addToCart,
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Tambah ke Keranjang"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

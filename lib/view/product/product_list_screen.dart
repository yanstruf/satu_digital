import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/product_model.dart';
// import 'package:satu_digital/view/product/product_edit_screen.dart';
import 'package:satu_digital/utils/format.dart';
import 'package:satu_digital/view/product/product_add_screen.dart';
import 'package:satu_digital/view/product/product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final int? currentUserId;
  final String? currentUserRole; // "admin" or "user"
  const ProductListScreen({
    super.key,
    this.currentUserId,
    this.currentUserRole,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DbHelper db = DbHelper();
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _futureProducts = db.getAllProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = widget.currentUserRole == 'admin';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        backgroundColor: const Color(0xFF007C82),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded),
            onPressed: () async {
              // allow both admin and user to add (per pilihan A)
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductAddScreen(currentUserId: widget.currentUserId),
                ),
              );
              if (res == true) _refresh();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada produk'));
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final p = list[index];
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          product: p,
                          currentUserId: widget.currentUserId,
                          currentUserRole: widget.currentUserRole,
                        ),
                      ),
                    );
                    if (result == true) _refresh();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              p.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatRupiah(p.price),
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    p.ownerId != null
                                        ? 'Owner: ${p.ownerId}'
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.8',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
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
              },
            ),
          );
        },
      ),
    );
  }
}

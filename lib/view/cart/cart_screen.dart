import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/cart_model.dart';
import 'package:satu_digital/model/product_model.dart';
import 'package:satu_digital/utils/format.dart';
import 'package:satu_digital/view/cart/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final int currentUserId;
  const CartScreen({super.key, required this.currentUserId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DbHelper db = DbHelper();

  late Future<List<_CartWithProduct>> _futureData;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _futureData = _loadCartWithProducts();
    setState(() {});
  }

  /// LOAD CART + PRODUCT SEKALIGUS (tanpa nested FutureBuilder)
  Future<List<_CartWithProduct>> _loadCartWithProducts() async {
    final cartList = await db.getCartByUser(widget.currentUserId);

    List<_CartWithProduct> result = [];

    for (var c in cartList) {
      final p = await db.getProductById(c.productId);
      if (p != null) {
        result.add(_CartWithProduct(cart: c, product: p));
      }
    }

    return result;
  }

  /// KONVERSI “Rp 1.250.000” → 1250000
  int _priceToInt(String price) {
    String clean = price.replaceAll("Rp", "").replaceAll(".", "").replaceAll(" ", "");
    return int.tryParse(clean) ?? 0;
    // return 0 jika parsing gagal
  }

  /// HITUNG TOTAL
  int _calculateTotal(List<_CartWithProduct> list) {
    int total = 0;

    for (var item in list) {
      int harga = _priceToInt(item.product.price as String);
      total += harga * item.cart.qty;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: const Color(0xFF007C82),
      ),
      body: FutureBuilder<List<_CartWithProduct>>(
        future: _futureData,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snap.data ?? [];

          if (list.isEmpty) {
            return const Center(child: Text('Keranjang kosong'));
          }

          final total = _calculateTotal(list);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final item = list[i];
                    final product = item.product;
                    final cart = item.cart;

                    return ListTile(
                      leading: Image.network(
                        product.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      subtitle: Text('${product.price} x ${cart.qty}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () async {
                              int newQty = (cart.qty - 1).clamp(1, 999);
                              await db.updateCartQty(cart.id!, newQty);
                              _load();
                            },
                          ),
                          Text(cart.qty.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              await db.updateCartQty(cart.id!, cart.qty + 1);
                              _load();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await db.deleteCartItem(cart.id!);
                              _load();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// BAGIAN TOTAL & CHECKOUT
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Total: ${formatRupiah(total)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: total == 0
                          ? null
                          : () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckoutScreen(
                                    userId: widget.currentUserId,
                                    totalAmount: total,
                                  ),
                                ),
                              );

                              if (res == true) {
                                await db.clearCartForUser(widget.currentUserId);
                                _load();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

/// MODEL GABUNGAN (Cart + Product)
class _CartWithProduct {
  final CartModel cart;
  final ProductModel product;

  _CartWithProduct({required this.cart, required this.product});
}

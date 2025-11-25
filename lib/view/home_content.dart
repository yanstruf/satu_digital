import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:satu_digital/database/db_helper.dart';
import 'package:satu_digital/model/product_model.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final DbHelper dbHelper = DbHelper();
  late Future<List<ProductModel>> productFuture;

  final List<String> bannerImages = [
    "https://images.unsplash.com/photo-1522199710521-72d69614c702?w=1200",
    "https://images.unsplash.com/photo-1556761175-4b46a572b786?w=1200",
    "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=1200",
  ];

  final List<Map<String, String>> articles = [
    {
      "title": "5 Cara UMKM Go Digital dengan Modal Minim",
      "image":
          "https://images.unsplash.com/photo-1552664730-d307ca884978?w=600",
    },
    {
      "title": "Tips Membuat Branding Bisnis Lebih Profesional",
      "image":
          "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600",
    },
    {
      "title": "Kenapa Bisnis Butuh Website di 2025?",
      "image":
          "https://images.unsplash.com/photo-1502882702201-7029a3ee5e3c?w=600",
    },
    {
      "title": "Strategi Digital Marketing yang Cocok untuk UMKM",
      "image":
          "https://images.unsplash.com/photo-1551434678-e076c223a692?w=600",
    },
  ];

  @override
  void initState() {
    super.initState();
    productFuture = dbHelper.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Cari produk...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Banner Slider
          CarouselSlider(
            options: CarouselOptions(
              height: 160,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1,
            ),
            items: bannerImages.map((image) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[300]),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Produk Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Produk Terbaru",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("Lihat Semua", style: TextStyle(color: Colors.teal)),
            ],
          ),

          const SizedBox(height: 12),

          // Produk From SQLite
          FutureBuilder<List<ProductModel>>(
            future: productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Terjadi kesalahan saat memuat produk."),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("Belum ada produk")),
                );
              }

              final products = snapshot.data!;

              return GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  return productCard(products[index]);
                },
              );
            },
          ),

          const SizedBox(height: 25),

          // Artikel Section
          const Text(
            "Artikel",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            itemCount: articles.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return articleCard(articles[index]);
            },
          ),
        ],
      ),
    );
  }

  // --- CARD PRODUK ---
  Widget productCard(ProductModel item) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[300]),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            "Rp ${item.price}",
            style: const TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              Expanded(
                child: Text(
                  item.location,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              Text(
                item.rating.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD ARTIKEL ---
  Widget articleCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item["image"]!,
              width: 110,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(width: 110, height: 80, color: Colors.grey[300]),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              item["title"]!,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  // Dummy produk (gunakan picsum supaya aman)
  final List<Map<String, dynamic>> products = [
    {
      "name": "Premium Website",
      "price": "Rp 1.250.000",
      "location": "Bandung",
      "rating": 4.9,
      "image": "https://picsum.photos/seed/p1/600",
    },
    {
      "name": "Jasa Foto Produk",
      "price": "Rp 350.000",
      "location": "Jakarta",
      "rating": 4.7,
      "image": "https://picsum.photos/seed/p2/600",
    },
  ];

  // Dummy artikel
  final List<Map<String, String>> articles = [
    {
      "title": "Cara Membuat UMKM Go Digital",
      "image": "https://picsum.photos/seed/a1/600",
    },
    {
      "title": "Tips Branding Bisnis dengan Biaya Murah",
      "image": "https://picsum.photos/seed/a2/600",
    },
  ];

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

          // Banner Network
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              "https://picsum.photos/seed/banner1/1200/600",
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Produk
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

          GridView.builder(
            itemCount: products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return productCard(products[index]);
            },
          ),

          const SizedBox(height: 25),

          // Artikel
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
  Widget productCard(Map<String, dynamic> item) {
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
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item["image"],
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 110,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            item["name"],
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            item["price"],
            style: const TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              Text(item["location"], style: const TextStyle(fontSize: 12)),
            ],
          ),

          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              Text(
                item["rating"].toString(),
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
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item["image"]!,
              width: 110,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 110,
                height: 80,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              ),
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

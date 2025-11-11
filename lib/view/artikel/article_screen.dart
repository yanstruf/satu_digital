import 'package:flutter/material.dart';

class ArtikelPage extends StatelessWidget {
  const ArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        title: const Text(
          "Artikel & Berita",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ArtikelCard(
            imagePath: "assets/images/meme1.jpg",
            title: "Hasil Panen Padi Organik Meningkat 20%",
            date: "25 Oktober 2025",
            author: "Tim Satu Digital",
            description:
                "Petani di Jawa Tengah melaporkan peningkatan hasil panen setelah menerapkan metode pertanian organik berbasis digital.",
          ),
          ArtikelCard(
            imagePath: "assets/images/sayur.jpg",
            title: "Teknologi IoT dalam Pertanian Modern",
            date: "22 Oktober 2025",
            author: "Admin Pertanian",
            description:
                "Internet of Things membantu petani memantau kelembaban tanah dan kondisi tanaman secara real-time.",
          ),
          ArtikelCard(
            imagePath: "assets/images/buah.jpg",
            title: "5 Tips Mengelola Lahan Pertanian Efisien",
            date: "20 Oktober 2025",
            author: "Budi Farm",
            description:
                "Cara sederhana untuk memaksimalkan hasil lahan pertanian kecil tanpa biaya besar.",
          ),
        ],
      ),
    );
  }
}

class ArtikelCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String author;
  final String description;

  const ArtikelCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.author,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtikelDetailPage(
              imagePath: imagePath,
              title: title,
              date: date,
              author: author,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dari assets
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                imagePath,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Konten artikel
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$date · $author",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Baca selengkapnya...",
                    style: TextStyle(color: Colors.teal),
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

class ArtikelDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String author;
  final String description;

  const ArtikelDetailPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.author,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        title: const Text(
          "Detail Artikel",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$date · $author",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Text(description, style: const TextStyle(fontSize: 15, height: 1.5)),
          const SizedBox(height: 20),
          const Text(
            "Artikel ini disusun untuk membantu para petani memahami perkembangan terbaru di dunia pertanian digital dan modernisasi lahan.",
            style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}

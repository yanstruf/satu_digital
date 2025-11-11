import 'package:flutter/material.dart';
import 'package:satu_digital/view/artikel/article_screen.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final List<Map<String, String>> productList = [
    {'image': 'assets/images/apple.png'},
    {'image': 'assets/images/buah.jpg'},
    {'image': 'assets/images/sayur.jpg'},
    {'image': 'assets/images/elektronik.jpg'},
    {'image': 'assets/images/google.png'},
    {'image': 'assets/images/meme1.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Cari produk atau kebutuhan anda . . .",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Banner Slider Otomatis
          const AutoSlideBanner(),
          const SizedBox(height: 20),

          // Bagian Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              "Kategori",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: SizedBox(
              height: 90, // tinggi area kategori
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryIcon(
                      imagePath: 'assets/images/buah.jpg',
                      title: 'Buah',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ArtikelPage(),
                          ),
                        );
                      },
                    ),
                    CategoryIcon(
                      imagePath: 'assets/images/sayur.jpg',
                      title: 'Sayur',
                    ),
                    // CategoryIcon(
                    //   imagePath: 'assets/images/beras.jpg',
                    //   title: 'Beras',
                    // ),
                    // CategoryIcon(
                    //   imagePath: 'assets/images/ikan.jpg',
                    //   title: 'Ikan',
                    // ),
                    //   CategoryIcon(
                    //     imagePath: 'assets/images/daging.jpg',
                    //     title: 'Daging',
                    //   ),
                    //   CategoryIcon(
                    //     imagePath: 'assets/images/alat.jpg',
                    //     title: 'Peralatan',
                    //   ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Produk
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Produk",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: nanti bisa diarahkan ke halaman semua produk
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductPage()));
                },
                child: const Text(
                  "Lihat semua",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Grid Produk
          GridView.builder(
            itemCount: productList.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.67,
            ),
            itemBuilder: (context, index) {
              final product = productList[index];
              return ProductCard(imagePath: product['image']);
            },
          ),

          const SizedBox(height: 20),

          // Berita Terbaru
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF009688),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Berita terbaru",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Hasil greeding dari Budi Farm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Budi farm berhasil menghasilkan 10 ton beras dari hasil greeding",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ArtikelPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Lainnya"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Banner otomatis slide
class AutoSlideBanner extends StatefulWidget {
  const AutoSlideBanner({super.key});

  @override
  State<AutoSlideBanner> createState() => _AutoSlideBannerState();
}

class _AutoSlideBannerState extends State<AutoSlideBanner> {
  late final PageController _controller;
  int _currentPage = 0;

  final List<String> _images = [
    'assets/images/contohbanner1.png',
    'assets/images/contohbanner2.png',
    'assets/images/contohbanner3.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88); // spacing pas
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (!mounted) return;

    _currentPage = (_currentPage + 1) % _images.length;

    _controller.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.width * (9 / 16), // tinggi dinamis 16:9
      child: PageView.builder(
        controller: _controller,
        padEnds: true,
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ), // spacing antar slide
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // background blur cover
                    Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.2),
                      colorBlendMode: BlendMode.darken,
                      filterQuality: FilterQuality.low,
                    ),

                    // gambar utama tidak crop (contain)
                    Center(
                      child: Image.asset(_images[index], fit: BoxFit.contain),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Category Card
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.teal.withOpacity(0.1),
            child: Icon(icon, color: Colors.teal, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Product Card
class ProductCard extends StatelessWidget {
  final String? imagePath; // pakai nullable, biar bisa default

  const ProductCard({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: AspectRatio(
              aspectRatio: 1, // rasio 1:1 (kotak), bisa ubah jadi 3/2, 4/3, dll
              child: Image.asset(
                imagePath!,
                fit: BoxFit.cover, // isi penuh, tapi bisa sedikit terpotong
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Info Produk
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Nama Produk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  "Rp 0",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;

  const CategoryIcon({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            // Gambar kategori
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

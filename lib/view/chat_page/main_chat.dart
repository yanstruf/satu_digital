import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        title: const Text(
          "Pesan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      // List Chat
      body: ListView.builder(
        itemCount: dummyChats.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final chat = dummyChats[index];
          return InkWell(
            onTap: () {
              // nanti bisa diarahkan ke ChatDetailPage
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buka chat dengan ${chat['name']}')),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Foto profil
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage(chat['avatar']),
                  ),
                  const SizedBox(width: 12),

                  // Nama dan pesan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat['lastMessage'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Waktu dan status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time'],
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      if (chat['unread'] > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat['unread'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Dummy Data Chat
final List<Map<String, dynamic>> dummyChats = [
  {
    'name': 'Toko Budi Farm',
    'avatar': 'assets/images/avatar/avatarchat.jpg',
    'lastMessage': 'Terima kasih, pesanan Anda sedang dikemas!',
    'time': '08.45',
    'unread': 1,
  },
  {
    'name': 'AgroMart Official',
    'avatar': 'assets/images/avatar/avatarchat.jpg',
    'lastMessage': 'Produk baru sudah tersedia, silakan cek katalog kami.',
    'time': 'Kemarin',
    'unread': 1,
  },
  {
    'name': 'Pupuk Organik Sejahtera',
    'avatar': 'assets/images/avatar/avatarchat.jpg',
    'lastMessage': 'Harga pupuk naik minggu depan, beli sekarang yuk!',
    'time': 'Senin',
    'unread': 1,
  },
  {
    'name': 'Bibit Unggul Nusantara',
    'avatar': 'assets/images/avatar/avatarchat.jpg',
    'lastMessage': 'Pesanan kamu sudah dikirim, terima kasih!',
    'time': 'Minggu',
    'unread': 1,
  },
];

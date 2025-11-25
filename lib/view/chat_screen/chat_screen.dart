import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // list chat hasil dari API
  List<dynamic> chats = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  // TODO: ganti dengan API real kamu
  Future<void> _loadChats() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      chats = []; // kosong dulu, setelah API → isi
      isLoading = false;
    });
  }

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

      // BODY
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // loading indicator
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF009688)),
      );
    }

    // jika belum ada chat
    if (chats.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada obrolan",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // kalau sudah ada data API
    return ListView.builder(
      itemCount: chats.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        final chat = chats[index];

        return InkWell(
          onTap: () {
            // TODO: buka chat detail
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
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: chat['avatar'] != null
                      ? NetworkImage(chat['avatar'])
                      : null,
                  child: chat['avatar'] == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat['name'] ?? 'Pengguna',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        chat['lastMessage'] ?? '',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat['time'] ?? '',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),

                    const SizedBox(height: 4),

                    if ((chat['unread'] ?? 0) > 0)
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
    );
  }
}

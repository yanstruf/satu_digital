import 'package:flutter/material.dart';
import 'package:satu_digital/view/chat_screen/chat_screen.dart';
import 'package:satu_digital/view/home_content.dart';
import 'package:satu_digital/view/order_screen/order_screen.dart';
import 'package:satu_digital/view/setting/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    const ChatScreen(),
    OrderScreen(),
    const SettingScreen(),
    const Center(child: Text("kosong?")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF3F4F6),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF009688),
      //   title: Text(
      //     "Beranda",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications, color: Colors.white),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),

      // Halaman utama berubah sesuai tab
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Pengaturan",
          ),
        ],
      ),
    );
  }
}

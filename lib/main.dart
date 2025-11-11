import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:satu_digital/view/chat_page/chat_screen.dart';
import 'package:satu_digital/view/dashboard/admin_dashboard.dart';
import 'package:satu_digital/view/form_register.dart';
import 'package:satu_digital/view/home_screen.dart';
import 'package:satu_digital/view/login_screen.dart';
import 'package:satu_digital/view/register_success.dart';
import 'package:satu_digital/view/splash_screen.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'user_database.db');
  // await deleteDatabase(path);
  // print('Database lama dihapus');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Satu Digital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007C82)),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
      routes: {
        '/chat': (context) => const ChatPage(),
        '/splash': (context) => const SplashScreen(),
        '/daftar': (context) => const FormPendaftaran(),
        '/success': (context) => const SuccessRegister(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const AdminDashboard(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:karangsegar/pages/HomePage.dart';
import 'package:karangsegar/pages/login_page.dart';
import 'package:karangsegar/pages/admin_page.dart';
import 'package:karangsegar/pages/perangkat_desa_page.dart'; // ✅ TAMBAHAN
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cylvovmjlhfelmrnslxn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5bHZvdm1qbGhmZWxtcm5zbHhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkwNDkwOTQsImV4cCI6MjA4NDYyNTA5NH0.oSD-446k6CEjvB6xOvSXm_cAa0DQ_0KTK2KVtvX1lwA',
  );

  runApp(const DesaKarangsegarApp());
}

class DesaKarangsegarApp extends StatelessWidget {
  const DesaKarangsegarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desa Karangsegar',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: const Color(0xFFF8FAF9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
      ),

      /// 🏠 DEFAULT = PUBLIK
      home: const HomePage(),

      /// 🔁 ROUTES PUBLIK & ADMIN
      routes: {
        '/login': (context) => const LoginPage(),
        '/admin': (context) => const AdminPage(),

        // ✅ PUBLIK
        '/admin/perangkat': (context) => const PerangkatDesaPage(),
      },
    );
  }
}

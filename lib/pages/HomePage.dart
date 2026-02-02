import 'package:flutter/material.dart';
import 'package:karangsegar/MenuType.dart';

import 'package:karangsegar/section/home_section.dart';
import 'package:karangsegar/section/posts_section.dart';
import 'package:karangsegar/section/profile_section.dart';
import 'package:karangsegar/section/potensi_section.dart';
import 'package:karangsegar/section/kontak_section.dart';
import 'package:karangsegar/section/perangkat_desa.dart';


import 'package:karangsegar/widgets/navbar.dart';
import 'package:karangsegar/widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuType activeMenu = MenuType.home;

  Widget _buildContent() {
    switch (activeMenu) {
      case MenuType.profil:
        return const ProfilSection();

      case MenuType.potensi:
        return const PotensiSection();

      case MenuType.perangkat:
        return const PerangkatDesaSection();

      case MenuType.kontak:
        return const KontakSection();

      case MenuType.home:
        return Column(
          children: const [
            HomeSection(),
            SizedBox(height: 40),
            PostsSection(),
          ],
        );
      // No default case needed here!
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===============================
          // NAVBAR (FIXED DI ATAS)
          // ===============================
          Navbar(
            activeMenu: activeMenu,
            onMenuSelected: (menu) {
              setState(() => activeMenu = menu);
            },
          ),

          // ===============================
          // CONTENT (SCROLLABLE)
          // ===============================
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildContent(),
                  const SizedBox(height: 60),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

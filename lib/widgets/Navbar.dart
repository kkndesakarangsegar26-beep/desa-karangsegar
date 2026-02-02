import 'package:flutter/material.dart';
import 'package:karangsegar/MenuType.dart';

class Navbar extends StatelessWidget {
  final MenuType activeMenu;
  final Function(MenuType) onMenuSelected;

  const Navbar({
    super.key,
    required this.activeMenu,
    required this.onMenuSelected,
  });

  Widget _menuItem(String title, MenuType menu) {
    final isActive = activeMenu == menu;

    return TextButton(
      onPressed: () => onMenuSelected(menu),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.black87,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Desa Karangsegar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _menuItem('Beranda', MenuType.home),
          _menuItem('Profil Desa', MenuType.profil),
          _menuItem('Perangkat Desa', MenuType.perangkat),
          _menuItem('Potensi', MenuType.potensi),
          _menuItem('Kontak', MenuType.kontak),
          
        ],
      ),
    );
  }
}
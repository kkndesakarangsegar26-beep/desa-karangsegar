import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 24,
      ),
      color: Colors.green[800],
      child: Column(
        children: [
          Text(
            'Desa Karangsegar',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Kecamatan Pebayuran, Kabupaten Bekasi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 12 : 14,
            ),
          ),

          const SizedBox(height: 16),

          Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: 1,
          ),

          const SizedBox(height: 12),

          Text(
            '© 2026 Pemerintah Desa Karangsegar',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

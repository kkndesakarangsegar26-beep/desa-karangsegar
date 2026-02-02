import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final greenDark = Colors.green.shade900;

    return Stack(
      children: [
        // ===== BACKGROUND (GRADIENT / IMAGE SIAP) =====
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: isMobile ? 90 : 140,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                greenDark,
                Colors.green.shade800,
                Colors.green.shade600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // ===== OVERLAY (BIAR TEKS KONTRAS) =====
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.12),
        ),

        // ===== CONTENT =====
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ===== BADGE =====
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Website Resmi Pemerintah Desa',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ===== JUDUL =====
                  Text(
                    'Desa Karangsegar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 32 : 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== SUBTITLE =====
                  Text(
                    'Kecamatan Pebayuran, Kabupaten Bekasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== TAGLINE =====
                  Text(
                    'Desa Mandiri, Maju, dan Sejahtera',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),

                  const SizedBox(height: 44),

                  // ===== CTA =====
                  Wrap(
                    spacing: 18,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: greenDark,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profil-desa');// TODO: scroll / navigate ke Profil Desa
                        },
                        child: const Text(
                          'Profil Desa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      // ===== PERANGKAT DESA =====
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.85),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin/perangkat');
                        },
                        child: const Text(
                          'Perangkat Desa',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/berita-desa');// TODO: scroll / navigate ke Berita Desa
                        },
                        child: const Text(
                          'Berita Desa',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

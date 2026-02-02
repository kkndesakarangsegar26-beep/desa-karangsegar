import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  bool showFullDesc = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final session = Supabase.instance.client.auth.currentUser;

    final greenDark = Colors.green.shade800;
    final greenSoft = Colors.green.shade50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= HERO =================
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: isMobile ? 70 : 110,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [greenDark, Colors.green.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Website Resmi\nDesa Karangsegar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 26 : 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kecamatan Pebayuran, Kabupaten Bekasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              if (session == null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Login Admin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: greenDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
            ],
          ),
        ),

        // ================= DESKRIPSI =================
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: 80,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: greenSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sekilas Desa Karangsegar',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: greenDark,
                          ),
                    ),

                    const SizedBox(height: 24),

                    _paragraph(
                      'Desa Karangsegar terletak di Kecamatan Pebayuran, Kabupaten Bekasi. '
                      'Secara geografis, Kecamatan Pebayuran berbatasan dengan Kabupaten Karawang '
                      'di sebelah utara dan timur, Kecamatan Cabangbungin di sebelah utara, '
                      'Kecamatan Sukakarya di sebelah barat, serta Kecamatan Kedungwaringin '
                      'di sebelah selatan.',
                    ),

                    if (showFullDesc) ...[
                      const SizedBox(height: 20),
                      _paragraph(
                        'Desa Karangsegar berada di bagian utara Desa Karangreja dan merupakan '
                        'salah satu desa dalam wilayah Kecamatan Pebayuran. Wilayah desa ini '
                        'merupakan dataran rendah dengan ketinggian rata-rata sekitar 4 meter '
                        'di atas permukaan laut.',
                      ),
                      const SizedBox(height: 20),
                      _paragraph(
                        'Sekitar 80% wilayah Desa Karangsegar dimanfaatkan sebagai kawasan '
                        'pertanian lahan basah, sedangkan 20% lainnya digunakan untuk permukiman '
                        'dan kebutuhan lainnya. Kondisi ini menjadikan Karangsegar sebagai desa '
                        'dengan karakter agraris yang kuat.',
                      ),
                      const SizedBox(height: 20),
                      _paragraph(
                        'Sebagian besar penduduk menggantungkan kehidupan pada sektor pertanian, '
                        'terutama sebagai buruh tani. Dengan potensi tersebut, Desa Karangsegar '
                        'memiliki peran penting dalam mendukung sektor pertanian di Kabupaten Bekasi.',
                      ),
                    ],

                    const SizedBox(height: 24),

                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          showFullDesc = !showFullDesc;
                        });
                      },
                      icon: Icon(
                        showFullDesc
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: greenDark,
                      ),
                      label: Text(
                        showFullDesc
                            ? 'Tutup deskripsi'
                            : 'Baca selengkapnya',
                        style: TextStyle(
                          color: greenDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ================= BERITA =================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Berita & Informasi Desa',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: greenDark,
                    ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Informasi terbaru seputar kegiatan dan pengumuman Desa Karangsegar.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 32),
              // PostsSection nanti di sini
            ],
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  static Widget _paragraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        height: 1.8,
        color: Colors.black87,
      ),
    );
  }
}

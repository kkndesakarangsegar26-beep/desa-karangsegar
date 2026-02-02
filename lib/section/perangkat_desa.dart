import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:karangsegar/widgets/perangkat_card.dart';

class PerangkatDesaSection extends StatelessWidget {
  const PerangkatDesaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 80,
      ),
      child: FutureBuilder<List<dynamic>>(
        future: Supabase.instance.client
            .from('perangkat_desa')
            .select()
            .order('urutan'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          // helper filter
          List<Map<String, dynamic>> byKategori(String k) =>
              data.where((e) => e['kategori'] == k).cast<Map<String, dynamic>>().toList();

          final kepala = byKategori('kepala');
          final sekdes = byKategori('sekdes');
          final kegiatan = byKategori('kegiatan');
          final seksi = byKategori('seksi');
          final dusun = byKategori('dusun');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Struktur Perangkat Desa',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
              ),
              const SizedBox(height: 50),

              // ================= KEPALA DESA =================
              _single(kepala),

              const SizedBox(height: 30),

              // ================= SEKDES =================
              _single(sekdes),

              const SizedBox(height: 40),
              const Divider(),

              // ================= KEGIATAN & SEKSI =================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _group('Kegiatan', kegiatan)),
                  const SizedBox(width: 30),
                  Expanded(child: _group('Seksi', seksi)),
                ],
              ),

              const SizedBox(height: 40),
              const Divider(),

              // ================= DUSUN =================
              _group('Dusun', dusun, grid: true),
            ],
          );
        },
      ),
    );
  }

  // ===== helper widget =====

  Widget _single(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const PerangkatCard(
        nama: 'Belum diisi',
        jabatan: '-',
        photoUrl: null,
      );
    }

    final d = data.first;
    return PerangkatCard(
      nama: d['nama'],
      jabatan: d['jabatan'],
      photoUrl: d['photo_url'],
    );
  }

  Widget _group(
    String title,
    List<Map<String, dynamic>> data, {
    bool grid = false,
  }) {
    if (data.isEmpty) {
      return Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const PerangkatCard(
            nama: 'Belum diisi',
            jabatan: '-',
            photoUrl: null,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        grid
            ? Wrap(
                spacing: 20,
                runSpacing: 20,
                children: data
                    .map((d) => SizedBox(
                          width: 220,
                          child: PerangkatCard(
                            nama: d['nama'],
                            jabatan: d['jabatan'],
                            photoUrl: d['photo_url'],
                          ),
                        ))
                    .toList(),
              )
            : Column(
                children: data
                    .map((d) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: PerangkatCard(
                            nama: d['nama'],
                            jabatan: d['jabatan'],
                            photoUrl: d['photo_url'],
                          ),
                        ))
                    .toList(),
              ),
      ],
    );
  }
}

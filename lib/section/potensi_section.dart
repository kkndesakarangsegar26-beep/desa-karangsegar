import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/potensi_card.dart';

class PotensiSection extends StatelessWidget {
  const PotensiSection({super.key});

  IconData _iconByKategori(String kategori) {
    switch (kategori) {
      case 'pertanian':
        return Icons.grass;
      case 'umkm':
        return Icons.store;
      default:
        return Icons.eco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Potensi Desa',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          FutureBuilder(
            future: Supabase.instance.client
                .from('potensi_desa')
                .select()
                .order('kategori'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Text('Gagal memuat potensi desa');
              }

              final data = snapshot.data as List;

              if (data.isEmpty) {
                return const Text('Belum ada data potensi desa');
              }

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: data.map((item) {
                  return PotensiCard(
                    title: item['nama'],
                    desc: item['deskripsi'],
                    photoUrl: item['photo_url'],
                    icon: _iconByKategori(item['kategori']),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

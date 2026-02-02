import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilSection extends StatelessWidget {
  const ProfilSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final greenDark = Colors.green.shade800;

    return FutureBuilder<List<dynamic>>(
      future: Supabase.instance.client.from('profil_desa').select().limit(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(80),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(80),
            child: Center(
              child: Text(
                'Data profil desa belum tersedia',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        final data = snapshot.data!.first as Map<String, dynamic>;

        final int laki = (data['jumlah_laki'] as int?) ?? 0;
        final int perempuan = (data['jumlah_perempuan'] as int?) ?? 0;
        final int total = laki + perempuan;

        final int dusun = (data['jumlah_dusun'] as int?) ?? 0;
        final String ketinggian = data['ketinggian'] ?? '-';

        final double lat =
            (data['latitude'] as num?)?.toDouble() ?? -6.11363;
        final double lng =
            (data['longitude'] as num?)?.toDouble() ?? 107.24725;

        final LatLng desaLocation = LatLng(lat, lng);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: 90,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== JUDUL =====
                  Text(
                    'Profil Desa Karangsegar',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: greenDark,
                        ),
                  ),

                  const SizedBox(height: 36),

                  // ===== DESKRIPSI =====
                  _card(
                    child: Text(
                      data['deskripsi'] ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.9,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ===== STATISTIK =====
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      _statCard(
                        'Penduduk',
                        '$total Jiwa',
                        Icons.groups,
                      ),
                      _statCard(
                        'Dusun',
                        '$dusun Dusun',
                        Icons.home_work,
                      ),
                      _statCard(
                        'Ketinggian',
                        ketinggian,
                        Icons.terrain,
                      ),
                    ],
                  ),

                  const SizedBox(height: 64),

                  // ===== DATA PENDUDUK =====
                  _sectionTitle('Data Kependudukan'),
                  const SizedBox(height: 20),

                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dataRow('Laki-laki', '$laki jiwa'),
                        _dataRow('Perempuan', '$perempuan jiwa'),
                        const Divider(height: 28),
                        _dataRow(
                          'Total Penduduk',
                          '$total jiwa',
                          bold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 64),

                  // ===== VISI =====
                  _sectionTitle('Visi Desa'),
                  const SizedBox(height: 16),
                  _highlightBox(data['visi']),

                  const SizedBox(height: 40),

                  // ===== MISI =====
                  _sectionTitle('Misi Desa'),
                  const SizedBox(height: 16),
                  _highlightBox(data['misi']),

                  const SizedBox(height: 72),

                  // ===== MAP =====
                  _sectionTitle('Lokasi Geografis'),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: isMobile ? 320 : 460,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: desaLocation,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('desa'),
                            position: desaLocation,
                            infoWindow: const InfoWindow(
                              title: 'Desa Karangsegar',
                              snippet: 'Kec. Pebayuran, Kab. Bekasi',
                            ),
                          ),
                        },
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===== COMPONENT =====

  static Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: child,
    );
  }

  static Widget _statCard(String label, String value, IconData icon) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green.shade50,
      ),
      child: Column(
        children: [
          Icon(icon, size: 44, color: Colors.green.shade800),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget _highlightBox(String? text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.green.shade50,
      ),
      child: Text(
        (text != null && text.isNotEmpty) ? text : '-',
        style: const TextStyle(
          fontSize: 16,
          height: 1.8,
        ),
      ),
    );
  }

  static Widget _dataRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

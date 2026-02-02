import 'package:flutter/material.dart';

class KontakSection extends StatelessWidget {
  const KontakSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Kontak Desa',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text('Alamat: Desa Karangsegar, Kabupaten Bekasi'),
          SizedBox(height: 10),
          Text('Email: desa.karangsegar@gmail.com'),
          SizedBox(height: 10),
          Text('Telepon: 08xxxxxxxxxx'),
        ],
      ),
    );
  }
}

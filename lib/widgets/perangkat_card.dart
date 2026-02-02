import 'package:flutter/material.dart';

class PerangkatCard extends StatelessWidget {
  final String nama;
  final String jabatan;
  final String? photoUrl;

  const PerangkatCard({
    super.key,
    required this.nama,
    required this.jabatan,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.green.shade50,
            backgroundImage:
                photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null
                ? Icon(
                    Icons.person,
                    size: 46,
                    color: Colors.green.shade400,
                  )
                : null,
          ),
          const SizedBox(height: 18),
          Text(
            nama,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            jabatan,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

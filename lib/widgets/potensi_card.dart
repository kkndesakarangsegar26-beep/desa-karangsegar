import 'package:flutter/material.dart';

class PotensiCard extends StatelessWidget {
  final String title;
  final String? desc;
  final String? photoUrl;
  final IconData icon;

  const PotensiCard({
    super.key,
    required this.title,
    this.desc,
    this.photoUrl,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===== FOTO =====
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: photoUrl != null
                ? Image.network(
                    photoUrl!,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(),
                  )
                : _fallback(),
          ),

          // ===== TEXT =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (desc != null) ...[
                  const SizedBox(height: 6),
                  Text(desc!, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback() {
    return Container(
      height: 140,
      color: Colors.green[50],
      child: Icon(icon, size: 50, color: Colors.green),
    );
  }
}

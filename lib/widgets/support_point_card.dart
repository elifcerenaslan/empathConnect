import 'package:flutter/material.dart';
import '../models/support_point.dart';

class SupportPointCard extends StatelessWidget {
  final SupportPoint point;
  final VoidCallback onMapTap;
  final VoidCallback onCallTap;

  const SupportPointCard({
    super.key,
    required this.point,
    required this.onMapTap,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve Tür
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    point.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary, // Nane yeşili arka plan
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    point.type,
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(point.address, style: TextStyle(color: Colors.grey[600])),
            const Divider(height: 30),
            
            // Butonlar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Yol Tarifi Butonu
                TextButton.icon(
                  onPressed: onMapTap,
                  icon: Icon(Icons.map_outlined, color: colorScheme.primary),
                  label: Text('Yol Tarifi', style: TextStyle(color: colorScheme.primary)),
                ),
                // Ara Butonu
                TextButton.icon(
                  onPressed: onCallTap,
                  icon: const Icon(Icons.call, color: Colors.green),
                  label: const Text('Ara', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
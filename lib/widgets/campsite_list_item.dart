import 'package:flutter/material.dart';
import '../models/campsite.dart';

class CampsiteListItem extends StatelessWidget {
  final Campsite campsite;
  final VoidCallback onTap;

  const CampsiteListItem({
    Key? key,
    required this.campsite,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                campsite.photo,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          campsite.label,
                          style: textTheme.titleLarge,
                        ),
                      ),
                      if (campsite.closeToWater) ...[
                        const Icon(Icons.water_drop, size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                      ],
                      if (campsite.campFireAllowed) ...[
                        const Icon(Icons.local_fire_department, size: 20, color: Colors.orange),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        campsite.country,
                        style: textTheme.bodyMedium,
                      ),
                      Spacer(),
                      Text(
                        '€${campsite.pricePerNight.toStringAsFixed(2)}/Night',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

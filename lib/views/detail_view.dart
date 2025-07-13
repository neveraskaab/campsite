import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/campsite.dart';

class DetailView extends StatefulWidget {
  final Campsite campsite;
  const DetailView({super.key, required this.campsite});

  @override
  createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favorite_${widget.campsite.id}';
    setState(() => _isFavorite = prefs.getBool(key) ?? false);
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favorite_${widget.campsite.id}';
    final newFav = !_isFavorite;
    await prefs.setBool(key, newFav);
    setState(() => _isFavorite = newFav);
  }

  @override
  Widget build(BuildContext context) {
    final theme     = Theme.of(context).textTheme;
    final languages = widget.campsite.hostLanguages
        .map((e) => LocaleNames.of(context)?.nameOf(e) ?? e)
        .toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.network(
            widget.campsite.photo,
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.campsite.label, style: theme.headlineSmall),
              const SizedBox(height: 4),
              Text(widget.campsite.country, style: theme.titleMedium),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Description', style: theme.titleMedium),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Nestled in the heart of nature, this cozy campsite offers breathtaking views, '
                  'rustic charm, and easy access to nearby hiking trails and water activities. '
                  'Whether you’re here to relax by the fire or explore the wilderness, our site '
                  'provides the perfect escape.',
              style: theme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                if (widget.campsite.closeToWater)
                  Chip(
                    avatar: const Icon(Icons.water_drop, size: 20, color: Colors.blue),
                    label: const Text('Water Nearby'),
                  ),
                if (widget.campsite.campFireAllowed)
                  Chip(
                    avatar: const Icon(Icons.local_fire_department, size: 20, color: Colors.orange),
                    label: const Text('Campfire Allowed'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Host', style: theme.titleMedium),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=${widget.campsite.id}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Alex Johnson', style: theme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Experienced outdoor enthusiast and eco-tourism advocate who loves sharing '
                      'the beauty of nature with guests.',
                  style: theme.bodyMedium,
                ),
              ])),
            ]),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Languages spoken by the host', style: theme.titleMedium),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: languages.map((lang) => Chip(label: Text(lang))).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Location', style: theme.titleMedium),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(widget.campsite.latitude, widget.campsite.longitude),
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.aab.campsite',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(widget.campsite.latitude, widget.campsite.longitude),
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            '€${widget.campsite.pricePerNight.toStringAsFixed(2)}/Night',
            style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sorry, this feature is not implemented yet.')),
              );
            },
            child: const Text('Buy Now'),
          ),
        ]),
      ),
    );
  }
}

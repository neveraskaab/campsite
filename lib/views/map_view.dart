import 'package:campsite/views/detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import '../models/campsite.dart';
import '../providers/campsite_provider.dart';
import '../widgets/filter_selection.dart';
import '../widgets/campsite_list_skeleton.dart';

class MapViewPage extends ConsumerWidget {
  const MapViewPage({super.key});

  void _openFilterDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Filters')),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: FiltersSection(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter markers',
            onPressed: () => _openFilterDialog(context),
          ),
        ],
      ),
      body: ref.watch(campsiteListProvider).when(
        data: (_) {
          final campsites = ref.watch(filteredCampsites);
          final markers = campsites.map((c) {
            return Marker(
              point: LatLng(c.latitude, c.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showCampsitePopup(context, c),
                child: Icon(
                  Icons.location_on,
                  size:  30,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            );
          }).toList();

          return FlutterMap(
            options: MapOptions(
              initialCenter: markers.isNotEmpty
                  ? markers.first.point
                  : LatLng(0, 0),
              initialZoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://mt{s}.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}',
                subdomains: const ['0', '1', '2', '3'],
                retinaMode: true,
              ),

              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  showPolygon: false,
                  padding: EdgeInsets.all(20),
                  maxClusterRadius: 50,
                  size: const Size(25, 25),
                  markers: markers,
                  builder: (context, count) {
                    return
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${count.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const CampsiteListSkeleton(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showCampsitePopup(BuildContext context, Campsite campsite) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailView(campsite: campsite)),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
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
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            campsite.label,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        if (campsite.closeToWater) ...[
                          const Icon(Icons.water_drop,
                              size: 20, color: Colors.blue),
                          const SizedBox(width: 8),
                        ],
                        if (campsite.campFireAllowed) ...[
                          const Icon(Icons.local_fire_department,
                              size: 20, color: Colors.orange),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          campsite.country,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          '€${campsite.pricePerNight.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

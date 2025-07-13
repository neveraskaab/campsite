import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/campsite_provider.dart';
import '../widgets/campsite_list_item.dart';
import '../widgets/campsite_list_skeleton.dart';
import '../widgets/filter_selection.dart';
import 'detail_view.dart';
import 'map_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  void _openFilterDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Filters')),
          body: Padding(
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
        title: const Text('Campsites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: 'Map view',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MapViewPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () => _openFilterDialog(context),
          ),
        ],
      ),
      body: ref.watch(campsiteListProvider).when(
        data: (_) {
          final list = ref.watch(filteredCampsites);
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) => CampsiteListItem(
              campsite: list[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailView(campsite: list[i]),
                ),
              ),
            ),
          );
        },
        loading: () => const CampsiteListSkeleton(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

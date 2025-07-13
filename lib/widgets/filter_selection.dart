import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import '../models/campsite.dart';
import '../providers/campsite_provider.dart';

class FiltersSection extends ConsumerWidget {
  const FiltersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final filterCtrl = ref.read(filterProvider.notifier);

    final all = ref
        .watch(campsiteListProvider)
        .when(
          data: (d) => d,
          loading: () => <Campsite>[],
          error: (_, __) => <Campsite>[],
        );

    final prices = all.map((c) => c.pricePerNight).toList()..sort();
    final minPrice = prices.isEmpty ? 0.0 : prices.first;
    final maxPrice = prices.isEmpty ? 100.0 : prices.last;
    final start = filter.minPrice?.clamp(minPrice, maxPrice) ?? minPrice;
    final end = filter.maxPrice?.clamp(minPrice, maxPrice) ?? maxPrice;

    final binCount = 20;
    final bins = List.generate(binCount, (_) => 0);
    if (prices.isNotEmpty) {
      final span = maxPrice - minPrice;
      for (var p in prices) {
        final idx = ((p - minPrice) / span * (binCount - 1)).floor().clamp(
          0,
          binCount - 1,
        );
        bins[idx]++;
      }
      final maxBin = bins.reduce(max);
      for (var i = 0; i < bins.length; i++) {
        bins[i] = ((bins[i] / maxBin) * 48).round();
      }
    }

    final languages =
        all.expand((c) => c.hostLanguages).whereType<String>().toSet().toList()
          ..sort();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price range',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                height: 48,
                width: MediaQuery.of(context).size.width * 0.99,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: bins.map((h) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: h.toDouble(),
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.6),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Expanded(
                    child: RangeSlider(
                      min: minPrice,
                      max: maxPrice,
                      divisions: binCount,
                      values: RangeValues(start, end),
                      labels: RangeLabels('€${start.round()}', '€${end.round()}'),
                      onChanged: (r) => filterCtrl.state =
                          filter.copyWith(minPrice: r.start, maxPrice: r.end),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Minimum'),
                      const SizedBox(height: 4),
                      Chip(label: Text('€${start.round()}')),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Maximum'),
                      const SizedBox(height: 4),
                      Chip(label: Text('€${end.round()}')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Amenities',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.water_drop),
                  label: const Text('Water Nearby'),
                  selected: filter.closeToWater ?? false,
                  onSelected: (isNowSelected) {
                    filterCtrl.state = filter.copyWith(
                      closeToWater: isNowSelected ? true : false,
                    );
                  },
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.local_fire_department),
                  label: const Text('Campfire'),
                  selected: filter.campFireAllowed ?? false,
                  onSelected: (isSelected) {
                    filterCtrl.state = filter.copyWith(
                      campFireAllowed: isSelected ? true : false,
                    );
                  },
                ),

              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Favorites',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FilterChip(
              showCheckmark: false,
              avatar: const Icon(Icons.favorite),
              label: const Text('Favorites Only'),
              selected: filter.favoritesOnly ?? false,
              onSelected: (isSelected) {
                filterCtrl.state = filter.copyWith(
                  favoritesOnly: isSelected ? true : false,
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Languages', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: languages.map((code) {
                final name = LocaleNames.of(context)?.nameOf(code) ?? code;
                final selected = filter.languages.contains(code);
                return FilterChip(
                  label: Text(name),
                  selected: selected,
                  onSelected: (v) {
                    final list = List<String>.from(filter.languages);
                    v ? list.add(code) : list.remove(code);
                    filterCtrl.state = filter.copyWith(languages: list);
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('Clear All'),
                  onPressed: () => filterCtrl.state = FilterState(),
                ),
                ElevatedButton(
                  child: const Text('Apply Filters'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

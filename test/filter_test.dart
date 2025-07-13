import 'package:campsite/models/campsite.dart';
import 'package:campsite/providers/campsite_provider.dart';
import 'package:campsite/utils/globals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('filteredCampsites provider', () {
    setUp(() async {

      SharedPreferences.setMockInitialValues({
        'favorite_1': true,
        'favorite_3': true,
      });
      Utils.prefs = await SharedPreferences.getInstance();

    });
    final sample = [
      Campsite(
        id: '1',
        label: 'Lake View',
        latitude: 0,
        longitude: 0,
        country: 'Wonderland',
        closeToWater: true,
        campFireAllowed: false,
        hostLanguages: ['en', 'de'],
        pricePerNight: 30,
        photo: '',
      ),
      Campsite(
        id: '2',
        label: 'Mountain Top',
        latitude: 1,
        longitude: 1,
        country: 'Wonderland',
        closeToWater: false,
        campFireAllowed: true,
        hostLanguages: ['fr'],
        pricePerNight: 50,
        photo: '',
      ),
      Campsite(
        id: '3',
        label: 'Forest Edge',
        latitude: 2,
        longitude: 2,
        country: 'Nowhere',
        closeToWater: true,
        campFireAllowed: true,
        hostLanguages: ['en'],
        pricePerNight: 70,
        photo: '',
      ),
    ];
    // Helper to create a container with sample data
    ProviderContainer makeContainer() {
      return ProviderContainer(overrides: [
        // Override the FutureProvider with our sample list directly:
        campsiteListProvider.overrideWith((ref) => sample),
      ]);
    }


    test('returns all when no filters set', () {
      final container = makeContainer();
      // default filterProvider has no filters
      final result = container.read(filteredCampsites);
      expect(result.length, equals(3));
      expect(result.map((c) => c.id), containsAll(['1', '2', '3']));
      container.dispose();
    });

    test('filters by closeToWater only', () {
      final container = makeContainer();
      // apply closeToWater filter
      container.read(filterProvider.notifier).state = FilterState(
        closeToWater: true,
      );
      final result = container.read(filteredCampsites);
      expect(result.length, equals(2));
      expect(result.map((c) => c.id), containsAll(['1', '3']));
      container.dispose();
    });

    test('filters by campFireAllowed only', () {
      final container = makeContainer();
      // apply campFireAllowed filter
      container.read(filterProvider.notifier).state = FilterState(
        campFireAllowed: true,
      );
      final result = container.read(filteredCampsites);
      expect(result.length, equals(2));
      expect(result.map((c) => c.id), containsAll(['2', '3']));
      container.dispose();
    });

    test('combines multiple filters', () {
      final container = makeContainer();
      // closeToWater AND campFireAllowed
      container.read(filterProvider.notifier).state = FilterState(
        closeToWater: true,
        campFireAllowed: true,
      );
      final result = container.read(filteredCampsites);
      expect(result.length, equals(1));
      expect(result.first.id, equals('3'));
      container.dispose();
    });
  });
}

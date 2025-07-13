import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/campsite.dart';
import '../services/api_service.dart';
import '../utils/globals.dart';

/// A singleton ApiService
final apiServiceProvider = Provider<ApiService>((_) => ApiService());

/// Async fetch + simple sort
final campsiteListProvider = FutureProvider<List<Campsite>>((ref) async {
  final api   = ref.watch(apiServiceProvider);
  final list  = await api.fetchCampsites();
  list.sort((a, b) => a.label.compareTo(b.label));
  return list;
});

class FilterState {
  final double? maxPrice;
  final List<String> languages;
  final bool? closeToWater;
  final bool? campFireAllowed;
  final double? minPrice;
  final bool? favoritesOnly;

  FilterState({
    this.maxPrice,
    this.languages = const [],
    this.closeToWater,
    this.campFireAllowed,
    this.minPrice,
    this.favoritesOnly
  });

  FilterState copyWith({
    double? maxPrice,
    List<String>? languages,
    bool? closeToWater,
    bool? campFireAllowed,
    double? minPrice,
    bool? favoritesOnly,
  }) =>
      FilterState(
        maxPrice:       maxPrice       ?? this.maxPrice,
        languages:      languages      ?? this.languages,
        closeToWater:   closeToWater   ?? this.closeToWater,
        campFireAllowed:campFireAllowed?? this.campFireAllowed,
        minPrice:  minPrice ?? this.minPrice,
        favoritesOnly: favoritesOnly ?? this.favoritesOnly
      );
}

final filteredCampsites = Provider<List<Campsite>>((ref) {
  final all = ref.watch(campsiteListProvider).when(
    data:    (d) => d,
    loading: ()  => <Campsite>[],
    error:   (_,__) => <Campsite>[],
  );
  final f = ref.watch(filterProvider);
  List<String> keys = Utils.prefs.getKeys().where((String key) => key != "lib_cached_image_data" && key != "lib_cached_image_data").toList(growable: false);
  return all.where((c) {
    if (f.maxPrice != null && c.pricePerNight > f.maxPrice!) return false;
    if (f.languages.isNotEmpty && !c.hostLanguages.any((lang) => f.languages.contains(lang))) return false;
    if (f.closeToWater == true && !c.closeToWater) return false;
    if (f.campFireAllowed == true && !c.campFireAllowed) return false;
    if (f.favoritesOnly == true && !keys.contains("favorite_${c.id}")) return false;
    return true;
  }).toList();
});

///  Holds the user’s filter  choices
final filterProvider = StateProvider<FilterState>((_) => FilterState());



import 'dart:math';

class Campsite {
  final String id;
  final String label;
  final double latitude;
  final double longitude;
  final String country;
  final bool closeToWater;
  final bool campFireAllowed;
  final List<dynamic> hostLanguages;
  final double pricePerNight;
  final String photo;

  Campsite({
    required this.id,
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.closeToWater,
    required this.campFireAllowed,
    required this.hostLanguages,
    required this.pricePerNight,
    required this.photo,
  });
  
  
  static List<String> randomList = ["Germany","Italy","France","Spain","Portugal"];

  factory Campsite.fromJson(Map<String, dynamic> json) {
    final rawGeo = json['geoLocation'] as Map<String, dynamic>?;
    final latRaw  = (rawGeo?['lat']  as num?) ?? 0;
    final lngRaw  = (rawGeo?['long'] as num?) ?? 0;
    final lat = latRaw / 10000;
    final lng = lngRaw / 10000;

    String photo = (json['photo'] as String? ?? '').replaceFirst('http:', 'https:');

    return Campsite(
      id:               json['id']             as String?  ?? '',
      label:            json['label']          as String?  ?? 'No name',
      latitude:         lat,
      longitude:        lng,
      country:          json['country']        as String?  ?? randomList[Random().nextInt(randomList.length)],
      closeToWater:     json['isCloseToWater']   as bool?    ?? false,
      campFireAllowed:  json['isCampFireAllowed']as bool?    ?? false,
      hostLanguages:     json['hostLanguages']   as List<dynamic>,
      pricePerNight:    (json['pricePerNight'] as num?)    ?.toDouble() ?? 0.0,
      photo:            photo,
    );
  }
}

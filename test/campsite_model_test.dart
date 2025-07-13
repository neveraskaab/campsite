import 'package:campsite/models/campsite.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Campsite.fromJson parses and fixes geoLocation', () {
    final json = {
      'id': '1',
      'label': 'Test',
      'geoLocation': {'lat': 52345678, 'long': 13234567},
      'country': 'TestLand',
      'isCloseToWater': true,
      'isCampFireAllowed': false,
      'hostLanguages': [],
      'pricePerNight': 50.5,
      'photo': 'https://example.com/photo.jpg',
    };
    final c = Campsite.fromJson(json);
    expect(c.latitude, 5234.5678);
    expect(c.longitude, 1323.4567);
  });
}

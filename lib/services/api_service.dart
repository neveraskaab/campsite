import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/campsite.dart';

class ApiService {
  static const _base = 'https://62ed0389a785760e67622eb2.mockapi.io/spots/v1';

  Future<List<Campsite>> fetchCampsites() async {
    try {
      final res = await http.get(Uri.parse('$_base/campsites'));
      if (res.statusCode != 200) throw Exception('Status ${res.statusCode}');
      final List raw = jsonDecode(res.body) as List;
      return raw
          .map((e) => Campsite.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('API error: $e');
      return [];
    }
  }
}

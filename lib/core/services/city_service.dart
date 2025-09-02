import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';

class CityService {
  static const String _baseUrl = 'https://turkiyeapi.dev/api/v1/provinces';
  
  /// Fetch all cities from Turkey API
  static Future<List<City>> fetchCities() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?fields=name'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> citiesData = data['data'] ?? [];
        
        final cities = citiesData
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
        
        // Sort cities alphabetically by name
        cities.sort((a, b) => a.name.compareTo(b.name));
        
        return cities;
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

import '../config.dart';

class ApiService {
  static const String _baseUrl = 'https://the-one-api.dev/v2';
  static const String _apiKey = Config.apiKey;

  Future<Map<String, dynamic>> getCharacters({
    int limit = 20,
    int page = 1,
    String? nameFilter,
    String? raceFilter,
  }) async {
    String url = '$_baseUrl/character?limit=$limit&page=$page';
    if (nameFilter != null && nameFilter.isNotEmpty) {
      url += '&name=/$nameFilter/i';
    }
    if (raceFilter != null &&
        raceFilter.isNotEmpty &&
        raceFilter != 'Wszystkie') {
      url += '&race=$raceFilter';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load characters: ${response.statusCode}');
    }
  }

  Future<Character> getCharacterDetails(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/character/$id'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List docs = data['docs'];
      if (docs.isNotEmpty) {
        return Character.fromJson(docs.first);
      } else {
        throw Exception('Character not found');
      }
    } else {
      throw Exception('Failed to load character details');
    }
  }
}

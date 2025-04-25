import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../features/characters/data/models/character.dart';

class CharacterService {
  final String baseUrl = "https://rickandmortyapi.com/api";

  Future<List<Character>> getCharactersByPage(int page) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/character?page=$page'),
      );

      if (response.statusCode != 200) throw Exception("Failed to load");

      final jsonResponse = json.decode(response.body);
      final characters = List<Map<String, dynamic>>.from(
        jsonResponse['results'],
      );

      prefs.setString('cached_page_$page', json.encode(characters));

      return characters.map((c) => Character.fromJson(c)).toList();
    } catch (_) {
      final cached = prefs.getString('cached_page_$page');
      if (cached != null) {
        final characters = List<Map<String, dynamic>>.from(json.decode(cached));
        return characters.map((c) => Character.fromJson(c)).toList();
      }
      rethrow;
    }
  }

  Future<int> getTotalPages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/character'));
      if (response.statusCode != 200) return 1;

      final jsonResponse = json.decode(response.body);
      return jsonResponse['info']['pages'] ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Future<Character?> getCharacterById(int id) async {
    final url = Uri.parse('$baseUrl/character/$id');
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) throw Exception();

      final jsonMap = json.decode(response.body);
      final character = Character.fromJson(jsonMap);

      await prefs.setString(
        'character_${character.id}',
        json.encode(character.toMap()),
      );

      return character;
    } catch (_) {
      final cached = prefs.getString('character_$id');
      if (cached != null) {
        return Character.fromJson(json.decode(cached));
      }
      return null;
    }
  }
}

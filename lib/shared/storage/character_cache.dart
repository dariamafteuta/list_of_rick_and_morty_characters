import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/characters/data/models/character.dart';

class CharacterCache {
  static const String prefix = 'character_';

  Future<void> saveCharacter(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(character.toJson());
    await prefs.setString('$prefix${character.id}', jsonString);
  }

  Future<Character?> getCharacter(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$prefix$id');
    if (jsonString == null) return null;

    try {
      final jsonMap = json.decode(jsonString);
      return Character.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> removeCharacter(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$prefix$id');
  }

  Future<void> clearAllCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(prefix));
    for (var k in keys) {
      await prefs.remove(k);
    }
  }
}

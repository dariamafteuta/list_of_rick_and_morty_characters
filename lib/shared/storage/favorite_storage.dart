import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/characters/data/models/character.dart';

class FavoriteStorage {
  static const String _keyIds = 'favorite_characters';
  static const String _keyCharacterCache = 'favorite_characters_cache';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<int>> getFavoriteIds() async {
    final prefs = await _prefs;
    return prefs.getStringList(_keyIds)?.map(int.parse).toList() ?? [];
  }

  Future<void> saveFavoriteIds(List<int> ids) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyIds, ids.map((e) => e.toString()).toList());
  }

  Future<bool> isFavorite(int id) async {
    final ids = await getFavoriteIds();
    return ids.contains(id);
  }

  Future<void> toggleFavorite(Character character) async {
    final prefs = await _prefs;
    final ids = await getFavoriteIds();
    final cache = await _getCacheMap();

    if (ids.contains(character.id)) {
      ids.remove(character.id);
      cache.remove(character.id.toString());
    } else {
      ids.add(character.id);
      cache[character.id.toString()] = json.encode(character.toMap());
    }

    await prefs.setStringList(_keyIds, ids.map((e) => e.toString()).toList());
    await prefs.setString(_keyCharacterCache, json.encode(cache));
  }

  Future<Map<String, String>> _getCacheMap() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyCharacterCache);
    if (raw == null) return {};
    final decoded = json.decode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v.toString()));
  }

  Future<void> cacheCharacters(List<Character> characters) async {
    final prefs = await _prefs;
    final Map<String, dynamic> cacheMap = {};

    for (var character in characters) {
      cacheMap[character.id.toString()] = character.toMap();
    }

    await prefs.setString(_keyCharacterCache, json.encode(cacheMap));
  }

  Future<List<Character>> getCachedFavorites() async {
    final ids = await getFavoriteIds();
    final prefs = await _prefs;
    final raw = prefs.getString(_keyCharacterCache);

    if (raw == null) return [];

    final decoded = json.decode(raw) as Map<String, dynamic>;
    final characters = <Character>[];

    for (var id in ids) {
      final idStr = id.toString();
      if (decoded.containsKey(idStr)) {
        try {
          final characterMap = decoded[idStr] as Map<String, dynamic>;
          characters.add(Character.fromJson(characterMap));
        } catch (e) {
          debugPrint("⚠️ Failed to parse character $idStr: $e");
        }
      }
    }

    return characters;
  }
}

import 'package:flutter/cupertino.dart';

import '../../../../../services/character_service.dart';
import '../../../../../shared/storage/favorite_storage.dart';
import '../../../presentation/favorite_characters_page.dart';
import '../../models/character.dart';

class FavoriteCharactersProvider extends ChangeNotifier {
  final CharacterService characterService;
  final FavoriteStorage favoriteStorage;

  List<Character> characters = [];
  SortOption _selectedSort = SortOption.id;
  bool isLoading = true;
  bool hasError = false;

  SortOption get selectedSort => _selectedSort;

  FavoriteCharactersProvider({
    required this.characterService,
    required this.favoriteStorage,
  });

  Future<void> loadFavorites() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final ids = await favoriteStorage.getFavoriteIds();
      final networkResults = await Future.wait(
        ids.map((id) => characterService.getCharacterById(id)),
      );

      characters = networkResults.whereType<Character>().toList();

      if (characters.isNotEmpty) {
        await favoriteStorage.cacheCharacters(characters);
      }

      if (characters.isEmpty) {
        characters = await favoriteStorage.getCachedFavorites();
      }

      _sortCharacters();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      characters = await favoriteStorage.getCachedFavorites();

      if (characters.isNotEmpty) {
        _sortCharacters();
        isLoading = false;
        hasError = false;
      } else {
        isLoading = false;
        hasError = true;
      }
      notifyListeners();
    }
  }

  void updateSort(SortOption newSort) {
    _selectedSort = newSort;
    _sortCharacters();
    notifyListeners();
  }

  void _sortCharacters() {
    characters.sort((a, b) {
      switch (_selectedSort) {
        case SortOption.id:
          return a.id.compareTo(b.id);
        case SortOption.name:
          return a.name.compareTo(b.name);
        case SortOption.status:
          return a.status.compareTo(b.status);
        case SortOption.species:
          return a.species.compareTo(b.species);
        case SortOption.gender:
          return a.gender.compareTo(b.gender);
      }
    });
  }

  void removeFavorite(int id) {
    characters.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}

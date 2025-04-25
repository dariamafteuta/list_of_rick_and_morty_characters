import 'package:flutter/cupertino.dart';

import '../../../../../services/character_service.dart';
import '../../models/character.dart';

class CharactersProvider extends ChangeNotifier {
  final CharacterService characterService;

  List<Character> characters = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  bool hasError = false;

  final ScrollController scrollController = ScrollController();

  CharactersProvider({required this.characterService}) {
    scrollController.addListener(_onScroll);
    fetchCharacters();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        currentPage <= totalPages) {
      fetchCharacters();
    }
  }

  Future<void> fetchCharacters() async {
    if (isLoading) return;

    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      if (currentPage == 1) {
        totalPages = await characterService.getTotalPages();
      }

      final newCharacters = await characterService.getCharactersByPage(
        currentPage,
      );
      characters.addAll(newCharacters);
      currentPage++;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to fetch characters: $e');
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

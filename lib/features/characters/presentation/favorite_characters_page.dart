import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/theme/theme_provider.dart';
import '../data/domain/providers/favorite_characters_provider.dart';
import 'character_card.dart';

enum SortOption { id, name, status, species, gender }

class FavoriteCharactersPage extends StatefulWidget {
  const FavoriteCharactersPage({super.key});

  @override
  State<FavoriteCharactersPage> createState() => _FavoriteCharactersPageState();
}

class _FavoriteCharactersPageState extends State<FavoriteCharactersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<FavoriteCharactersProvider>(
            context,
            listen: false,
          ).loadFavorites(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteCharactersProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    if (provider.isLoading) {
      return Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CupertinoActivityIndicator(
            radius: 12,
            color: colors.loaderColor,
          ),
        ),
      );
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/rick-and-morty.png',
              width: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Connection problem. Please check your internet.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (provider.characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/rick-and-morty.png',
              width: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              "No favorite characters",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colors.textColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: colors.accentColor, width: 2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SortOption>(
                dropdownColor: colors.backgroundColor,
                value: provider.selectedSort,
                icon: Icon(Icons.arrow_drop_down, color: colors.accentColor),
                style: TextStyle(
                  color: colors.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                onChanged: (SortOption? newValue) {
                  if (newValue != null) {
                    provider.updateSort(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: SortOption.id,
                    child: Text('🧬 Sort by ID'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.name,
                    child: Text('🧠 Sort by Name'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.status,
                    child: Text('☠️ Sort by Status'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.species,
                    child: Text('👽 Sort by Species'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.gender,
                    child: Text('🚻 Sort by Gender'),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.characters.length,
            itemBuilder: (context, index) {
              final character = provider.characters[index];
              return CharacterCard(
                key: ValueKey(character.id),
                character: character,
                onRemove: () {
                  provider.removeFavorite(character.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

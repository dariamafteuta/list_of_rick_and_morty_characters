import 'package:flutter/material.dart';
import 'package:list_of_rick_and_morty_characters/services/character_service.dart';
import 'package:list_of_rick_and_morty_characters/shared/storage/favorite_storage.dart';
import 'package:list_of_rick_and_morty_characters/shared/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'app/app_navigator.dart';
import 'features/characters/data/domain/providers/characters_provider.dart';
import 'shared/theme/app_colors.dart';
import 'features/characters/data/domain/providers/favorite_characters_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create:
              (_) => CharactersProvider(characterService: CharacterService()),
        ),
        ChangeNotifierProvider(
          create:
              (_) => FavoriteCharactersProvider(
                characterService: CharacterService(),
                favoriteStorage: FavoriteStorage(),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Rick & Morty',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: themeDataFromAppColors(LightThemeColors()),
      darkTheme: themeDataFromAppColors(DarkThemeColors()),
      home: const AppNavigator(),
    );
  }
}

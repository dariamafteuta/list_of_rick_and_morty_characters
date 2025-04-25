import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/theme/theme_provider.dart';
import '../data/domain/providers/characters_provider.dart';
import 'character_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharactersProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    final hasCachedData = provider.characters.isNotEmpty;

    return Column(
      children: [
        Expanded(
          child: provider.isLoading && provider.characters.isEmpty
              ? Center(
            child: CupertinoActivityIndicator(
              radius: 16,
              color: colors.loaderColor,
            ),
          )
              : ShaderMask(
            shaderCallback: (bounds) =>
                LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.backgroundColor,
                    Colors.transparent,
                    Colors.transparent,
                    colors.backgroundColor,
                  ],
                  stops: const [0.0, 0.05, 0.95, 1.0],
                ).createShader(bounds),
            blendMode: BlendMode.dstOut,
            child: ListView.builder(
              controller: provider.scrollController,
              itemCount: provider.characters.length + 1,
              itemBuilder: (context, index) {
                if (index < provider.characters.length) {
                  return CharacterCard(
                    character: provider.characters[index],
                  );
                } else {
                  return provider.isLoading
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 12,
                        color: colors.loaderColor,
                      ),
                    ),
                  )
                      : const SizedBox.shrink();
                }
              },
            ),
          ),
        ),

        if (provider.hasError && !hasCachedData)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
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
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: provider.fetchCharacters,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentColor,
                    foregroundColor: colors.textColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

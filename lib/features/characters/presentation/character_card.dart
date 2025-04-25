import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../shared/storage/favorite_storage.dart';
import '../../../shared/theme/theme_provider.dart';
import '../data/models/character.dart';
import 'package:provider/provider.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final VoidCallback? onRemove;

  const CharacterCard({super.key, required this.character, this.onRemove});

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  final FavoriteStorage favoriteStorage = FavoriteStorage();

  late Character character;
  bool isFavorite = false;
  bool isRemoving = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    character = widget.character;
    _loadFavoriteState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteState() async {
    final exists = await favoriteStorage.isFavorite(character.id);
    if (mounted) {
      setState(() => isFavorite = exists);
    }
  }

  Future<void> _toggleFavorite() async {
    await favoriteStorage.toggleFavorite(character);

    if (mounted) {
      if (isFavorite) {
        if (widget.onRemove != null) {
          setState(() => isRemoving = true);
          await _controller.forward();
          widget.onRemove!();
        } else {
          setState(() => isFavorite = false);
        }
      } else {
        setState(() => isFavorite = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;
    final borderColor =
        isFavorite ? colors.accentColor : colors.mainColor.withOpacity(0.6);

    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return AnimatedSlide(
          offset: _offsetAnimation.value,
          duration: const Duration(milliseconds: 400),
          child: child,
        );
      },
      child: AnimatedOpacity(
        opacity: isRemoving ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 400),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 60,
                        height: 60,
                        color: colors.iconColor.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person,
                          color: colors.iconColor.withOpacity(0.4),
                          size: 30,
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: colors.iconColor.withOpacity(0.1),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person_off,
                          color: colors.iconColor.withOpacity(0.6),
                          size: 30,
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      character.species,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                ),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color:
                        isFavorite
                            ? colors.accentColor
                            : colors.inactiveIconColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

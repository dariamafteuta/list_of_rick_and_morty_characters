import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/characters/presentation/favorite_characters_page.dart';
import '../features/characters/presentation/home_screen.dart';
import '../shared/screens/not_found_screen.dart';
import '../shared/ui/enhanced_bottom_navigation_bar.dart';
import '../shared/theme/theme_provider.dart';
import 'app_route.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  AppRoute currentRoute = AppRoute.home;

  final Map<AppRoute, Widget> routeViews = const {
    AppRoute.home: HomeScreen(),
    AppRoute.favoriteCharacters: FavoriteCharactersPage(),
  };

  void navigateTo(AppRoute route) {
    setState(() {
      currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;
    final view = routeViews[currentRoute] ?? const NotFoundScreen();

    return Scaffold(
      body: view,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: colors.appBarColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    "Rick & Morty",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 26,
                      letterSpacing: 1.2,
                      color: colors.appBarTextColor,
                      shadows: const [
                        Shadow(
                          color: Colors.greenAccent,
                          blurRadius: 8,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.lightGreenAccent,
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Icon(
                        themeProvider.isDark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: colors.iconColor,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: EnhancedBottomNavigationBar(navigateTo: navigateTo),
    );
  }
}

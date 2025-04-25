import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../app/app_route.dart';
import '../theme/theme_provider.dart';

class EnhancedBottomNavigationBar extends StatelessWidget {
  final void Function(AppRoute) navigateTo;

  const EnhancedBottomNavigationBar({super.key, required this.navigateTo});

  void handleTabChange(int index) {
    AppRoute destination = AppRoute.home;

    switch (index) {
      case 0:
        destination = AppRoute.home;
        break;
      case 1:
        destination = AppRoute.favoriteCharacters;
        break;
    }

    navigateTo(destination);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.appBarColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          tabBorderRadius: 12,
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          backgroundColor: colors.appBarColor,
          tabBackgroundColor: colors.accentColor.withOpacity(0.25),
          rippleColor: Colors.white24,
          hoverColor: Colors.white10,
          activeColor: colors.appBarTextColor,
          color: colors.iconColor,
          iconSize: 26,
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 400),
          onTabChange: handleTabChange,
          tabs: const [
            GButton(
              icon: Icons.explore_outlined,
              text: "Home",
            ),
            GButton(
              icon: Icons.star_border,
              text: "Favorites",
            ),
          ],
        ),
      ),
    );
  }
}
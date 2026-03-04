import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/home_screen.dart';
import '../pages/map_screen.dart';
import '../pages/diary_screen.dart';
import '../pages/favorites_screen.dart';
import '../pages/profile_screen.dart';
import '../../core/theme/app_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  static void setIndex(BuildContext context, int index) {
    context.findAncestorStateOfType<_MainLayoutState>()?.setIndex(index);
  }

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final glassExt = theme.extension<GlassThemeExtension>();

    final pages = [
      const HomeScreen(),
      const MapScreen(),
      const DiaryScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true, // Let body flow under the bottom nav
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildTailwindBottomNav(theme, isDark, glassExt),
    );
  }

  Widget _buildTailwindBottomNav(
      ThemeData theme, bool isDark, GlassThemeExtension? glassExt) {
    return Container(
      decoration: BoxDecoration(
        color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: glassExt?.glassBorderColor ?? Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SafeArea(
            bottom: true,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded, // or FontAwesomeIcons.house
                    label: 'Inicio',
                    isActive: _currentIndex == 0,
                    theme: theme,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.map_outlined,
                    label: 'Mapa',
                    isActive: _currentIndex == 1,
                    theme: theme,
                  ),
                  // FAB Central
                  _buildFAB(theme),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.favorite_border_rounded,
                    label: 'Favoritos',
                    isActive: _currentIndex == 3,
                    theme: theme,
                  ),
                  _buildNavItem(
                    index: 4,
                    icon: Icons.person_rounded,
                    label: 'Perfil',
                    isActive: _currentIndex == 4,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    required ThemeData theme,
  }) {
    final color = isActive
        ? theme.colorScheme.primary
        : (theme.brightness == Brightness.dark
            ? const Color(0xFF64748B)
            : const Color(0xFF94A3B8));

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 36,
              width: 56,
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 2; // Diary Screen
        });
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: isDark ? const Color(0xFF1a2230) : Colors.white,
                  width: 4,
                ),
              ),
              child:
                  Icon(Icons.menu_book_rounded, color: primaryColor, size: 28),
            ),
            const SizedBox(height: 2),
            Text(
              'Diario',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

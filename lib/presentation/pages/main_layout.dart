import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/home_screen.dart';

import '../pages/map_screen.dart';
import '../pages/diary_screen.dart';
import '../pages/favorites_screen.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      const HomeScreen(),
      const MapScreen(),
      const DiaryScreen(),
      const FavoritesScreen(),
      const Scaffold(body: Center(child: Text('Perfil'))),
    ];

    return Scaffold(
      extendBody: true, // Let body flow under the bottom nav
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildTailwindBottomNav(isDark),
    );
  }

  Widget _buildTailwindBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF191022).withOpacity(0.65)
            : Colors.white.withOpacity(0.65),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.5),
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
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded, // or FontAwesomeIcons.house
                    label: 'Inicio',
                    isActive: _currentIndex == 0,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.map_outlined,
                    label: 'Mapa',
                    isActive: _currentIndex == 1,
                    isDark: isDark,
                  ),
                  // FAB Central
                  _buildFAB(),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.favorite_border_rounded,
                    label: 'Favoritos',
                    isActive: _currentIndex == 3,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 4,
                    icon: Icons.person_rounded,
                    label: 'Perfil',
                    isActive: _currentIndex == 4,
                    isDark: isDark,
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
    required bool isDark,
  }) {
    final color = isActive
        ? const Color(0xFF7F13EC)
        : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 32,
              width: 48,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF7F13EC).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
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

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 2; // Diary Screen
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24), // pull it up
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1152d4).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1152d4).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1a2230)
                      : Colors.white,
                  width: 4,
                ),
              ),
              child: const Icon(Icons.menu_book_rounded,
                  color: Color(0xFF1152d4), size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              'Diario',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1152d4),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

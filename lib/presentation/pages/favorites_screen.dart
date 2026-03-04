import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';
import 'package:agapemap/l10n/app_localizations.dart';

import '../../core/utils/l10n_helper.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/saved_verse.dart';
import '../../domain/usecases/diary_usecases.dart';
import '../../core/theme/app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<SavedVerse> _savedVerses = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // 'all' or emotionId

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final getEntries = GetIt.instance<GetDiaryEntries>();
      final verses = await getEntries();
      setState(() {
        _savedVerses = verses;
      });
    } catch (e) {
      // Handle error gracefully
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFavorite(String id) async {
    try {
      final deleteEntry = GetIt.instance<DeleteDiaryEntry>();
      await deleteEntry(id);
      _loadFavorites();
    } catch (e) {
      // Handle error
    }
  }

  List<SavedVerse> get _filteredVerses {
    if (_selectedFilter == 'all') return _savedVerses;
    return _savedVerses.where((v) => v.emotionId == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final bgColor = theme.scaffoldBackgroundColor;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );
    }

    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: bgColor,
      // No extendBodyBehindAppBar so filters sit cleanly at top
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildGlassHeader(theme),
            _buildFilters(l10n, theme),
            Expanded(
              child: _filteredVerses.isEmpty
                  ? _buildEmptyState(l10n, theme)
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 120, left: 24, right: 24),
                      itemCount: _filteredVerses.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteCard(
                            _filteredVerses[index], l10n, theme);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassHeader(ThemeData theme) {
    final glassExt = theme.extension<GlassThemeExtension>();
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: primaryColor.withOpacity(0.1)),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tus Oraciones Favoritas',
                style: GoogleFonts.manrope(
                  color: theme.colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCmhqTPfYWLRu4wrqmIyJRridGSVItLpKIPmeGu78EvSm9dBJYwQiIhE4INTvn5pkXL2DaTYHENmXHBCge1-bcJRhIqIsQ70-o7WpLzHSfdDAFhQA-fahLdvgRWL_fPLo8PJBtXBINnTjA6b3NTrmrhNJALyF8sJ5MJ3T_x9MwgVx-Yv-FuZvAwNwq_YkQ8PgyVBNBDAOOyOdBHqMYsMWkZWuuiZjNOrzH6LQ_o_ajdZvkug3bq6AanQjZcOMSRfENHV2bQotApeA'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n, ThemeData theme) {
    // Collect active emotions from existing verses
    final activeEmotionsId =
        _savedVerses.map((v) => v.emotionId).toSet().toList();

    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildFilterChip(
            id: 'all',
            label: 'Todas',
            color: theme.colorScheme.primary,
            isSelected: _selectedFilter == 'all',
            theme: theme,
          ),
          ...activeEmotionsId.map((id) {
            final emotion = Emotions.getById(id);
            return _buildFilterChip(
              id: id,
              label: emotion.getName(l10n),
              color: emotion.color,
              isSelected: _selectedFilter == id,
              theme: theme,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String id,
    required String label,
    required Color color,
    required bool isSelected,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            color: isSelected
                ? color
                : theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
      SavedVerse verse, AppLocalizations l10n, ThemeData theme) {
    final emotion = Emotions.getById(verse.emotionId);
    final color = emotion.color;
    final glassExt = theme.extension<GlassThemeExtension>();
    final textColor = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(emotion.icon, color: color, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          verse.reference,
                          style: GoogleFonts.manrope(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _removeFavorite(verse.id),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.favorite,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '"${verse.text}"',
                  style: GoogleFonts.manrope(
                    color: textColor.withOpacity(0.7),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                if (verse.note != null && verse.note!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      verse.note!,
                      style: GoogleFonts.manrope(
                        color: textColor.withOpacity(0.54),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ThemeData theme) {
    final textColor = theme.colorScheme.onSurface;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 60, color: textColor.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'Aún no hay favoritos',
            style: GoogleFonts.manrope(
              color: textColor.withOpacity(0.8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Guarda oraciones o versículos\npara verlos aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: textColor.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

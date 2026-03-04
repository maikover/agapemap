import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';
import 'package:agapemap/l10n/app_localizations.dart';

import '../../core/utils/l10n_helper.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/saved_verse.dart';
import '../../domain/usecases/diary_usecases.dart';

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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0a120d),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF25f47b)),
        ),
      );
    }

    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF0a120d),
      // No extendBodyBehindAppBar so filters sit cleanly at top
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildGlassHeader(),
            _buildFilters(l10n),
            Expanded(
              child: _filteredVerses.isEmpty
                  ? _buildEmptyState(l10n)
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 120, left: 24, right: 24),
                      itemCount: _filteredVerses.length,
                      itemBuilder: (context, index) {
                        return _buildFavoriteCard(_filteredVerses[index], l10n);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF102217).withOpacity(0.7),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF25f47b).withOpacity(0.1)),
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
                  color: Colors.white,
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
                  border: Border.all(color: const Color(0xFF25f47b), width: 2),
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

  Widget _buildFilters(AppLocalizations l10n) {
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
            color: const Color(0xFF25f47b),
            isSelected: _selectedFilter == 'all',
          ),
          ...activeEmotionsId.map((id) {
            final emotion = Emotions.getById(id);
            return _buildFilterChip(
              id: id,
              label: emotion.getName(l10n),
              color: emotion.color,
              isSelected: _selectedFilter == id,
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
  }) {
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
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            color: isSelected ? color : Colors.white60,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(SavedVerse verse, AppLocalizations l10n) {
    final emotion = Emotions.getById(verse.emotionId);
    final color = emotion.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF102217).withOpacity(0.4),
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
                            color: Colors.white,
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
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFF25f47b),
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
                    color: Colors.white70,
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
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      verse.note!,
                      style: GoogleFonts.manrope(
                        color: Colors.white54,
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

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 60, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'Aún no hay favoritos',
            style: GoogleFonts.manrope(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Guarda oraciones o versículos\npara verlos aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

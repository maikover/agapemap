import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../core/utils/l10n_helper.dart';
import '../../core/utils/share_service.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/saved_verse.dart';
import '../../domain/entities/verse.dart';
import '../../domain/usecases/diary_usecases.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<SavedVerse> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    try {
      final getEntries = GetIt.instance<GetDiaryEntries>();
      final entries = await getEntries();

      List<SavedVerse> loadedEntries = entries;

      // Inject mock data if empty (user requested examples)
      if (loadedEntries.isEmpty) {
        loadedEntries = [
          SavedVerse(
            id: 'mock-1',
            verseId: 'v1',
            book: 'Salmos',
            chapter: 23,
            verse: 1,
            text: 'El Señor es mi pastor, nada me faltará.',
            emotionId: 'peace',
            savedAt: DateTime.now(),
          ),
          SavedVerse(
            id: 'mock-2',
            verseId: 'v2',
            book: 'Filipenses',
            chapter: 4,
            verse: 13,
            text: 'Todo lo puedo en Cristo que me fortalece.',
            emotionId: 'strength',
            savedAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
          SavedVerse(
            id: 'mock-3',
            verseId: 'v3',
            book: '1 Tesalonicenses',
            chapter: 5,
            verse: 18,
            text: 'Dad gracias en todo, porque esta es la voluntad de Dios.',
            emotionId: 'redemption', // Emoción más afín a Gratitud (corazón)
            savedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          SavedVerse(
            id: 'mock-4',
            verseId: 'v4',
            book: 'Jeremías',
            chapter: 29,
            verse: 11,
            text:
                'Porque yo sé los pensamientos que tengo acerca de vosotros, dice Jehová, pensamientos de paz...',
            emotionId: 'renewal', // Esperanza
            savedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ];
      }

      setState(() {
        _entries = loadedEntries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteEntry(String id) async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1a2230)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.deleteConfirmation,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
                Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.delete,
              style: const TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final deleteEntry = GetIt.instance<DeleteDiaryEntry>();
      await deleteEntry(id);
      _loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Tailwind Colors Mapping
    final primaryColor = const Color(0xFF1152d4);
    final bgColor = isDark ? const Color(0xFF101622) : const Color(0xFFf6f6f8);
    final surfaceColor =
        isDark ? const Color(0xFF1a2230) : const Color(0xFFffffff);
    final textColor =
        isDark ? const Color(0xFFf1f5f9) : const Color(0xFF0f172a);
    final textMuted =
        isDark ? const Color(0xFF94a3b8) : const Color(0xFF64748b);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // We use custom back button
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          // Header Gradient Background (top glow)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                    bgColor.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Custom Header Section
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 16, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: isDark
                                    ? const Color(0xFFcbd5e1)
                                    : const Color(0xFF475569),
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'EDITAR',
                              style: GoogleFonts.manrope(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.diary, // "Mi Diario"
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_entries.length} Versículos guardados',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildFilterChip(
                        label: 'Todos',
                        isActive: true,
                        primaryColor: primaryColor,
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        icon: Icons.check,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        label: 'Paz',
                        isActive: false,
                        primaryColor: primaryColor,
                        surfaceColor: surfaceColor,
                        textColor: textMuted,
                        dotColor: Colors.yellow[400],
                        isDark: isDark,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        label: 'Fuerza',
                        isActive: false,
                        primaryColor: primaryColor,
                        surfaceColor: surfaceColor,
                        textColor: textMuted,
                        dotColor: Colors.blue[500],
                        isDark: isDark,
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        label: 'Gratitud',
                        isActive: false,
                        primaryColor: primaryColor,
                        surfaceColor: surfaceColor,
                        textColor: textMuted,
                        dotColor: Colors.pink[400],
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Main Content List
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        )
                      : _entries.isEmpty
                          ? _buildEmptyState(l10n, textColor, textMuted)
                          : _buildDiaryList(l10n, isDark, primaryColor,
                              surfaceColor, textColor, textMuted),
                ),
                const SizedBox(height: 80), // Padding for BottomNav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required Color primaryColor,
    required Color surfaceColor,
    required Color textColor,
    Color? dotColor,
    IconData? icon,
    bool isDark = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? null
            : Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05),
              ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
          ],
          if (dotColor != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: dotColor.withOpacity(0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: GoogleFonts.manrope(
              color: isActive ? Colors.white : textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      AppLocalizations l10n, Color textColor, Color textMuted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined,
              size: 64, color: textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            l10n.emptyDiary,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l10n.emptyDiaryHint,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: textMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryList(
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
    Color surfaceColor,
    Color textColor,
    Color textMuted,
  ) {
    return RefreshIndicator(
      onRefresh: _loadEntries,
      color: primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          final emotion = Emotions.getById(entry.emotionId);

          // Treat the first item as the Featured Card, rest as Standard Glass Cards
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildFeaturedCard(entry, emotion, l10n),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildStandardCard(entry, emotion, l10n, isDark,
                  primaryColor, surfaceColor, textColor, textMuted),
            );
          }
        },
      ),
    );
  }

  Widget _buildFeaturedCard(
      SavedVerse entry, Emotion emotion, AppLocalizations l10n) {
    final dateFormat = DateFormat.jm(
        Localizations.localeOf(context).languageCode); // e.g. 9:41 AM

    return GestureDetector(
      onTap: () {
        // Opción: Abrir detalle completo aquí. Por ahora estático según el diseño.
      },
      child: Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1152d4).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Image Background
              Positioned.fill(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBz17sDotdO0Et1pBRYzZ-PiSAt5XOKx34FEWL6ONlbva9aMrghl3AqVNTuk-_e2NYBFdbnQgMfTFLQ9QRx2QAbuA2_qMVD7TVkYKr4BFEdaQAXIqPNJgf9bsSsGUoelT-vvO4UKfOfF-1rOnDQ_usxFjXooY_Mm5aQdREWJa900McfBeQafYEcbLJ5JM8FwzeyuqHLUvjuXVf6-Ttnh7DNwukesx7eEaYXlsi6Dp2GHZQG_0NTue1o5xsyhr7Ddh3hH0BsMdT7bA',
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Options Button top right
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => _deleteEntry(entry.id),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
              // Text Content Bottom
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: emotion.color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: emotion.color.withOpacity(0.8),
                                  blurRadius: 8),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          emotion.getName(l10n).toUpperCase(),
                          style: GoogleFonts.manrope(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.reference,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${entry.text}"',
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Guardado hoy • ${dateFormat.format(entry.savedAt)}',
                      style: GoogleFonts.manrope(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardCard(
    SavedVerse entry,
    Emotion emotion,
    AppLocalizations l10n,
    bool isDark,
    Color primaryColor,
    Color surfaceColor,
    Color textColor,
    Color textMuted,
  ) {
    final dateFormat = DateFormat.MMMd(
        Localizations.localeOf(context).languageCode); // e.g. 12 Oct

    return GestureDetector(
      onTap: () {
        // Read full / Share logic
        final verse = Verse(
          id: entry.verseId,
          book: entry.book,
          chapter: entry.chapter,
          verse: entry.verse,
          text: entry.text,
          translation: 'nvi',
        );
        ShareService.shareVerse(
            verse: verse, emotion: emotion, appName: 'AgapeMap');
      },
      child: Dismissible(
        key: Key(entry.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.delete, color: Colors.redAccent),
        ),
        onDismissed: (_) => _deleteEntry(entry.id),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1a2230).withOpacity(0.7)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1152d4).withOpacity(0.04), // soft shadow
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 24,
                            decoration: BoxDecoration(
                              color: emotion.color,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: emotion.color.withOpacity(0.4),
                                    blurRadius: 8),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            emotion.getName(l10n).toUpperCase(),
                            style: GoogleFonts.manrope(
                              color: textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.bookmark_border,
                          color: textMuted.withOpacity(0.6), size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Middle Section: Reference & Text
                  Text(
                    entry.reference,
                    style: GoogleFonts.outfit(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${entry.text}"',
                    style: GoogleFonts.manrope(
                      color: isDark
                          ? const Color(0xFFcbd5e1)
                          : const Color(0xFF475569),
                      fontSize: 15,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Bottom Row: Date & Action
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${dateFormat.format(entry.savedAt)} • ${DateFormat.jm().format(entry.savedAt)}',
                          style: GoogleFonts.manrope(
                            color: textMuted,
                            fontSize: 11,
                          ),
                        ),
                        // Sharing instead of "LEER COMPLETO" to preserve functionality gracefully
                        Row(
                          children: [
                            Text(
                              'COMPARTIR',
                              style: GoogleFonts.manrope(
                                color: primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.share, color: primaryColor, size: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

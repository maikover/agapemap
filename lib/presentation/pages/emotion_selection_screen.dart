import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../core/utils/l10n_helper.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/usecases/get_random_verse_for_emotion.dart';
import '../../domain/entities/verse.dart';
import 'verse_swipe_screen.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_back_button.dart';

class EmotionSelectionScreen extends StatefulWidget {
  const EmotionSelectionScreen({super.key});

  @override
  State<EmotionSelectionScreen> createState() => _EmotionSelectionScreenState();
}

class _EmotionSelectionScreenState extends State<EmotionSelectionScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _selectEmotionAndContinue(String emotionId) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final getVerses = GetIt.instance<GetRandomVerseForEmotion>();
      final verses = <Verse>[];
      for (int i = 0; i < 5; i++) {
        final verse = await getVerses(emotionId);
        verses.add(verse);
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerseSwipeScreen(
              verses: verses,
              emotion: Emotions.getById(emotionId),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l10n.error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = theme.colorScheme.primary;
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;
    final textMuted = theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Used custom header below
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background Ambient Effects (Organic Shapes)
          Positioned(
            top: -40,
            left: -40,
            child: FadeTransition(
              opacity:
                  Tween<double>(begin: 0.6, end: 1.0).animate(_pulseController),
              child: _buildOrganicShape(
                size: 256, // w-64 h-64
                color: primaryColor.withOpacity(isDark ? 0.3 : 0.2),
              ),
            ),
          ),
          Positioned(
            top: 160, // top-40
            right: -80, // -right-20
            child: _buildOrganicShape(
              size: 320, // w-80 h-80
              color: Colors.purple[500]!.withOpacity(isDark ? 0.25 : 0.15),
            ),
          ),
          Positioned(
            bottom: 80, // bottom-20
            left: 40, // left-10
            child: _buildOrganicShape(
              size: 288, // w-72 h-72
              color: Colors.teal[500]!.withOpacity(isDark ? 0.15 : 0.1),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header (AgapeMap + Nav)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Solo mantenemos el botón de volver si es que vinieron de otra pantalla.
                      // Se eliminó el título AgapeMap y el icono de foto circular a petición del usuario.
                      CustomBackButton(color: textColor),
                    ],
                  ),
                ),

                // Main Content Scroll
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Titles
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        child: Column(
                          children: [
                            Text(
                              '¿Cómo está tu',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                height: 1.2,
                                letterSpacing: -1,
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [primaryColor, Colors.blue[300]!],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                'corazón hoy?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Selecciona una emoción para personalizar tu momento de oración.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textMuted,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Grid
                      GridView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.05,
                        ),
                        itemCount: Emotions.all.length,
                        itemBuilder: (context, index) {
                          final emotion = Emotions.all[index];
                          return _buildEmotionGlassCard(
                            emotion: emotion,
                            isDark: isDark,
                            textColor: textColor,
                            l10n: l10n,
                            theme: theme,
                          );
                        },
                      ),

                      // Helper / Quote
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.2),
                              primaryColor.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                color: primaryColor, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿No estás seguro?',
                                    style: GoogleFonts.manrope(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Podemos guiarte a través de una oración general para encontrar calma.',
                                    style: GoogleFonts.manrope(
                                      color: textMuted,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100), // Space for global navbar
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrganicShape({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildEmotionGlassCard({
    required Emotion emotion,
    required bool isDark,
    required Color textColor,
    required AppLocalizations l10n,
    required ThemeData theme,
  }) {
    final glassExt = theme.extension<GlassThemeExtension>();
    final defaultBg = glassExt?.glassBgColor ?? theme.colorScheme.surface;
    final defaultBorder = glassExt?.glassBorderColor ?? Colors.transparent;

    return InkWell(
      onTap: () => _selectEmotionAndContinue(emotion.id),
      borderRadius: BorderRadius.circular(24),
      splashColor: emotion.color.withOpacity(0.2),
      highlightColor: emotion.color.withOpacity(0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: defaultBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: defaultBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 24,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Stack(
              children: [
                // Hover Gradient (static opacity for now to simulate Tailwind inner glow)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          emotion.color.withOpacity(0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: emotion.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: emotion.color.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius:
                                  inset ? -2 : 0, // Mock inner shadow feel
                            )
                          ],
                        ),
                        child: Icon(
                          emotion.icon,
                          size: 32,
                          color: isDark
                              ? emotion.color.withOpacity(0.8)
                              : emotion.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        emotion.getName(l10n),
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get inset => true;
}

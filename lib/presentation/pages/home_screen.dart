import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'emotion_selection_screen.dart';
import 'main_layout.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background ambient gradients
          _buildAmbientBackground(theme),

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(theme, textColor),
                        const SizedBox(height: 24),
                        _buildVerseOfDay(theme),
                        const SizedBox(height: 24),
                        _buildQuickActions(context, theme, textColor),
                        const SizedBox(height: 24),
                        _buildDailyInspiration(theme, textColor),
                        const SizedBox(height: 120), // Padding for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientBackground(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: isDark ? 0.15 : 0.25),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          top: 150,
          right: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withValues(alpha: isDark ? 0.10 : 0.15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 50,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: isDark ? 0.05 : 0.10),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme, Color textColor) {
    final textMuted = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final glassExt = theme.extension<GlassThemeExtension>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: glassExt?.glassBorderColor ??
                              Colors.white.withValues(alpha: 0.1),
                          width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBjU32bkOlDqiBqhTl8ODupkOA-GVuu3FQQGug_yxEcxkvqHg2AijOAJi1-O4FX-O3LhCN8IR3e63O_HGaSGxFqfLy5_OCYI7UXoQ4ykX7sFnOYHmpu3ISQnT0BUJ6TepyTscB7OhHOHkZQZwMdUdS0v6zNar5FGLgJduSERqq2LwnLFAC5-5WzarsvR5W0IL-pP3Xd-8EMi-fIKj0I39d5z9FeKdTWFqoCCpYSCKR0RMZhJ8CSHYL7at0oPpFcQwpDwm4wZ-j9HA'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[400],
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.scaffoldBackgroundColor, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BUENOS DÍAS',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Mateo',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
              border: Border.all(
                  color: glassExt?.glassBorderColor ?? Colors.transparent),
            ),
            child: Icon(Icons.notifications_outlined,
                color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseOfDay(ThemeData theme) {
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.9),
            primary.withValues(alpha: 1.0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Icon(Icons.format_quote,
                size: 120, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.light_mode, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Versículo del día',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"Todo lo puedo en Cristo que me fortalece."',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.3,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Filipenses 4:13',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildIconButton(Icons.share_outlined),
                  const SizedBox(width: 8),
                  _buildIconButton(Icons.favorite_border),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, ThemeData theme, Color textColor) {
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tu Bienestar',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'Ver todo',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          theme: theme,
          gradientColors: [
            const Color(0xFFEC4899),
            const Color(0xFFFB7185)
          ], // pink-500 to rose-400
          iconBgColor: isDark
              ? const Color(0xFFEC4899).withValues(alpha: 0.2)
              : const Color(0xFFFDF2F8), // pink-900/20 : pink-50
          iconColor: const Color(0xFFEC4899), // pink-500
          icon: Icons.monitor_heart_outlined,
          title: 'Termómetro Emocional',
          description:
              'Registra cómo te sientes hoy para recibir versículos personalizados.',
          actionText: 'Chequear ahora',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmotionSelectionScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          theme: theme,
          gradientColors: [
            const Color(0xFF3B82F6),
            const Color(0xFF22D3EE)
          ], // blue-500 to cyan-400
          iconBgColor: isDark
              ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
              : const Color(0xFFEFF6FF), // blue-900/20 : blue-50
          iconColor: const Color(0xFF3B82F6), // blue-500
          icon: Icons.menu_book_outlined,
          title: 'Mi Diario',
          description:
              'Escribe tus pensamientos y reflexiones diarias con gratitud.',
          actionText: 'Escribir entrada',
          onTap: () {
            MainLayout.setIndex(context, 2);
          },
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          theme: theme,
          gradientColors: [
            const Color(0xFFFBBF24),
            const Color(0xFFF97316)
          ], // amber-400 to orange-500
          iconBgColor: isDark
              ? const Color(0xFFF97316).withValues(alpha: 0.2)
              : const Color(0xFFFFF7ED),
          iconColor: const Color(0xFFF97316), // orange-500
          icon: Icons.map_outlined,
          title: 'Mapa de Oraciones',
          description:
              'Conecta con creyentes cerca de ti y comparte peticiones de oración.',
          actionText: 'Ver mapa',
          hasMapPreview: true,
          onTap: () {
            MainLayout.setIndex(context, 1);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required ThemeData theme,
    required List<Color> gradientColors,
    required Color iconBgColor,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String description,
    required String actionText,
    bool hasMapPreview = false,
    VoidCallback? onTap,
  }) {
    final glassExt = theme.extension<GlassThemeExtension>();
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: glassExt?.glassBorderColor ?? Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 6,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  if (hasMapPreview)
                    Container(
                      height: 96,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        image: DecorationImage(
                          image: const NetworkImage(
                              'https://placeholder.pics/svg/300'),
                          fit: BoxFit.cover,
                          colorFilter: isDark
                              ? ColorFilter.mode(
                                  Colors.black.withValues(alpha: 0.5),
                                  BlendMode.darken)
                              : null,
                          opacity: isDark ? 0.3 : 0.6,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  glassExt?.glassBgColor ??
                                      theme.colorScheme.surface,
                                  (glassExt?.glassBgColor ??
                                          theme.colorScheme.surface)
                                      .withValues(alpha: 0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 48,
                            left: 32,
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF97316),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(0, 4)),
                                    ],
                                  ),
                                  child: const Icon(Icons.location_on,
                                      color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.brightness == Brightness.dark
                                        ? const Color(0xFF102217)
                                        : Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Tu comunidad',
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: hasMapPreview ? 8 : 20,
                        bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasMapPreview)
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(icon, color: iconColor, size: 28),
                          ),
                        if (!hasMapPreview) const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.outfit().fontFamily,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    actionText,
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: iconColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                      hasMapPreview
                                          ? Icons.map_outlined
                                          : Icons.arrow_forward,
                                      color: iconColor,
                                      size: 16),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildDailyInspiration(ThemeData theme, Color textColor) {
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: primary.withValues(alpha: isDark ? 0.3 : 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDWIqEk7oQFAC1CpjN0qwJ0XUorfnvuiShyLXaegiZ9LE55APqP8d9IXglCQL7V-UQMUwG3PVbKaU4OkNbYjpryac-COtilzzLPxnOVTmEo0lDyQ1AtUxecfQEIld_gMxBVcFcsuytGC09heb9WchM0EXvj99nYst3vZlS8XXjxplp8YANIo6t-1R5YdKo6iZRS5ianhWZxlJYYcfPWGMvV6p3kSYImsR6jSBUuk3YyM_62xCjM7Z-nse7mA5cAi61dLLPk1TQ4CA'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Devocional Matutino',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Comienza tu día con gratitud y propósito. Escucha la reflexión de hoy.',
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.play_circle_outline, color: primary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'REPRODUCIR (5 MIN)',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

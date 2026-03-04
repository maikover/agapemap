import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../core/utils/l10n_helper.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/usecases/prayer_usecases.dart';
import '../../core/utils/location_service.dart';
import '../../core/theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  List<PrayerLocation> _prayers = [];
  bool _isLoading = true;
  double? _userLat;
  double? _userLng;
  bool _hasLocationPermission = false;
  PrayerLocation? _selectedPrayer;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _initLocation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    if (mounted) setState(() => _isLoading = true);

    final locationService = GetIt.instance<LocationService>();
    _hasLocationPermission = await locationService.requestPermission();

    if (_hasLocationPermission) {
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        _userLat = position.latitude;
        _userLng = position.longitude;
      }
    }

    await _loadPrayers();
  }

  Future<void> _loadPrayers() async {
    try {
      final getPrayers = GetIt.instance<GetNearbyPrayers>();

      if (_userLat != null && _userLng != null) {
        _prayers = await getPrayers(
          latitude: _userLat!,
          longitude: _userLng!,
          radiusInMeters: 5000,
        );
      } else {
        final getAll = GetIt.instance<GetAllPrayers>();
        _prayers = await getAll();
      }
      if (_prayers.isNotEmpty) {
        _selectedPrayer = _prayers.first;
      }
    } catch (e) {
      // Silently fail
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    if (!_hasLocationPermission) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: _buildPermissionRequest(),
      );
    }

    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Simulated Map Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBCyAwEYCxht_zOyJw0qi2LEwpQ7TvcvkIIe7fL12LmsBYbRUkcGXD4oh1Z09Ubo3Icqm1NGX_gU6YG5TtaBwG8fDDMFyewMStLrYys4x6YysVInAeJro9eV7B0Oy8wlVd_B9ib58xz6oXDkGQOWR-WbTUWtpG8S6BUXeXzaS23NHyAkTN-HOBuVRt_KnW7j8Z601bCx4v2b2yF5pVbpUr-osxMoED_4ZkjfqIBWzrplP5aGzq5ck_7HQ-npw_5dhmG2Iuijl6X7A',
                fit: BoxFit.cover,
                colorBlendMode:
                    isDark ? BlendMode.saturation : BlendMode.darken,
              ),
            ),
          ),

          // Top Header and Search Bar
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopHeader(),
                const SizedBox(height: 16),
                _buildSearchBar(),
              ],
            ),
          ),

          // Map Zoom Controls (Right Middle)
          _buildMapControls(),

          // Glowing Prayer Markers
          ..._prayers.asMap().entries.map((entry) {
            final index = entry.key;
            final prayer = entry.value;
            final isSelected = _selectedPrayer?.id == prayer.id;

            // Randomly scattered mapping
            final double topPos = 250 + (index * 80) % 350;
            final double leftPos = 50 + (index * 120) % 250;

            return Positioned(
              top: topPos,
              left: leftPos,
              child: _buildMapMarker(prayer, isSelected),
            );
          }),

          // Floating Layout (FAB + Bottom Sheet)
          Positioned(
            left: 24,
            right: 24,
            bottom: 100, // Above MainLayout navigation
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFAB(context),
                const SizedBox(height: 24),
                _prayers.isEmpty
                    ? _buildEmptyStateOverlay(l10n)
                    : _buildPrayerDetailsOverlay(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassIconButton(Icons.settings),
          Column(
            children: [
              Text(
                'AgapeMap',
                style: GoogleFonts.manrope(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'PREMIUM',
                style: GoogleFonts.manrope(
                  color: primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildGlassIconButton(Icons.notifications),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final glassExt = theme.extension<GlassThemeExtension>();
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
              color: glassExt?.glassBorderColor ?? Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.search, color: primaryColor.withOpacity(0.7)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Buscar oraciones cercanas...',
                        hintStyle:
                            TextStyle(color: theme.textTheme.bodyMedium?.color),
                        border: InputBorder.none,
                      ),
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

  Widget _buildMapControls() {
    final theme = Theme.of(context);
    return Positioned(
      right: 24,
      top: MediaQuery.of(context).size.height * 0.45,
      child: Column(
        children: [
          _buildGlassIconButton(Icons.add, size: 40),
          const SizedBox(height: 12),
          _buildGlassIconButton(Icons.remove, size: 40),
          const SizedBox(height: 16),
          _buildGlassIconButton(Icons.near_me,
              size: 40, iconColor: theme.colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildGlassIconButton(IconData icon,
      {double size = 48, Color? iconColor}) {
    final theme = Theme.of(context);
    final glassExt = theme.extension<GlassThemeExtension>();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
        shape: BoxShape.circle,
        border:
            Border.all(color: glassExt?.glassBorderColor ?? Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Icon(icon, color: iconColor ?? theme.colorScheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildMapMarker(PrayerLocation prayer, bool isSelected) {
    final emotion =
        prayer.emotionId != null ? Emotions.getById(prayer.emotionId!) : null;
    final color = emotion?.color ?? const Color(0xFF3b82f6); // Default blue
    final size = isSelected ? 24.0 : 16.0;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPrayer = prayer;
        });
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse Ring
            ScaleTransition(
              scale:
                  Tween<double>(begin: 0.8, end: 1.5).animate(_pulseController),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 0.0)
                    .animate(_pulseController),
                child: Container(
                  width: size * 2.5,
                  height: size * 2.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color,
                      width: isSelected ? 3 : 2,
                    ),
                  ),
                ),
              ),
            ),
            // Map Dot
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.8),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    return GestureDetector(
      onTap: () => _showCreatePrayerSheet(context),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: onPrimary),
            const SizedBox(width: 8),
            Text(
              'PLANTAR MI ORACIÓN',
              style: GoogleFonts.manrope(
                color: onPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerDetailsOverlay(AppLocalizations l10n) {
    if (_selectedPrayer == null) return const SizedBox.shrink();

    final prayer = _selectedPrayer!;
    final emotion =
        prayer.emotionId != null ? Emotions.getById(prayer.emotionId!) : null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF102217).withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border(
            top: BorderSide(color: const Color(0xFF25f47b).withOpacity(0.2))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grabber handle
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Content Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emotion Gradient Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF25f47b),
                            Color(0xFF10b981)
                          ], // primary to emerald
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF25f47b).withOpacity(0.3),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          emotion?.icon ?? Icons.self_improvement,
                          color: const Color(0xFF0a120d),
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ORACIÓN CERCANA',
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF25f47b),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'Hace 5 min',
                                style: GoogleFonts.manrope(
                                    color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (prayer.verseReference != null) ...[
                            Text(
                              prayer.verseReference!,
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            '"${prayer.prayerText}"',
                            style: GoogleFonts.manrope(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bottom Divider & Actions
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top:
                              BorderSide(color: Colors.white.withOpacity(0.1))),
                    ),
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar Row
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFF25f47b), width: 2),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCmhqTPfYWLRu4wrqmIyJRridGSVItLpKIPmeGu78EvSm9dBJYwQiIhE4INTvn5pkXL2DaTYHENmXHBCge1-bcJRhIqIsQ70-o7WpLzHSfdDAFhQA-fahLdvgRWL_fPLo8PJBtXBINnTjA6b3NTrmrhNJALyF8sJ5MJ3T_x9MwgVx-Yv-FuZvAwNwq_YkQ8PgyVBNBDAOOyOdBHqMYsMWkZWuuiZjNOrzH6LQ_o_ajdZvkug3bq6AanQjZcOMSRfENHV2bQotApeA'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'María G.',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        // Action Buttons
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite,
                                  color: Color(0xFF25f47b), size: 20),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25f47b).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFF25f47b)
                                        .withOpacity(0.3)),
                              ),
                              child: Text(
                                'UNIRME',
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF25f47b),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateOverlay(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final glassExt = theme.extension<GlassThemeExtension>();
    final primaryColor = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: glassExt?.glassBgColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border(
            top: BorderSide(
                color: glassExt?.glassBorderColor ??
                    primaryColor.withOpacity(0.2))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map_outlined,
                    size: 48, color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  l10n.noPrayersNearby,
                  style: GoogleFonts.manrope(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.plantPrayerHint,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRequest() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off,
                size: 80, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              context.l10n.locationPermissionRequired,
              style: GoogleFonts.manrope(
                  fontSize: 18, color: theme.colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(context.l10n.enableLocation),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePrayerSheet(BuildContext context) {
    final prayerController = TextEditingController();
    final verseController = TextEditingController();
    String? selectedEmotionId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF102217).withOpacity(0.95), // Dark Theme modal
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border(
              top: BorderSide(color: const Color(0xFF25f47b).withOpacity(0.2))),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 32,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.plantPrayer,
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Selector de emoción
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: context.l10n.selectEmotion,
                    labelStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF25f47b)),
                    ),
                  ),
                  dropdownColor: const Color(0xFF0a120d),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
                  items: Emotions.all
                      .map((e) => DropdownMenuItem(
                            value: e.id,
                            child: Row(
                              children: [
                                Icon(e.icon, color: e.color, size: 18),
                                const SizedBox(width: 12),
                                Text(e.getName(context.l10n),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => selectedEmotionId = value,
                ),
                const SizedBox(height: 20),

                // Versículo
                TextField(
                  controller: verseController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: context.l10n.verseReferenceOptional,
                    labelStyle: const TextStyle(color: Colors.white54),
                    hintText: 'Juan 3:16',
                    hintStyle: const TextStyle(color: Colors.white30),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF25f47b)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Oración
                TextField(
                  controller: prayerController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: context.l10n.yourPrayer,
                    labelStyle: const TextStyle(color: Colors.white54),
                    hintText: context.l10n.prayerHint,
                    hintStyle: const TextStyle(color: Colors.white30),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF25f47b)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Botón
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25f47b),
                      foregroundColor: const Color(0xFF0a120d),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () async {
                      if (prayerController.text.isEmpty) return;
                      // Mismo bypass de dev local si no hay location,
                      // O mostrar el error
                      if (_userLat == null || _userLng == null) {
                        // Fallback para test
                        _userLat = 40.7128;
                        _userLng = -74.0060;
                      }

                      final savePrayer = GetIt.instance<SavePrayerLocation>();
                      await savePrayer(
                        latitude: _userLat ?? 0,
                        longitude: _userLng ?? 0,
                        verseReference: verseController.text.isNotEmpty
                            ? verseController.text
                            : null,
                        prayerText: prayerController.text,
                        emotionId: selectedEmotionId,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                        _loadPrayers();
                      }
                    },
                    child: Text(
                      context.l10n.plant,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

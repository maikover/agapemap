import 'package:flutter/material.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/l10n_helper.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/usecases/prayer_usecases.dart';
import '../../core/utils/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<PrayerLocation> _prayers = [];
  bool _isLoading = true;
  double? _userLat;
  double? _userLng;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    setState(() => _isLoading = true);
    
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
        // Oraciones cercanas
        _prayers = await getPrayers(
          latitude: _userLat!,
          longitude: _userLng!,
          radiusInMeters: 5000, // 5km
        );
      } else {
        // Todas las oraciones
        final getAll = GetIt.instance<GetAllPrayers>();
        _prayers = await getAll();
      }
    } catch (e) {
      // Silently fail
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.blessingsMap),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            onPressed: _initLocation,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo simple
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.background, AppColors.surface],
              ),
            ),
          ),
          
          // Contenido
          _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(l10n),
          
          // Botón flotante para agregar oración
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () => _showCreatePrayerSheet(context),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_location_alt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    if (!_hasLocationPermission) {
      return _buildPermissionRequest();
    }
    
    if (_prayers.isEmpty) {
      return _buildEmptyState(l10n);
    }
    
    return _buildPrayerList(l10n);
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.locationPermissionRequired,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.locationPermissionHint,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initLocation,
              child: Text(context.l10n.enableLocation),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location_alt_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noPrayersNearby,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.plantPrayerHint,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerList(AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _prayers.length,
      itemBuilder: (context, index) {
        final prayer = _prayers[index];
        final emotion = prayer.emotionId != null 
            ? Emotions.getById(prayer.emotionId!) 
            : null;
        
        final dateFormat = DateFormat.yMMMd(
          Localizations.localeOf(context).languageCode,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (emotion?.color ?? AppColors.primary).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: (emotion?.color ?? AppColors.primary).withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(prayer.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    if (emotion != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: emotion.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          emotion.getName(context.l10n),
                          style: TextStyle(
                            fontSize: 10,
                            color: emotion.color,
                          ),
                        ),
                      ),
                  ],
                ),
                
                // Versículo
                if (prayer.verseReference != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    prayer.verseReference!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: emotion?.color ?? AppColors.primary,
                    ),
                  ),
                  if (prayer.verseText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      prayer.verseText!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
                
                // Oración
                const SizedBox(height: 8),
                Text(
                  prayer.prayerText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreatePrayerSheet(BuildContext context) {
    final prayerController = TextEditingController();
    final verseController = TextEditingController();
    String? selectedEmotionId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.plantPrayer,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Selector de emoción
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: context.l10n.selectEmotion,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              dropdownColor: AppColors.surface,
              items: Emotions.all.map((e) => DropdownMenuItem(
                value: e.id,
                child: Row(
                  children: [
                    Icon(e.icon, color: e.color, size: 20),
                    const SizedBox(width: 8),
                    Text(e.getName(context.l10n)),
                  ],
                ),
              )).toList(),
              onChanged: (value) => selectedEmotionId = value,
            ),
            const SizedBox(height: 16),
            
            // Versículo (opcional)
            TextField(
              controller: verseController,
              decoration: InputDecoration(
                labelText: context.l10n.verseReferenceOptional,
                hintText: 'Juan 3:16',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Oración
            TextField(
              controller: prayerController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.yourPrayer,
                hintText: context.l10n.prayerHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (prayerController.text.isEmpty) return;
                  if (_userLat == null || _userLng == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.locationRequired)),
                    );
                    return;
                  }
                  
                  final savePrayer = GetIt.instance<SavePrayerLocation>();
                  await savePrayer(
                    latitude: _userLat!,
                    longitude: _userLng!,
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
                child: Text(context.l10n.plant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

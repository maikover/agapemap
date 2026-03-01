import 'package:flutter/material.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/l10n_helper.dart';
import '../../core/utils/locale_service.dart';
import '../../config/injection.dart';
import 'emotion_selection_screen.dart';
import 'diary_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _toggleLanguage() {
    final currentLocale = context.locale;
    final newLocale = currentLocale.languageCode == 'es' 
      ? const Locale('en') 
      : const Locale('es');
    
    // Usar el método del widget padre (AgapeMapApp)
    // Como no tenemos acceso directo, usamos un callback o rebuild
    // Para simplificar, recreamos el estado a través de setAppLanguage
    setAppLanguage(newLocale.languageCode);
    
    // Forzar rebuild
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLang = context.locale.languageCode;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Language toggle
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton.icon(
                    onPressed: _toggleLanguage,
                    icon: const Icon(
                      Icons.language,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    label: Text(
                      currentLang == 'es' ? 'EN' : 'ES',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Título
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Descripción
                Text(
                  l10n.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Botón comenzar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Establecer idioma antes de navegar
                      setAppLanguage(context.locale.languageCode);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmotionSelectionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: Text(
                      l10n.start,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Botón diario
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiaryScreen(),
                      ),
                    );
                  },
                  child: Text(
                    l10n.viewDiary,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Botón mapa
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map,
                        size: 16,
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.blessingsMap,
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

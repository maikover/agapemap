import 'package:flutter/material.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/l10n_helper.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/usecases/get_random_verse_for_emotion.dart';
import '../../domain/entities/verse.dart';
import '../widgets/generative_art_background.dart';
import 'verse_swipe_screen.dart';

class EmotionSelectionScreen extends StatefulWidget {
  const EmotionSelectionScreen({super.key});

  @override
  State<EmotionSelectionScreen> createState() => _EmotionSelectionScreenState();
}

class _EmotionSelectionScreenState extends State<EmotionSelectionScreen> {
  String? _selectedEmotionId;
  bool _isLoading = false;

  void _selectEmotion(String emotionId) {
    setState(() {
      _selectedEmotionId = emotionId;
    });
  }

  Future<void> _continueToVerses() async {
    if (_selectedEmotionId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final getVerses = GetIt.instance<GetRandomVerseForEmotion>();
      
      final verses = <Verse>[];
      for (int i = 0; i < 5; i++) {
        final verse = await getVerses(_selectedEmotionId!);
        verses.add(verse);
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerseSwipeScreen(
              verses: verses,
              emotion: Emotions.getById(_selectedEmotionId!),
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
    final emotions = Emotions.all;
    final selectedEmotion = _selectedEmotionId != null 
        ? Emotions.getById(_selectedEmotionId!) 
        : null;
    
    return Scaffold(
      body: Stack(
        children: [
          // Arte generativo de fondo
          if (selectedEmotion != null)
            Positioned.fill(
              child: GenerativeArtBackground(
                baseColor: selectedEmotion.color,
                pattern: selectedEmotion.artPattern,
                animationDuration: 8.0,
              ),
            ),
          
          // Fondo base con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.95),
                  AppColors.surface.withOpacity(0.98),
                ],
              ),
            ),
          ),
          
          // Contenido
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.howIsYourHeart,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                
                // Grid de emociones
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemCount: emotions.length,
                      itemBuilder: (context, index) {
                        final emotion = emotions[index];
                        final isSelected = _selectedEmotionId == emotion.id;
                        
                        return GestureDetector(
                          onTap: () => _selectEmotion(emotion.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? emotion.color.withOpacity(0.3)
                                : AppColors.cardBackground.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? emotion.color : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: emotion.color.withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  emotion.icon,
                                  size: 40,
                                  color: emotion.color,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  emotion.getName(l10n),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected 
                                      ? emotion.color 
                                      : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Descripción de emoción seleccionada
                if (_selectedEmotionId != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      Emotions.getById(_selectedEmotionId!).getDescription(l10n),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary.withOpacity(0.8),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Botón continuar
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedEmotionId == null || _isLoading
                        ? null
                        : _continueToVerses,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        disabledBackgroundColor: AppColors.cardBackground,
                        backgroundColor: selectedEmotion?.color ?? AppColors.primary,
                      ),
                      child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            l10n.receiveMyWord,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}

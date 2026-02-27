import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/l10n_helper.dart';
import '../../core/utils/share_service.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/verse.dart';
import '../../domain/usecases/save_verse_to_diary.dart';
import '../widgets/generative_art_background.dart';

class VerseSwipeScreen extends StatefulWidget {
  final List<Verse> verses;
  final Emotion emotion;

  const VerseSwipeScreen({
    super.key,
    required this.verses,
    required this.emotion,
  });

  @override
  State<VerseSwipeScreen> createState() => _VerseSwipeScreenState();
}

class _VerseSwipeScreenState extends State<VerseSwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Scaffold(
      body: Stack(
        children: [
          // Arte generativo de fondo
          Positioned.fill(
            child: GenerativeArtBackground(
              baseColor: widget.emotion.color,
              pattern: widget.emotion.artPattern,
              animationDuration: 6.0,
            ),
          ),
          
          // Fondo con gradiente para legibilidad
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.emotion.color.withOpacity(0.2),
                  AppColors.background.withOpacity(0.9),
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
                          widget.emotion.getName(l10n),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: widget.emotion.color,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _shareCurrentVerse(),
                        icon: Icon(
                          Icons.share,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Instrucciones
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.next,
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            l10n.amen,
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Tarjetas de versículos
                Expanded(
                  child: widget.verses.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noVersesAvailable,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : CardSwiper(
                        controller: _controller,
                        cardsCount: widget.verses.length,
                        numberOfCardsDisplayed: widget.verses.length > 1 ? 2 : 1,
                        backCardOffset: const Offset(0, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        onSwipe: _onSwipe,
                        onUndo: _onUndo,
                        allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                          horizontal: true,
                        ),
                        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                          return _buildVerseCard(widget.verses[index], l10n);
                        },
                      ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseCard(Verse verse, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.emotion.color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Indicador de emoción
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.emotion.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.emotion.icon,
                    size: 16,
                    color: widget.emotion.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.emotion.getName(l10n),
                    style: TextStyle(
                      color: widget.emotion.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Referencia del versículo
            Text(
              verse.reference,
              style: TextStyle(
                fontSize: 14,
                color: widget.emotion.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Texto del versículo
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    verse.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
            
            const Spacer(),
            
            // Indicadores de swipe
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.amen} →',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _currentIndex = currentIndex ?? 0;
    });

    if (direction == CardSwiperDirection.right) {
      _saveVerse(widget.verses[previousIndex]);
    }

    if (currentIndex == null || currentIndex >= widget.verses.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showCompletionDialog();
        }
      });
    }

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    return true;
  }

  void _saveVerse(Verse verse) async {
    final l10n = context.l10n;
    
    // Guardar en el diario
    try {
      final saveToDiary = GetIt.instance<SaveVerseToDiary>();
      await saveToDiary(
        verse: verse,
        emotionId: widget.emotion.id,
      );
    } catch (e) {
      // Silently fail - no interrupting UX
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.amen}: ${verse.reference}'),
        backgroundColor: widget.emotion.color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _shareCurrentVerse() {
    final currentVerse = widget.verses[_currentIndex];
    ShareService.shareVerse(
      verse: currentVerse,
      emotion: widget.emotion,
      appName: 'AgapeMap',
    );
  }

  void _showCompletionDialog() {
    final l10n = context.l10n;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l10n.youReceivedYourWord,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 48,
              color: widget.emotion.color,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.thanksForReceiving,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: Text(
              l10n.backToHome,
              style: TextStyle(color: widget.emotion.color),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../core/utils/l10n_helper.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_back_button.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 6.0, bottom: 6.0),
                child: CustomBackButton(color: Colors.white),
              )
            : null,
        centerTitle: true,
        title: Text(
          widget.emotion.getName(l10n),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareCurrentVerse,
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Arte generativo de fondo inmersivo suave
          Positioned.fill(
            child: GenerativeArtBackground(
              baseColor: widget.emotion.color,
              pattern: widget.emotion.artPattern,
              animationDuration: 12.0,
            ),
          ),

          // Filtro para oscurecer el fondo para que el texto resalte
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

          // Contenido
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Tarjetas de versículos
                Expanded(
                  child: widget.verses.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noVersesAvailable,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        )
                      : CardSwiper(
                          controller: _controller,
                          cardsCount: widget.verses.length,
                          numberOfCardsDisplayed:
                              widget.verses.length > 1 ? 2 : 1,
                          backCardOffset: const Offset(0, 30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          onSwipe: _onSwipe,
                          onUndo: _onUndo,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.symmetric(
                            horizontal: true,
                          ),
                          cardBuilder: (context, index, percentThresholdX,
                              percentThresholdY) {
                            return _buildVerseCard(widget.verses[index], l10n);
                          },
                        ),
                ),

                // Botones Flotantes Elegantes
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFloatingAction(
                        icon: FontAwesomeIcons.xmark,
                        color: Colors.white.withOpacity(0.8),
                        onTap: () => _controller.swipeLeft(),
                      ),
                      _buildFloatingAction(
                        icon: FontAwesomeIcons.solidHeart,
                        color: widget.emotion.color,
                        onTap: () => _controller.swipeRight(),
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final size = isPrimary ? 70.0 : 60.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: isPrimary
                ? color.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
            width: isPrimary ? 2 : 1,
          ),
          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Icon(
              icon,
              size: isPrimary ? 30 : 24,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerseCard(Verse verse, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // Indicador de emoción
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.emotion.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: widget.emotion.color.withOpacity(0.3)),
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
                        widget.emotion.getName(l10n).toUpperCase(),
                        style: TextStyle(
                          color: widget.emotion.color,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Texto del versículo (Tipografía Grande, Impactante)
                Expanded(
                  flex: 5,
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        '"${verse.text}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Referencia del versículo
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    verse.reference,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
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
    if (_currentIndex >= widget.verses.length) return;

    final currentVerse = widget.verses[_currentIndex];
    ShareService.shareVerse(
      verse: currentVerse,
      emotion: widget.emotion,
      appName: 'AgapeMap',
    );
  }

  void _showCompletionDialog() {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        elevation: 20,
        title: Text(
          l10n.youReceivedYourWord,
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.emotion.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.solidHeart,
                size: 40,
                color: widget.emotion.color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.thanksForReceiving,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.emotion.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              l10n.backToHome,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

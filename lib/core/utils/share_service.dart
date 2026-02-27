import 'package:share_plus/share_plus.dart';
import '../../domain/entities/verse.dart';
import '../../domain/entities/emotion.dart';

/// Widget para compartir versículos
class ShareService {
  /// Compartir versículo como texto
  static Future<void> shareVerse({
    required Verse verse,
    required Emotion emotion,
    required String appName,
  }) async {
    final text = '''
${verse.text}

— ${verse.reference}

Compartido desde $appName 🌟
''';

    await Share.share(
      text,
      subject: verse.reference,
    );
  }

  /// Compartir versículo con marca de agua
  static Future<void> shareVerseWithBranding({
    required Verse verse,
    required Emotion emotion,
    required String appName,
    required String brandingText,
  }) async {
    final text = '''
${verse.text}

— ${verse.reference}

$brandingText
''';

    await Share.share(
      text,
      subject: verse.reference,
    );
  }

  /// Compartir oración del mapa
  static Future<void> sharePrayer({
    required String prayerText,
    String? verseReference,
    String? verseText,
    required String appName,
  }) async {
    final buffer = StringBuffer();
    
    if (verseReference != null) {
      buffer.writeln(verseReference);
      if (verseText != null) {
        buffer.writeln(verseText);
      }
      buffer.writeln();
    }
    
    buffer.writeln(prayerText);
    buffer.writeln();
    buffer.writeln('Compartido desde $appName 🙏');

    await Share.share(
      buffer.toString(),
      subject: 'Oración de esperanza',
    );
  }

  /// Invitar amigos a la app
  static Future<void> inviteFriends({
    required String appName,
    String? referralCode,
  }) async {
    final text = '''
📖 Descarga $appName

Recibe una palabra de Dios adaptada a tu corazón cada día.

$appName - Tu palabra diaria 🙏
''';

    await Share.share(
      text,
      subject: 'Te recomiendo $appName',
    );
  }
}

/// Botón de compartir flotante
class ShareFloatingButton extends StatelessWidget {
  final VoidCallback onShare;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const ShareFloatingButton({
    super.key,
    required this.onShare,
    this.icon = Icons.share,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onShare,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      child: Icon(
        icon,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}

/// Selector de opción de compartir
class ShareOptionsSheet extends StatelessWidget {
  final String title;
  final List<ShareOption> options;

  const ShareOptionsSheet({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...options.map((option) => ListTile(
            leading: Icon(option.icon, color: option.color),
            title: Text(option.label),
            onTap: () {
              Navigator.pop(context);
              option.onTap();
            },
          )),
        ],
      ),
    );
  }
}

/// Opción de compartir
class ShareOption {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const ShareOption({
    required this.label,
    required this.icon,
    this.color,
    required this.onTap,
  });
}

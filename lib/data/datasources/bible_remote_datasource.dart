import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verse_model.dart';
import '../../core/constants/api_constants.dart';

/// Excepciones personalizadas
class BibleApiException implements Exception {
  final String message;
  final int? statusCode;

  BibleApiException(this.message, {this.statusCode});

  @override
  String toString() => 'BibleApiException: $message';
}

/// Fuente de datos remota: API de la Biblia
class BibleRemoteDataSource {
  final http.Client client;
  String _currentTranslation = BibleTranslations.getTranslation('es');

  BibleRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  /// Establecer traducción actual
  void setTranslation(String languageCode) {
    _currentTranslation = BibleTranslations.getTranslation(languageCode);
  }

  /// Obtener traducción actual
  String get currentTranslation => _currentTranslation;

  /// Obtener un versículo específico
  Future<VerseModel> getVerse(String reference) async {
    String urlString =
        '${ApiConstants.bibleApiBaseUrl}/$reference?translation=$_currentTranslation';

    // Quitamos temporalmente o comentamos el uso de corsproxy.io
    // la API de bible-api.com ya soporta CORS (*). corsproxy.io está devolviendo 403.
    // if (kIsWeb) {
    //   urlString = 'https://corsproxy.io/?${Uri.encodeComponent(urlString)}';
    // }

    final url = Uri.parse(urlString);

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['error'] != null) {
          throw BibleApiException(json['error']);
        }

        return VerseModel.fromJson(json);
      } else {
        throw BibleApiException(
          'Error fetching verse',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is BibleApiException) rethrow;
      throw BibleApiException('Network error: $e');
    }
  }

  /// Obtener múltiples versículos
  Future<List<VerseModel>> getVerses(String references) async {
    String urlString =
        '${ApiConstants.bibleApiBaseUrl}/$references?translation=$_currentTranslation';

    // if (kIsWeb) {
    //   urlString = 'https://corsproxy.io/?${Uri.encodeComponent(urlString)}';
    // }

    final url = Uri.parse(urlString);

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['error'] != null) {
          throw BibleApiException(json['error']);
        }

        final verses = json['verses'] as List;
        return verses.map((v) => VerseModel.fromJson(v)).toList();
      } else {
        throw BibleApiException(
          'Error fetching verses',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is BibleApiException) rethrow;
      throw BibleApiException('Network error: $e');
    }
  }

  /// Buscar versículos por palabra clave
  Future<List<VerseModel>> searchVerses(String query) async {
    String urlString =
        '${ApiConstants.bibleApiBaseUrl}/search?query=$query&translation=$_currentTranslation';

    // if (kIsWeb) {
    //   urlString = 'https://corsproxy.io/?${Uri.encodeComponent(urlString)}';
    // }

    final url = Uri.parse(urlString);

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['error'] != null) {
          throw BibleApiException(json['error']);
        }

        final results = json['results'] as List;
        return results.map((r) => VerseModel.fromJson(r)).toList();
      } else {
        throw BibleApiException(
          'Error searching verses',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is BibleApiException) rethrow;
      throw BibleApiException('Network error: $e');
    }
  }

  /// Obtener versículos de una categoría/emoción específica
  Future<List<VerseModel>> getVersesByCategory(String category) async {
    // Mapeo de categorías a versículos conocidos
    final Map<String, List<String>> categoryVersesEs = {
      'salmos': [
        'salmos 23:1',
        'salmos 91:1',
        'salmos 139:1',
        'salmos 46:1',
        'salmos 27:1',
      ],
      'isaias': [
        'isaias 41:10',
        'isaias 40:31',
        'isaias 26:3',
      ],
      'mateo': [
        'mateo 6:33',
        'mateo 11:28',
        'mateo 5:4',
      ],
      'filipenses': [
        'filipenses 4:6',
        'filipenses 4:13',
        'filipenses 4:19',
      ],
      'romanos': [
        'romanos 8:28',
        'romanos 5:8',
        'romanos 12:2',
      ],
      '2corintios': [
        '2corintios 5:17',
        '2corintios 12:9',
        '2corintios 4:18',
      ],
      'proverbios': [
        'proverbios 3:5',
        'proverbios 16:9',
        'proverbios 1:7',
      ],
      'hebreos': [
        'hebreos 11:1',
        'hebreos 13:8',
        'hebreos 4:16',
      ],
      '1juan': [
        '1juan 1:9',
        '1juan 4:8',
        '1juan 4:18',
      ],
    };

    final Map<String, List<String>> categoryVersesEn = {
      'psalms': [
        'psalms 23:1',
        'psalms 91:1',
        'psalms 139:1',
        'psalms 46:1',
        'psalms 27:1',
      ],
      'isaiah': [
        'isaiah 41:10',
        'isaiah 40:31',
        'isaiah 26:3',
      ],
      'matthew': [
        'matthew 6:33',
        'matthew 11:28',
        'matthew 5:4',
      ],
      'philippians': [
        'philippians 4:6',
        'philippians 4:13',
        'philippians 4:19',
      ],
      'romans': [
        'romans 8:28',
        'romans 5:8',
        'romans 12:2',
      ],
      '2corinthians': [
        '2corinthians 5:17',
        '2corinthians 12:9',
        '2corinthians 4:18',
      ],
      'proverbs': [
        'proverbs 3:5',
        'proverbs 16:9',
        'proverbs 1:7',
      ],
      'hebrews': [
        'hebrews 11:1',
        'hebrews 13:8',
        'hebrews 4:16',
      ],
      '1john': [
        '1john 1:9',
        '1john 4:8',
        '1john 4:18',
      ],
    };

    // Seleccionar según idioma
    final versesMap =
        _currentTranslation == 'nvi' ? categoryVersesEs : categoryVersesEn;
    final verses = versesMap[category.toLowerCase()] ?? versesMap['psalms']!;

    final results = <VerseModel>[];

    for (final ref in verses) {
      try {
        final verse = await getVerse(ref);
        results.add(verse);
      } catch (e) {
        continue;
      }
    }

    return results;
  }
}

import '../../domain/entities/verse.dart';

/// Modelo de datos: Versículo (DTO para la API)
class VerseModel extends Verse {
  const VerseModel({
    required super.id,
    required super.book,
    required super.chapter,
    required super.verse,
    required super.text,
    required super.translation,
  });
  
  /// Crear desde JSON de la API
  factory VerseModel.fromJson(Map<String, dynamic> json) {
    // La API de bible-api.com devuelve el libro como objeto o string
    String bookName;
    if (json['book'] is Map) {
      bookName = json['book']['name'] ?? 'Unknown';
    } else {
      bookName = json['book'] ?? 'Unknown';
    }
    
    return VerseModel(
      id: '${bookName}_${json['chapter']}_${json['verse']}',
      book: bookName,
      chapter: json['chapter'] ?? 1,
      verse: json['verse'] ?? 1,
      text: json['text'] ?? '',
      translation: json['translation'] ?? 'nvi',
    );
  }
  
  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'translation': translation,
    };
  }
  
  /// Crear desde entidad de dominio
  factory VerseModel.fromEntity(Verse verse) {
    return VerseModel(
      id: verse.id,
      book: verse.book,
      chapter: verse.chapter,
      verse: verse.verse,
      text: verse.text,
      translation: verse.translation,
    );
  }
  
  /// Convertir a entidad de dominio
  Verse toEntity() {
    return Verse(
      id: id,
      book: book,
      chapter: chapter,
      verse: verse,
      text: text,
      translation: translation,
    );
  }
}

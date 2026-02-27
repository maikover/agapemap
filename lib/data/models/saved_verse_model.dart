import '../../domain/entities/saved_verse.dart';

/// Modelo para base de datos local
class SavedVerseModel extends SavedVerse {
  const SavedVerseModel({
    required super.id,
    required super.verseId,
    required super.book,
    required super.chapter,
    required super.verse,
    required super.text,
    required super.emotionId,
    required super.savedAt,
    super.note,
  });

  /// Crear desde entidad
  factory SavedVerseModel.fromEntity(SavedVerse entity) {
    return SavedVerseModel(
      id: entity.id,
      verseId: entity.verseId,
      book: entity.book,
      chapter: entity.chapter,
      verse: entity.verse,
      text: entity.text,
      emotionId: entity.emotionId,
      savedAt: entity.savedAt,
      note: entity.note,
    );
  }

  /// Crear desde DB
  factory SavedVerseModel.fromMap(Map<String, dynamic> map) {
    return SavedVerseModel(
      id: map['id'] as String,
      verseId: map['verse_id'] as String,
      book: map['book'] as String,
      chapter: map['chapter'] as int,
      verse: map['verse'] as int,
      text: map['text'] as String,
      emotionId: map['emotion_id'] as String,
      savedAt: DateTime.parse(map['saved_at'] as String),
      note: map['note'] as String?,
    );
  }

  /// Convertir a Map para DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'verse_id': verseId,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
      'emotion_id': emotionId,
      'saved_at': savedAt.toIso8601String(),
      'note': note,
    };
  }

  /// Convertir a entidad
  SavedVerse toEntity() {
    return SavedVerse(
      id: id,
      verseId: verseId,
      book: book,
      chapter: chapter,
      verse: verse,
      text: text,
      emotionId: emotionId,
      savedAt: savedAt,
      note: note,
    );
  }
}

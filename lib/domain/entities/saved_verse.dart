import 'package:equatable/equatable.dart';

/// Entidad: Versículo guardado en el diario
class SavedVerse extends Equatable {
  final String id;
  final String verseId;
  final String book;
  final int chapter;
  final int verse;
  final String text;
  final String emotionId;
  final DateTime savedAt;
  final String? note;

  const SavedVerse({
    required this.id,
    required this.verseId,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.emotionId,
    required this.savedAt,
    this.note,
  });

  String get reference => '$book $chapter:$verse';

  @override
  List<Object?> get props => [id, verseId, book, chapter, verse, emotionId, savedAt, note];
}

import 'package:uuid/uuid.dart';
import '../../domain/entities/saved_verse.dart';
import '../../domain/entities/verse.dart';
import '../../domain/repositories/diary_repository.dart';

/// Caso de uso: Guardar versículo en el diario
class SaveVerseToDiary {
  final DiaryRepository repository;
  final Uuid _uuid = const Uuid();

  SaveVerseToDiary(this.repository);

  Future<void> call({
    required Verse verse,
    required String emotionId,
    String? note,
  }) async {
    final savedVerse = SavedVerse(
      id: _uuid.v4(),
      verseId: verse.id,
      book: verse.book,
      chapter: verse.chapter,
      verse: verse.verse,
      text: verse.text,
      emotionId: emotionId,
      savedAt: DateTime.now(),
      note: note,
    );

    await repository.saveVerse(savedVerse);
  }
}

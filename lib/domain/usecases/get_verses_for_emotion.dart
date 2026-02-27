import '../../domain/entities/verse.dart';
import '../../domain/repositories/verse_repository.dart';

/// Caso de uso: Obtener un versículo aleatorio para una emoción
class GetVersesForEmotion {
  final VerseRepository repository;
  
  GetVersesForEmotion(this.repository);
  
  Future<List<Verse>> call(String emotionId) async {
    return await repository.getVersesForEmotion(emotionId);
  }
}

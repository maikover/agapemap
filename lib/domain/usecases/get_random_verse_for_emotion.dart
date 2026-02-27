import '../../domain/entities/verse.dart';
import '../../domain/repositories/verse_repository.dart';

/// Caso de uso: Obtener un versículo aleatorio para una emoción
class GetRandomVerseForEmotion {
  final VerseRepository repository;
  
  GetRandomVerseForEmotion(this.repository);
  
  Future<Verse> call(String emotionId) async {
    return await repository.getRandomVerseForEmotion(emotionId);
  }
}

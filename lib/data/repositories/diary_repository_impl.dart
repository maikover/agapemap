import '../../domain/entities/saved_verse.dart';
import '../../domain/repositories/diary_repository.dart';
import '../datasources/diary_local_datasource.dart';
import '../models/saved_verse_model.dart';

/// Implementación del repositorio del diario
class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryLocalDataSource localDataSource;

  DiaryRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveVerse(SavedVerse verse) async {
    final model = SavedVerseModel.fromEntity(verse);
    await localDataSource.saveVerse(model);
  }

  @override
  Future<List<SavedVerse>> getSavedVerses() async {
    final models = await localDataSource.getSavedVerses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<SavedVerse?> getVerseById(String id) async {
    final model = await localDataSource.getVerseById(id);
    return model?.toEntity();
  }

  @override
  Future<void> deleteVerse(String id) async {
    await localDataSource.deleteVerse(id);
  }

  @override
  Future<void> updateNote(String id, String note) async {
    await localDataSource.updateNote(id, note);
  }

  @override
  Future<int> getSavedCount() async {
    return await localDataSource.getSavedCount();
  }

  @override
  Future<List<SavedVerse>> getVersesByEmotion(String emotionId) async {
    final models = await localDataSource.getVersesByEmotion(emotionId);
    return models.map((m) => m.toEntity()).toList();
  }
}

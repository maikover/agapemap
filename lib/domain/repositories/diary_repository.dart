import '../../domain/entities/saved_verse.dart';

/// Interfaz del repositorio del diario
abstract class DiaryRepository {
  /// Guardar un versículo
  Future<void> saveVerse(SavedVerse verse);
  
  /// Obtener todos los versículos guardados
  Future<List<SavedVerse>> getSavedVerses();
  
  /// Obtener un versículo por ID
  Future<SavedVerse?> getVerseById(String id);
  
  /// Eliminar un versículo
  Future<void> deleteVerse(String id);
  
  /// Actualizar nota
  Future<void> updateNote(String id, String note);
  
  /// Obtener cantidad de versículos guardados
  Future<int> getSavedCount();
  
  /// Obtener versículos por emoción
  Future<List<SavedVerse>> getVersesByEmotion(String emotionId);
}

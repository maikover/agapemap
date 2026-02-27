import '../../domain/entities/saved_verse.dart';
import '../../domain/repositories/diary_repository.dart';

/// Caso de uso: Obtener entradas del diario
class GetDiaryEntries {
  final DiaryRepository repository;

  GetDiaryEntries(this.repository);

  Future<List<SavedVerse>> call() async {
    return await repository.getSavedVerses();
  }
}

/// Caso de uso: Eliminar entrada del diario
class DeleteDiaryEntry {
  final DiaryRepository repository;

  DeleteDiaryEntry(this.repository);

  Future<void> call(String id) async {
    await repository.deleteVerse(id);
  }
}

/// Caso de uso: Actualizar nota de entrada
class UpdateDiaryNote {
  final DiaryRepository repository;

  UpdateDiaryNote(this.repository);

  Future<void> call(String id, String note) async {
    await repository.updateNote(id, note);
  }
}

/// Caso de uso: Obtener cantidad de entradas
class GetDiaryCount {
  final DiaryRepository repository;

  GetDiaryCount(this.repository);

  Future<int> call() async {
    return await repository.getSavedCount();
  }
}

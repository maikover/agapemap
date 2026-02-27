import 'package:get_it/get_it.dart';
import '../data/datasources/bible_remote_datasource.dart';
import '../data/datasources/diary_local_datasource.dart';
import '../data/datasources/prayer_local_datasource.dart';
import '../data/repositories/verse_repository_impl.dart';
import '../data/repositories/diary_repository_impl.dart';
import '../data/repositories/prayer_repository_impl.dart';
import '../domain/repositories/verse_repository.dart';
import '../domain/repositories/diary_repository.dart';
import '../domain/repositories/prayer_repository.dart';
import '../domain/usecases/get_verses_for_emotion.dart';
import '../domain/usecases/get_random_verse_for_emotion.dart';
import '../domain/usecases/save_verse_to_diary.dart';
import '../domain/usecases/diary_usecases.dart';
import '../domain/usecases/prayer_usecases.dart';
import '../core/utils/location_service.dart';

final sl = GetIt.instance;

/// Inicializar dependencias
Future<void> initDependencies() async {
  // Services
  sl.registerLazySingleton<LocationService>(() => LocationService());
  
  // Data Sources
  sl.registerLazySingleton<BibleRemoteDataSource>(
    () => BibleRemoteDataSource(),
  );
  
  sl.registerLazySingleton<DiaryLocalDataSource>(
    () => DiaryLocalDataSource(),
  );
  
  sl.registerLazySingleton<PrayerLocalDataSource>(
    () => PrayerLocalDataSource(),
  );
  
  // Repositories
  sl.registerLazySingleton<VerseRepositoryImpl>(
    () => VerseRepositoryImpl(remoteDataSource: sl()),
  );
  
  sl.registerLazySingleton<VerseRepository>(
    () => sl<VerseRepositoryImpl>(),
  );
  
  sl.registerLazySingleton<DiaryRepositoryImpl>(
    () => DiaryRepositoryImpl(localDataSource: sl()),
  );
  
  sl.registerLazySingleton<DiaryRepository>(
    () => sl<DiaryRepositoryImpl>(),
  );
  
  sl.registerLazySingleton<PrayerRepositoryImpl>(
    () => PrayerRepositoryImpl(localDataSource: sl()),
  );
  
  sl.registerLazySingleton<PrayerRepository>(
    () => sl<PrayerRepositoryImpl>(),
  );
  
  // Use Cases - Versículos
  sl.registerLazySingleton(() => GetVersesForEmotion(sl()));
  sl.registerLazySingleton(() => GetRandomVerseForEmotion(sl()));
  
  // Use Cases - Diario
  sl.registerLazySingleton(() => SaveVerseToDiary(sl()));
  sl.registerLazySingleton(() => GetDiaryEntries(sl()));
  sl.registerLazySingleton(() => DeleteDiaryEntry(sl()));
  sl.registerLazySingleton(() => UpdateDiaryNote(sl()));
  sl.registerLazySingleton(() => GetDiaryCount(sl()));
  
  // Use Cases - Oraciones
  sl.registerLazySingleton(() => SavePrayerLocation(sl()));
  sl.registerLazySingleton(() => GetNearbyPrayers(sl()));
  sl.registerLazySingleton(() => GetAllPrayers(sl()));
  sl.registerLazySingleton(() => DeletePrayer(sl()));
  sl.registerLazySingleton(() => GetPrayerCount(sl()));
}

/// Cambiar idioma de la app
void setAppLanguage(String languageCode) {
  final repository = sl<VerseRepositoryImpl>();
  repository.setLanguage(languageCode);
}

/// Obtener idioma actual
String getCurrentLanguage() {
  return sl<VerseRepositoryImpl>().currentLanguage;
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// El título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'AgapeMap'**
  String get appTitle;

  /// Subtítulo de la app
  ///
  /// In es, this message translates to:
  /// **'Tu palabra diaria'**
  String get subtitle;

  /// Botón para comenzar
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get start;

  /// Botón para ver el diario
  ///
  /// In es, this message translates to:
  /// **'Ver mi diario'**
  String get viewDiary;

  /// Título de selección de emoción
  ///
  /// In es, this message translates to:
  /// **'¿Cómo está tu corazón hoy?'**
  String get howIsYourHeart;

  /// Botón para recibir versículos
  ///
  /// In es, this message translates to:
  /// **'Recibir mi palabra'**
  String get receiveMyWord;

  /// Label para siguiente versículo
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get next;

  /// Label para guardar versículo
  ///
  /// In es, this message translates to:
  /// **'Amén'**
  String get amen;

  /// Mensaje cuando no hay versículos
  ///
  /// In es, this message translates to:
  /// **'No hay versículos disponibles'**
  String get noVersesAvailable;

  /// Título del diálogo de completion
  ///
  /// In es, this message translates to:
  /// **'¡Has recibido tu palabra!'**
  String get youReceivedYourWord;

  /// Mensaje de agradecimiento
  ///
  /// In es, this message translates to:
  /// **'Gracias por recibir hoy la palabra de Dios.'**
  String get thanksForReceiving;

  /// Botón para volver al inicio
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio'**
  String get backToHome;

  /// Título del diario
  ///
  /// In es, this message translates to:
  /// **'Diario'**
  String get diary;

  /// Mensaje de coming soon
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

  /// Emoción: Paz
  ///
  /// In es, this message translates to:
  /// **'Paz'**
  String get peace;

  /// Descripción de paz
  ///
  /// In es, this message translates to:
  /// **'Busca la paz del Espíritu Santo'**
  String get peaceDescription;

  /// Emoción: Redención
  ///
  /// In es, this message translates to:
  /// **'Redención'**
  String get redemption;

  /// Descripción de redención
  ///
  /// In es, this message translates to:
  /// **'Libertad de ansiedad y preocupación'**
  String get redemptionDescription;

  /// Emoción: Fortaleza
  ///
  /// In es, this message translates to:
  /// **'Fortaleza'**
  String get strength;

  /// Descripción de fortaleza
  ///
  /// In es, this message translates to:
  /// **'Busca fuerza y gloria'**
  String get strengthDescription;

  /// Emoción: Renovación
  ///
  /// In es, this message translates to:
  /// **'Renovación'**
  String get renewal;

  /// Descripción de renovación
  ///
  /// In es, this message translates to:
  /// **'Crecimiento espiritual'**
  String get renewalDescription;

  /// Emoción: Sabiduría
  ///
  /// In es, this message translates to:
  /// **'Sabiduría'**
  String get wisdom;

  /// Descripción de sabiduría
  ///
  /// In es, this message translates to:
  /// **'Guía divina para decisiones'**
  String get wisdomDescription;

  /// Emoción: Santidad
  ///
  /// In es, this message translates to:
  /// **'Santidad'**
  String get holiness;

  /// Descripción de santidad
  ///
  /// In es, this message translates to:
  /// **'Limpieza y paz interior'**
  String get holinessDescription;

  /// Título de error genérico
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// Mensaje de error de red
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Intenta de nuevo.'**
  String get networkError;

  /// Mensaje cuando se guarda un versículo
  ///
  /// In es, this message translates to:
  /// **'Versículo guardado'**
  String get verseSaved;

  /// Confirmar eliminación
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar esta entrada?'**
  String get deleteConfirmation;

  /// Botón eliminar
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// Botón cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Diario vacío
  ///
  /// In es, this message translates to:
  /// **'Tu diario está vacío'**
  String get emptyDiary;

  /// Hint para diario vacío
  ///
  /// In es, this message translates to:
  /// **'Guarda versículos con Amén para verlos aquí'**
  String get emptyDiaryHint;

  /// Título del mapa
  ///
  /// In es, this message translates to:
  /// **'Mapa de Bendiciones'**
  String get blessingsMap;

  /// Permiso requerido
  ///
  /// In es, this message translates to:
  /// **'Se requiere permiso de ubicación'**
  String get locationPermissionRequired;

  /// Hint de permiso
  ///
  /// In es, this message translates to:
  /// **'Para ver oraciones cerca de ti'**
  String get locationPermissionHint;

  /// Botón habilitar
  ///
  /// In es, this message translates to:
  /// **'Habilitar ubicación'**
  String get enableLocation;

  /// Sin oraciones
  ///
  /// In es, this message translates to:
  /// **'No hay oraciones cercanas'**
  String get noPrayersNearby;

  /// Hint para plantar
  ///
  /// In es, this message translates to:
  /// **'Planta una oración en este lugar'**
  String get plantPrayerHint;

  /// Título de plantar
  ///
  /// In es, this message translates to:
  /// **'Plantar Oración'**
  String get plantPrayer;

  /// Selector de emoción
  ///
  /// In es, this message translates to:
  /// **'Selecciona una emoción'**
  String get selectEmotion;

  /// Versículo opcional
  ///
  /// In es, this message translates to:
  /// **'Versículo (opcional)'**
  String get verseReferenceOptional;

  /// Input de oración
  ///
  /// In es, this message translates to:
  /// **'Tu oración'**
  String get yourPrayer;

  /// Hint de oración
  ///
  /// In es, this message translates to:
  /// **'Escribe una oración de esperanza...'**
  String get prayerHint;

  /// Ubicación requerida
  ///
  /// In es, this message translates to:
  /// **'Se requiere tu ubicación'**
  String get locationRequired;

  /// Botón plantar
  ///
  /// In es, this message translates to:
  /// **'Plantar'**
  String get plant;

  /// Botón compartir
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get share;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

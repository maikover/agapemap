import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:agapemap/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/locale_service.dart';
import 'config/injection.dart';
import 'presentation/pages/splash_screen.dart';
import 'presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientación
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configurar System UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  // Inicializar dependencias
  await initDependencies();
  
  runApp(const AgapeMapApp());
}

class AgapeMapApp extends StatefulWidget {
  const AgapeMapApp({super.key});

  @override
  State<AgapeMapApp> createState() => _AgapeMapAppState();
}

class _AgapeMapAppState extends State<AgapeMapApp> {
  Locale _locale = const Locale('es');
  
  void _changeLanguage(Locale locale) {
    if (!LocaleService.isSupported(locale)) return;
    
    setState(() {
      _locale = locale;
    });
    
    // Actualizar traducción en la API
    setAppLanguage(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgapeMap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocaleService.supportedLocales,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

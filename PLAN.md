# AgapeMap - Plan de Implementación Detallado

## Visión General del Proyecto

**Nombre:** AgapeMap (o "Cromía Bíblica")  
**Tipo:** Aplicación móvil Android/iOS  
**Framework:** Flutter  
**Objetivo:** Conectar la Palabra de Dios con las emociones del usuario y su entorno físico

---

## Fase 1: Fundamentos

### 1.1 Configuración Inicial del Proyecto
- [ ] 1.1.1 Renombrar proyecto de `flutter_app` a `agapemap`
- [ ] 1.1.2 Actualizar pubspec.yaml con metadatos (name, description, version)
- [ ] 1.1.3 Ejecutar `flutter pub get` para verificar dependencias base
- [ ] 1.1.4 Generar estructura de carpetas Clean Architecture
- [ ] 1.1.5 Crear archivo main.dart con estructura básica

### 1.2 Estructura Clean Architecture
- [ ] 1.2.1 Crear carpeta `lib/core/`
  - [ ] 1.2.1.1 `lib/core/constants/` — Constantes globales (colores, strings, API endpoints)
  - [ ] 1.2.1.2 `lib/core/theme/` — Tema de la app (colores bíblicos, tipografía)
  - [ ] 1.2.1.3 `lib/core/utils/` — Utilidades (helpers, extensiones)
  - [ ] 1.2.1.4 `lib/core/error/` — Manejo de errores (excepciones, failiures)
- [ ] 1.2.2 Crear carpeta `lib/data/`
  - [ ] 1.2.2.1 `lib/data/datasources/` — Fuentes de datos (API, local)
  - [ ] 1.2.2.2 `lib/data/models/` — Modelos de datos (DTOs)
  - [ ] 1.2.2.3 `lib/data/repositories/` — Implementación de repositorios
- [ ] 1.2.3 Crear carpeta `lib/domain/`
  - [ ] 1.2.3.1 `lib/domain/entities/` — Entidades del negocio
  - [ ] 1.2.3.2 `lib/domain/repositories/` — Interfaces de repositorios
  - [ ] 1.2.3.3 `lib/domain/usecases/` — Casos de uso
- [ ] 1.2.4 Crear carpeta `lib/presentation/`
  - [ ] 1.2.4.1 `lib/presentation/pages/` — Pantallas principales
  - [ ] 1.2.4.2 `lib/presentation/widgets/` — Widgets reutilizables
  - [ ] 1.2.4.3 `lib/presentation/providers/` — Proveedores de estado (BLoC)
- [ ] 1.2.5 Crear carpeta `lib/config/` — Configuraciones (routes, injection)

### 1.3 Integración Free Use Bible API
- [ ] 1.3.1 Estudiar documentación de la API
  - [ ] 1.3.1.1 Endpoint base: `https://bible-api.com/` o similar
  - [ ] 1.3.1.2 Formato de respuesta JSON
  - [ ] 1.3.1.3 Métodos disponibles (buscar por libro, capítulo, versículo)
- [ ] 1.3.2 Crear modelo `VerseModel` en `lib/data/models/`
  - [ ] 1.3.2.1 Propiedades: book, chapter, verse, text, translation
  - [ ] 1.3.2.2 Método fromJson()
  - [ ] 1.3.2.3 Método toJson()
- [ ] 1.3.3 Crear datasource `BibleRemoteDataSource` en `lib/data/datasources/`
  - [ ] 1.3.3.1 Método getVerse(reference)
  - [ ] 1.3.3.2 Método getVersesByCategory(category)
  - [ ] 1.3.3.3 Método searchVerses(query)
- [ ] 1.3.4 Crear entidad `Verse` en `lib/domain/entities/`
- [ ] 1.3.5 Crear repositorio `VerseRepository` (interfaz + implementación)
- [ ] 1.3.6 Crear caso de uso `GetDailyVerse`
- [ ] 1.3.7 Crear caso de uso `GetVersesByEmotion`

### 1.4 Pantalla de Inicio Básica
- [ ] 1.4.1 Crear pantalla `SplashScreen`
  - [ ] 1.4.1.1 Logo de AgapeMap
  - [ ] 1.4.1.2 Animación de carga (2 segundos)
  - [ ] 1.4.1.3 Navegación automática a HomeScreen
- [ ] 1.4.2 Crear pantalla `HomeScreen`
  - [ ] 1.4.2.1 Título "AgapeMap"
  - [ ] 1.4.2.2 Botón "Comenzar" (placeholder)
  - [ ] 1.4.2.3 Fondo simple (color ] 1. sólido)
- [4.3 Configurar navegación básica con GoRouter o Navigator
- [ ] 1.4.4 Ejecutar build de prueba (`flutter build apk --debug`)

### Entregables Fase 1
- Proyecto Flutter con estructura Clean Architecture funcionando
- API de Biblia integrada y probada
- Pantallas Splash y Home operativos

---

## Fase 2: Termómetro Emocional + Arte Generativo

### 2.1 Sistema de Emociones Bíblicas
- [ ] 2.1.1 Definir emotions mapping (emoción → categoría bíblica → color)
  - [ ] 2.1.1.1 Azul → Paz/Esperanza → Salmos 23, 91, 139
  - [ ] 2.1.1.2 Rojo → Ansiedad/Redención → Mateo 6, Filipenses 4
  - [ ] 2.1.1.3 Ámbar → Fuerza/Gloria → Josué 1, Salmos 18
  - [ ] 2.1.1.4 Verde → Renovación/Crecimiento → 2 Corintios 5, Romanos 12
  - [ ] 2.1.1.5 Púrpura → Sabiduría/Realeza → Proverbios, Salmos 119
  - [ ] 2.1.1.6 Blanco → Limpieza/Santidad → Hebreos 10, 1 Juan 1
- [ ] 2.1.2 Crear modelo `Emotion` en `lib/domain/entities/`
  - [ ] 2.1.2.1 Propiedades: id, name, color, description, bibleCategories
- [ ] 2.1.3 Crear constante `emotions` en `lib/core/constants/`
- [ ] 2.1.4 Crear provider/emotion provider para estado seleccionado

### 2.2 Pantalla de Termómetro Emocional
- [ ] 2.2.1 Crear `EmotionSelectionScreen`
  - [ ] 2.2.1.1 Título: "¿Cómo está tu corazón hoy?"
  - [ ] 2.2.1.2 Grid de opciones de emociones (círculos coloreados)
  - [ ] 2.2.1.3 Nombre de cada emoción bajo el círculo
  - [ ] 2.2.1.4 Descripción breve al seleccionar
  - [ ] 2.2.1.5 Botón "Recibir mi palabra" → navega a VerseScreen
- [ ] 2.2.2 Implementar animación de selección (escala, opacidad)
- [ ] 2.2.3 Guardar emoción seleccionada en SharedPreferences

### 2.3 Motor de Arte Generativo
- [ ] 2.3.1 Crear widget `GenerativeArtBackground` en `lib/presentation/widgets/`
  - [ ] 2.3.1.1 Usar CustomPainter
  - [ ] 2.3.1.2 Implementar patrones geométricos (mandala, ondas, espirales)
  - [ ] 2.3.1.3 Usar funciones trigonométricas (sin, cos, tan)
  - [ ] 2.3.1.4 Animación fluida (AnimationController + vsync)
- [ ] 2.3.2 Implementar cambio de colores según emoción
  - [ ] 2.3.2.1接受 emotion.color como parámetro
  - [ ] 2.3.2.2 Generar gradientes y tonos derivados
- [ ] 2.3.3 Optimizar rendimiento (usar canvas.save/restore, evitar recrear objetos)
- [ ] 2.3.4 Integrar como fondo de pantallas principales

### 2.4 Conexión Emoción → Versículos
- [ ] 2.4.1 Crear caso de uso `GetVersesForEmotion`
  - [ ] 2.4.1.1 Input: emotionId
  - [ ] 2.4.1.2 Output: lista de versículos de categorías relacionadas
- [ ] 2.4.2 Crear caso de uso `GetRandomVerseForEmotion`
- [ ] 2.4.3 Implementar cacheo básico de versículos por emoción

### Entregables Fase 2
- Pantalla de selección emocional funcional
- Arte generativo animado con colores bíblicos
- Sistema de recomendación de versículos por emoción

---

## Fase 3: Mecánica de Swipe

### 3.1 Configuración de Flutter Card Swiper
- [ ] 3.1.1 Agregar dependencia `flutter_card_swiper` al pubspec.yaml
- [ ] 3.1.2 Importar y configurar en el proyecto
- [ ] 3.1.3 Probar con lista de prueba de versículos

### 3.2 Pantalla de Versículos (Swipe)
- [ ] 3.2.1 Crear `VerseSwipeScreen`
  - [ ] 3.2.1.1 Fondo: arte generativo (de Fase 2)
  - [ ] 3.2.1.2 Widget de tarjeta de versículo
  - [ ] 3.2.1.3 Indicadores de swipe (izquierda/derecha)
- [ ] 3.2.2 Diseñar tarjeta de versículo
  - [ ] 3.2.2.1 Fondo blanco/crema semitransparente
  - [ ] 3.2.2.2 Texto del versículo (referencia + contenido)
  - [ ] 3.2.2.3 Decoración (bordes redondeados, sombra)
  - [ ] 3.2.2.4 Iconos de guía (←Otro | Amén→)
- [ ] 3.2.3 Implementar lógica de swipe
  - [ ] 3.2.3.1 Swipe derecha → "Amén" → guardar en diario
  - [ ] 3.2.3.2 Swipe izquierda → Siguiente versículo
  - [ ] 3.2.3.3 Animación de transición
- [ ] 3.2.4 Gestionar caso cuando se agotan versículos
  - [ ] 3.2.4.1 Mensaje: "Has recibido toda la palabra para hoy"
  - [ ] 3.2.4.2 Botón para volver al inicio

### 3.3 Sistema de Diario (Versículos Guardados)
- [ ] 3.3.1 Crear modelo `SavedVerse` en `lib/data/models/`
  - [ ] 3.3.1.1 Propiedades: verseId, verseText, emotion, savedAt, note (opcional)
- [ ] 3.3.2 Crear datasource local `VerseLocalDataSource`
  - [ ] 3.3.2.1 Usar SQLite (sqflite) o SharedPreferences
  - [ ] 3.3.2.2 Métodos: saveVerse, getSavedVerses, deleteVerse
- [ ] 3.3.3 Crear repositorio `DiaryRepository` (interfaz + implementación)
- [ ] 3.3.4 Crear caso de uso `SaveVerseToDiary`
- [ ] 3.3.5 Crear caso de uso `GetDiaryEntries`

### 3.4 Pantalla de Diario
- [ ] 3.4.1 Crear `DiaryScreen`
  - [ ] 3.4.1.1 Lista de versículos guardados
  - [ ] 3.4.1.2 Fecha de guardado
  - [ ] 3.4.1.3 Emoción asociada
  - [ ] 3.4.1.4 Opción de eliminar entrada
- [ ] 3.4.2 Implementar orden cronológico inverso
- [ ] 3.4.3 Agregar búsqueda en diario

### 3.5 Pantalla de Detalle de Versículo
- [ ] 3.5.1 Crear `VerseDetailScreen`
  - [ ] 3.5.1.1 Versículo completo
  - [ ] 3.5.1.2 Nota personal (agregar/editar)
  - [ ] 3.5.1.3 Opción de compartir

### Entregables Fase 3
- Mecánica de swipe funcionando
- Diario de versículos guardados operativo
- Navegación completa entre pantallas

---

## Fase 4: Mapa de Bendiciones (Geofencing)

### 4.1 Configuración de Permisos
- [ ] 4.1.1 Agregar permisos en `android/app/src/main/AndroidManifest.xml`
  - [ ] 4.1.1.1 `ACCESS_FINE_LOCATION`
  - [ ] 4.1.1.2 `ACCESS_COARSE_LOCATION`
  - [ ] 4.1.1.3 `ACCESS_BACKGROUND_LOCATION`
  - [ ] 4.1.1.4 `FOREGROUND_SERVICE`
  - [ ] 4.1.1.5 `POST_NOTIFICATIONS` (Android 13+)
- [ ] 4.1.2 Agregar permisos en `ios/Runner/Info.plist`
  - [ ] 4.1.2.1 `NSLocationWhenInUseUsageDescription`
  - [ ] 4.1.2.2 `NSLocationAlwaysAndWhenInUseUsageDescription`
- [ ] 4.1.3 Implementar solicitud de permisos con `permission_handler`
- [ ] 4.1.4 Crear pantalla de explicación de permisos

### 4.2 Servicio de Geolocalización
- [ ] 4.2.1 Crear `LocationService` en `lib/core/utils/`
  - [ ] 4.2.1.1 Obtener ubicación actual
  - [ ] 4.2.1.2 Monitorear cambios de ubicación
  - [ ] 4.2.1.3 Calcular distancia entre puntos
- [ ] 4.2.2 Crear modelo `LocationData` en `lib/domain/entities/`
- [ ] 4.2.3 Implementar manejo de errores de ubicación

### 4.3 Sistema de Geofencing
- [ ] 4.3.1 Evaluar opciones de geofencing:
  - [ ] 4.3.1.1 Opción A: Geolocator + проверка manual (más control)
  - [ ] 4.3.1.2 Opción B: flutter_local_notifications con location triggers
  - [ ] 4.3.1.3 Opción C: geofence_service package
- [ ] 4.3.2 Implementar sistema elegido
  - [ ] 4.3.2.1 Definir radio de geofence (default: 100 metros)
  - [ ] 4.3.2.2 Crear/destroy geofences dinámicamente
  - [ ] 4.3.2.3 Manejar entrada/salida de geofences

### 4.4 Base de Datos de Oraciones
- [ ] 4.4.1 Crear modelo `PrayerLocation` en `lib/data/models/`
  - [ ] 4.4.1.1 Propiedades: id, latitude, longitude, verseText, prayerText, createdAt, authorId (anonimizado)
- [ ] 4.4.2 Crear tabla en SQLite para oraciones geolocalizadas
- [ ] 4.4.3 Implementar datasource `PrayerLocalDataSource`
  - [ ] 4.4.3.1 Método savePrayerLocation(prayer)
  - [ ] 4.4.3.2 Método getNearbyPrayers(lat, lng, radius)
  - [ ] 4.4.3.3 Método deletePrayerLocation(id)
- [ ] 4.4.4 Crear repositorio `PrayerRepository`

### 4.5 Pantalla del Mapa
- [ ] 4.5.1 Crear `MapScreen`
  - [ ] 4.5.1.1 Mapa de la ciudad (Google Maps o OpenStreetMap)
  - [ ] 4.5.1.2 Marcadores de oraciones cercanas
  - [ ] 4.5.1.3 Mi ubicación actual
- [ ] 4.5.2 Implementar `PrayerMarker`
  - [ ] 4.5.2.1 Icono de marcador (vela, cruz, corazón)
  - [ ] 4.5.2.2 Popup con vista previa de oración
- [ ] 4.5.3 Crear `CreatePrayerScreen` (modal/bottom sheet)
  - [ ] 4.5.3.1 Selector de versículo (del diario o buscar)
  - [ ] 4.5.3.2 Campo de oración personal
  - [ ] 4.5.3.3 Botón "Plantar oración aquí"

### 4.6 Notificaciones de Oraciones Cercanas
- [ ] 4.6.1 Configurar `flutter_local_notifications`
- [ ] 4.6.2 Crear notificación de "oración cercana"
  - [ ] 4.6.2.1 Título: "🙏 Oración cerca de ti"
  - [ ] 4.6.2.2 Cuerpo: "Alguien dejó una palabra de esperanza en este lugar"
  - [ ] 4.6.2.3 Acción: abrir mapa en ubicación
- [ ] 4.6.3 Implementar lógica de déclenche
  - [ ] 4.6.3.1 Cuando usuario entra en geofence de oración
  - [ ] 4.6.3.2 Verificar que no sea la misma oración ya mostrada
  - [ ] 4.6.3.3 Rate limiting (máx 1 notificación por hora)

### 4.7 Funcionalidades Avanzadas (Opcional)
- [ ] 4.7.1 Rutas de oraciones (heatmap de oraciones en la ciudad)
- [ ] 4.7.2 Estadísticas personales de oraciones plantadas
- [ ] 4.7.3 Reporte de oraciones inapropiadas

### Entregables Fase 4
- Mapa con oraciones geolocalizadas
- Sistema de plantar oraciones en ubicaciones
- Notificaciones cuando hay oraciones cercanas

---

## Fase 5: Monetización + Viralidad

### 5.1 Sistema de Suscripciones Premium
- [ ] 5.1.1 Definir características Premium
  - [ ] 5.1.1.1 Diario ilimitado (sin límite de 10 entradas)
  - [ ] 5.1.1.2 Estadísticas emocionales (gráficos de estados de ánimo)
  - [ ] 5.1.1.3 Oraciones geolocalizadas ilimitadas (sin límite de 3)
  - [ ] 5.1.1.4 Temas de arte adicionales
  - [ ] 5.1.1.5 Exportar diario como PDF
- [ ] 5.1.2 Implementar servicio de pagos (Flutter)
  - [ ] 5.1.2.1 Integrar `in_app_purchase` o similar
  - [ ] 5.1.2.2 Suscripción mensual ($2.99/mes)
  - [ ] 5.1.2.3 Suscripción anual ($19.99/año) - 44% dto
- [ ] 5.1.3 Crear pantalla de Premium
  - [ ] 5.1.3.1 Beneficios claramente expuestos
  - [ ] 5.1.3.2 Botones de suscripción
  - [ ] 5.1.3.3 Restaurar compras
- [ ] 5.1.4 Implementar verificación de estado Premium
  - [ ] 5.1.4.1 Guardar estado en SecureStorage
  - [ ] 5.1.4.2 Verificar al inicio de la app

### 5.2 Generador de Imágenes para Compartir
- [ ] 5.2.1 Crear `ShareGenerator`
  - [ ] 5.2.1.1 Combinar versículo + arte generativo
  - [ ] 5.2.1.2 Agregar marca de agua discreta "AgapeMap"
  - [ ] 5.2.1.3 Exportar como imagen (PNG/JPG)
- [ ] 5.2.2 Implementar compartir nativo
  - [ ] 5.2.2.1 Usar `share_plus` para compartir en redes
  - [ ] 5.2.2.2 Integración con Stories de Instagram
  - [ ] 5.2.2.3 Estados de WhatsApp
- [ ] 5.2.3 Crear pantalla de "Comparte tu palabra"
  - [ ] 5.2.3.1 Vista previa de imagen
  - [ ] 5.2.3.2 Selector de red social
  - [ ] 5.2.3.3 Guardar en galería

### 5.3 Integración con Redes Sociales
- [ ] 5.3.1 Deep links para compartir
  - [ ] 5.3.1.1 URL scheme: `agapemap://verse/{id}`
  - [ ] 5.3.1.2 Universal links para web
- [ ] 5.3.2 Widget de invitación
  - [ ] 5.3.2.1 "Invita a un amigo a recibir palabra"
  - [ ] 5.3.2.2 Link de referido único
- [ ] 5.3.3 Publicación automática (opcional con consentimiento)

### 5.4 Analítica y Optimización
- [ ] 5.4.1 Integrar Firebase Analytics o similar
  - [ ] 5.4.1.1 Eventos de uso (swipes, saves, prayers)
  - [ ] 5.4.1.2 Funnel de conversión Premium
  - [ ] 5.4.1.3 Métricas de retención
- [ ] 5.4.2 Configurar Crashlytics
- [ ] 5.4.3 Implementar A/B testing para UI

### 5.5 Preparación para Producción
- [ ] 5.5.1 Configurar build para Release
  - [ ] 5.5.1.1 ProGuard/R8 para Android
  - [ ] 5.5.1.2 Optimización de assets
- [ ] 5.5.2 Preparar Store Listings
  - [ ] 5.5.2.1 Screenshots profesionales
  - [ ] 5.5.2.2 Descripciones optimizadas
  - 5.5.2.3 Keywords de ASO
- [ ] 5.5.3 Crear Política de Privacidad
- [ ] 5.5.4 Configurar Terms of Service

### Entregables Fase 5
- Sistema de suscripciones funcionando
- Compartir en redes sociales operativo
- App lista para publicación en stores

---

## Dependencias Completas (pubspec.yaml)

```yaml
name: agapemap
description: Conecta la Palabra de Dios con tus emociones y tu entorno.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  
  # Networking
  http: ^1.1.0
  
  # UI Components
  flutter_card_swiper: ^6.0.0
  google_fonts: ^6.1.0
  
  # Location & Maps
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  google_maps_flutter: ^2.5.0
  flutter_map: ^4.0.0
  latlong2: ^0.9.0
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
  # Storage
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # Utilities
  uuid: ^4.2.1
  intl: ^0.18.1
  url_launcher: ^6.2.1
  share_plus: ^7.2.1
  permission_handler: ^11.1.0
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  provider: ^6.1.1
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Monetization
  in_app_purchase: ^3.1.5
  
  # Analytics (optional)
  firebase_core: ^2.24.0
  firebase_analytics: ^10.7.0
  firebase_crashlytics: ^3.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
```

---

## Orden de Implementación Recomendado

1. **Semana 1**: Fases 1.1 - 1.4 (Fundamentos + API + UI básica)
2. **Semana 2**: Fases 2.1 - 2.4 (Emociones + Arte Generativo)
3. **Semana 3**: Fases 3.1 - 3.5 (Swipe + Diario)
4. **Semana 4**: Fases 4.1 - 4.4 (Geolocalización + Base de datos)
5. **Semana 5**: Fases 4.5 - 4.6 (Mapa + Notificaciones)
6. **Semana 6**: Fase 5 (Monetización + Viralidad + Producción)

---

*Documento actualizado: $(date)*
*Proyecto: AgapeMap*
*Ubicación: `/root/.openclaw/workspace/agapemap/`*

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Servicio de geolocalización
class LocationService {
  Position? _lastPosition;
  
  /// Obtener última posición conocida
  Position? get lastPosition => _lastPosition;
  
  /// Verificar y solicitar permisos de ubicación
  Future<bool> requestPermission() async {
    // Verificar si los permisos están habilitados
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    
    var permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }
  
  /// Obtener ubicación actual
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return null;
      
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      
      _lastPosition = position;
      return position;
    } catch (e) {
      return null;
    }
  }
  
  /// Obtener ubicación actual (solo cuando está en uso)
  Future<Position?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      _lastPosition = position;
      return position;
    } catch (e) {
      return null;
    }
  }
  
  /// Calcular distancia entre dos puntos
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude, startLongitude,
      endLatitude, endLongitude,
    );
  }
  
  /// Stream de ubicación en tiempo real
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // metros
      ),
    );
  }
  
  /// Abrir configuración de ubicación
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
  
  /// Abrir configuración de permisos
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import 'passenger_data.dart';

/// Datos de los viajes pasados, recurrentes, en curso y del buscador.
///
/// Complementa a [PassengerData] con las vistas que todavía no tenían su
/// fuente de datos: detalle de viaje pasado (PAS-19), viajes recurrentes
/// (PAS-17/18), viaje en curso (PAS-12) y búsqueda de viaje (PAS-02).
///
/// TODO(gateway): cuando el API esté disponible, sustituir estos valores
/// por las llamadas al backend (los getters pasarán a ser `async`) sin
/// tocar las vistas más allá de manejar el estado de carga.
abstract class TripsExtraData {
  TripsExtraData._();

  // ── Detalle de viaje pasado (PAS-19) ──────────────────────────
  static const PastTripDetail pastTrip = PastTripDetail(
    title: 'Viaje del vie 2 oct',
    statusLabel: 'Finalizado',
    price: 'S/ 7.50',
    route: 'Lince → San Isidro',
    details: '7:10 a 7:36 a. m. · calificaste con 5 estrellas',
    people: [
      PastTripPerson(
        initials: 'CH',
        name: 'Carlos Huamán',
        role: 'Conductor · 4.8',
        background: AppColors.primarySoft,
        foreground: AppColors.primaryDark,
      ),
      PastTripPerson(
        initials: 'AM',
        name: 'Andrea M.',
        role: 'Pasajera',
        background: AppColors.accentSoft,
        foreground: AppColors.warning,
      ),
      PastTripPerson(
        initials: 'LT',
        name: 'Luis T.',
        role: 'Pasajero',
        background: AppColors.primarySoft,
        foreground: AppColors.primaryDark,
      ),
      PastTripPerson(
        initials: 'RC',
        name: 'Rosa C.',
        role: 'Pasajera',
        background: AppColors.accentSoft,
        foreground: AppColors.warning,
      ),
    ],
  );

  // ── Viajes recurrentes (PAS-18) ───────────────────────────────
  static const List<RecurringTrip> recurringTrips = [
    RecurringTrip(
      from: 'Lince',
      to: 'San Isidro',
      schedule: 'Lun a vie · 7:00 a 8:00 a. m.',
      initiallyActive: true,
      activeNote: 'Próxima solicitud: lun 12 oct',
      pausedNote: 'Sin solicitudes nuevas desde el 3 oct',
    ),
    RecurringTrip(
      from: 'Lince',
      to: 'Monterrico',
      schedule: 'Sábados · 8:30 a 9:30 a. m.',
      initiallyActive: false,
      activeNote: 'Próxima solicitud: sáb 17 oct',
      pausedNote: 'Sin solicitudes nuevas desde el 3 oct',
    ),
  ];

  // ── Formulario de viaje recurrente (PAS-17) ───────────────────
  /// Ruta que precargan los formularios de recurrencia y de búsqueda.
  static const TripRoute defaultRoute = TripRoute(
    origin: 'Av. Arequipa 2450, Lince',
    destination: 'C. E. Real, San Isidro',
  );

  static const RecurringFormDefaults recurringForm = RecurringFormDefaults(
    route: defaultRoute,
    departureTime: '7:00 a. m.',
    arrivalTime: '8:00 a. m.',
    startDate: 'Lunes 12 de octubre',
  );

  // ── Viaje en curso (PAS-12) ───────────────────────────────────
  static const LiveTripUpdate liveTrip = LiveTripUpdate(
    statusLabel: 'Viaje en curso',
    eta: 'Llegas a las 7:38 a. m.',
    etaDetail: 'San Isidro · faltan 14 minutos',
    nextStopTitle: 'Próxima: Av. Arenales con Canevaro',
    nextStopSubtitle: 'En 3 min · sube 1 pasajero',
    driver: PassengerData.driver,
    vehicleLine: 'Toyota Yaris gris plata',
    shareStatus: 'Compartes tu ubicación con Rosa (mamá)',
  );

  // ── Buscar viaje (PAS-02) ─────────────────────────────────────
  static const SearchFormDefaults searchForm = SearchFormDefaults(
    route: defaultRoute,
    fromTime: '7:00 a. m.',
    toTime: '8:00 a. m.',
  );

  static const List<RecentSearch> recentSearches = [
    RecentSearch(
      title: 'Lince → San Isidro',
      subtitle: 'Lun a vie · 7:00 a 8:00 a. m.',
    ),
    RecentSearch(
      title: 'Lince → Monterrico',
      subtitle: 'Sábado · 8:30 a 9:30 a. m.',
    ),
  ];
}

// ── Modelos ───────────────────────────────────────────────────────

/// Viaje terminado con su resumen y las personas que viajaron (PAS-19).
class PastTripDetail {
  const PastTripDetail({
    required this.title,
    required this.statusLabel,
    required this.price,
    required this.route,
    required this.details,
    required this.people,
  });

  /// Título del viaje, por ejemplo `'Viaje del vie 2 oct'`.
  final String title;

  /// Estado del viaje, por ejemplo `'Finalizado'`.
  final String statusLabel;

  /// Monto cobrado, por ejemplo `'S/ 7.50'`.
  final String price;

  /// Ruta, por ejemplo `'Lince → San Isidro'`.
  final String route;

  /// Horario y calificación, por ejemplo `'7:10 a 7:36 a. m. · calificaste con 5 estrellas'`.
  final String details;

  final List<PastTripPerson> people;
}

/// Persona que viajó en un viaje pasado (conductor o pasajero).
class PastTripPerson {
  const PastTripPerson({
    required this.initials,
    required this.name,
    required this.role,
    required this.background,
    required this.foreground,
  });

  final String initials;
  final String name;

  /// Rol y calificación, por ejemplo `'Conductor · 4.8'` o `'Pasajera'`.
  final String role;

  /// Color de fondo del avatar.
  final Color background;

  /// Color de texto del avatar.
  final Color foreground;
}

/// Viaje recurrente guardado por el pasajero (PAS-18).
class RecurringTrip {
  const RecurringTrip({
    required this.from,
    required this.to,
    required this.schedule,
    required this.initiallyActive,
    required this.activeNote,
    required this.pausedNote,
  });

  final String from;
  final String to;

  /// Frecuencia, por ejemplo `'Lun a vie · 7:00 a 8:00 a. m.'`.
  final String schedule;

  /// Estado inicial del interruptor de la tarjeta.
  final bool initiallyActive;

  /// Nota mostrada cuando el viaje está activo.
  final String activeNote;

  /// Nota mostrada cuando el viaje está en pausa.
  final String pausedNote;
}

/// Ruta precargada en un formulario (origen y destino).
class TripRoute {
  const TripRoute({required this.origin, required this.destination});

  final String origin;
  final String destination;
}

/// Valores iniciales del formulario de viaje recurrente (PAS-17).
class RecurringFormDefaults {
  const RecurringFormDefaults({
    required this.route,
    required this.departureTime,
    required this.arrivalTime,
    required this.startDate,
  });

  final TripRoute route;

  /// Hora de salida, por ejemplo `'7:00 a. m.'`.
  final String departureTime;

  /// Hora de llegada, por ejemplo `'8:00 a. m.'`.
  final String arrivalTime;

  /// Fecha de inicio, por ejemplo `'Lunes 12 de octubre'`.
  final String startDate;
}

/// Datos del viaje en curso que se muestran en el panel (PAS-12).
class LiveTripUpdate {
  const LiveTripUpdate({
    required this.statusLabel,
    required this.eta,
    required this.etaDetail,
    required this.nextStopTitle,
    required this.nextStopSubtitle,
    required this.driver,
    required this.vehicleLine,
    required this.shareStatus,
  });

  /// Estado del viaje, por ejemplo `'Viaje en curso'`.
  final String statusLabel;

  /// Hora estimada de llegada, por ejemplo `'Llegas a las 7:38 a. m.'`.
  final String eta;

  /// Destino y minutos restantes, por ejemplo `'San Isidro · faltan 14 minutos'`.
  final String etaDetail;

  /// Próxima parada, por ejemplo `'Próxima: Av. Arenales con Canevaro'`.
  final String nextStopTitle;

  /// Detalle de la próxima parada, por ejemplo `'En 3 min · sube 1 pasajero'`.
  final String nextStopSubtitle;

  /// Conductor al mando del viaje.
  final DriverProfile driver;

  /// Línea del vehículo mostrada en la tarjeta del conductor.
  final String vehicleLine;

  /// Aviso de ubicación compartida, por ejemplo `'Compartes tu ubicación con Rosa (mamá)'`.
  final String shareStatus;
}

/// Valores iniciales del formulario de búsqueda (PAS-02).
class SearchFormDefaults {
  const SearchFormDefaults({
    required this.route,
    required this.fromTime,
    required this.toTime,
  });

  final TripRoute route;

  /// Inicio del rango horario, por ejemplo `'7:00 a. m.'`.
  final String fromTime;

  /// Fin del rango horario, por ejemplo `'8:00 a. m.'`.
  final String toTime;
}

/// Búsqueda guardada que aparece en "Búsquedas recientes" (PAS-02).
class RecentSearch {
  const RecentSearch({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

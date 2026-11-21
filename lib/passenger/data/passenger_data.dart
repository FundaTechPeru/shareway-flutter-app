import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';

/// Modelos de datos y fuente demo del módulo passenger.
///
/// Todo lo que hoy son datos hardcodeados vive aquí: las vistas solo leen
/// de [PassengerData] y ya no definen sus propios datos.
///
/// TODO(gateway): cuando el API esté disponible, sustituir los getters de
/// [PassengerData] por las llamadas al backend (los métodos pasarán a ser
/// `async`) sin tocar las vistas más allá de manejar el estado de carga.

// ── Conductor ────────────────────────────────────────────────────

/// Conductor verificado asociado a un viaje.
class DriverProfile {
  const DriverProfile({
    required this.initials,
    required this.name,
    required this.rating,
    required this.tripsCount,
    required this.memberSince,
    required this.vehicle,
    required this.vehicleShort,
    required this.vehicleDetail,
    required this.vehicleSeats,
    required this.plate,
    this.documents = const [],
    this.reviews = const [],
  });

  final String initials;
  final String name;

  /// Calificación promedio, por ejemplo `'4.8'`.
  final String rating;

  /// Total de viajes realizados, por ejemplo `'312'`.
  final String tripsCount;

  final String memberSince;

  /// Modelo completo, por ejemplo `'Toyota Yaris 2019'`.
  final String vehicle;

  /// Versión corta para tarjetas, por ejemplo `'Toyota Yaris gris'`.
  final String vehicleShort;

  /// Subtítulo del vehículo, por ejemplo `'Gris plata · sedán'`.
  final String vehicleDetail;

  /// Capacidad, por ejemplo `'4 asientos para pasajeros'`.
  final String vehicleSeats;

  final String plate;
  final List<String> documents;
  final List<DriverReview> reviews;
}

/// Opinión de un pasajero sobre el conductor.
class DriverReview {
  const DriverReview({
    required this.author,
    required this.date,
    required this.stars,
    required this.text,
  });

  final String author;
  final String date;
  final int stars;
  final String text;
}

// ── Viajes ───────────────────────────────────────────────────────

/// Ruta popular que aparece en el inicio (PAS-01).
class PopularRoute {
  const PopularRoute({
    required this.from,
    required this.to,
    required this.detail,
    required this.price,
  });

  final String from;
  final String to;
  final String detail;
  final String price;
}

/// Próximo viaje con reserva confirmada (tarjeta del inicio).
class NextTrip {
  const NextTrip({
    required this.weekday,
    required this.day,
    required this.month,
    required this.route,
    required this.schedule,
    required this.passengers,
  });

  final String weekday;
  final String day;
  final String month;
  final String route;
  final String schedule;
  final String passengers;
}

/// Viaje programado en "Mis viajes" (PAS-08).
class UpcomingTrip {
  const UpcomingTrip({
    required this.weekday,
    required this.day,
    required this.month,
    required this.route,
    required this.detail,
    required this.passengers,
  });

  final String weekday;
  final String day;
  final String month;
  final String route;
  final String detail;
  final String passengers;
}

/// Viaje terminado en "Mis viajes" (PAS-08).
class PastTrip {
  const PastTrip({
    required this.cancelled,
    required this.title,
    required this.subtitle,
    this.action = PastTripAction.none,
  });

  final bool cancelled;
  final String title;
  final String subtitle;
  final PastTripAction action;
}

/// Qué hace al tocar un viaje pasado.
enum PastTripAction { none, openDetail, rate }

/// Opción de viaje en los resultados de búsqueda (PAS-03).
class TripOption {
  const TripOption({
    required this.time,
    required this.seatsFree,
    required this.seatsTotal,
    required this.price,
    required this.origin,
    required this.destination,
    required this.progress,
    required this.passengers,
    required this.driverInitials,
    required this.driverName,
    this.driverRating,
    this.newDriver = false,
  });

  final String time;
  final int seatsFree;
  final int seatsTotal;
  final String price;
  final String origin;
  final String destination;

  /// Avance del viaje, de 0 a 1 (para la barra de progreso).
  final double progress;

  final String passengers;
  final String driverInitials;
  final String driverName;
  final String? driverRating;
  final bool newDriver;
}

/// Parada de recojo o llegada de un viaje.
class TripStop {
  const TripStop({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final String title;
  final String subtitle;
  final String time;
}

/// Criterio de búsqueda que encabeza los resultados (PAS-03).
class SearchQuery {
  const SearchQuery({required this.route, required this.window});

  final String route;
  final String window;
}

/// Detalle completo del viaje seleccionado (PAS-04).
class TripDetail {
  const TripDetail({
    required this.summary,
    required this.route,
    required this.meta,
    required this.price,
    required this.stops,
  });

  final String summary;
  final String route;
  final String meta;
  final String price;
  final List<TripStop> stops;
}

/// Pasajeros confirmados de un viaje (PAS-04).
class PassengerGroup {
  const PassengerGroup({
    required this.confirmed,
    required this.total,
    required this.progress,
    required this.initials,
    required this.minimumLabel,
  });

  final int confirmed;
  final int total;
  final double progress;
  final List<String> initials;
  final String minimumLabel;
}

// ── Reservas ─────────────────────────────────────────────────────

/// Reserva activa del pasajero (PAS-09).
class Booking {
  const Booking({
    required this.statusTitle,
    required this.statusDetail,
    required this.stops,
  });

  final String statusTitle;
  final String statusDetail;
  final List<TripStop> stops;
}

// ── Avisos ───────────────────────────────────────────────────────

/// Tipo de aviso: define el icono y el color que muestra la vista.
enum NotificationType {
  tripOnWay,
  bookingConfirmed,
  rating,
  recurring,
  payment,
  emergency,
}

/// Aviso de la pestaña "Avisos" (diseñada con la guía de estilo).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.route,
  });

  final int id;
  final NotificationType type;
  final String title;
  final String body;
  final String time;

  /// Ruta que se abre al tocar el aviso, si corresponde.
  final String? route;
}

/// En qué grupo de la pantalla cayeron los avisos.
class NotificationGroup {
  const NotificationGroup({required this.label, required this.items});

  final String label;
  final List<AppNotification> items;
}

// ── Contactos ────────────────────────────────────────────────────

/// Contacto con el que se comparte un viaje (PAS-13).
class ShareContact {
  const ShareContact({
    required this.initials,
    required this.name,
    required this.meta,
    required this.background,
    required this.foreground,
  });

  final String initials;
  final String name;
  final String meta;
  final Color background;
  final Color foreground;
}

// ── Perfil ───────────────────────────────────────────────────────

/// Cuenta del pasajero autenticado.
class PassengerAccount {
  const PassengerAccount({
    required this.name,
    required this.location,
    required this.initials,
    this.email = '',
    this.phone = '',
  });

  final String name;
  final String location;
  final String initials;
  final String email;
  final String phone;
}

// ── Fuente de datos demo ─────────────────────────────────────────

/// Datos demo del módulo passenger.
///
/// Punto único al que consultan todas las vistas. Sustituir por el API
/// gateway reescribiendo estos getters.
abstract class PassengerData {
  PassengerData._();

  // ── Cuenta ───────────────────────────────────────────────────
  static const PassengerAccount account = PassengerAccount(
    name: 'Lucía',
    location: 'Cerca de Linde, Lima',
    initials: 'LP',
    email: 'lucia.paredes@correo.com',
    phone: '+51 9•• •• 204',
  );

  // ── Inicio (PAS-01) ──────────────────────────────────────────
  static const NextTrip nextTrip = NextTrip(
    weekday: 'MIE',
    day: '7',
    month: 'oct',
    route: 'Lince → San Isidro',
    schedule: 'Sale 7:10 a. m. · 28 min',
    passengers: '4 de 4 pasajeros',
  );

  static const List<PopularRoute> popularRoutes = [
    PopularRoute(
      from: 'Lince',
      to: 'San Isidro',
      detail: 'Av. Arequipa · 12 viajes hoy',
      price: 'S/ 6.50',
    ),
    PopularRoute(
      from: 'Lince',
      to: 'Miraflores',
      detail: 'Av. Arenales · 9 viajes hoy',
      price: 'S/ 7.00',
    ),
    PopularRoute(
      from: 'Jesús María',
      to: 'Surco',
      detail: 'Av. Salaverry · 6 viajes hoy',
      price: 'S/ 9.50',
    ),
  ];

  // ── Mis viajes (PAS-08) ──────────────────────────────────────
  static const List<UpcomingTrip> upcomingTrips = [
    UpcomingTrip(
      weekday: 'MIE',
      day: '7',
      month: 'oct',
      route: 'Lince → San Isidro',
      detail: 'Sale 7:10 a. m. · con Carlos H.',
      passengers: '4 de 4 pasajeros',
    ),
    UpcomingTrip(
      weekday: 'JUE',
      day: '8',
      month: 'oct',
      route: 'Lince → San Isidro',
      detail: 'Sale 7:10 a. m. · con Carlos H.',
      passengers: '4 de 4 pasajeros',
    ),
  ];

  static const List<PastTrip> pastTrips = [
    PastTrip(
      cancelled: false,
      title: 'Vie 2 oct · Lince a San Isidro',
      subtitle: 'S/ 7.50 · Calificaste con 5 estrellas',
      action: PastTripAction.openDetail,
    ),
    PastTrip(
      cancelled: false,
      title: 'Mié 30 sep · Lince a Miraflores',
      subtitle: 'S/ 7.00 · Aún sin calificar',
      action: PastTripAction.rate,
    ),
    PastTrip(
      cancelled: true,
      title: 'Lun 28 sep · Lince a San Isidro',
      subtitle: 'Cancelado por ti · sin penalidad',
    ),
  ];

  // ── Búsqueda (PAS-02/03) ─────────────────────────────────────
  static const SearchQuery lastQuery = SearchQuery(
    route: 'Lince a San Isidro',
    window: 'Jue 8 oct · 7:00 a. m. a 8:00 a. m.',
  );

  static const List<TripOption> searchResults = [
    TripOption(
      time: '7:10 a. m.',
      seatsFree: 1,
      seatsTotal: 4,
      price: 'S/ 7.50',
      origin: 'Av. Arequipa con Risso',
      destination: 'Av. Rivera Navarrete 501',
      progress: 0.75,
      passengers: '3 de 4 pasajeros confirmados',
      driverInitials: 'CH',
      driverName: 'Carlos H.',
      driverRating: '4.8',
    ),
    TripOption(
      time: '7:25 a. m.',
      seatsFree: 2,
      seatsTotal: 3,
      price: 'S/ 6.80',
      origin: 'Av. Arenales con Canevaro',
      destination: 'Av. Rivera Navarrette 501',
      progress: 0.67,
      passengers: '2 de 3 pasajeros confirmados',
      driverInitials: 'MT',
      driverName: 'Milagros T.',
      driverRating: '4.9',
    ),
    TripOption(
      time: '7:45 a. m.',
      seatsFree: 3,
      seatsTotal: 3,
      price: 'S/ 7.20',
      origin: 'Av. Arequipa con Risso',
      destination: 'Av. Javier Prado Este 492',
      progress: 0.34,
      passengers: '1 de 3 pasajeros confirmados',
      driverInitials: 'JR',
      driverName: 'Jorge R.',
      newDriver: true,
    ),
  ];

  // ── Detalle del viaje (PAS-04) ───────────────────────────────
  static const TripDetail tripDetail = TripDetail(
    summary: 'Jue 8 oct · sale 7:10 a. m.',
    route: 'Lince → San Isidro',
    meta: '28 min · 6.4 km · 2 paradas de recojo',
    price: 'S/ 7.50',
    stops: [
      TripStop(
        title: 'Av. Arequipa con Risso',
        subtitle: 'Tu punto de recojo',
        time: '7:10 a. m.',
      ),
      TripStop(
        title: 'Av. Arenales con Canevaro',
        subtitle: 'Recojo de 1 pasajero',
        time: '7:17 a. m.',
      ),
      TripStop(
        title: 'Av. Rivera Navarrete 501',
        subtitle: 'Llegada a San Isidro',
        time: '7:38 a. m.',
      ),
    ],
  );

  static const PassengerGroup tripPassengers = PassengerGroup(
    confirmed: 3,
    total: 4,
    progress: 0.75,
    initials: ['AM', 'LT', 'RC'],
    minimumLabel: 'Mínimo de 3 cumplido',
  );

  // ── Conductor (PAS-10) ───────────────────────────────────────
  static const DriverProfile driver = DriverProfile(
    initials: 'CH',
    name: 'Carlos Huamán',
    rating: '4.8',
    tripsCount: '312',
    memberSince: 'En ShareWay desde agosto de 2025',
    vehicle: 'Toyota Yaris 2019',
    vehicleShort: 'Toyota Yaris gris',
    vehicleDetail: 'Gris plata · sedán',
    vehicleSeats: '4 asientos para pasajeros',
    plate: 'BKL-482',
    documents: ['Brevete', 'SOAT', 'Tarjeta de propiedad'],
    reviews: [
      DriverReview(
        author: 'Andrea M.',
        date: '2 oct',
        stars: 5,
        text: 'Puntual y muy amable. El auto estaba limpio.',
      ),
    ],
  );

  // ── Reserva activa (PAS-09) ──────────────────────────────────
  static const Booking currentBooking = Booking(
    statusTitle: 'Reserva confirmada',
    statusDetail: 'Sale mañana, mié 7 oct, a las 7:10 a. m.',
    stops: [
      TripStop(
        title: 'Av. Arequipa con Risso',
        subtitle: 'Tu punto de recojo',
        time: '7:10 a. m.',
      ),
      TripStop(
        title: 'Av. Rivera Navarrete 501',
        subtitle: 'San Isidro',
        time: '7:38 a. m.',
      ),
    ],
  );

  /// Coordenadas del auto en el mapa del detalle (fracciones del tamaño).
  static const List<Offset> mapRoute = [
    Offset(0.11, 0.51),
    Offset(0.31, 0.42),
    Offset(0.42, 0.44),
    Offset(0.72, 0.30),
    Offset(0.875, 0.15),
  ];

  // ── Avisos ───────────────────────────────────────────────────
  static const List<NotificationGroup> notificationGroups = [
    NotificationGroup(
      label: 'Hoy',
      items: [
        AppNotification(
          id: 5,
          type: NotificationType.emergency,
          title: 'Carlos activó una alerta',
          body:
              'Viaje SW-58213 · Av. Arenales 1250, Lince. '
              'Ubicación en vivo disponible.',
          time: 'hace 1 min',
          route: '/passenger/emergency/alert',
        ),
        AppNotification(
          id: 0,
          type: NotificationType.tripOnWay,
          title: 'Tu conductor va en camino',
          body: 'Carlos H. saldrá en 10 minutos desde Av. Arequipa con Risso.',
          time: 'hace 5 min',
          route: '/passenger/emergency/live-tracking',
        ),
        AppNotification(
          id: 1,
          type: NotificationType.bookingConfirmed,
          title: 'Reserva confirmada',
          body: 'Jue 8 oct · Lince a San Isidro · 7:10 a. m. · S/ 7.50.',
          time: 'hace 2 h',
        ),
      ],
    ),
    NotificationGroup(
      label: 'Anteriores',
      items: [
        AppNotification(
          id: 2,
          type: NotificationType.rating,
          title: 'Califica tu viaje de ayer',
          body: 'Tienes 48 horas para puntuar a Carlos H.',
          time: 'ayer',
        ),
        AppNotification(
          id: 3,
          type: NotificationType.recurring,
          title: 'Tu viaje recurrente está activo',
          body: 'Crearemos la solicitud de la próxima semana el lunes.',
          time: '2 oct',
        ),
        AppNotification(
          id: 4,
          type: NotificationType.payment,
          title: 'Pago aprobado',
          body: 'Cobramos S/ 7.50 a tu Visa •••• 4821.',
          time: '2 oct',
        ),
      ],
    ),
  ];

  // ── Compartir ubicación (PAS-13) ─────────────────────────────
  static const List<ShareContact> shareContacts = [
    ShareContact(
      initials: 'RP',
      name: 'Rosa Paredes',
      meta: 'Mamá · +51 9•• ••204',
      background: AppColors.accentSoft,
      foreground: AppColors.warning,
    ),
    ShareContact(
      initials: 'DP',
      name: 'Diego Paredes',
      meta: 'Hermano · +51 9•• •• 871',
      background: AppColors.primarySoft,
      foreground: AppColors.primaryDark,
    ),
  ];
}

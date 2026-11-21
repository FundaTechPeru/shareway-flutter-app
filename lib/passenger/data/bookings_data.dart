/// Datos de las vistas del flujo de reserva (PAS-05 a PAS-16).
///
/// Las vistas de `presentation/views/booking` leen de [BookingsData] en vez
/// de definir sus propios datasets; el copy de UI (títulos, botones,
/// mensajes) permanece en cada vista. El conductor y el vehículo se
/// consultan en `PassengerData.driver`.
///
/// TODO(gateway): sustituir por llamadas al API.
library;

// ── Modelos ─────────────────────────────────────────────────────

/// Tarjeta guardada en "Tus tarjetas" (PAS-07).
class PaymentCard {
  const PaymentCard({required this.brand, required this.meta});

  /// Ejemplo: `'Visa •••• 4821'`.
  final String brand;

  /// Ejemplo: `'Vence 08/28 · Predeterminada'`.
  final String meta;
}

/// Método de pago seleccionado en la confirmación (PAS-05).
class PaymentMethod {
  const PaymentMethod({required this.brand, required this.note});

  final String brand;

  /// Cuándo se cobra, por ejemplo `'Se cobra al terminar el viaje'`.
  final String note;
}

/// Resumen de un viaje en tarjeta: fecha, ruta y punto de recojo.
class TripSummary {
  const TripSummary({
    required this.schedule,
    required this.route,
    required this.pickup,
  });

  /// Ejemplo: `'Jue 8 oct · sale 7:10 a. m.'`.
  final String schedule;

  /// Ejemplo: `'Lince → San Isidro'`.
  final String route;

  /// Punto de recojo sin el prefijo «Recojo: », por ejemplo
  /// `'Av. Arequipa con Risso'`.
  final String pickup;
}

/// Reserva confirmada que celebra la pantalla de éxito (PAS-06).
class BookingConfirmation {
  const BookingConfirmation({required this.schedule, required this.route});

  final String schedule;
  final String route;
}

/// Viaje y conductor a calificar (PAS-15).
class RateTrip {
  const RateTrip({required this.schedule, required this.route});

  final String schedule;

  /// Ruta como se escribe en la pantalla, por ejemplo `'Lince a San Isidro'`.
  final String route;
}

/// Datos que encabezan el código de abordaje (PAS-11).
///
/// El QR y el PIN se generan en la vista.
class BoardingCode {
  const BoardingCode({required this.date, required this.time});

  final String date;
  final String time;
}

/// Monto de una línea del desglose de precios.
class PriceLine {
  const PriceLine({
    required this.label,
    required this.value,
    this.discount = false,
  });

  final String label;
  final String value;

  /// Línea de ahorro/descuento (la vista la pinta en verde).
  final bool discount;
}

/// Desglose de montos con su total (PAS-05 y PAS-16).
class PriceBreakdown {
  const PriceBreakdown({
    required this.lines,
    required this.totalLabel,
    required this.total,
  });

  final List<PriceLine> lines;
  final String totalLabel;
  final String total;
}

/// Resumen del viaje en el recibo (PAS-16).
class ReceiptSummary {
  const ReceiptSummary({
    required this.date,
    required this.route,
    required this.schedule,
  });

  final String date;
  final String route;

  /// Horario completo, por ejemplo `'7:10 a 7:38 a. m. · 28 min · 6.4 km'`.
  final String schedule;
}

/// Pago registrado en el recibo.
class ReceiptPayment {
  const ReceiptPayment({required this.brand, required this.status});

  final String brand;
  final String status;
}

/// Par etiqueta–valor de una fila de datos (por ejemplo el recibo).
class LabeledValue {
  const LabeledValue({required this.label, required this.value});

  final String label;
  final String value;
}

/// Recibo completo de un viaje finalizado (PAS-16).
class TripReceipt {
  const TripReceipt({
    required this.summary,
    required this.breakdown,
    required this.payment,
    required this.meta,
  });

  final ReceiptSummary summary;
  final PriceBreakdown breakdown;
  final ReceiptPayment payment;

  /// Filas de metadatos: número de viaje, conductor y vehículo.
  final List<LabeledValue> meta;
}

// ── Fuente de datos demo ─────────────────────────────────────────

/// Datos de las vistas del flujo de reserva.
abstract class BookingsData {
  BookingsData._();

  // ── Métodos de pago (PAS-07) ──────────────────────────────────
  static const List<PaymentCard> paymentCards = [
    PaymentCard(brand: 'Visa •••• 4821', meta: 'Vence 08/28 · Predeterminada'),
    PaymentCard(brand: 'Mastercard •••• 0937', meta: 'Vence 02/27'),
  ];

  // ── Confirmar reserva (PAS-05) ────────────────────────────────
  static const TripSummary confirmTrip = TripSummary(
    schedule: 'Jue 8 oct · sale 7:10 a. m.',
    route: 'Lince → San Isidro',
    pickup: 'Av. Arequipa con Risso',
  );

  static const PriceBreakdown confirmPrice = PriceBreakdown(
    lines: [
      PriceLine(label: 'Tarifa base', value: 'S/ 3.00'),
      PriceLine(label: 'Distancia (6.4 km)', value: 'S/ 5.20'),
      PriceLine(
        label: 'Ahorro por compartir',
        value: '− S/ 0.70',
        discount: true,
      ),
    ],
    totalLabel: 'Total por 1 asiento',
    total: 'S/ 7.50',
  );

  static const PaymentMethod paymentMethod = PaymentMethod(
    brand: 'Visa •••• 4821',
    note: 'Se cobra al terminar el viaje',
  );

  // ── Reserva confirmada (PAS-06) ───────────────────────────────
  static const BookingConfirmation bookingSuccess = BookingConfirmation(
    schedule: 'Jue 8 oct · 7:10 a. m.',
    route: 'Lince → San Isidro',
  );

  // ── Cancelar reserva (PAS-14) ─────────────────────────────────
  static const TripSummary cancelTrip = TripSummary(
    schedule: 'Mié 7 oct · sale 7:10 a. m.',
    route: 'Lince → San Isidro',
    pickup: 'Av. Arequipa con Risso',
  );

  // ── Código de abordaje (PAS-11) ───────────────────────────────
  static const BoardingCode boardingCode = BoardingCode(
    date: 'Mié 7 oct',
    time: '7:10 a. m.',
  );

  // ── Calificar el viaje (PAS-15) ───────────────────────────────
  // El conductor se consulta en PassengerData.driver.
  static const RateTrip rateTrip = RateTrip(
    schedule: 'Mié 7 oct',
    route: 'Lince a San Isidro',
  );

  // ── Recibo del viaje (PAS-16) ─────────────────────────────────
  static const TripReceipt receipt = TripReceipt(
    summary: ReceiptSummary(
      date: 'Mié 7 oct 2026',
      route: 'Lince → San Isidro',
      schedule: '7:10 a 7:38 a. m. · 28 min · 6.4 km',
    ),
    breakdown: PriceBreakdown(
      lines: [
        PriceLine(label: 'Tarifa base', value: 'S/ 3.00'),
        PriceLine(label: 'Distancia (6.4 km)', value: 'S/ 5.20'),
        PriceLine(
          label: 'Ahorro por compartir',
          value: '− S/ 0.70',
          discount: true,
        ),
      ],
      totalLabel: 'Total cobrado',
      total: 'S/ 7.50',
    ),
    payment: ReceiptPayment(brand: 'Visa •••• 4821', status: 'Pagado'),
    meta: [
      LabeledValue(label: 'N.° de viaje', value: 'SW-58213'),
      LabeledValue(label: 'Conductor', value: 'Carlos Huamán'),
      LabeledValue(label: 'Vehículo', value: 'Toyota Yaris · BKL-482'),
    ],
  );
}

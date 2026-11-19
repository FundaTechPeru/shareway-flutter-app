import 'package:flutter/material.dart';

import 'iam/presentation/views/forgot_password_screen.dart';
import 'iam/presentation/views/login_screen.dart';
import 'iam/presentation/views/onboarding_screen.dart';
import 'iam/presentation/views/permissions_screen.dart';
import 'iam/presentation/views/register_screen.dart';
import 'iam/presentation/views/splash_screen.dart';
import 'iam/presentation/views/verify_phone_screen.dart';
import 'passenger/presentation/passenger_shell.dart';
import 'passenger/presentation/views/booking/booking_detail_screen.dart';
import 'passenger/presentation/views/booking/booking_success_screen.dart';
import 'passenger/presentation/views/booking/cancel_booking_screen.dart';
import 'passenger/presentation/views/booking/confirm_booking_screen.dart';
import 'passenger/presentation/views/booking/boarding_code_screen.dart';
import 'passenger/presentation/views/booking/payment_methods_screen.dart';
import 'passenger/presentation/views/booking/rate_trip_screen.dart';
import 'passenger/presentation/views/booking/trip_receipt_screen.dart';
import 'passenger/presentation/views/driver/driver_profile_screen.dart';
import 'passenger/presentation/views/emergency/emergency_alert_screen.dart';
import 'passenger/presentation/views/emergency/expired_link_screen.dart';
import 'passenger/presentation/views/emergency/live_tracking_screen.dart';
import 'passenger/presentation/views/search/search_results_screen.dart';
import 'passenger/presentation/views/search/search_trip_screen.dart';
import 'passenger/presentation/views/search/trip_detail_screen.dart';
import 'passenger/presentation/views/trip/live_trip_screen.dart';
import 'passenger/presentation/views/trip/share_location_screen.dart';
import 'passenger/presentation/views/trips/past_trip_detail_screen.dart';
import 'passenger/presentation/views/trips/recurring_trip_form_screen.dart';
import 'passenger/presentation/views/profile/blocked_users_screen.dart';
import 'passenger/presentation/views/profile/edit_profile_screen.dart';
import 'passenger/presentation/views/profile/emergency_contacts_screen.dart';
import 'passenger/presentation/views/profile/settings_screen.dart';
import 'shared/theme/app_theme.dart';

/// Raíz de la aplicación ShareWay.
///
/// El flujo de acceso (módulo **iam / ACC**) es:
///
/// ```text
/// Splash → Bienvenida → Iniciar sesión ⇄ Crear cuenta → Verificar celular
///        → Permisos → PassengerShell
/// ```
///
/// Desde el [PassengerShell] se entra al módulo **passenger (PAS)**:
///
/// ```text
/// Inicio → Buscar viaje → Resultados → Detalle → Confirmar reserva
///        → Reserva confirmada
/// ```
class ShareWayApp extends StatelessWidget {
  const ShareWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareWay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const SplashScreen(),
      routes: {
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        VerifyPhoneScreen.routeName: (_) => const VerifyPhoneScreen(),
        ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
        PermissionsScreen.routeName: (_) => const PermissionsScreen(),

        // ── Módulo passenger (PAS) ──────────────────────────────
        PassengerShell.routeName: (context) => PassengerShell(
          initialTab: (ModalRoute.of(context)?.settings.arguments as int?) ?? 0,
        ),
        SearchTripScreen.routeName: (_) => const SearchTripScreen(),
        SearchResultsScreen.routeName: (_) => const SearchResultsScreen(),
        TripDetailScreen.routeName: (_) => const TripDetailScreen(),
        ConfirmBookingScreen.routeName: (_) => const ConfirmBookingScreen(),
        BookingSuccessScreen.routeName: (_) => const BookingSuccessScreen(),
        PaymentMethodsScreen.routeName: (_) => const PaymentMethodsScreen(),
        CancelBookingScreen.routeName: (_) => const CancelBookingScreen(),
        RateTripScreen.routeName: (_) => const RateTripScreen(),
        TripReceiptScreen.routeName: (_) => const TripReceiptScreen(),
        BookingDetailScreen.routeName: (_) => const BookingDetailScreen(),
        BoardingCodeScreen.routeName: (_) => const BoardingCodeScreen(),
        DriverProfileScreen.routeName: (_) => const DriverProfileScreen(),
        LiveTripScreen.routeName: (_) => const LiveTripScreen(),
        ShareLocationScreen.routeName: (_) => const ShareLocationScreen(),
        RecurringTripFormScreen.routeName: (_) =>
            const RecurringTripFormScreen(),
        PastTripDetailScreen.routeName: (_) => const PastTripDetailScreen(),
        BlockedUsersScreen.routeName: (_) => const BlockedUsersScreen(),
        EmergencyContactsScreen.routeName: (_) =>
            const EmergencyContactsScreen(),
        EditProfileScreen.routeName: (_) => const EditProfileScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),

        // ── Seguimiento compartido / emergencia (EME) ───────────
        LiveTrackingScreen.routeName: (_) => const LiveTrackingScreen(),
        EmergencyAlertScreen.routeName: (_) => const EmergencyAlertScreen(),
        ExpiredLinkScreen.routeName: (_) => const ExpiredLinkScreen(),

        // ── Estados de error passenger (PAS-E) ─────────────────
        '/passenger/home/empty': (_) =>
            const PassengerShell(initialTab: 0, emptyHome: true),
        '/passenger/search/results/empty': (_) =>
            const SearchResultsScreen(empty: true),
        '/passenger/booking/confirm/seat-unavailable': (_) =>
            const ConfirmBookingScreen(seatUnavailable: true),
        '/passenger/booking/price-change': (_) =>
            const BookingDetailScreen(showPriceChange: true),
        '/passenger/booking/late-cancellation': (_) =>
            const BookingDetailScreen(lateCancellation: true),
      },
    );
  }
}

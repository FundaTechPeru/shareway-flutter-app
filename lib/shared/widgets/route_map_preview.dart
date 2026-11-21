import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../driver/domain/driver_map_models.dart';
import '../theme/app_theme.dart';
import 'shareway_components.dart';

const _mapTilerApiKey = String.fromEnvironment('MAPTILER_API_KEY');

class RouteMapPreview extends StatefulWidget {
  const RouteMapPreview({
    super.key,
    this.points,
    this.height = 190,
    this.activeStop = 0,
    this.showVehicle = true,
    this.allowDemoFallback = true,
    this.routeLabel = 'Recorrido ilustrativo',
  });

  final List<DriverMapPoint>? points;
  final double height;
  final int activeStop;
  final bool showVehicle;
  final bool allowDemoFallback;
  final String routeLabel;

  @override
  State<RouteMapPreview> createState() => _RouteMapPreviewState();
}

class _RouteMapPreviewState extends State<RouteMapPreview> {
  bool _hasTileError = false;

  @override
  Widget build(BuildContext context) {
    if (_mapTilerApiKey.isEmpty) {
      if (!widget.allowDemoFallback) {
        return _MapUnavailablePreview(height: widget.height);
      }
      return IllustratedRouteMap(
        height: widget.height,
        activeStop: widget.activeStop,
        showVehicle: widget.showVehicle,
      );
    }

    final providedPoints = widget.points;
    if ((providedPoints == null || providedPoints.isEmpty) &&
        !widget.allowDemoFallback) {
      return _MapUnavailablePreview(height: widget.height);
    }
    final points = providedPoints == null || providedPoints.isEmpty
        ? DriverDemoMapRoutes.linceToSanIsidro
        : providedPoints;
    final coordinates = points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);
    final safeActiveStop = widget.activeStop.clamp(0, points.length - 1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: coordinates.first,
                  initialZoom: 13,
                  initialCameraFit: coordinates.length > 1
                      ? CameraFit.coordinates(
                          coordinates: coordinates,
                          padding: const EdgeInsets.all(34),
                          maxZoom: 15,
                          minZoom: 11,
                        )
                      : null,
                  backgroundColor: const Color(0xFFEAF0EF),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.maptiler.com/maps/streets-v4/{z}/{x}/{y}.png?key={key}',
                    additionalOptions: {'key': _mapTilerApiKey},
                    userAgentPackageName: 'com.shareway.shareway_flutter_app',
                    maxNativeZoom: 19,
                    maxZoom: 19,
                    errorTileCallback: (tile, error, stackTrace) {
                      if (!mounted || _hasTileError) return;
                      setState(() => _hasTileError = true);
                    },
                  ),
                  if (coordinates.length > 1)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: coordinates,
                          color: ShareWayColors.primary,
                          strokeWidth: 4,
                          borderColor: Colors.white,
                          borderStrokeWidth: 1.5,
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      for (var index = 0; index < points.length; index++)
                        Marker(
                          point: coordinates[index],
                          width: 40,
                          height: 40,
                          child: _RoutePointMarker(
                            point: points[index],
                            index: index,
                            isActive: index == safeActiveStop,
                            showVehicle: widget.showVehicle,
                          ),
                        ),
                    ],
                  ),
                  RichAttributionWidget(
                    alignment: AttributionAlignment.bottomRight,
                    attributions: [
                      TextSourceAttribution(
                        '© MapTiler',
                        onTap: () => _openAttribution(
                          'https://www.maptiler.com/copyright/',
                        ),
                      ),
                      TextSourceAttribution(
                        '© OpenStreetMap contributors',
                        onTap: () => _openAttribution(
                          'https://www.openstreetmap.org/copyright',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: _MapLabel(
                icon: Icons.alt_route_rounded,
                label: widget.routeLabel,
              ),
            ),
            Positioned(
              left: 8,
              bottom: 7,
              child: Semantics(
                link: true,
                label: 'MapTiler',
                child: GestureDetector(
                  onTap: () => _openAttribution('https://www.maptiler.com/'),
                  child: SizedBox(
                    width: 78,
                    height: 25,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        const Text(
                          'MapTiler',
                          style: TextStyle(
                            color: Color(0xFF34445A),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SvgPicture.network(
                          'https://api.maptiler.com/resources/logo.svg',
                          width: 78,
                          height: 25,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          semanticsLabel: 'MapTiler',
                          placeholderBuilder: (_) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_hasTileError)
              const Positioned(
                left: 10,
                bottom: 38,
                child: _MapLabel(
                  icon: Icons.wifi_off_rounded,
                  label: 'Mapa no disponible; revisa clave/conexión',
                  warning: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> _openAttribution(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

class _MapUnavailablePreview extends StatelessWidget {
  const _MapUnavailablePreview({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: ShareWayColors.pale),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map_outlined, color: ShareWayColors.muted, size: 30),
                SizedBox(height: 8),
                Text(
                  'Mapa no disponible para este viaje',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ShareWayColors.secondaryInk,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _RoutePointMarker extends StatelessWidget {
  const _RoutePointMarker({
    required this.point,
    required this.index,
    required this.isActive,
    required this.showVehicle,
  });

  final DriverMapPoint point;
  final int index;
  final bool isActive;
  final bool showVehicle;

  @override
  Widget build(BuildContext context) {
    final isVehicle = isActive && showVehicle;
    final background = isActive
        ? ShareWayColors.primaryDark
        : point.kind == DriverMapPointKind.destination
        ? ShareWayColors.accent
        : ShareWayColors.primary;
    final icon = switch (point.kind) {
      DriverMapPointKind.origin => Icons.trip_origin_rounded,
      DriverMapPointKind.pickup => null,
      DriverMapPointKind.destination => Icons.flag_rounded,
    };

    return Tooltip(
      message: point.label,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: isVehicle
            ? const Icon(
                Icons.directions_car_filled_rounded,
                color: Colors.white,
                size: 19,
              )
            : icon != null
            ? Icon(icon, color: Colors.white, size: 18)
            : Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({
    required this.icon,
    required this.label,
    this.warning = false,
  });

  final IconData icon;
  final String label;
  final bool warning;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: warning ? ShareWayColors.warning : ShareWayColors.primary,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

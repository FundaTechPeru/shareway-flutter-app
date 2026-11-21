# Mapa MapTiler para el flujo del conductor

## Intención

Reemplazar el mapa dibujado de ShareWay por un mapa interactivo de calles en las pantallas de propuestas, detalle del viaje, viaje en curso y seguimiento de emergencia. La app seguirá usando datos ficticios para mostrar paradas y un recorrido ilustrativo.

## Estado actual

- `IllustratedRouteMap` en `lib/shared/widgets/shareway_components.dart` dibuja un mapa con `CustomPaint`.
- Las pantallas de conductor reutilizan ese componente.
- Las muestras tienen direcciones y paradas, pero no coordenadas.
- La sesión, el perfil y la disponibilidad usan el API Gateway; propuestas y viajes continúan con datos demo.
- El proyecto declara Dart `^3.13.5` y tiene destinos Android, iOS y web.

## Alcance

- Usar `flutter_map` con mosaicos raster de MapTiler para Android, iOS y Chrome.
- Añadir coordenadas ficticias de demostración para las rutas de muestra en Lima.
- Dibujar marcadores de origen, recojos y destino, una línea entre ellos y un marcador de vehículo en las vistas que lo necesiten.
- Mostrar el logo y la atribución enlazada de MapTiler, además de la atribución enlazada de OpenStreetMap.
- Mantener una ilustración como alternativa cuando no se configura la clave; informar si falla la carga de mosaicos.
- Leer la clave local desde `--dart-define-from-file=map_secrets.json`; excluir ese archivo de Git.
- Preservar el diseño ShareWay alrededor del mapa.

## Fuera de alcance

- GPS real, permisos de ubicación o seguimiento en segundo plano.
- Geocodificación, cálculo de rutas por calles, navegación giro a giro o ETA real.
- Cambios al API Gateway, microservicios, contratos de API o almacenamiento de coordenadas.

## Decisión de mapas y costo

Se selecciona MapTiler Free con `flutter_map`. MapTiler requiere una clave de API de cliente. Según el plan Free publicado, incluye hasta 100.000 solicitudes de API al mes y no requiere información de pago; al alcanzar el límite, el servicio se pausa hasta el siguiente mes. Al usar `flutter_map`, cada mosaico cuenta como una solicitud, no como una sesión única. La clave no se puede ocultar por completo en una app cliente, así que debe mantenerse fuera de Git y restringirse por orígenes permitidos.

## Datos y presentación

- Las coordenadas se guardan en modelos de mapa separados de los DTOs del Gateway.
- La línea entre puntos es una representación visual del orden de las paradas, no una ruta vial calculada.
- No se presentarán estos datos como ubicación real del conductor.
- Si falta la clave, el resto de la app seguirá navegable con el mapa ilustrado existente.

## Aprobación

El usuario eligió MapTiler y creó una clave gratuita para continuar con el mapa de demostración.

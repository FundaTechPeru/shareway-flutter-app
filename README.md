# ShareWay · Aplicación Flutter

Primera versión navegable de la vista móvil para conductores. El trabajo vive en la rama `feature/driver` y usa los colores y componentes de la guía visual de ShareWay.

## Ejecutar

```bash
flutter pub get
flutter run
```

También puede iniciarse en Chrome con `flutter run -d chrome` para revisar las pantallas en escritorio.

### Mapa de demostración

El mapa usa `flutter_map` con mosaicos de MapTiler. La clave es una clave pública de cliente: no la subas a GitHub ni la pegues en el código. El archivo local `map_secrets.json` está excluido de Git. Para prepararlo, copia `map_secrets.example.json`, reemplaza el valor por tu clave y ejecuta:

```bash
flutter run --dart-define-from-file=map_secrets.json
```

Para Chrome:

```bash
flutter run -d chrome --dart-define-from-file=map_secrets.json
```

MapTiler registra los mosaicos solicitados por `flutter_map` como solicitudes de API. Su plan Free actualmente incluye 100.000 solicitudes mensuales; al alcanzar la cuota el servicio se pausa hasta el siguiente mes y no activa cargos automáticos. El mapa muestra el logo y la atribución enlazada de MapTiler, además de OpenStreetMap. Si no se configura la clave se conserva el mapa ilustrado. Las coordenadas y líneas son de demostración: no representan navegación, ubicación en vivo ni una ruta calculada por calles. La clave no queda secreta dentro de una aplicación compilada; limita sus orígenes permitidos desde MapTiler.

## Conectar con API Gateway

La app usa por defecto el Gateway desplegado. En Android inicia así:

```bash
flutter run --dart-define-from-file=map_secrets.json
```

Si todavía no tienes `map_secrets.json`, puedes ejecutar `flutter run` y el mapa mostrará la ilustración de respaldo. Para probar la interfaz sin conectarte al API, fuerza el modo demo con `flutter run --dart-define=SHAREWAY_API_BASE_URL=`. Para apuntar a otro Gateway, define `SHAREWAY_API_BASE_URL` con su URL HTTPS. En Chrome, el Gateway debe habilitar CORS para `localhost`; las llamadas desde Android nativo no usan CORS.

En ese modo, la app permite recorrer bienvenida, inicio de sesión y creación de cuenta. El registro usa `POST /api/v1/auth/register` y luego inicia sesión con `POST /api/v1/auth/login`; el backend crea primero el usuario como `PASSENGER`. Para obtener el rol `DRIVER`, la persona completa en la app su licencia y contacto de emergencia mediante Driver Management. El código de verificación SMS está presentado como maqueta: no se envía ningún mensaje ni se valida el número, porque el Gateway y Driver Management todavía no exponen ese flujo. El token de sesión se guarda con almacenamiento seguro. El inicio consulta perfil, vehículos, documentos y disponibilidad semanal; las pantallas de perfil y registro permiten consultar y actualizar los datos que admite Driver Management. Para el navegador, el Gateway debe permitir CORS para el origen exacto de Flutter; el almacenamiento web funciona en HTTPS o localhost.

En modo conectado, propuestas y viajes muestran el estado real de integración, sin mezclar los datos demo. Trip Planning permite consultar propuestas por ID de solicitud, pero todavía no expone la bandeja del conductor ni acciones para aceptar/rechazar. Trip Execution tampoco expone una lista de viajes por conductor para alimentar la agenda. La disponibilidad conectada guarda días y horarios recurrentes en Driver Management; las zonas de operación de la vista demo no existen en ese contrato.

## Flujo disponible

- Inicio del conductor con ganancia estimada, próximo viaje y propuestas pendientes.
- Revisión, aceptación y rechazo de propuestas de viaje.
- Agenda de viajes, detalle de ruta y aviso de cambio por cancelación de un pasajero.
- Inicio del viaje, lista de pasajeros y validación de abordaje con PIN de demostración `5108`.
- Seguimiento ilustrativo, activación de alerta de emergencia y pantallas de enlace activo, alerta enviada y enlace expirado.
- Cierre del viaje, resumen de ganancias y calificación de pasajeros.
- Avisos, ayuda y soporte, perfil y configuración de disponibilidad.
- Bienvenida, inicio de sesión y creación de cuenta de conductor, con una pantalla de verificación telefónica marcada como prototipo.
- Registro/edición del conductor en tres pasos: datos, documentos y vehículo.

## Organización

- `lib/driver/domain`: modelos y contrato del repositorio.
- `lib/driver/data`: datos y comportamiento temporales para la demostración.
- `lib/driver/presentation`: pantallas y controlador del flujo de conductor.
- `lib/shared`: tema y componentes compartidos.
- `lib/shared/data`: cliente HTTP del Gateway y almacenamiento de sesión.
- `lib/auth/presentation`: splash, bienvenida, inicio de sesión, registro, maqueta de verificación telefónica y alta de perfil de conductor.

## Alcance de esta versión

La interfaz puede recorrerse sin el Gateway. En modo demo, los viajes y las propuestas se cargan desde `DemoDriverRepository`; en modo API, la sesión, perfil, vehículo, documentos y disponibilidad semanal se consultan o guardan por las rutas disponibles. Las pantallas de propuestas y viajes no muestran contenido ficticio en modo API porque faltan endpoints de bandeja del conductor. El mapa base requiere conexión y la clave de MapTiler; sin clave se muestra una ilustración. Cámara/QR, geolocalización en vivo, notificaciones push, llamadas y las operaciones de aceptación de propuestas aún requieren integración. Los datos de emergencia y los cobros del viaje también son demostrativos.

## Términos y condiciones

El borrador académico para ShareWay está en [`docs/terminos-y-condiciones-shareway.md`](docs/terminos-y-condiciones-shareway.md). Tiene campos pendientes y no debe usarse como contrato de una operación real hasta adecuarlo al modelo definitivo del servicio y completar la información de la entidad operadora.

# Revisión de contratos para la app de conductor

Fecha de revisión: 18 de noviembre de 2026. Revisión de solo lectura de los repositorios actuales de Driver Management, Trip Planning & Matching, Trip Execution, Payments & Settlement y API Gateway.

## Endpoints que ya cubren pantallas del conductor

Todas las rutas se consumen por el API Gateway y requieren `Authorization: Bearer <accessToken>`, salvo las rutas públicas de autenticación.

| Flujo | Método y ruta pública | Observaciones |
|---|---|---|
| Crear cuenta | `POST /api/v1/auth/register` | Crea inicialmente una cuenta con rol `PASSENGER`; requiere correo, contraseña, nombre y celular. |
| Iniciar sesión | `POST /api/v1/auth/login` | Devuelve `accessToken`, `tokenType` y `expiresIn`. |
| Perfil | `GET /api/v1/users/me` | Perfil del usuario autenticado; su `id` es UUID. |
| Alta de conductor | `POST /api/v1/users/me/driver-profile` | Requiere número de licencia y contacto de emergencia; el estado inicial es `PENDING_VERIFICATION`. |
| Perfil de conductor | `GET /api/v1/users/me/driver-profile` | Devuelve perfil, licencia y estado de verificación. |
| Documentos | `POST /api/v1/drivers/me/documents` | `multipart/form-data` con `type` y `file`; admite PDF/JPEG/PNG hasta 5 MB. También hay `GET` de lista y detalle. |
| Vehículos | `GET/POST /api/v1/drivers/me/vehicles`; `GET/PUT /api/v1/drivers/me/vehicles/{id}` | Permite registrar, listar y editar vehículos. El identificador del vehículo es UUID. |
| Disponibilidad semanal | `GET/PUT /api/v1/drivers/me/availability` | Reemplaza la semana completa con franjas por día y hora. |
| Ganancias | `GET /api/v1/settlements/me`, `GET /api/v1/settlements/me/summary`, `GET /api/v1/settlements/me/{id}` | Sirve para historial y resumen de liquidaciones del conductor. |
| Operaciones de viaje | `POST /api/v1/trips`, `GET /api/v1/trips/{id}`, y `POST /api/v1/trips/{id}/abordajes`, `/iniciar`, `/finalizar` y `/cancelar` | El Gateway reescribe `/api/v1/trips` a `/api/viajes` en Trip Execution. El detalle requiere conocer el UUID del viaje. |

## Bloqueos para conectar propuestas y agenda

1. **Los identificadores no coinciden entre servicios.** Driver Management usa UUID para usuarios. Trip Planning & Matching todavía define `driverId` y `passengerId` como `Long`; Trip Execution usa UUID para conductor, grupo y viaje. La app no debe convertir ni inventar estos IDs. Hay que unificar los contratos y la persistencia en UUID antes de conectar el matching de punta a punta.

2. **Falta una bandeja de propuestas para el conductor.** Trip Planning permite crear disponibilidades, listar solicitudes de viaje y generar/listar propuestas por `tripRequestId`. No expone una consulta de propuestas asignadas al conductor autenticado ni operaciones para aceptar o rechazar una propuesta. El modelo actual de propuesta tampoco contiene los datos de ruta y paradas que muestran las pantallas.

3. **Falta una consulta de viajes del conductor.** Trip Execution tiene creación y consulta por UUID, además de validar abordaje, iniciar, finalizar y cancelar. No aparece una ruta para listar próximos e históricos del conductor. Su DTO de detalle devuelve estado y abordajes, pero no direcciones ni orden de paradas.

4. **La disponibilidad semanal y la disponibilidad para matching son contratos distintos.** Driver Management guarda franjas recurrentes por día de semana. Trip Planning recibe una disponibilidad puntual con fecha, zona, horario, asientos e `driverId`. Debe definirse quién transforma o sincroniza el calendario semanal en disponibilidades puntuales.

5. **Las pantallas de ubicación, emergencia y avisos siguen siendo demo.** En los repositorios revisados no se encontró una API pública para compartir ubicación del viaje, emitir alertas del conductor o listar notificaciones del conductor.

## Estado de integración en la app Flutter

- Implementados en modo API: login con JWT, almacenamiento seguro, carga del perfil autenticado, alta de perfil conductor, consulta y guardado de vehículo, carga/listado de documentos, y consulta/reemplazo de disponibilidad semanal.
- Requieren URL del Gateway y credenciales válidas para probar tráfico real. La URL se configura con `--dart-define=SHAREWAY_API_BASE_URL=...`.
- Viajes, propuestas, zonas de disponibilidad, vista previa de documentos, ubicación, emergencia y avisos siguen en modo demo o requieren endpoints adicionales.

## Siguiente orden de integración

1. Alinear los IDs de Trip Planning & Matching con UUID y verificar su compatibilidad con Driver Management y Trip Execution.
2. Acordar e implementar la bandeja del conductor para propuestas, con aceptación/rechazo y los datos necesarios para mostrar ruta, tarifa, horarios y vencimiento.
3. Acordar una consulta de agenda del conductor que devuelva los viajes con paradas y pasajeros; definir la relación con Booking & Pricing.
4. Configurar una URL del API Gateway desplegada y validar el inicio de sesión y las operaciones del perfil con una cuenta de conductor.
5. Alinear el matching y agregar los endpoints de propuestas/agenda descritos arriba antes de reemplazar los datos demo de esos módulos.

## Mapeo del Gateway

El Gateway registra los prefijos `/api/v1/auth`, `/api/v1/users`, `/api/v1/drivers`, `/api/v1/driver-documents`, `/api/v1/trip-requests`, `/api/v1/driver-availabilities`, `/api/v1/settlements` y `/api/v1/trips`. Por ello, las rutas existentes de esos servicios tienen entrada pública configurada. El Gateway valida el JWT; Trip Planning & Matching y Trip Execution dependen de esa protección perimetral según la documentación actual.

## Repositorios inspeccionados

- `FundaTechPeru/shareway-api-gateway` — `src/routes.ts` y `README.md`.
- `FundaTechPeru/shareway-driver-management-service` — controladores REST y DTO de usuarios, conductores, documentos, disponibilidad y vehículos.
- `FundaTechPeru/shareway-trip-planning-matching-service` — `TripMatchingController` y DTO de solicitudes, disponibilidades y propuestas.
- `FundaTechPeru/shareway-trip-execution` — `ViajesController` y `ViajeDto`.
- `FundaTechPeru/shareway-payments-settlement-service` — `SettlementController`.

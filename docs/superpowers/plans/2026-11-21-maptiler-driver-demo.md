# ShareWay Driver MapTiler Implementation Plan

## Objetivo

Reemplazar los cuatro mapas dibujados del flujo del conductor por un mapa de calles MapTiler con paradas y recorrido de demostración.

## Restricciones

- Trabajar en `feature/driver` y preservar los cambios que ya estaban en el área de trabajo.
- No cambiar el Gateway ni los microservicios.
- Mantener las coordenadas y la línea como datos ficticios; no añadir GPS.
- No guardar la clave MapTiler en archivos versionados. Cargarla desde `map_secrets.json`, ignorado por Git.
- No añadir ni ejecutar pruebas automatizadas salvo que el usuario lo pida.

## Tareas

1. Crear `DriverMapPoint` y rutas demo para Lince–San Isidro, Jesús María–Surco y Miraflores–Lima Centro; conservar esos datos al actualizar modelos.
2. Añadir `flutter_map`, `latlong2`, `flutter_svg` y `url_launcher`. Cargar mosaicos `streets-v4` de MapTiler con clave desde `MAPTILER_API_KEY`, logo, atribución enlazada y estado de error.
3. Mantener la ilustración existente como alternativa cuando no haya clave.
4. Conectar propuesta, detalle, viaje activo y enlace de emergencia a las rutas de demostración correspondientes.
5. Excluir `map_secrets.json`, copiar localmente la clave desde el archivo del Escritorio y documentar cómo ejecutar en Android y Chrome.
6. Actualizar esta especificación y el README con límites del mapa, clave de cliente y fronteras de demostración.

## Revisión manual futura

- En Android y Chrome, con clave válida, aparecen mosaicos, marcadores, atribución y polilínea.
- Sin clave, la app muestra la ilustración y conserva el resto de la navegación.
- Una clave o conexión inválida muestra un aviso de carga sin bloquear la pantalla.
- Las paradas cambian según el viaje; la cancelación de un pasajero quita su marcador.
- La app no solicita permisos de ubicación.

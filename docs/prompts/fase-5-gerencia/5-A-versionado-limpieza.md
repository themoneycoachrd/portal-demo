# Fase 5 — Sub-fase A: Versionado y limpieza inicial

## Objetivo

Antes de reorganizar la UI de Gerencia, guardar la versión actual y eliminar lo que sale (módulo top-level "Base de Datos" y pill "Links Portal"). Después de esto, el archivo queda con un solo módulo top-level y listo para construir la estructura nueva en la sub-fase B.

## Pre-requisitos

- Ninguno. Esta es la primera sub-fase de la Fase 5.

## Alcance

### 1. Versionado
- Copiar `pages/gerencia.html` a `pages/version-anterior/gerencia-YYYY-MM-DD.html` con la fecha de hoy.
- Si la carpeta `pages/version-anterior/` no existe, crearla.
- Confirmar que el archivo copiado es idéntico al original antes de continuar.

### 2. Eliminar el módulo top-level "Base de Datos"
- Hoy `gerencia.html` tiene 3 módulos top-level: Clientes, Contadoras, Base de Datos.
- Eliminar el botón / tab "Base de Datos" del top-level.
- Eliminar el div que contiene su UI completa.
- Eliminar las funciones JS asociadas (bdSubTabs, render de sub-tabs de BD, etc.) que ya no se usen. **Importante:** algunas de estas funciones se van a reaprovechar en la sub-fase C (Outsourcing CRUD, Contadoras maestra, Asignaciones, Link Dashboard). No las borres del todo; déjalas comentadas o muévelas a una sección "// PENDIENTE migrar a pill X" al final del script.
- El módulo top-level "Contadoras" (KPI + checklist) **no se toca**. Sigue como está.

### 3. Eliminar el pill / sub-tab "Links Portal"
- Eliminar el sub-tab "Links Portal" de la antigua BD (ya no aplica porque BD se elimina).
- Eliminar las funciones JS de generación/manejo de tokens del lado de gerencia (esa funcionalidad vive ahora solo en `portal-clientes.html`).
- Verificar que no hay queries activas a `portal_clientes_tokens` desde gerencia.html que se quedaron huérfanas.

### 4. Estado al cerrar la sub-fase
- `gerencia.html` tiene solo dos módulos top-level: "Clientes" y "Contadoras".
- El módulo "Clientes" queda funcional como hoy (con sus pills actuales: Dashboard, Outsourcing, Software, Implementaciones, Facturación). En la sub-fase B se le reescribirá la estructura de pills.
- `pages/version-anterior/gerencia-YYYY-MM-DD.html` existe y es la versión previa exacta.

## Qué NO tocar

- El módulo top-level "Contadoras" (KPI + checklist).
- La tabla `clientes` (maestra) ni ninguna otra tabla Supabase. Esta sub-fase es solo UI/limpieza.
- `index.html`, `usuarios.html` u otros módulos.

## Criterios de cierre

- Versionado en `pages/version-anterior/` confirmado.
- Top-level "Base de Datos" eliminado del HTML y del switch de tabs.
- Pill "Links Portal" eliminado.
- `gerencia.html` carga sin errores en consola.
- Login funciona, navegación entre los dos módulos top-level restantes funciona.

## Punto de validación con Felix

Mostrar el archivo cargado en el navegador con los dos módulos top-level únicamente y confirmar que la limpieza está completa antes de pasar a la sub-fase B.

## Después de cerrar

- Marcar el item "Sub-fase A — Versionado y limpieza inicial" como tachado en el checklist macro de `plan.md`.
- En la tabla de orden de la Fase 5, cambiar el estado de la sub-fase A a "Cerrado YYYY-MM-DD".
- Agregar entrada en `memory-portal.md` con lo hecho.

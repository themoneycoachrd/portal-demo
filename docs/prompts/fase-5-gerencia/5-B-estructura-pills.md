# Fase 5 — Sub-fase B: Estructura de pills nueva

## Objetivo

Construir el esqueleto de los 8 pills del módulo unificado en el orden acordado con Felix. Cada pill arranca con un placeholder; el contenido real se migra en la sub-fase C.

## Pre-requisitos

- Sub-fase A cerrada (versionado hecho, top-level BD y pill Links Portal eliminados).

## Orden exacto de los pills

Dentro del módulo top-level (el que antes era "Clientes"), reemplazar la barra de pills actual por estos 8 pills en este orden:

1. **Dashboard**
2. **Outsourcing**
3. **Software**
4. **Implementaciones**
5. **Contadoras**
6. **Asignaciones**
7. **Link Dashboard**
8. **Facturación**

## Alcance

### 1. Renombrar el módulo top-level
- El módulo top-level que antes se llamaba "Clientes" se renombra. Sugerencia: "Gerencia" o "Dashboard Gerencia". Confirmar con Felix qué nombre prefiere antes de cambiar. Si no hay confirmación, dejar "Clientes" provisional y marcar como TODO.

### 2. Reescribir la barra de pills
- Reemplazar la barra de pills actual (Dashboard, Outsourcing, Software, Implementaciones, Facturación) por la nueva de 8 pills en el orden de arriba.
- Mantener el estilo visual de los pills (mismas variables CSS, mismo comportamiento de active state).
- Estado por defecto: Dashboard activo.

### 3. Contenedores de contenido
Por cada pill, crear un div contenedor vacío con su `id`:
```html
<div id="pill-dashboard" class="pill-content active">...placeholder...</div>
<div id="pill-outsourcing" class="pill-content">...placeholder...</div>
<div id="pill-software" class="pill-content">...placeholder...</div>
<div id="pill-implementaciones" class="pill-content">...placeholder...</div>
<div id="pill-contadoras" class="pill-content">...placeholder...</div>
<div id="pill-asignaciones" class="pill-content">...placeholder...</div>
<div id="pill-link-dashboard" class="pill-content">...placeholder...</div>
<div id="pill-facturacion" class="pill-content">...placeholder...</div>
```

Placeholder sugerido (texto temporal):
```html
<div style="padding:40px;text-align:center;color:#888;">
  Pill <strong>{nombre}</strong> — contenido pendiente de migración (sub-fase C).
</div>
```

### 4. JS de navegación entre pills
- Función `selectPill(pillId)` que oculta todos los `.pill-content` y muestra solo el seleccionado.
- Click handlers en cada pill llaman a `selectPill()`.
- Mantener consistencia con cómo se navegan los pills hoy en el resto del portal.

### 5. Implementaciones — pills internos FE/Adm
Dentro del pill "Implementaciones", crear la estructura de dos pills internos:
- Pill interno "FE"
- Pill interno "Adm" (con esa capitalización exacta: A mayúscula, resto minúscula)
- Por ahora con placeholders. El contenido se migra en sub-fase C.

## Qué NO tocar

- Módulo top-level "Contadoras" (KPI + checklist).
- El contenido viejo de los pills (Dashboard, Outsourcing, Software, Implementaciones, Facturación de la versión actual). Va a quedar fuera de la estructura nueva — déjalo comentado o en una sección "// PENDIENTE migrar" al final del HTML para reaprovecharlo en sub-fase C.

## Criterios de cierre

- Los 8 pills aparecen en el orden correcto.
- Click en cada pill cambia el contenedor visible.
- Implementaciones tiene los dos pills internos FE y Adm (con esa capitalización).
- Login y modo embed funcionan sin errores.
- Consola limpia.

## Punto de validación con Felix

Felix prueba la navegación entre los 8 pills y confirma que el orden y los nombres son correctos antes de pasar a migrar contenido.

## Después de cerrar

- Marcar la sub-fase B como tachada en el checklist macro y en la tabla de orden de `plan.md`.
- Agregar entrada en `memory-portal.md`.

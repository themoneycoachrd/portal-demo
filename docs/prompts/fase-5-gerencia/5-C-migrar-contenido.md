# Fase 5 — Sub-fase C: Migrar contenido pill por pill

## Objetivo

Llenar los 8 pills con su contenido real. La mayoría se migra del CC actual o de BD actual; algunos requieren cambios visuales o funcionales.

## Pre-requisitos

- Sub-fases A y B cerradas (esqueleto de pills creado y vacío).

## Reglas comunes

- Reutilizar funciones JS comentadas que dejamos en sub-fase A.
- No inventar estilos: usar las variables CSS existentes.
- Cada pill se trabaja por separado. Probar pill por pill antes de pasar al siguiente.
- Si descubres algo que requiere decisión, parar y preguntar a Felix.

## Orden sugerido

Hacer primero los que tienen contenido ya armado y poca lógica (Dashboard, Software, Asignaciones, Link Dashboard, Facturación). Después los que tienen cambios (Outsourcing, Implementaciones, Contadoras).

## Pill por pill

### 1. Dashboard
- **Origen:** CC → Dashboard actual.
- **Cambios:** ninguno funcional. Solo trasladar el HTML/JS al nuevo contenedor `#pill-dashboard`.
- **Criterio de cierre:** las cards (Clientes actuales, Nuevos, Churn, Crecimiento), el gráfico de evolución, la tabla resumen mensual y el detalle expandible por mes se ven y funcionan como hoy.

### 2. Outsourcing (el más cargado)
- **Origen:** combinar CC → Outsourcing (visual analítica) + BD → Outsourcing (CRUD).
- **Estructura final del pill:**
  1. Filtro por mes (pills) — como hoy en CC.
  2. **Stats cards en este orden:** Sin asignar (arriba), Tax One, Contabilidad, Supervisión, Bookkeeping.
  3. **Después de Bookkeeping**, dos bloques nuevos: **Nuevos** y **Churn** (vienen de la vista actual de BD/Outsourcing).
  4. Tabla principal de clientes. Debe mostrar: ID, Nombre, RNC, Contacto, Email, Teléfono, Estado, Tipo servicio, Contadora (Contabilidad), Contadora (Impuestos).
  5. Filtro por tipo de servicio: stats cards son clickables y filtran la tabla.
  6. **CRUD:** botones "Nuevo cliente", "Editar" (modal), "Marcar inactivo".
  7. Alerta de "Clientes a crear" (la que existía en BD/Outsourcing) si aplica.
- **Modal de cliente:** reutilizar el modal de BD/Outsourcing (dos selects de contadora, dos checkboxes de responsabilidad, dropdown de monto_adm). Ya está conectado a la maestra `clientes`.
- **Criterio de cierre:** se puede ver, filtrar, crear y editar clientes desde un solo pill. Nuevos y Churn aparecen al final de los stats.

### 3. Software
- **Origen:** combinar CC → Software (analítica) + BD → Software (CRUD).
- **Estructura final:** stats cards arriba (Total, Inicio, Nuevos, Churn, Cierre), filtro de mes, filtro de licencia (pills), tabla de clientes con licencias, botones CRUD (Nuevo, Editar, Inactivar), alerta de licencias pendientes.
- **Criterio de cierre:** un solo pill que cubre análisis + gestión de licencias.

### 4. Implementaciones (con pills internos FE / Adm)
- **Origen:** datos vienen de las tablas `implementaciones_fe` e `implementaciones_completas` (la "Adm" en este contexto es lo que hoy se llama "Implementación Completa" o ADM Cloud — confirmar con Felix qué nombre prefiere para la tabla mostrada). Recordatorio del CLAUDE.md global: escribir "Adm", no "ADM".
- **Pills internos:**
  - **FE:** tabla con clientes en implementación de Facturación Electrónica.
  - **Adm:** tabla con clientes en implementación ADM Cloud.
- Cada pill interno tiene su propia tabla con estado, fase, semáforo y fecha estimada de cierre. Reutilizar lo que ya está en `implementaciones.html` para no duplicar lógica.
- **Cards de riesgo:** mantener la card de "Implementaciones en riesgo" del CC actual, arriba de los pills internos.
- **Criterio de cierre:** ambos pills internos cargan datos correctamente y se navega entre ellos sin errores.

### 5. Contadoras (pill, no top-level)
- **Origen:** BD → Contadores.
- **Estructura final:** tabla con todas las contadoras (Nombre, Clientes asignados, Activo/Inactivo, Acciones). Botón "Nueva contadora". Modal de edición.
- **Criterio de cierre:** Felix puede agregar una contadora nueva desde aquí y se refleja en los selects del modal de cliente del pill Outsourcing.

### 6. Asignaciones
- **Origen:** BD → Asignaciones.
- **Cambios:** ninguno funcional. Trasladar el contenido tal cual.
- **Criterio de cierre:** filtro por mes, tabla con cliente/contadora/servicio/admin, edición inline funciona.

### 7. Link Dashboard
- **Origen:** BD → Link Dashboard.
- **Cambios:** ninguno funcional. Trasladar el contenido tal cual.
- **Criterio de cierre:** la configuración del link público funciona.

### 8. Facturación
- **Origen:** CC → Facturación.
- **Cambios:** ninguno funcional. Trasladar el contenido tal cual.
- **Criterio de cierre:** filtro por mes, montos Outsourcing y Software, desglose por contadora/cliente, comparativa Facturado vs Perdido se ven correctamente.

## Qué NO tocar

- Tablas de Supabase (no cambia el esquema, solo se mueven queries).
- Módulo top-level "Contadoras" (KPI + checklist).
- Reglas RLS.

## Criterios de cierre globales

- Los 8 pills muestran su contenido real.
- Outsourcing tiene stats en el orden correcto (Sin asignar arriba, luego Tax One, Contabilidad, Supervisión, Bookkeeping, Nuevos, Churn).
- CRUD funciona en Outsourcing, Software y Contadoras.
- Consola limpia.
- Modo embed sigue funcionando.

## Punto de validación con Felix

Felix prueba cada pill uno por uno. Si encuentra que algo se ve raro o falta data, se corrige antes de pasar a la sub-fase D.

## Después de cerrar

- Marcar la sub-fase C como tachada en `plan.md`.
- Entrada en `memory-portal.md` listando los pills migrados.

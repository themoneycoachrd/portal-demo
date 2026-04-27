# Proyecto: Portal Account One

## Qué es

Portal web interno de Account One. El equipo lo usa para gestionar operaciones diarias: control de contadoras, ventas, KPIs, permisos, y eventualmente un portal para clientes. Stack: HTML/CSS/JS vanilla + Supabase + GitHub Pages.

## Contexto del proyecto

Lee `docs/about-project.md` para entender la arquitectura, los módulos, las tablas de Supabase y el equipo. Lee `docs/memory-portal.md` para saber qué se ha hecho, qué decisiones se tomaron y qué está pendiente.

## Metodología de trabajo

### Antes de tocar código

1. **Lee el estado actual.** Revisa `docs/memory-portal.md` para saber dónde quedamos. No asumas que sabes qué cambió desde la última sesión.
2. **Identifica qué módulo se va a tocar.** Cada módulo es un archivo .html independiente. No hay dependencias entre módulos excepto `index.html` (sidebar).
3. **Si es un cambio grande, haz un plan primero.** Lista qué vas a cambiar, qué puede romperse, y valida con Félix antes de ejecutar. Para cambios pequeños, ejecuta directo.

### Durante el desarrollo

4. **Un módulo a la vez.** No toques dos archivos HTML al mismo tiempo a menos que el cambio lo requiera (ej: agregar un item al menú de index.html cuando creas un módulo nuevo).
5. **Lee el archivo antes de escribirlo.** Siempre. Sin excepción. El Write tool falla si no leíste primero.
6. **Mantén la consistencia visual.** Todos los módulos comparten el mismo design system (variables CSS, estilos de cards, tablas, botones). Antes de inventar un estilo nuevo, revisa si ya existe en otro módulo.
7. **Prueba mentalmente antes de entregar.** Recorre el flujo: login → carga de datos → render → interacción → guardado. Verifica que no haya IDs duplicados, variables sin declarar, o queries que fallen con RLS.

### Después de cada sesión

8. **Actualiza `docs/memory-portal.md`** con lo que se hizo, las decisiones tomadas y los problemas resueltos.
9. **Si hubo una decisión que afecta otros proyectos**, actualiza también `About Me/memory-general.md`.
10. **Avance del plan en `docs/plan.md`:** cuando se complete una fase del plan, marcarla como tachada en dos lugares:
    - En el checklist general de arriba: cambiar `- [ ]` por `- [x]`.
    - En el título de la fase y en su tabla de orden: envolver el nombre en `~~...~~` para que se vea tachado.
    - Cambiar el estado en la tabla de orden de "Pendiente" / "Por iniciar" a "Cerrado YYYY-MM-DD".
    - Si solo se completa parte de una fase (un punto del alcance), tachar ese bullet específico, no la fase entera.
    El plan debe reflejar visualmente, de un vistazo, qué está cerrado y qué falta.

## Reglas técnicas

### Consistencia visual (regla obligatoria)
- **Antes de crear cualquier componente visual nuevo, busca si ya existe algo parecido en otro módulo del portal.** Revisa los archivos existentes (contabilidad.html, impuestos.html, gerencia.html, etc.) y copia la misma arquitectura, los mismos CSS classes, los mismos colores y la misma estructura HTML.
- **Componentes reutilizables del portal:** summary-stats (Clientes/Completados/En progreso/Sin iniciar/Avance promedio con colores verde/ámbar/rojo), check-table (tabla de checklist con columnas #/Tarea/Impuesto/Firma/Limite/Estado/Fecha), toggle-group (botones Si/No con active-yes verde y active-no rojo), detail-header + progress-row (vista detalle de cliente), month-tabs + contadora-pills (navegación), client table (tabla con barra de progreso y status badges).
- **No inventes clases CSS nuevas si ya existen equivalentes.** Reutiliza: `.summary-stats`, `.check-table`, `.group-row`, `.toggle-group`, `.toggle-opt`, `.detail-header`, `.progress-row`, `.view-toggle`, `.tipo-badge`, etc.
- **Si Félix pide "algo parecido a X", lee X primero y copia la estructura exacta.**

### HTML / CSS / JS
- **Sin frameworks.** Todo es vanilla. No propongas React, Vue, ni nada que requiera build.
- **Un archivo por módulo.** CSS y JS van inline en el mismo .html.
- **Variable del cliente Supabase = `sb`**, nunca `supabase`.
- **Embed mode:** todos los módulos soportan `?embed=1` que oculta header, login y breadcrumb via `body.embed`.
- **Login:** cada módulo tiene su propio login. En modo embed, la sesión viene del index.html padre.

### Supabase
- **RLS siempre activo.** Toda tabla nueva debe tener RLS habilitado y políticas definidas.
- **`get_my_role()`** es la función SECURITY DEFINER que devuelve el rol del usuario. Usarla en políticas RLS.
- **UPSERT con `onConflict`** para guardar datos. No hacer INSERT + UPDATE separados.
- **Meses en texto** en la tabla `asignaciones` ('enero', 'abril'). No cambiar a números.
- **Los .sql se ejecutan manualmente** en el SQL Editor de Supabase. Incluir comentarios claros.

### Permisos
- **Sistema de grupos.** Tabla `grupos` con JSONB `permisos` (matriz pantalla x habilidad). Tabla `usuario_grupos` (many-to-many).
- **Habilidades:** consulta, adicion, edicion, anulacion, eliminar.
- **Pantallas:** control-clientes, control-contadoras, comercial, checklist, kpi, impuestos, implementaciones, portal-clientes, usuarios.
- **Permisos aditivos:** un usuario en múltiples grupos obtiene la unión de todos los permisos.

### Diseño visual
- **Paleta:** navy (#1a2332), blue (#4361ee), green (#10b981), red (#ef4444), amber (#f59e0b).
- **Month tabs:** pill buttons estilo ventas.html (Ene, Feb, Mar...).
- **Cards:** border-radius 12px, border 1px solid var(--border), padding 20px.
- **Tablas:** font-size 0.82rem, headers uppercase 0.68rem, hover background #fafbfc.
- **Avatares de contadoras:** color neutro (navy), no colores individuales.
- **Contadoras excluidas del control:** Karina y Milka (su servicio no aplica).

## Archivos del proyecto

```
Projects/Portal-account-one/
├── CLAUDE.md                ← Este archivo (instrucciones del proyecto)
├── pages/                   ← Frontend — los .html que se suben a GitHub Pages
│   ├── index.html           ← Página principal con sidebar de navegación
│   ├── ventas.html          ← Pipeline de ventas
│   ├── control-contadoras.html
│   ├── checklist.html
│   ├── contadores.html
│   ├── kpi.html
│   └── usuarios.html       ← Gestión de grupos y permisos
├── db/                      ← Scripts SQL para Supabase (se ejecutan manual)
│   ├── supabase-setup.sql   ← Tablas iniciales (leads, roas_mensual)
│   ├── auth-setup.sql       ← Profiles, get_my_role(), triggers de auth
│   ├── contadores-setup.sql ← Asignaciones contadora-cliente
│   ├── reporte-setup.sql    ← reporte_mensual
│   ├── checklist-setup.sql  ← checklist_mensual
│   ├── permisos-setup.sql   ← Grupos y usuario_grupos
│   ├── kpi-policies.sql     ← RLS para KPI
│   └── rls-policies.sql     ← Políticas RLS generales
├── docs/                    ← Documentación del proyecto
│   ├── about-project.md     ← Arquitectura, módulos, tablas, equipo
│   └── memory-portal.md     ← Memoria del proyecto (estado, decisiones, pendientes)
└── Referencias/             ← Documentos de entrada que Félix suba
```

## Despliegue

1. Editar archivos en `pages/` (frontend) o `db/` (base de datos)
2. Félix sube el contenido de `pages/` a GitHub (`themoneycoachrd/portal-accountone`)
3. GitHub Pages publica automáticamente
4. Scripts de `db/` se ejecutan manualmente en Supabase SQL Editor

## Qué no hacer

- **No inventes módulos nuevos sin que Félix los pida.** Hay una lista de pendientes, pero el orden lo decide él.
- **No cambies el stack.** Si algo se puede resolver con JS vanilla, se resuelve con JS vanilla.
- **No toques la Supabase key.** Es una anon key pública, pero no la expongas fuera de los archivos del proyecto.
- **No borres datos de Supabase.** Si hay que limpiar algo, confirma con Félix primero.
- **No cambies RLS policies sin documentar.** Cualquier cambio de seguridad se documenta en docs/memory-portal.md.

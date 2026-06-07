# Proyecto: Portal Account One

## Qué es

Portal web interno de Account One. El equipo lo usa para gestionar operaciones diarias: contabilidad, ventas, KPIs, cobros, impuestos, implementaciones, personal, y un portal para clientes. Stack: HTML/CSS/JS vanilla + Supabase + Vercel.

## Contexto del proyecto

Lee `docs/about-project.md` para entender la arquitectura, los módulos, las tablas de Supabase y el equipo. Lee `docs/memory-portal.md` para saber qué se ha hecho, qué decisiones se tomaron y qué está pendiente.

---

## Workflow de desarrollo

### Concepto: 1 sesión = 1 issue = 1 branch = 1 PR

Cada sesión de trabajo sigue este flujo:

```
GitHub Issue (plan) → Branch → Commits → PR → Merge a main
```

No se trabaja directo en main. No se crean múltiples PRs para un mismo plan. Si el plan es demasiado grande para una sesión, se parte en issues más pequeños.

### Paso 1: Planificar (inicio de sesión)

1. **Leer el estado actual.** Revisar `docs/memory-portal.md` y los issues abiertos en GitHub.
2. **Crear un GitHub Issue** con el plan de la sesión:
   - Título claro: qué se va a lograr (ej: "Fase 3: Dashboard de carga por contadora")
   - Descripción con checklist de tareas (`- [ ] tarea`)
   - Label del área: `fase-3`, `bug`, `mejora`, `refactor`
3. **Crear branch** desde main, nombrado según el issue:
   - Features: `feat/descripcion-corta` (ej: `feat/dashboard-carga-contadoras`)
   - Bugs: `fix/descripcion-corta` (ej: `fix/inactivos-wrong-function`)
   - Refactors: `refactor/descripcion-corta`

### Paso 2: Ejecutar (durante la sesión)

4. **Commits pequeños y descriptivos.** Cada commit hace una cosa. El mensaje dice por qué, no solo qué.
   - Bien: "Agregar cálculo de carga por contadora con barra de capacidad"
   - Mal: "cambios"
5. **Un módulo a la vez.** No tocar dos archivos HTML al mismo tiempo a menos que el cambio lo requiera.
6. **Leer el archivo antes de escribirlo.** Siempre. Sin excepción.
7. **Verificar cada cambio.** Después de implementar, comprobar que funciona (en browser, en producción, o revisando la lógica). No avanzar al siguiente punto sin confirmar el anterior.

### Paso 3: Cerrar (final de sesión)

8. **Crear UN Pull Request** que cierre el issue:
   - Título = resumen de lo que se hizo
   - Body con: resumen en bullets, archivos tocados, cómo probar, referencia al issue (`Closes #N`)
   - El PR debe cuadrar con el plan del issue. Si se hizo algo extra, documentarlo. Si algo quedó pendiente, anotarlo.
9. **Merge a main** después de revisar el PR.
10. **Actualizar `docs/memory-portal.md`** con lo que se hizo y las decisiones tomadas.
11. **Marcar avance en `docs/plan.md`** si aplica (tachar fases completadas).

### Cuándo NO seguir este flujo

- **Hotfix urgente en producción:** branch `fix/`, commit, PR, merge inmediato. Sin issue previo.
- **Cambio trivial** (un typo, una línea): commit directo a main está bien. No todo necesita ceremonia.

---

## Reglas técnicas

### HTML / CSS / JS
- **Sin frameworks.** Todo es vanilla. No proponer React, Vue, ni nada que requiera build.
- **Un archivo por módulo.** CSS y JS van inline en el mismo .html.
- **Variable del cliente Supabase = `sb`**, nunca `supabase`.
- **Año dinámico:** `var ANIO = new Date().getFullYear()`. Nunca hardcodear el año.
- **Embed mode:** todos los módulos soportan `?embed=1` que oculta header, login y breadcrumb via `body.embed`.

### Supabase
- **RLS siempre activo.** Toda tabla nueva debe tener RLS habilitado y políticas definidas.
- **`get_my_role()`** es la función SECURITY DEFINER que devuelve el rol del usuario.
- **UPSERT con `onConflict`** para guardar datos. No hacer INSERT + UPDATE separados.
- **Los .sql van en `db/`** y se ejecutan manualmente en el SQL Editor de Supabase.

### Permisos
- **Sistema de grupos.** Tabla `grupos` con JSONB `permisos` (matriz pantalla x habilidad).
- **`tengoPermiso()`** en el frontend para verificar acceso.
- **Habilidades:** consulta, adicion, edicion, anulacion, eliminar.

### Consistencia visual (obligatoria)
- **Antes de crear algo nuevo, buscar si ya existe en otro módulo.** Copiar la misma estructura.
- **Todo cambio visual en portal-admin.html debe replicarse en portal-clientes.html en la misma sesión.**
- **Paleta:** navy (#1a2332), blue (#4361ee), green (#10b981), red (#ef4444), amber (#f59e0b).
- **Cards:** border-radius 12px, border 1px solid var(--border), padding 20px.
- **Tablas:** font-size 0.82rem, headers uppercase 0.68rem, hover background #fafbfc.

---

## Estructura del proyecto

```
Projects/Portal Account One/
├── CLAUDE.md              ← Este archivo
├── docs/
│   ├── about-project.md   ← Arquitectura, módulos, tablas, equipo
│   ├── memory-portal.md   ← Memoria del proyecto (estado, decisiones, pendientes)
│   └── plan.md            ← Plan maestro con fases
├── pages/                 ← Frontend (root directory en Vercel)
│   ├── index.html         ← Página principal con sidebar
│   ├── gerencia.html      ← Clientes, outsourcing, cobros, personal
│   ├── contabilidad.html  ← Checklist + KPI de contadoras
│   ├── impuestos.html     ← Checklist + KPI de impuestos
│   ├── implementaciones.html
│   ├── ventas.html        ← Pipeline comercial
│   ├── personal.html      ← Wow Board, organigrama, directorio
│   ├── usuarios.html      ← Gestión de permisos y grupos
│   ├── portal-admin.html  ← Portal de clientes (admin)
│   ├── portal-clientes.html ← Portal de clientes (vista cliente)
│   └── dashboard-publico.html ← Dashboard para TV de oficina
├── db/                    ← Scripts SQL para Supabase (ejecución manual)
└── Referencias/           ← Documentos de entrada
```

## Despliegue

- **Repo:** `themoneycoachrd/portal-accountone-v2` (GitHub, privado)
- **Hosting:** Vercel, conectado al repo. Root directory = `pages/`, branch = `main`.
- **Flujo:** push a main → Vercel despliega automáticamente.
- **SQL:** scripts en `db/` se ejecutan manualmente en Supabase SQL Editor.

## Qué no hacer

- **No trabajar directo en main.** Siempre branch + PR (excepto hotfixes triviales).
- **No inventar módulos nuevos sin que Félix los pida.**
- **No cambiar el stack.** Si se puede resolver con JS vanilla, se resuelve con JS vanilla.
- **No borrar datos de Supabase sin confirmar.**
- **No cambiar RLS policies sin documentar en memory-portal.md.**
- **No crear múltiples PRs para un mismo plan.** 1 issue = 1 PR.

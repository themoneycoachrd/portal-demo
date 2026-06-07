# Plan de desarrollo — Portal Account One

Plan vivo. Se actualiza al cierre de cada fase. Las descripciones funcionales detalladas viven en `memory-portal.md`; aquí se trackea el avance, dependencias y pendientes de cada fase.

---

## Checklist macro

Vista rápida de avance. Cada item se tacha cuando la fase se cierra. Para detalle, ir a la sección de cada fase abajo.

- [x] Fase 0 — Comercial (cerrado, no se toca)
- [x] **~~Fase 1 — Consolidación BD de clientes (5 sub-fases)~~**
  - [x] Sub-fase A — Definición del esquema final
  - [x] Sub-fase B — Migración de datos
  - [x] Sub-fase C — Refactor del rol de `asignaciones`
  - [x] Sub-fase D — Refactor de módulos para leer de la maestra
  - [x] Sub-fase E — Pantalla de gestión en Gerencia
- [ ] **Fase 9 — Migración a permisos por grupo (hasPermiso)** ← PRÓXIMA
  - [ ] Sub-fase A — Actualizar catálogo MODULOS en usuarios.html
  - [ ] Sub-fase B — Función compartida de carga de permisos
  - [ ] Sub-fase C — Migrar sidebar de index.html
  - [ ] Sub-fase D — Migrar módulos uno por uno
  - [ ] Sub-fase E — Verificación y limpieza
- [ ] **Fase 11 — Auditoría y mejoras con Claude Code** ← EN CURSO
  - [ ] Bugs críticos (año hardcodeado, Chart.js leak, saving flag, getCurrentMonth, XSS)
  - [ ] Inconsistencias de diseño (colores, login, tabs, tildes)
  - [ ] UX (reemplazar alert/confirm/prompt nativos, feedback, responsive)
- [ ] Fase 2 — KPI (rehacer)
- [ ] Fase 3 — Checklist Mensual (submódulo de Contadoras)
- [ ] Fase 4 — Control de Contadoras (consolidación)
- [ ] Fase 10 — Refactor gerencia.html (partir en módulos JS separados)
- [x] **~~Fase 5 — Gerencia (reorganización de pills + super reporte)~~**
  - [x] ~~Sub-fase A — Versionado y limpieza inicial~~
  - [x] ~~Sub-fase B — Estructura de pills nueva~~
  - [x] ~~Sub-fase C — Migrar contenido pill por pill~~
  - [x] ~~Sub-fase D — Actualizar catálogo MODULOS en usuarios.html~~
  - [x] ~~Sub-fase E — Validación con Felix~~
- [x] ~~Fase 6 — Impuestos~~
- [x] ~~Fase 7 — Implementaciones~~
- [x] ~~Fase 8 — Portal de Clientes (fase 1)~~

---

## Orden de ejecución

| # | Fase | Estado | Notas |
|---|---|---|---|
| 0 | Comercial (ventas.html) | Cerrado | No se toca |
| 1 | ~~**Consolidación BD de clientes**~~ | Cerrado 2026-04-26 | 5 sub-fases completadas. Fundacional: todos los módulos leen de la maestra |
| 2 | KPI (rehacer) | Por iniciar | Bloqueado: falta fórmula mensual sobre 100. Depende de Fase 1 |
| 3 | Checklist Mensual (submódulo de Contadoras) | Pendiente | Lista de items por definir |
| 4 | Control de Contadoras (consolidación) | Pendiente | Integrar KPI + Checklist en un módulo coherente |
| 5 | ~~Gerencia (super reporte)~~ | Cerrado 2026-05-14 | 8 pills migrados, CRUD integrado, validación en vivo OK |
| 6 | ~~Impuestos~~ | Cerrado 2026-04-26 | impuestos.html funcional con Checklist + KPI, dos vistas |
| 7 | ~~Implementaciones~~ | Cerrado 2026-04-26 | implementaciones.html con dos tabs (Completa + FE) |
| 8 | ~~Portal de Clientes (fase 1)~~ | Cerrado 2026-04-27 | portal-clientes.html funcional. Fase 2 pendiente: calculadora IR-17, RLS anon |
| **9** | **Migración a permisos por grupo** | **Próxima** | Reemplazar profiles.rol por hasPermiso() en toda la UI. profiles.rol se mantiene solo para RLS |
| 10 | Refactor gerencia.html | Pendiente | Partir archivo de 6000+ líneas en módulos JS separados. Eliminar código duplicado. Trabajar en branch aparte |
| **11** | **Auditoría y mejoras con Claude Code** | **En curso** | Corregir bugs encontrados en auditoría del 2026-06-05 + mejoras de diseño y UX. Trabajar sobre versión Claude Design |

> **Cambio de orden (2026-04-26):** La consolidación de la BD de clientes se insertó como Fase 1 (antes de KPI) porque es fundacional. KPI y todos los módulos necesitan leer de la maestra. Si arrancamos KPI primero y después consolidamos, tocamos KPI dos veces.

---

## Fase 1 — Consolidación BD de clientes

**Objetivo:** que exista una sola tabla maestra (`clientes`) de donde todos los módulos deriven el universo de clientes, contadoras asignadas y responsabilidades. Hoy cada módulo deduce los clientes de su propia tabla y los conteos no cuadran (29 vs 17 vs 32).

**Problema que resuelve:** no hay un padrón único de clientes. `asignaciones` acopla cliente + contadora + montos mensuales. No hay campo que diga "este cliente tiene responsabilidad de contabilidad" o "tiene responsabilidad de impuestos". `perfiles_clientes` (3 registros) fue un intento abandonado.

**Decisiones tomadas:**
- `responsabilidad_contabilidad` y `responsabilidad_impuestos`: flags bool en la maestra.
- `contadora_contabilidad` y `contadora_impuestos`: campos independientes en la maestra. Cuando cambia (una vez al año o cuando aplique), se actualiza el campo directo. Los módulos derivan la contadora desde la maestra.
- `monto_adm`: cantidad de transacciones contratadas (integer, no monetario). Fijo hasta cambio de contrato.
- `serv` no se almacena como dato fijo: se deriva del checklist del último mes.
- Tabla `clientes_cambios_contadora` para histórico automático (trigger en BD).
- `asignaciones` se mantiene pero cambia de rol: pasa a ser registro de excepciones mensuales (vacaciones, licencia, monto distinto), no fuente de la lista de clientes.
- `perfiles_clientes` se marca como deprecada (no se borra, se ignora).

---

### ~~Sub-fase A — Definición del esquema final~~ (Cerrada 2026-04-26)

SQL en `db/clientes-consolidacion-fase-a.sql`. Cambios aplicados:
- ALTER TABLE `clientes`: +`responsabilidad_contabilidad` (bool), +`responsabilidad_impuestos` (bool), +`contadora_contabilidad` (text), +`contadora_impuestos` (text), +`monto_adm` (int). DROP `contadora`.
- Migración automática: datos de la columna vieja copiados a las dos nuevas. Karina → ambas responsabilidades false. Milka → responsabilidad_impuestos false.
- CREATE TABLE `clientes_cambios_contadora` con trigger automático `trg_log_cambio_contadora`.
- RLS: admin todo, autenticados leen.

---

### ~~Sub-fase B — Migración de datos~~ (Cerrada 2026-04-26)

SQL en `db/clientes-consolidacion-fase-b.sql`. Cambios aplicados:
- Poblado de `monto_adm` desde `asignaciones.serv` (no `.adm`, que es transacciones digitadas variables).
- Flags de responsabilidad corregidos caso por caso: Kaizen y Centro Adorartes (RST, `resp_imp=false`), CLC/Vitalie/Fleximoney (`resp_contab=false`, solo impuestos con Karina), Mab Arquitectura (`resp_contab=false`, `resp_imp=false`, bookkeeping con Milka).
- `perfiles_clientes` marcada como deprecada con COMMENT ON TABLE.
- Validación visual con widget HTML antes de generar el SQL final.

---

### ~~Sub-fase C — Refactor del rol de `asignaciones`~~ (Cerrada 2026-04-26)

SQL en `db/clientes-consolidacion-fase-c.sql`. Cambios aplicados:
- COMMENT ON TABLE `asignaciones` documentando nuevo rol como excepciones mensuales.
- COMMENT ON COLUMN para `contadora`, `adm` y `serv` explicando su significado.
- Datos históricos (enero-abril 2026) conservados como referencia, no borrados.
- Decisión: lógica de fallback = módulos leen de `clientes` (maestra); solo consultan `asignaciones` si hay excepción para ese mes.

---

### ~~Sub-fase D — Refactor de módulos para leer de la maestra~~ (Cerrada 2026-04-26)

Archivos modificados: `contabilidad.html`, `impuestos.html`, `implementaciones.html`, `gerencia.html`.

Cambios por módulo:
- **contabilidad.html:** `loadAsignaciones()` reescrita. Lee clientes de `sb.from('clientes')` con filtro `responsabilidad_contabilidad=true`. Construye ASIGNACIONES desde la maestra (mismos clientes para todos los meses). `adm` sigue viniendo de `asignaciones` para tracking de digitación mensual.
- **impuestos.html:** `loadContadoras()` reescrita. Lee de `sb.from('clientes')` con filtro `responsabilidad_impuestos=true`. `getContadorasForMes()` retorna `contadorasMap._maestra` (mismo universo todos los meses).
- **implementaciones.html:** `loadContadoras()` cambió de `asignaciones` a `sb.from('contadoras')` con filtro de activas.
- **gerencia.html (BD Clientes):** Modal actualizado con dos selects de contadora (contab/imp), dos checkboxes de responsabilidad, y dropdown de monto_adm (50/100/200). Tabla muestra Cont. contab, Cont. imp, Adm. `clSaveClient()` graba los campos nuevos.
- **gerencia.html (Control Contadoras):** Sin cambios — sigue leyendo de `asignaciones`. Se refactoreará en Fase 4.
- **kpi.html / checklist.html:** Ahora parte de contabilidad.html, cubiertos por ese refactor.

---

### ~~Sub-fase E — Pantalla de gestión en Gerencia~~ (Cerrada 2026-04-26)

Cambios en `gerencia.html` (sección BD Clientes):
- Tabla ya mostraba las columnas nuevas (Cont. contab, Cont. imp, Adm, N/A para responsabilidad false) desde Sub-fase D.
- **Motivo de cambio de contadora:** al editar un cliente y cambiar cualquier contadora, aparece un campo amarillo pidiendo el motivo. Después del save, el JS actualiza los registros auto-creados por el trigger con el motivo ingresado.
- **Historial de cambios:** botón de reloj en cada fila (solo admin). Abre modal con tabla de cambios: fecha, área (badge Contab/Imp), anterior, nueva, motivo.
- Variables `clOrigContab` y `clOrigImp` guardan valores originales al abrir el modal para detectar cambios.
- Función `clCheckContadoraChanged()` muestra/oculta el campo motivo dinámicamente.

---

## Fase 2 — KPI (rehacer)

**Objetivo:** que cada contadora tenga un documento rellenable mensual donde anote su desempeño, vea su nota sobre 100 al instante, y vea la proyección de bono trimestral mientras llena.

**Alcance:**
- Formulario mensual por contadora con tres bloques de datos: fechas de carga de transacciones, fecha de entrega del resumen de declaración al cliente, fecha de reunión o video grabado.
- Cálculo automático de la nota mensual sobre 100 (fórmula pendiente de Félix).
- Vista trimestral con los tres meses y el promedio.
- Cálculo y proyección de bono según los tramos definidos: 90-100 = 1/3 del sueldo, 80-89 = 1/4, 70-79 = 1/6, menos de 70 = sin bono.
- Acceso restringido: cada contadora solo ve su propio KPI; Félix ve todos.

**Tablas Supabase:**
- `kpi_mensual` (nueva): contadora, año, mes, bloques de datos, nota calculada.
- `sueldos_contadoras` (nueva o ampliación de `profiles`): para que el cálculo de bono use el sueldo real de cada quien.

**Bloqueadores antes de codificar:**
- Fase 1 (consolidación BD) completada — KPI necesita leer de la maestra.
- Fórmula exacta del KPI mensual: qué componentes lo arman y cuánto pesa cada uno.
- ¿Quién puede editar sueldos? (solo Félix, asumo).
- ¿Objetivo de Victoria sigue en 500 provisional o se redefine ahora?

**Pendientes que se resuelven después:**
- Histórico anterior a la implementación (¿se carga, se ignora, se carga manual?).

---

## Fase 3 — Checklist Mensual (submódulo de Contadoras)

**Objetivo:** que la contadora tenga, por cliente y por mes, una lista de todo lo que tiene que presentar, con sí/no, fecha de presentación y semáforo por fecha límite.

**Alcance:**
- Lista universal de items con activación opcional por cliente (algunos clientes no aplican a todo).
- Cada item con su propia fecha límite. Semáforo verde / amarillo / rojo según días faltantes.
- Campo de fecha de presentación que llena la contadora cuando marca el item como hecho.
- Campo opcional de instrucciones embebidas por item.
- Vista por cliente y vista por contadora (filtrable).
- Reemplaza al `checklist.html` legacy.

**Tablas Supabase:**
- `checklist_items_catalogo` (nueva): catálogo universal de items con su fecha límite por defecto y instrucciones.
- `checklist_cliente_items` (nueva o ampliación de `checklist_mensual`): qué items aplican a qué cliente.
- `checklist_mensual` (existe, posible ajuste): registro mensual por cliente/contadora/item con sí-no, fecha presentación, fecha límite efectiva.

**Bloqueadores antes de codificar:**
- Lista base de items universales (Félix tiene que dictarla o pasar la lista que ya use el equipo).
- Definir umbrales del semáforo: ¿cuántos días antes de la fecha pasa de verde a amarillo, y de amarillo a rojo?

**Pendientes:**
- ¿Las instrucciones por item son texto plano, link, o ambos?

---

## Fase 4 — Control de Contadoras (consolidación)

**Objetivo:** dejar el módulo principal de las contadoras coherente, con el reporte mensual ya existente + KPI (Fase 1) + Checklist (Fase 2) integrados.

**Alcance:**
- Mantener el rediseño actual (month pills, contadora filter pills, KPI dashboard).
- Integrar el botón / modal de Checklist Mensual al lado de cada cliente.
- Integrar la vista de KPI mensual de la contadora.
- Asegurar que la vista contadora solo muestra sus propios datos y la vista admin muestra todo.

**Tablas Supabase:**
- Las que ya tiene + las de Fases 2 y 3.

**Bloqueadores:**
- Que las Fases 2 y 3 estén estables.

---

## ~~Fase 5 — Gerencia (reorganización de pills + super reporte)~~ (Cerrada 2026-05-14)

**Objetivo:** unificar los módulos top-level "Clientes" y "Base de Datos" en uno solo, reorganizar las pills en el orden definido con Felix, y mantener "Contadoras" como módulo top-level intacto. Felix usa Gerencia como ojo de águila de la firma; no se llena información aquí, se consume y se gestiona la maestra.

**Decisiones tomadas (2026-05-13):**

Top-level del módulo:
- Se elimina el módulo "Base de Datos" como top-level.
- Quedan dos módulos top-level: el unificado (Clientes + BD juntos) y "Contadoras" (intacto, no se toca — KPI + checklist como hoy).

Pills dentro del módulo unificado (en este orden):
1. **Dashboard** — vista resumen ejecutivo (ya existe en Clientes).
2. **Outsourcing** — análisis + CRUD en el mismo pill. Stats cards por tipo de servicio: Sin asignar arriba, luego Tax One, Contabilidad, Supervisión, Bookkeeping. Después de Bookkeeping se agregan los bloques de "Nuevos" y "Churn" (vienen de la vista actual de BD).
3. **Software** — el actual.
4. **Implementaciones** — un solo pill con dos pills internos para FE y Adm (Adm con esa capitalización: A mayúscula, resto minúscula).
5. **Contadoras** (pill, distinto del top-level) — maestra editable de contadoras (la que hoy vive en BD → Contadores). Crear/editar/inactivar cuando llega o se va una contadora.
6. **Asignaciones** — la actual.
7. **Link Dashboard** — la actual.
8. **Facturación** — la actual.

Pills que se eliminan:
- **Links Portal** — ya vive en Portal de Clientes, se quita de aquí.

Versionado obligatorio:
- Antes de tocar `gerencia.html`, copiarlo a `pages/version-anterior/gerencia-YYYY-MM-DD.html`. Mismo principio para otros archivos modificados a fondo.

**Tablas Supabase:**
- No crea tablas nuevas. Lee y agrega de las que alimentan los otros módulos (maestra `clientes`, `contadoras`, `asignaciones`, `implementaciones_*`, `software_clientes`, `meses_resumen`, `kpi_scores`).

**Bloqueadores:**
- Estructura base (sub-fases A-C de esta fase) no tiene bloqueadores; se puede arrancar en cualquier momento, no depende de Fases 2-4.
- Pills que muestran datos de fases pendientes (Contadoras = Fase 4, Impuestos = Fase 6 ya cerrada) se completan en su orden natural.

**Sub-fases:**

### ~~Sub-fase A — Versionado y limpieza inicial~~ (Cerrada 2026-05-13)
- ~~Copiar `gerencia.html` actual a `pages/version-anterior/gerencia-YYYY-MM-DD.html`.~~
- ~~Eliminar el módulo top-level "Base de Datos" del HTML y su JS asociado.~~
- ~~Eliminar el pill "Links Portal" (toda referencia).~~
- ~~Dejar el módulo top-level único renombrado a "Gerencia" o el nombre que defina Felix.~~
Funciones BD comentadas con `/* PENDIENTE MIGRAR */` para reutilizar en Sub-fase C. Links Portal eliminado completamente.

### ~~Sub-fase B — Estructura de pills nueva~~ (Cerrada 2026-05-13)
- ~~Crear el contenedor de pills con el orden acordado (8 pills).~~
- ~~Cada pill arranca vacío con un placeholder.~~
- ~~Validar navegación entre pills antes de migrar contenido.~~
8 pills: Dashboard, Outsourcing, Software, Implementaciones, Contadoras, Asignaciones, Link Dashboard, Facturación. Los 3 nuevos usan permisos `basedatos` con sub-keys originales (contadoras, asignaciones, links-portal).

### ~~Sub-fase C — Migrar contenido pill por pill~~ (Cerrada 2026-05-13)
Por cada pill, migrar el contenido desde su origen actual (CC o BD):
- ~~**Dashboard:** migrar desde CC → Dashboard. Sin cambios funcionales.~~ (Ya funcionaba)
- ~~**Outsourcing:** agregar CRUD del modal de BD → Outsourcing.~~ (Migrado 2026-05-13, toggle analytics/CRUD). Pendiente: reordenar stats cards (Sin asignar arriba), agregar bloques de Nuevos y Churn después de Bookkeeping.
- ~~**Software:** unificar CC → Software (analítica) con BD → Software (CRUD) en un solo pill.~~ (Migrado 2026-05-13, toggle analytics/CRUD)
- ~~**Implementaciones:** convertir el pill actual de CC en pill con sub-pills internos para FE y Adm.~~ (Sub-pills Resumen/Checklist FE/Checklist Adm, 2026-05-13)
- ~~**Contadoras:** migrar desde BD → Contadores. Maestra editable con CRUD básico.~~ (Migrado 2026-05-13)
- ~~**Asignaciones:** migrar desde BD → Asignaciones. Sin cambios funcionales.~~ (Migrado 2026-05-13)
- ~~**Link Dashboard:** migrar desde BD → Link Dashboard. Sin cambios funcionales.~~ (Migrado 2026-05-13)
- ~~**Facturación:** migrar desde CC → Facturación. Sin cambios funcionales.~~ (Ya funcionaba)

### ~~Sub-fase D — Actualizar catálogo MODULOS en usuarios.html~~ (Cerrada 2026-05-13)
- ~~Reflejar la nueva estructura de pills en el array MODULOS (necesario para que los permisos funcionen — depende de Fase 9 si arranca primero, o se hace aquí si Fase 9 todavía no llegó).~~
- ~~Quitar "Perfiles" si seguía. Agregar los pills nuevos. Eliminar "Links Portal".~~
Labels actualizados: Servicios→Outsourcing, Implementación→Implementaciones, Links portal→Link Dashboard. IDs mantenidos para compatibilidad con permisos existentes.

### ~~Sub-fase E — Validación con Felix~~ (Cerrada 2026-05-14)
- ~~Mostrar el módulo completo con todos los pills.~~
- ~~Felix prueba la navegación, los datos, los modales.~~
- ~~Si algo falta o sobra, se ajusta antes de cerrar la fase.~~
Validación en vivo: 8 pills verificados (Dashboard, Outsourcing analytics+CRUD, Software analytics+CRUD, Implementaciones con sub-pills FE/Adm, Contadoras, Asignaciones, Link Dashboard con URL del dashboard TV, Facturación). Pill Link Dashboard corregido: mostraba tokens de clientes, ahora muestra URL del dashboard público para TV.

**Prompts de ejecución:** ver `docs/prompts/fase-5-gerencia/` (uno por sub-fase).

---

## ~~Fase 6 — Impuestos~~ (Cerrada 2026-04-26)

Módulo `impuestos.html` funcional. Detalle completo en `memory-portal.md` (entradas del 2026-04-25 y 2026-04-26).

**Lo que se construyó:**
- Dos tabs: Control de Impuestos (tabla matriz cliente x impuesto con semáforo) + Checklist (detalle por cliente con items por impuesto).
- Month pills + contadora pills + filter cards (Pendientes, Por vencer, En atraso, En progreso).
- Vista detalle por cliente con secciones colapsables, importe por impuesto, semáforo por fecha.
- Lee de tabla `clientes` (maestra) con `responsabilidad_impuestos=true`.
- Tabla: `impuestos_checklist` con JSONB. Grupo "Impuestos" en permisos para Karina y Lovelis.

**Pendientes menores:**
- Columnas 606 y 607 no están separadas todavía (agrupadas con ITBIS).

---

## ~~Fase 7 — Implementaciones~~ (Cerrada 2026-04-26)

Módulo `implementaciones.html` funcional. Detalle completo en `memory-portal.md` (entrada del 2026-04-26).

**Lo que se construyó:**
- Dos tabs: Implementación Completa (6 fases de Kick-off a Go Live) + Facturación Electrónica (5 pasos con semáforo por fecha go live).
- Dropdown de estatus editable con UPDATE inmediato a Supabase.
- Modales para agregar clientes en cada tab.
- Month pills en tab FE para filtrar por `fecha_go_live_estimada`.
- Tablas: `implementaciones_completas`, `implementaciones_fe`. Grupo "Implementaciones" para Claudia.

**Pendientes menores:**
- Columna de notas internas (campo existe en BD, no visible en UI).
- Editar todos los campos inline (actualmente solo estatus es editable).

---

## ~~Fase 8 — Portal de Clientes (fase 1)~~ (Cerrada 2026-04-27)

Módulo `portal-clientes.html` funcional. Detalle completo en `memory-portal.md` (entrada del 2026-04-27).

**Lo que se construyó:**
- 6 tabs: Dashboard, TSS, IR-3, IR-17, Anticipo, ITBIS.
- Checklist por impuesto con tipos: yesno, upload (Supabase Storage), monto, auto (hereda de otro tab).
- Dashboard con summary cards por impuesto, semáforo (verde/amarillo/rojo/gris), progreso.
- IR-3 hereda estado de nómina/volantes desde TSS automáticamente.
- ITBIS con sub-item condicional (pago a cuenta solo si facturas_atrasadas = sí).
- Dual mode: cliente via `?token=UUID` (sin login) / admin con login + selector de cliente.
- Login propio para admin (email/password, mismo patrón que otros módulos).
- Archivos en bucket `portal-clientes` de Supabase Storage.
- Links Portal en gerencia.html → Base de Datos (tabla con copy buttons).
- Tablas: `portal_clientes_tokens`, `portal_clientes_data`, `portal_clientes_archivos`.

**Fase 2 del portal (pendiente):**
- Calculadora IR-17 dentro del tab IR-17.
- RLS policies para acceso anónimo por token (actualmente solo admin).
- Notificaciones al cliente cuando se acerca un deadline.
- Validación de que el link no haya expirado (campo `activo` ya existe)

---

## Fase 9 — Migración a permisos por grupo (hasPermiso)

**Objetivo:** que toda la UI del portal (sidebar + módulos) use el sistema de grupos/permisos que ya existe en Supabase, en vez del string `profiles.rol`. Hoy hay dos sistemas que no se hablan: `profiles.rol` controla todo en la práctica, y el JSONB de `grupos.permisos` es código muerto. Después de esta fase, `profiles.rol` solo se usa para RLS en Supabase (seguridad de datos), y `hasPermiso()` controla toda la UI (qué ves y qué puedes hacer).

**Decisiones tomadas (2026-05-13):**
- Arquitectura: cada módulo consulta `grupos` + `usuario_grupos` directamente (no postMessage).
- Granularidad: visibilidad de tabs/secciones + botones de acción (editar, agregar, eliminar). No las 5 habilidades completas del JSONB.
- Sidebar: se migra también (si no tienes permisos en un módulo, no aparece).
- `profiles.rol` se mantiene solo para RLS de Supabase (`get_my_role()`). La UI no lo consulta.
- Catálogo de pantallas (MODULOS en usuarios.html): hardcodeado, se actualiza manualmente.
- HABILIDADES simplificadas: `consulta` (ver tabs/secciones) + `edicion` (agregar, editar, eliminar). Las 5 originales (consulta, adicion, edicion, anulacion, eliminar) se reducen a 2 porque con 10 empleados no necesitas granularidad fina.

**Estado actual del sistema de grupos:**
- Tabla `grupos`: id, nombre, permisos (JSONB). Existe y tiene datos.
- Tabla `usuario_grupos`: user_id, grupo_id. Existe y tiene asignaciones.
- `loadUserPermisos()` en index.html: carga permisos, merge aditivo. Funciona.
- `hasPermiso(modId, scrId, subtabId, habId)` en index.html: retorna true/false. Funciona pero nunca se llama.
- MODULOS en usuarios.html: desactualizado (faltan Personal, Facturación en Gerencia, Checklist/Movimiento en Comercial; sobra "Perfiles" en Gerencia; Implementaciones tiene la estructura vieja).

**Qué módulos existen hoy vs lo que dice MODULOS:**

| Módulo real | Tabs/secciones reales | Lo que dice MODULOS |
|---|---|---|
| gerencia.html | Clientes, Contadoras, BD, Facturación | Clientes (con subtab Perfiles que ya no existe), Contadoras, BD |
| ventas.html | ROAS, Pipeline, Movimiento, Checklist | ROAS, Pipeline |
| contabilidad.html | Checklist, KPI | Checklist, KPI ✓ |
| impuestos.html | Checklist, KPI | Control, Checklist (nombres incorrectos) |
| implementaciones.html | Checklist FE, Checklist Adm | Impl completa, FE (estructura vieja) |
| portal-admin.html | Checklist, Presentación | Checklist, Presentación ✓ |
| portal-clientes.html | Checklist, Presentación | Checklist, Presentación ✓ |
| personal.html | Wow Board, Historial, Dar Puntos, Pagar Bono | NO EXISTE en MODULOS |
| usuarios.html | Grupos, Usuarios | Grupos, Usuarios ✓ |
| dashboard-publico.html | (vista TV, sin login) | NO en MODULOS (correcto, no necesita permisos) |

---

### Sub-fase A — Actualizar catálogo MODULOS en usuarios.html

**Objetivo:** que el array MODULOS refleje exactamente los módulos y tabs que existen hoy. Sin esto, los permisos no se pueden asignar correctamente.

**Cambios:**
- Gerencia: quitar subtab "Perfiles", agregar screen "Facturación".
- Comercial: agregar screens "Movimiento" y "Checklist".
- Impuestos: renombrar "Control" → "Checklist", "Checklist" → "KPI" (para que matcheen los tabs reales).
- Implementaciones: cambiar a "Checklist FE" y "Checklist Adm".
- Agregar módulo "Personal" con screens: "Wow Board", "Dar Puntos", "Pagar Bono".
- Simplificar HABILIDADES: de 5 (consulta, adicion, edicion, anulacion, eliminar) a 2 (consulta, edicion).

**Punto de validación:** mostrar la UI de usuarios.html con el catálogo actualizado para que Felix confirme que los nombres y la estructura son correctos.

**Criterio de cierre:** la UI de grupos en usuarios.html muestra todos los módulos y tabs actuales con los dos toggles (consulta/edición) por cada uno.

---

### Sub-fase B — Función compartida de carga de permisos

**Objetivo:** que cada módulo pueda cargar sus propios permisos sin depender de index.html.

**Cambios:**
- Crear una función `loadMisPermisos()` reutilizable que cada módulo copie (o que viva en un snippet compartido al inicio del script).
- La función: obtiene el user.id de la sesión Supabase → consulta `usuario_grupos` → consulta `grupos` → merge aditivo → retorna el objeto de permisos.
- Crear helper `tengoPermiso(modId, scrId, habId)` que cada módulo usa para decidir qué mostrar y qué habilitar. Admin siempre retorna true.
- Cada módulo llama a `loadMisPermisos()` después del login, igual que hoy llama a `profiles.select('rol')`.

**Decisión sobre profiles.rol:** los módulos siguen cargando `profiles.rol` para pasarlo a Supabase queries que lo necesiten (ej: `get_my_role()` en RLS). Pero las decisiones de UI (qué tabs mostrar, qué botones habilitar) usan `tengoPermiso()`.

**Criterio de cierre:** la función está definida y probada en un módulo piloto (sugerido: contabilidad.html por ser simple y tener ambos tabs Checklist/KPI).

---

### Sub-fase C — Migrar sidebar de index.html

**Objetivo:** que el sidebar use permisos de grupo en vez del array `roles:` hardcodeado.

**Cambios:**
- index.html ya tiene `loadUserPermisos()` y `hasPermiso()`. Se reutilizan.
- Cambiar la lógica de filtrado del MENU: en vez de `section.roles.includes(userRole)`, verificar `hasPermiso(section.id, null, 'consulta')` — si el usuario tiene al menos un permiso de consulta en cualquier pantalla del módulo, el módulo aparece.
- Mantener el array MENU como está (para iconos, labels, hrefs) pero eliminar el campo `roles:`.
- Admin sigue viendo todo (hasPermiso retorna true para admin).

**Riesgo:** si un usuario no tiene grupo asignado, no ve nada en el sidebar. Mitigación: en la Sub-fase E, verificar que todos los usuarios tengan al menos un grupo antes de hacer el switch.

**Criterio de cierre:** el sidebar se renderiza correctamente para admin, comercial y contadoras según sus grupos asignados.

---

### Sub-fase D — Migrar módulos uno por uno

**Objetivo:** reemplazar todos los `if (userRole === 'admin')` y `if (userRole === 'comercial')` por llamadas a `tengoPermiso()`.

**Orden sugerido (de menos a más complejo):**

1. **contabilidad.html** — piloto. Dos tabs (Checklist, KPI). Contadoras ven sus clientes, admin ve todo. Pocas decisiones de UI basadas en rol.
2. **impuestos.html** — similar a contabilidad. Dos tabs.
3. **personal.html** — simple, todos ven el tablero, admin ve "Dar Puntos" y "Pagar Bono".
4. **implementaciones.html** — dos tabs (FE, Adm). Ya consulta grupos para edición.
5. **ventas.html** — más tabs (ROAS, Pipeline, Movimiento, Checklist). Comercial tiene acceso diferenciado.
6. **gerencia.html** — el más complejo. Múltiples secciones con visibilidad diferenciada por rol.
7. **portal-admin.html** — admin + contadoras.
8. **portal-clientes.html** — admin + contadoras + comercial.

**Por cada módulo, el cambio es:**
- Agregar `loadMisPermisos()` y `tengoPermiso()` (copiar de Sub-fase B).
- Reemplazar `if (userRole === 'admin')` → `if (tengoPermiso('modulo', 'pantalla', 'edicion'))`.
- Reemplazar visibilidad de tabs → `if (tengoPermiso('modulo', 'tab', 'consulta'))`.
- Probar con al menos dos roles distintos.

**Criterio de cierre:** todos los módulos usan `tengoPermiso()` y ninguno consulta `userRole` para decisiones de UI (puede seguir existiendo para RLS o para queries que lo necesiten).

---

### Sub-fase E — Verificación y limpieza

**Objetivo:** asegurar que todo funciona y limpiar código muerto.

**Tareas:**
- Verificar que todos los usuarios en `profiles` tengan al menos un grupo en `usuario_grupos`. Si alguno no tiene, asignarlo.
- Actualizar los grupos existentes en Supabase con los permisos correctos para el catálogo nuevo (MODULOS actualizado).
- Probar flujo completo por rol: login → sidebar correcto → cada módulo muestra los tabs correctos → los botones de acción aparecen/desaparecen según permisos.
- Eliminar campo `roles:` del MENU en index.html (ya no se usa).
- Eliminar ROLE_PICKER_DATA de index.html si ya no se usa.
- Documentar en memory-portal.md.

**Criterio de cierre:** Felix prueba con su cuenta (admin) y con una cuenta de contadora, confirma que todo se ve correcto.

---

> **Nota de orden (2026-05-13):** La Fase 9 se ejecuta antes de las Fases 2-5 porque afecta la infraestructura de todos los módulos. Si arrancamos KPI (Fase 2) primero, habría que migrarlo dos veces: una con roles y otra con permisos.

---

## Fase 10 — Refactor gerencia.html (partir en módulos JS separados)

**Objetivo:** reducir gerencia.html de 6000+ líneas en un solo archivo a una arquitectura modular donde cada pill/feature tiene su propio archivo JS. Eliminar el código duplicado (hoy hay dos copias casi idénticas de las funciones BD/CC/SW, la segunda sobreescribe la primera en runtime).

**Problema que resuelve:** gerencia.html es el archivo más largo y frágil del portal. Cualquier cambio requiere encontrar y actualizar dos copias de la misma función. Las variables `const` declaradas en ambas copias causan errores silenciosos que matan el script sin mensaje en consola. El archivo es imposible de mantener a esta escala.

**Enfoque:**
- Trabajar en un **branch separado** de Git para no romper producción.
- Partir el JS en archivos por pill/funcionalidad: `gerencia-clientes.js`, `gerencia-contadoras.js`, `gerencia-bd.js`, `gerencia-impl.js`, `gerencia-facturacion.js`, etc.
- gerencia.html queda como shell: HTML + CSS + `<script src="...">` para cada módulo JS.
- Eliminar las funciones duplicadas. Cada función existe una sola vez.
- Unificar las variables compartidas (`bdClientes`, `ccSOFTWARE_CLIENTES`, etc.) en un archivo `gerencia-shared.js` o al inicio del HTML.
- Verificar que el flujo completo funciona: login → carga de datos → render de cada pill → búsqueda → modales CRUD → guardado.

**Dependencias:** ninguna. Se puede hacer en cualquier momento. Se recomienda hacerlo después de que las demás fases estén cerradas para no estar tocando un archivo en refactor mientras se agregan features.

**Criterio de cierre:** gerencia.html tiene menos de 500 líneas (solo HTML/CSS y los `<script src>`). Cada archivo JS tiene una sola responsabilidad. No hay funciones duplicadas. El portal funciona igual que antes del refactor.

---

## Fase 11 — Auditoría y mejoras con Claude Code

**Objetivo:** corregir todos los bugs encontrados en la auditoría del 2026-06-05 sobre la versión de Claude Design, alinear el diseño visual entre los 14 módulos, y mejorar la UX general del portal.

**Contexto:** Felix rediseñó visualmente el portal con Claude Design. El resultado está en `Portal Contadores Claude Design/`. Se hizo una auditoría de código con Claude Code que encontró ~120 hallazgos. Esta fase los corrige.

**Git:** Se inicializó repositorio en `Portal Account One/`. Commit v1.0 con el estado base (hash 0a7dc82). Cada grupo de correcciones = un commit.

**Sub-fase A — Bugs críticos:**
- [ ] Año 2026 hardcodeado → hacerlo dinámico con `new Date().getFullYear()` en todos los archivos
- [ ] Chart.js memory leak → destruir instancia anterior antes de crear nueva (contabilidad.html, impuestos.html)
- [ ] Flag `saving` sin limpiar en error → wrap en try/finally (portal-clientes.html)
- [ ] `getCurrentMonth()` roto en enero → manejar diciembre del año anterior
- [ ] XSS en `esc()` inconsistente → unificar función de escape HTML en todos los archivos
- [ ] Nombres con comillas rompen onclick → usar data attributes o event delegation
- [ ] Progreso de archivos siempre 0 → contar uploads como completados (portal-admin.html)
- [ ] Variables no declaradas en gerencia.html → declarar o verificar scope
- [ ] Meses activos hardcodeados → calcular dinámicamente (gerencia.html)
- [ ] Colspan incorrecto en ventas.html → corregir según número real de columnas

**Sub-fase B — Consistencia de diseño:**
- [ ] Unificar `--navy` y `--blue` a los valores canónicos (#1a2332 y #4361ee) en todos los archivos
- [ ] Unificar estilo de login (borde, botón, labels) — personal.html es el outlier
- [ ] Unificar estilo de tabs activos (border-bottom vs fondo navy)
- [ ] Corregir tildes en UI ("Contrasena" → "Contraseña", "Miercoles" → "Miércoles", etc.)
- [ ] Unificar z-index de modales entre archivos
- [ ] Eliminar imports de assets/theme.css y assets/theme.js inexistentes

**Sub-fase C — UX y feedback:**
- [ ] Reemplazar `alert()`/`confirm()`/`prompt()` nativos por modales inline
- [ ] Agregar spinner/loading state en botones de login
- [ ] Agregar `beforeunload` warning cuando hay cambios sin guardar
- [ ] Manejo de sesión expirada (detectar y mostrar login)
- [ ] Pantalla de error si Supabase falla (en vez de "Cargando..." infinito)
- [ ] Mejorar responsive en grids que no tienen breakpoints intermedios

---

## Pendientes transversales

Cosas que no son de un módulo en particular pero hay que resolver en algún punto:

- **RLS de leads / roas_mensual:** todavía permisivas (anon). Pendiente restringir cuando ya no estorben al desarrollo.
- **Sueldos por contadora:** decidir dónde se guardan (tabla nueva vs ampliar `profiles`) — afecta Fase 2.
- **Objetivo de Victoria en KPI:** sigue en 500 provisional.
- **Storage del Portal de Clientes:** Supabase Storage vs OneDrive — decisión al llegar a Fase 8.

---

## Cómo se actualiza este plan

- Al cerrar una fase, marcar estado "Cerrado" y agregar fecha.
- Si una fase descubre un nuevo bloqueador, agregarlo en su sección.
- Si cambia el orden de fases, dejar nota arriba con la razón.
- Las descripciones funcionales detalladas siguen viviendo en `memory-portal.md`; este archivo es para planeación y avance.

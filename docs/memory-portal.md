# Memory: Portal Account One

Memoria específica del proyecto. Detalles técnicos, decisiones, problemas resueltos, estado de cada módulo.


---

## Estado actual por módulo

| Módulo | Estado | Último cambio |
|---|---|---|
| index.html (inicio + sidebar) | Funcional | 2026-05-13: Sidebar filtrado por tengoPermiso (Fase 9). |
| ventas.html (Comercial) | Funcional | 2026-06-06: Mes dinámico (ya no hardcodeado en abril). |
| **contabilidad.html** (Contabilidad) | **Funcional** — Checklist + KPI | 2026-05-26: KPI bono invertido (100→abajo), log de deducciones, fechas semanas, confirmación semanal, template correo. |
| ~~contadores-tab.html~~ | Renombrado a contabilidad.html | 2026-04-26 |
| **gerencia.html** (Clientes) | **Funcional** — CC con 8 pills + Cobros + Personal | 2026-06-06: Asignaciones rediseñado (cards por carga, sin semáforos, copiar mes anterior). |
| ~~checklist.html~~ | Reemplazado por contabilidad.html | 2026-04-25 |
| ~~kpi.html~~ | Reemplazado por contabilidad.html | 2026-04-25 |
| ~~contadores.html~~ | Reemplazado por gerencia.html | 2026-04-25 |
| ~~control-contadoras.html~~ | Reemplazado por gerencia.html | 2026-04-25 |
| usuarios.html | Funcional | 2026-05-28: Módulo Cobros agregado al catálogo MODULOS. |
| **impuestos.html** (Impuestos) | **Funcional** — Resumen + Checklist + KPI | 2026-05-26: Tab Resumen con urgencia, charts, insights admin, pills analistas. |
| **implementaciones.html** (Implementaciones) | **Funcional** — Resumen + Checklist FE + Checklist Adm | 2026-05-28: Resumen rediseñado (barras HTML, sin Chart.js), gráficos side-by-side (tipo + fase), fix barra progreso. |
| **portal-clientes.html** (Portal de Clientes) | **Funcional** — Dual: cliente (RNC) + admin (login) | 2026-05-28: Calendario ITBIS actualizado (día 14/19, último recordatorio dinámico). |
| **portal-admin.html** (Portal Clientes - Admin) | **Funcional** — Tabs Checklist/Presentación con carga Excel | 2026-05-28: Calendario ITBIS (día 14 borrador a Impuestos, día 19 devuelto, último recordatorio dinámico con CALENDARIO_DGII_2026). |
| **dashboard-publico.html** (Dashboard TV) | **Funcional** — Vista optimizada para TV | 2026-05-28: Fix clientes sin fecha_entrada (preexistentes). |
| **personal.html** (Personal) | **Funcional** — Organigrama + Directorio + Wow Points + Retroalimentación | 2026-06-06: Pestaña Retroalimentación con CRUD (quejas, errores, feedback). |

---

## Entradas

## 👉 RETOMAR AQUÍ — cierre 2026-06-07 (domingo). Mañana: REVIEW de arquitectura

**MERGEADO A v2/main (producción staging) HOY:** PR-1 a PR-4 (identidad: mapeo GUID, asignaciones.equipo_id, limpieza personas, adm_cloud_id en clientes) · Botón "Leer caso" + editor Quill en Retroalimentación (#24) · Wow Points "Listos para pago" + fecha automática + historial editable (#25) · Limpieza header (sin Exportar/Filtros, campana=changelog, subtítulo Clientes estático) (#26) · **Consolidación: 3 tarjetas KPI en Contabilidad (#29) + borrado de la pestaña Personal duplicada en gerencia, −600 líneas (#30).**

**PLAN DE MAÑANA (acordado): un PROYECTO NUEVO de REVIEW de arquitectura ANTES de los cambios grandes.** Usar `improve-codebase-architecture` (probado hoy, funciona muy bien). El issue #18 (audit) es básicamente eso. Recién después del review, decidir cómo hacer los cambios grandes.

**Lo que queda del plan (va al review):**
- **#11 — Renovar asignaciones:** dropdown "Asignar a" lea de `equipo` por ID (hoy lee de la tabla vieja `contadoras`). Eso arregla los nombres malos (Morelia/Milka sin apellido, "plena", capacidades vacías) que Félix ve en **Datos > Contadores** (subtab del BD, mismo nido) y permite **retirar la tabla `contadoras` vieja**. gerencia.html tiene lógica DUPLICADA aquí. (Nota: hoy quedó visible que Datos tiene "Equipo" buena + "Contadores" vieja = duplicación de personas a limpiar.)
- **PR-5/#14 — Auth:** profiles→equipo + normalizar roles en 34 archivos RLS. Riesgo ALTO (login). Su propio PR.
- **PR-6/#15 — Cobros por GUID:** OJO, descubrimos que el GUID de clientes (empresa Adm Cloud del cliente) NO es el id que usa cobros (cliente AR dentro de Account One). El puente real hoy es el **RNC**; Adm Cloud Xchange (`AdmCloudID`) sería el ideal pero casi nadie está enlazado (1 de 50). Decisión de diseño para el review.
- **Backlog:** #17 KPI design-an-interface, #19 ITBIS con Karina (lunes, humano).

**SETUP STAGING→PRODUCCIÓN (importante):** v2 = donde trabajamos (Claude Code). Producción = repo aparte `portal-accountone` (Vercel `portal-accountone.vercel.app`), Claude SIN acceso (404). Félix copia la carpeta manual cuando todo está probado. **Misma base Supabase** para ambos (SQL ya aplicados sirven a los dos; producción NO re-ejecuta SQL). Verificado: producción está en versión vieja (sin retroalimentación/Quill), estructura calza (sirve desde pages/). Reglas de repo + nomenclatura de issues: ver memory-general.md.

**Orden exacto para retomar (lo que falta del plan):**
1. **PR-4** (#13): backfill `adm_cloud_id` en `clientes`. El mapeo YA está en `docs/mapeo-guid-clientes.md` (36 clientes con GUID, 2 sin Adm: Centro Adorartes, Mab). Es lo más rápido → **empezar por aquí.**
2. **Renovar módulo asignaciones** (#11): que el dropdown "Asignar a" lea de `equipo` por `equipo_id` (hoy lee de `contadoras`). Arregla la mezcla nombre/nombre+apellido que vio Félix y permite eliminar la tabla `contadoras`. Ojo: gerencia.html tiene lógica DUPLICADA aquí (dos bdLoadContadoras, dos bdAsigSaveAll) — es "renovar cuarto por cuarto".
3. **PR-5** (#14): auth `profiles→equipo` + normalizar vocabulario de roles en 34 archivos RLS. Riesgo ALTO (si rompe login nadie entra), su propio PR, verificar login antes de mergear.
4. **PR-6** (#15): cobros por GUID (stretch).
5. **Backlog:** #16 leer-caso, #17 KPI design-an-interface, #18 audit general, #19 ITBIS con Karina (lunes, humano).

**Flujo por PR:** rama → push → preview Vercel → Félix prueba → merge con su OK (Claude NO mergea a main sin OK explícito). Repo: `portal-accountone-v2`. Supabase URL `https://ouetusstqvpyjeycfdio.supabase.co` (anon key en pages/; tabla `clientes` y `asignaciones` legibles con anon; `equipo`/`contadoras`/`profiles` NO — RLS).
**Reglas activas:** preguntar antes de decisiones de arquitectura; confirmar antes de borrar archivos/git que haga desaparecer archivos.

---

## Sesión 2026-06-07 — Arquitectura de referencia (basada en Adm Cloud)

Félix planteó repensar el portal siguiendo la arquitectura de Adm Cloud (sin código fuente). Estudiamos la Knowledge Base (https://knowledge.admcloud.net/, 32 artículos vía 2 agentes de investigación) y **confirmamos la arquitectura tocando la API real** de Adm Cloud (MCP connector, cuenta de Félix, 87 empresas).

**Hallazgos confirmados en vivo:**
- **Multi-tenant por base de datos:** cada empresa tiene su propio `ServerName` + `DatabaseName`. Aislamiento físico, no filtro.
- **Modularidad por banderas:** `Module_Core_Enabled`, `Module_CRM_Enabled`, etc. Account One corre en Enterprise.
- **Entidad unificada "Relación":** la tabla Customers tiene 173 campos con casillas `IsCustomer`/`IsVendor`/`IsEmployee`/`IsSalesRep`. Una sola entidad, muchos roles.
- **Todo identificado por GUID estable**, nunca por nombre. Catálogo de cuentas con `ParentAccountID` (jerarquía), clasificación que dicta comportamiento (`IsCashAccount`, `RequireLocation`).
- **Transacciones = documentos que se anulan (`Void`), no se borran**, y se firman (`Signed`). Rastro de auditoría.
- **Sí hay API REST real** (134 recursos).

**Entregable:** `docs/arquitectura-referencia.md` — 7 principios de diseño + modelo de datos objetivo + diagnóstico de dónde el portal se aleja + checklist de decisión. Es el documento contra el cual medir cada cambio futuro del portal.

**El insight de mayor impacto:** cada cliente de Account One **ya es una empresa con GUID permanente en Adm Cloud**. Adoptar ese GUID como `cliente_id` del portal acaba con todos los problemas de emparejar nombres (Srl, Karina/Karina Sanchez, Morelia/Morelia Matos, duplicado de Tricargo) — esos son síntomas de identificar clientes por nombre. La cura es el ID.

**Principales desviaciones a enderezar (por prioridad):**
1. Clientes identificados por nombre y regados en varias tablas (`clientes`, `impuestos_checklist`, `reporte_mensual`, `cobros_facturas`). Arreglo de mayor impacto.
2. Datos de comportamiento (colores, capacidad, objetivos, precios) hardcodeados en HTML → mover a tablas (ya empezado con `equipo`/`precios`).
3. Sin ID estable compartido con Adm Cloud → adoptar el GUID de empresa.

**Lo que ya está alineado:** grupos de permisos JSONB, RLS en todas las tablas, tabla `equipo` unificada, inactivar en vez de borrar.

**Entregable 2 (mismo día):** `docs/arquitectura-general-objetivo.md` — el plano del portal entero visto limpio, en 5 capas (Acceso → Identidad/Maestras → Configuración → Transacciones → Vistas). Félix pidió "armar lo general primero" antes de ir módulo por módulo, porque construyó el portal sin arquitectura limpia.

**Diagnóstico central del plano:** el problema es uno solo, la identidad fragmentada:
- **Personas en 3 tablas:** `profiles`, `contadoras`, `equipo`. Deben fundirse en una sola `equipo` con roles (como `IsCustomer`/`IsVendor` de Adm Cloud). `profiles` queda solo para enlazar `auth.uid → equipo_id`.
- **Clientes referenciados por nombre en ~12 tablas.** Una sola maestra `clientes` con `id` = GUID de Adm Cloud; todas las transacciones la referencian por `cliente_id`.

**Las 3 decisiones de fondo:** (1) una tabla de personas, (2) `cliente_id` = GUID de Adm Cloud, (3) un `periodo` estándar (año+mes) en vez del mes en texto.

**Camino de migración por fases (no rompe nada, reversible):** A) unificar personas → B) traer GUID de Adm Cloud a `clientes` (mapear 40 clientes vs 87 empresas, semi-manual, una vez) → C) migrar transacciones a `cliente_id` una tabla a la vez → D) sacar columnas dobladas de `clientes` a `asignaciones` → E) mover comportamiento del código (colores, capacidad, objetivos, calendario, precios) a tablas de config.

**Se conserva tal cual:** grupos de permisos JSONB, RLS, inactivar-en-vez-de-borrar, el stack (HTML vanilla + Supabase + Vercel). El rediseño es de DATOS, no de tecnología.

**GitHub montado:** Project #2 "Portal Account One — Arquitectura" + milestone "Arquitectura — Identidad (Sesión 2026-06-07)" + 11 issues. Epic = issue #20. PRs sesión: #10-#15. Backlog: #16 (leer-caso), #17 (KPI design), #18 (audit general), #19 (ITBIS Karina lunes). Repo: `portal-accountone-v2`.

**✅ PR-1 COMPLETADO (PR #21, cierra #10) — Mapeo GUID clientes ↔ Adm Cloud:**
- 38 clientes del portal cruzados contra 87 empresas de Adm Cloud (API). 36 con `adm_cloud_id`, 2 sin Adm Cloud: **Centro Adorartes** (se devolvió en implementación) y **Mab Arquitectura** (único cliente con QuickBooks).
- Mapeo completo en `docs/mapeo-guid-clientes.md`.
- **APRENDIZAJE CLAVE (corrige el plano):** la identidad canónica del cliente es el **UUID propio de `clientes.id`** (existe para los 38), NO el GUID de Adm Cloud. El GUID va como columna **`adm_cloud_id` opcional/nullable** (puente de sync). Razón: 2 clientes no están en Adm Cloud. Docs de arquitectura ya ajustados.
- Acceso a Supabase del portal: URL `https://ouetusstqvpyjeycfdio.supabase.co`, anon key embebida en pages/, tabla `clientes` legible con anon (id, nombre, rnc, activo).

**PRÁCTICA FIJA (pedida por Félix 2026-06-07):** cada PR se prueba antes de mergear. Claude verifica lo técnico (integridad de datos, que no se rompa nada); Félix hace un par de pruebas a mano en la pantalla. No avanzar al siguiente PR sin QA.

**🔄 PR-2 EN PROGRESO (rama `fase-a/equipo-maestra-unica`, issue #11) — asignaciones por ID:**
Decisiones de Félix: equipo = base única; roles unificados (PERO el relink de auth se separó a su propio PR, ver #14 ampliado); contadoras se deprecia y se elimina al final; y **decidió la cura profunda**: migrar `asignaciones` a referenciar `equipo.id` en vez del nombre (no solo limpiar nombres).
- Causa raíz de las dos Morelias: el dropdown une `equipo` (nombre corto) + `asignaciones` (texto libre, nombre largo). Mismo problema con Beliani ("Beliani" 8 filas + "Beliani Brito" 8 filas).
- **Paso 1 ✅ HECHO + QA PASÓ:** `db/asignaciones-equipo-id.sql` (Félix lo corrió en Supabase). Agregó `equipo_id` nullable a `asignaciones`, backfill explícito por nombre. QA confirmó: 153 filas enlazadas (8 "Sin asignar" en null), y "Beliani"+"Beliani Brito" apuntan al MISMO id ✓.
- **Paso 2 (pendiente, Claude):** frontend de `gerencia.html` — dropdown lee de `equipo`, asignaciones leen/escriben por `equipo_id`. Solo `gerencia.html` lee la tabla `contadoras`. Ojo: hay lógica de contadoras DUPLICADA en gerencia.html (dos `bdContadoras`, dos `bdLoadContadoras` en líneas ~5275 y ~6861; la 2da gana). QA visible tras Paso 2: abrir Asignaciones → una sola Morelia, asignaciones de Beliani juntas, poder guardar.
- **Paso 3 (final):** eliminar columna `contadora` (nombre) de asignaciones, ya con confianza.

**Detalle hallazgo auth (para el PR #14):** `get_my_role()` se usa en 34 archivos RLS; roles escritos inconsistentes (contadora/contadores, comercial/ventas, analista/impuestos, implementadora/implementaciones); `profiles.rol` solo permite 5 valores → varias políticas muertas; los permisos reales corren por `grupos` (80 `tengoPermiso` en frontend).

**CIERRE SESIÓN 2026-06-07 — qué quedó mergeado a producción (PR #22 squash a main):**
- ✅ **PR-1** (mapeo GUID + 3 docs de arquitectura) — en main. Issue #10 cerrado, PR #21 cerrado (superseado por #22). Los docs de arquitectura ahora viven en main permanentemente.
- ✅ **PR-2 capa de datos** — `asignaciones.equipo_id` backfilled + QA. Fix Morelia duplicada del dropdown a nivel DATOS (`UPDATE contadoras SET activa=false WHERE nombre='Morelia'`, Félix lo corrió). El dropdown ya muestra una sola "Morelia Matos" (QA visual de Félix ✓).
- ✅ **PR-3 limpieza personas** (gerencia.html Datos>Equipo) — sueldo OCULTO (dato conservado para el bono), botón Inactivar (soft) + Eliminar (✕ admin), orden: **todos los fijos → todos los freelance → inactivos al final** (Félix pidió freelance todos abajo, no por departamento). Duplicados sin apellido (Esmeralda, Michel) los borró Félix probando el botón ✕.

**Decisiones/aprendizajes de la sesión:**
- Félix consideró empezar el portal de cero; conversamos y concluimos: NO reescribir, sino "renovar cuarto por cuarto" (lo que ya hacemos). Si un módulo sigue dando bugs, ese se rehace limpio.
- 2 reglas nuevas (en memory-general): preguntar antes de decisiones de arquitectura; confirmar antes de borrar archivos/operaciones git que hagan desaparecer archivos.
- Práctica fija: QA por PR (Claude verifica datos + Félix prueba en preview de Vercel antes de mergear).

**PENDIENTE (issue #11 sigue abierto + próximas sesiones):**
- **Renovación del módulo de asignaciones (gerencia.html):** que el dropdown "Asignar a" lea de `equipo` por `equipo_id` (no de `contadoras`). Eso normaliza los nombres (hoy mezcla "Milka" vs "Beliani Brito" porque `contadoras` está inconsistente) y permite eliminar la tabla `contadoras`. gerencia.html tiene lógica DUPLICADA aquí (candidato a renovar cuarto por cuarto).
- **PR-4** (#13): backfill `adm_cloud_id` en `clientes` (el mapeo ya está hecho en docs/mapeo-guid-clientes.md).
- **PR-5** (#14): auth profiles→equipo + normalizar 34 archivos RLS con roles inconsistentes. Su propio PR, riesgo alto.
- **PR-6** (#15): cobros por GUID (stretch).
- **Backlog** (#16 leer-caso, #17 KPI design-an-interface, #18 audit general, #19 ITBIS Karina lunes).

## Sesión 2026-06-06 (tarde) — Fases 3, 4 y 5

### Branch: `feat/dashboard-carga-contadoras` / PR #6

**Fase 3 — Asignaciones (gerencia.html):**
- Función `bdRenderAsignaciones()` reescrita. Ya no es async (no carga checklist data).
- Cards por contadora con barra de capacidad y tabla de clientes interna.
- Ordenamiento por utilización descendente (la más cargada primero).
- Semáforos (dots rojo/ámbar/verde) eliminados — confundían a Felix.
- Botón "Copiar del mes anterior" (`bdAsigCopyPrevMonth()`) funcional.
- CSS limpiado: eliminadas clases `.asig-light`, `.asig-card-badge`, `.asig-card-footer`.
- Feedback de Felix: los `monto_adm` de clientes en tabla `clientes` están vacíos para muchos. Se editan en Outsourcing > modal del cliente > "Transacciones Adm".

**Fase 4 — Retroalimentación (personal.html):**
- Nueva pestaña "Retroalimentación" junto a Organigrama, Directorio, Wow Board, Historial.
- Tabla `retroalimentacion` ya existía en Supabase (schema: empleado, tipo, cliente_nombre, descripcion, accion_tomada, severidad, estado, fecha_incidente).
- UI: stats cards, filtros (empleado/tipo/severidad/estado), tabla con badges, modal crear/editar.
- Solo admin puede crear y editar casos.
- Datos se cargan en paralelo con wow_points en `startApp()`.

**Fase 5 — Bug fixes:**
- Chart.js memory leak: `_resChartCliente` y `_impResChartCliente` guardan instancia, `destroy()` antes de recrear.
- Saving flag: `saveData()` en portal-clientes.html usa `try/finally` para garantizar `saving = false`.
- XSS en `esc()`: 5 archivos corregidos (checklist, contabilidad, implementaciones, gerencia, ventas). Versión unificada: escapa &, ", <, >, '.

### Estado del plan post-sesión (actualizado 2026-06-06 noche)
- **Fase 1D:** ✅ Completada
- **Fase 2:** Pendiente — Unificar outsourcing (quitar toggle analytics/CRUD)
- **Fase 3:** ✅ Completada — Dashboard carga + tabla Datos agrupada por contadora
- **Fase 4:** ✅ Completada — Retroalimentación en Personal
- **Fase 5:** ✅ Completada — Bug fixes de auditoría

### Continuación sesión nocturna (mismo branch, PR #6)

**Bugs corregidos:**
- `datosRenderAsignaciones()` usaba `APP.userRole` (variable de personal.html) → ReferenceError silencioso, la tabla no renderizaba. Fix: usa `tengoPermiso()`.
- `bdRefreshAsigView()` no verificaba qué tab principal estaba activo → podía renderizar en contenedor equivocado. Fix: agrega chequeo `gerMainTab === 'datos'`.

**Rediseño tabla Datos > Asignaciones:**
- Tabla plana reemplazada por grupos colapsables por contadora.
- Cada grupo: header clickeable con nombre, cantidad de clientes, total tx, barra de capacidad.
- Cerrados por defecto, clic para abrir/cerrar. Estado en `datosAsigOpen`.
- Columnas con `table-layout:fixed` y `colgroup` para alineación consistente entre grupos.
- Dos columnas de tx: "Contratadas" (de `clientes.monto_adm`) y "Tx Mes" (de `asignaciones.adm`).
- Ordenadas por total tx descendente; "Sin asignar" siempre al final.

**PR #6 mergeado a main con squash.**

### Pendientes detectados
- **Taina (contadora despedida):** No aparece en mayo aunque tenía clientes. Verificar si al desactivarla en `equipo` se borraron sus asignaciones históricas o si nunca se cargaron. Resolver en próxima sesión.
- **Nombres de contadoras:** Inconsistencia en tabla `contadoras` (algunas con nombre completo, otras solo primer nombre). No es bug de código.
- **monto_adm vacíos:** Varios clientes tienen 0 transacciones contratadas. Felix debe actualizar en Outsourcing > modal.
- **Wow Points edit/delete + pago automático** — tarea separada.

---

## Sesión 2026-06-06 — Merge a producción + fixes post-deploy

### Cambios completados

**1. Merge mejoras-junio-2026 → main (producción):**
- Branch mergeado a main y desplegado en Vercel.
- Release v2.1.0 creada como documentación retroactiva (el primer merge fue directo sin PR).
- PR workflow establecido: a partir de ahora, siempre crear PR antes de mergear a main.

**2. Fix Inactivos pill en función correcta (PR #3):**
- Bug: la pill Inactivos estaba en `bdRenderClientes()` (~línea 5429), pero la vista activa de outsourcing usa `ccRenderServicios()` (~línea 1807). gerencia.html tiene DOS sistemas de render para outsourcing.
- Fix: agregada la lógica de cálculo de inactivos + pill HTML + filtro en `ccRenderServicios()`.
- Cálculo: filtra `ccAllClientes` excluyendo activos del mes, verificando que `fecha_entrada` sea <= último día del mes.
- Pill clickeable con filtro `ccServMovFiltro === 'inactivos'`, integrada con el sistema de filtros existente (mfLabels, mfColors, mfBgs).
- Commit: `111c5aa`.

**3. Fix mes comercial dinámico (PR #4):**
- ventas.html línea 1019: `currentMonth: 'abril'` → `currentMonth: MONTHS[new Date().getMonth()]`.
- `MONTHS` array ya existía en línea 682, antes de la definición de APP.
- Commit: `52899a2`.

**4. Migration-003: exclusiones Wow Board (ejecutada por Felix):**
- `db/equipo-migration-003.sql`: excluir Esmeralda Perez y Michelle Dijool del Wow Board.
- `UPDATE equipo SET excluida_wowboard = true WHERE nombre/apellido`.
- Incluida en commit de PR #4.

**5. Verificación en producción:**
- ✅ Contadoras KPI: 4 contadoras (correcto — Karina es analista, no contadora KPI).
- ✅ Pill Inactivos visible y funcional en outsourcing.
- ✅ Wow Board: Michel, nueva Esmeralda, Doriluz, Esmeralda Perez y Michelle Dijool excluidas.
- ✅ ventas.html arranca en mes corriente (junio).
- ℹ️ Capacidad mayo mostrando solo 1 asignación = problema de DATA (asignaciones no copiadas de abril), no bug de código. Se resolverá en Fase 3.

### Git / PRs de esta sesión
- PR #3: Fix pill Inactivos en función correcta (ccRenderServicios)
- PR #4: Fix mes comercial dinámico + migration-003 wow board
- Release v2.1.0: documentación retroactiva del merge inicial

### Estado del plan (Fases pendientes)
- **Fase 1D:** ✅ COMPLETADA — módulos migrados a tabla `equipo`, año dinámico, fix cobros.
- **Fase 2:** Pendiente — Unificar outsourcing (quitar toggle analytics/CRUD).
- **Fase 3:** Pendiente — Rediseño asignaciones con dashboard de carga por contadora + botón "Copiar del mes anterior".
- **Fase 4:** Pendiente — Pestaña Retroalimentación en personal.html (tabla `retroalimentacion` ya existe en Supabase).
- **Fase 5:** Pendiente — Bugs auditoría (Chart.js leak, saving flag, XSS en esc()).

### Otros pendientes
- **Wow Points edit/delete + pago automático a 1,000 puntos** — tarea separada.
- **Software transacciones** — Felix debe proveer los máximos de transacciones por plan de software.
- **KPI UI redesign** — sesión separada con design skill.

## Sesión 2026-06-05 (noche) — Branch mejoras-junio-2026 + fix cobros

### Cambios completados
- **Memoria reorganizada:** entradas en orden descendente (más reciente arriba). Secciones de referencia al final.
- **Branch `mejoras-junio-2026` creado** con PR #2 (mergeado a main):
  - SQL: tablas `equipo` (roster 14 personas), `precios` (outsourcing DOP + software USD), `retroalimentacion` (quejas/errores/feedback). Las 3 ejecutadas en Supabase.
  - Año dinámico: ~96 instancias de `2026` reemplazadas por `var ANIO = new Date().getFullYear()` en 10 archivos.
  - Fix cobros `balance_dop`: el fallback `parseFloat(f.balance_dop || 0) || balance` trataba facturas USD sin balance_dop como pesos. Cambiado a `f.balance_dop != null ? parseFloat(f.balance_dop) : balance`. Total ahora cuadra con Excel (RD$1,434,815).
  - Fix cobros notas de crédito: saldos negativos se muestran en verde, greeting usa total global, saldado solo entre -0.01 y 0.01.
  - Fix saludo index.html: nombre con fallback a "Felix" si userName vacío.

### Plan pendiente del branch (Fases 1D-5)
- **Fase 1D:** Migrar módulos a leer de tabla `equipo` (eliminar arrays hardcodeados en 6 archivos)
- **Fase 2:** Unificar outsourcing (quitar toggle analytics/CRUD, vista única con stats + tabla editable)
- **Fase 3:** Rediseño asignaciones con dashboard de carga por contadora
- **Fase 4:** Pestaña Retroalimentación en personal.html (tabla ya existe en Supabase)
- **Fase 5:** Bugs auditoría (Chart.js leak, saving flag, XSS en esc())

### Pendientes para próxima sesión (anotados por Felix)
1. **Wow Points — editar/borrar + pago automático:** Poder editar y borrar wow points. Cuando alguien llega a 1,000 puntos, que aparezca automáticamente arriba como "pendiente de pago" en la sección de Wow Points.
2. **Comercial (ventas.html) — mes hardcodeado en abril:** El módulo arranca en abril. Cambiar para que empiece en el mes corriente (`new Date().getMonth()`).

## Sesión 2026-06-05 (tarde) — Auditoría completa del portal con Claude Code

### Contexto

Felix quiere empezar a mejorar el portal directamente con Claude Code en vez de Claude Design. Se hizo una auditoría de los 14 archivos HTML de la carpeta `Portal Contadores Claude Design/` para identificar bugs, inconsistencias de diseño y mejoras de UX. Se inicializó git en el proyecto para tener historial de cambios.

### Git inicializado

- `git init` en `Projects/Portal Account One/`
- Commit inicial: `v1.0 - Estado base del portal antes de mejoras con Claude Code` (hash: 0a7dc82)
- `.gitignore` creado (excluye .DS_Store, *.tmp, *~)
- 157 archivos trackeados

### Auditoría: bugs críticos encontrados

1. **Año 2026 hardcodeado en todo el portal** — En enero 2027 el dashboard, checklist, impuestos, calendario y ROAS dejan de funcionar. Está en: index.html, dashboard-publico.html, portal-admin.html, portal-clientes.html, checklist.html, gerencia.html, ventas.html. Es el hallazgo más repetido (~15 instancias).

2. **Chart.js memory leak** (contabilidad.html, impuestos.html) — Cada vez que se cambia filtro o contadora, se crea un nuevo Chart sin destruir el anterior. Acumula instancias, causa flicker y consume memoria.

3. **Flag `saving` nunca se limpia si falla** (portal-clientes.html:670) — Si un upsert a Supabase falla con excepción, el flag queda en `true` y el portal se bloquea permanentemente sin poder guardar.

4. **`getCurrentMonth()` roto en enero** (múltiples archivos) — En enero antes del día 22, devuelve enero en vez de diciembre del año anterior. Diciembre queda inaccesible.

5. **XSS en nombres con caracteres especiales** (contabilidad.html) — La función `esc()` solo escapa comillas simples, no HTML. Nombres de clientes con `<` o `"` pueden inyectar código en atributos `onclick`.

6. **Nombres con comillas simples rompen onclick** (portal-clientes.html:1128) — Si un cliente se llama "D'León Srl", el JavaScript dentro del `onclick` quiebra con SyntaxError.

7. **Progreso de archivos siempre cuenta como 0** (portal-admin.html:1037) — La rama `upload` nunca cuenta como completado, así que el índice de progreso es sistemáticamente menor al real.

8. **Variables no declaradas en gerencia.html** — `bdClientes`, `ccImplFEData`, `ccImplAdmData`, `ccServView`, `ccSwView` se usan sin declarar. Si no vienen de otro script, causan `ReferenceError`.

9. **Meses activos hardcodeados en gerencia** (gerencia.html:1391) — Solo muestra enero a mayo. En junio o después, la tabla de software muestra datos incompletos sin avisar.

10. **Colspan incorrecto en ventas** (ventas.html:1210) — El formulario de edición no ocupa el ancho completo de la tabla.

### Auditoría: inconsistencias de diseño entre archivos

| Problema | Archivos afectados |
|---|---|
| `--navy` tiene 3 valores distintos (#1a2332, #1e3a5f) | index.html vs personal.html vs ventas.html |
| `--blue` varía entre #4361ee y #3b82f6 | personal.html vs resto |
| Header con gradiente vs color sólido | personal.html vs todos los demás |
| Botón login dice "Iniciar sesión" vs "Entrar" | personal.html vs resto |
| Login box con/sin borde | personal.html vs resto |
| Tabs activos: fondo navy vs border-bottom | usuarios.html vs kpi.html/personal.html |
| "Contrasena" sin tilde en 4 archivos, con tilde en 1 | Todos vs personal.html |
| z-index del modal de notas: 900 vs 9000 | impuestos.html vs contabilidad.html |

### Auditoría: UX — `alert()`/`confirm()`/`prompt()` nativos

Se usan diálogos nativos del browser en casi todo el portal. Se ven feos, no funcionan bien en móvil, y son inconsistentes con los toasts que sí tiene el portal. Archivos afectados: contabilidad.html, kpi.html, personal.html, implementaciones.html, ventas.html, portal-admin.html.

### Auditoría: falta de feedback

- No hay spinner en botones de login
- No hay warning de `beforeunload` si hay cambios sin guardar (checklist.html)
- No hay manejo de sesión expirada en ningún archivo
- No hay pantalla de error si Supabase falla (queda "Cargando..." para siempre)
- `handleCkSave()` no muestra toast de éxito al guardar

### Auditoría: responsive

- personal.html: grid de 4 columnas sin breakpoint mobile
- portal-clientes.html: grid de 3 columnas salta directo a 1 (falta intermedio de 2)
- gerencia.html: `cob-urgency` y `cob-charts` no tienen breakpoints
- ventas.html: charts con `minmax(400px)` demasiado grande para tablets
- Tablas complejas en contabilidad.html inutilizables en pantallas <480px

### Auditoría: otros notables

- `assets/theme.css` y `assets/theme.js` no existen pero se importan en index.html y dashboard-publico.html (causan 404)
- `document.execCommand('copy')` deprecated, usado como fallback en varios archivos
- Contadoras hardcodeadas en gerencia.html (nombres, colores y capacidad en el código, no en BD)
- Supabase anon key en el HTML de todos los archivos (no es crítico si RLS está bien, pero vale documentarlo)

### Skills de mattpocock instalados

Se instalaron 29 skills de desarrollo en `.agents/skills/` y se crearon los slash commands en `~/.claude/commands/` para que funcionen globalmente. Skills relevantes para el portal: `/diagnose`, `/grill-me`, `/zoom-out`, `/review`, `/qa`, `/improve-codebase-architecture`.

### Infraestructura: Git + GitHub + Vercel

- Git inicializado en `Projects/Portal Account One/` con commit v1.0 (hash 0a7dc82)
- Homebrew instalado en el Mac (`/opt/homebrew/bin/brew`)
- GitHub CLI (`gh`) instalado y autenticado como `themoneycoachrd`
- Repo nuevo creado: `themoneycoachrd/portal-accountone-v2` (privado)
- Vercel conectado al repo, root directory = `pages`, branch = `main`
- Git config: `user.email = coach@felixrosa.com`, `user.name = Felix Rosa`
- Archivos de Claude Design copiados a `pages/` como base de trabajo
- `assets/theme.css` y `assets/theme.js` copiados a `pages/assets/`

### Grill-me: decisiones de diseño para Fase 11B

Se hizo sesión de /grill-me para definir el plan de la sub-fase B (diseño). Decisiones:

1. **Archivos de trabajo:** solo `pages/`. La carpeta Claude Design en `Referencias/` es backup muerto.
2. **Orden:** diseño primero (B), bugs después (A), UX al final (C).
3. **personal.html:** alinear al resto (no al revés). Es el outlier.
4. **Tabs activos:** estilo border-bottom (no fondo navy). usuarios.html era el outlier.
5. **z-index:** escala estándar toast:1000, modal:2000, login:3000.
6. **theme.css:** absorber lo bueno en cada archivo y eliminar imports (opción A, autocontenido).
7. **Tildes:** barrer todo, no solo login.

### Cambios aplicados (Fase 11B - Diseño)

**Commit: Corregir tildes en login (PR #1)**
- 19 instancias de "Contrasena" → "Contraseña" en 7 archivos

**Commit: Fase 11B — consistencia de diseño**
- personal.html: colores alineados (#1a2332/#4361ee), header sólido sin gradiente, login con borde y botón "Entrar", labels gris
- usuarios.html: tabs activos con border-bottom en vez de fondo navy
- z-index estandarizado en 12 archivos
- Tildes corregidas en toda la UI: sesión, nómina, autorización, presentación, próximo, reunión, ejecución, proyección, día, último, miércoles, sábado, y más
- Nota: `video_reunion` se mantiene sin tilde porque es key JSONB en la BD

**Commit: Limpiar sidebar y agregar header descriptivo**
- Sidebar: eliminadas las descripciones (navDesc) debajo de cada item del menú
- Header de sección: al entrar a un módulo aparece banner con label en azul, título descriptivo y descripción

**Commit: Unificar Portal Clientes en sidebar**
- "Portal Clientes (A)" y "Portal Clientes (C)" unificados en un solo item "Portal de clientes"
- Click abre landing con dos tarjetas: "Administrativo" y "Links de clientes"
- tieneAccesoModulo corregido para verificar acceso a hijos de secciones

### Pendiente de Fase 11B

- **Absorber theme.css:** theme.css define colores distintos (#28368D navy, #25AAE1 blue) que sobreescriben los inline. Decisión fue absorber lo bueno en cada archivo y eliminar los imports. Esto es el cambio más grande y no se ha hecho todavía.
- **Verificar visual en Vercel:** Los cambios de diseño se subieron pero no se verificaron visualmente en el portal desplegado.

---

## Sesión 2026-06-05

### Cambios completados

**1. Reporte mensual de KPI por contadora (contabilidad.html):**
- Nuevo sub-tab "Reporte Mensual" en KPI (solo admin), con month pills (12 meses) y contadora pills.
- Default: mes anterior al actual (el reporte se genera el día 1 sobre el mes que cerró).
- Tres bloques: Digitación (X/50 pts) con tabla de carga/dig por semana + comparativo Meta vs Total; Llenado Portal (X/30 pts); Correo/Reunión (X/20 pts). Cada bloque con su badge de puntuación.
- Tabla de digitación tiene dos filas por cliente: carga (verde) y digitación (azul), con fechas.
- Campo de nota temporal por cliente (no se guarda en BD).
- Score card arriba con desglose y nivel de bono.

**2. Reorganización de columnas KPI detail (contabilidad.html):**
- Stats: "Objetivo" → "Visión", "Tx meta (Adm)" → "Mes anterior".
- Tabla: columna Adm movida de antes de las semanas a después de Total. Nuevas columnas: "Mes ant." (effectiveAdm), "Contrat." (monto_adm del cliente), "%" (digitado vs contratado).
- Fila de totales actualizada con las 3 columnas nuevas.

**3. Mv Creative incluida en scoring de Beliani (contabilidad.html + SQL):**
- `isMvException()` ahora retorna `false`. MV_EXCEPTION desactivada.
- SQL `db/mv-creative-adm.sql`: carga ADM real en asignaciones (abril=123, mayo=142).
- `monto_adm` en maestra se mantiene en 200 (plan contratado original).

**4. Botones de notas en Cobros unificados (gerencia.html):**
- Historial de cobro convertido de cards a tabla con mismo formato que tareas.
- Botones compactos ✎ ✓ ✗ al final de cada fila, mismo estilo.

**5. Fix moneda en upload Excel de cobros (gerencia.html + SQL):**
- Default cambiado de USD a DOP cuando no hay columna de moneda.
- Detección de columna "balance en moneda local" del Excel de Adm Cloud.
- Nuevo campo `balance_dop` en `cobros_facturas` (SQL: `db/cobros-balance-dop.sql`).
- Balance original (USD/DOP) se muestra por factura; `balance_dop` se usa para totales del dashboard.
- Eliminada dependencia de tasa hardcodeada de 61.

**6. Filtro por tipo de impuesto en Resumen (contabilidad.html + impuestos.html):**
- Gráfico "Por tipo de impuesto" reemplazado de Chart.js canvas a barras HTML clickeables.
- Click en barra filtra las secciones Urgente/Vencido/Próximo para mostrar solo pendientes de ese impuesto.
- Badge "Filtrando: IR-17 ✕" para limpiar. Labels con ancho fijo para alinear barras.
- "Proveedores" renombrado a "IR-17" en contabilidad.html para alinear con impuestos.

**7. Cards de urgencia clickeables (contabilidad.html + impuestos.html):**
- Cards Urgente/Vencido/Próximo funcionan como filtro. Click muestra solo esa categoría abajo.
- Card activa con borde resaltado, demás con opacidad baja. Se combina con filtro de tipo.

**8. Link Cliente Demo en portal-admin.html:**
- Card "Cliente Demo" con borde azul punteado en las stats de Checklist y Presentación.
- Click abre `portal-clientes.html?demo=1` en nueva pestaña.

**9. Editar y eliminar en Wow Points (personal.html):**
- Botones ✎ (editar motivo/puntos) y ✗ (eliminar) en cada fila del historial, solo para admin.
- Editar usa prompt. Eliminar pide confirmación y borra de Supabase.

**10. Fix mes default en ventas.html:**
- `currentMonth` ya no hardcodeado en 'abril'. Ahora usa el mes actual del sistema.
- Movimiento y Checklist se pre-renderizan al entrar para estar listos al cambiar tab.

### SQL ejecutados en esta sesión
- `db/mv-creative-adm.sql` — ADM real de Mv Creative (abril=123, mayo=142)
- `db/cobros-balance-dop.sql` — columna `balance_dop` en `cobros_facturas`

### Archivos modificados
- `pages/contabilidad.html` — reporte KPI, columnas, MV exception, filtros resumen
- `pages/impuestos.html` — filtros resumen (barras + urgencia)
- `pages/gerencia.html` — notas cobros tabla, moneda upload Excel, balance_dop
- `pages/portal-admin.html` — link Cliente Demo
- `pages/personal.html` — editar/eliminar Wow Points
- `pages/ventas.html` — mes corriente, pre-render tabs

---

## Sesión 2026-06-02

### Cambios completados

**Migración Taína → Morelia:**
- UPDATE `impuestos_checklist`, `reporte_mensual`, `clientes` (contab + imp) de Taina a Morelia.
- Tabla `checklist_contadores` también migrada (era la que contenía la data real de contabilidad, keyed por `contadora_cliente_mes`).
- Unificación "Morelia Matos" → "Morelia" en todas las tablas.
- Morelia activada en tabla `contadoras`, Taina inactivada.
- KPI: Morelia agregada en `KPI_CONTADORAS` de contabilidad.html (tier Contadora II, objetivo 500, salario 60000).
- También hay duplicados de Karina: `Karina` y `Karina Sanchez` en impuestos_checklist. Pendiente unificar.

**Abril completado para Lovelis y Doriluz (impuestos):**
- 85 registros insertados en impuestos_checklist para abril: 7 clientes de Doriluz × 5 impuestos + 10 clientes de Lovelis × 5 impuestos.
- Nombres en impuestos son completos: `Lovelis Guzman`, `Doriluz Crisostomo` (no solo primer nombre).

**getCurrentMonth() actualizado (contabilidad, impuestos, portal-clientes):**
- Del día 1 al 22: muestra el mes anterior (en presentación). A partir del 23: mes actual.
- Aplica al checklist default y al tab de impuestos.

**Calendario portal-admin y portal-clientes:**
- Título: "Presentación fiscal de Mayo — se presenta en Junio 2026".
- Mes default: antes del 20 muestra mes anterior, después del 20 muestra actual.

**Cobros — botones en historial de notas:**
- Cada nota del historial ahora tiene botones ✎ Editar, ✓ Completar, ✗ Eliminar.
- Función `cobEditarNota(id)` abre el modal prellenado con tipo_contacto, resultado, fechas y nota.

**Cobros — 4 niveles de templates WhatsApp + correo:**
- Emisión, Fin de mes, Estándar, Personal Felix.
- Moneda correcta (USD/DOP) en todos los templates y estado de cuenta.
- Filtro de tareas por asignado (Todas/Esmeralda/Felix).

**Modo demo portal-clientes (?demo=1):**
- Arranca sin login, sin Supabase, data hardcodeada.
- Portal-demo.html eliminado (no funcionaba). Demo ahora vive dentro de portal-clientes.html.
- Cliente Demo eliminado de tablas reales (no afecta conteos).

**Archivos modificados:**
- `pages/gerencia.html` — cobros: notas con botones, 4 niveles templates, moneda, upload Excel, filtro asignado
- `pages/contabilidad.html` — KPI Morelia, eliminado Resumen del Mes que no funcionó
- `pages/impuestos.html` — getCurrentMonth() con mes en presentación
- `pages/portal-clientes.html` — modo demo, getCurrentMonth(), título calendario
- `pages/portal-admin.html` — título calendario, mes default

### Pendiente: Reporte mensual de KPI por contadora

**Concepto:** Botón "Generar reporte de [mes]" que produce un snapshot individual por contadora.

**Contenido por contadora (tabla con una fila por cliente):**
- Cliente | Meta ADM | Facturas cargadas (fecha) | Digitación S1-S5 (fechas) | Portal llenado (límite vs fecha) | Correo enviado (límite vs fecha) | Nota

**Fuente de datos:** Todo está en `kpi_detalle` JSONB:
- `datos.digitacion[cliente]` = array de 6 semanas con `{carga, dig, fecha, fecha_respuesta}`
- `datos.resumenes[cliente]` = `{done, fecha}` (llenado portal)
- `datos.video[cliente]` = `{done, fecha}` (correo/reunión)

**Nota de exclusión:** Temporal, no se guarda. Para cuando un cliente entregó facturas muy tarde y sale del KPI.

**Decisión:** Construir en próxima sesión como sub-tab "Reporte" en KPI, o como botón que genera un documento.

## Sesión 2026-05-30

### Plan de la sesión

**1. ✅ Fix permiso Facturación para Esmeralda**
- Bug: `tengoPermiso` pasaba subtabId para facturación (que no tiene subtabs), buscando ruta de 3 niveles inexistente.
- Fix: `noSub: true` en la tab definition, filtro no pasa subtabId.
- Pendiente: Felix debe asignar permiso `gerencia.facturacion.consulta` al grupo de Esmeralda en usuarios.html.

**2. Filtro de tareas por asignado en Cobros**
- Agregar pills o toggle para filtrar tareas: "Todas", "Esmeralda", "Felix".
- Aplica tanto en "Tareas pendientes" del dashboard como en la tabla de tareas del perfil del cliente.

**3. Fix moneda en templates (WhatsApp, correo, estado de cuenta)**
- Templates WhatsApp y correo usan `cobFormatMoney()` que siempre muestra RD$. Deben usar la moneda real del cliente (USD en la mayoría).
- Estado de cuenta también muestra RD$ en vez de la moneda correcta.
- `cobFormatMoney` necesita recibir la moneda como parámetro.

**4. Diseñar 3 templates WhatsApp + 3 templates correo para cobros**
- Nivel 1 (automático/cordial): "Acabamos de emitir tu factura, las facturas no tienen crédito."
- Nivel 2 (toque humano): "No queremos que se junten dos meses, queremos avisarte."
- Nivel 3 (dueño a dueño): Mensaje personal de Felix.
- Investigar mejores prácticas de cobros antes de redactar.

**5. Fix estado de cuenta: montos en moneda correcta**
- Incluido en el fix de moneda (#3). Los montos deben mostrar USD o DOP según la moneda del cliente.

## Sesión 2026-05-29

### Cobros: tareas completar/borrar + orden tabla

**Tareas de cobro (completar y borrar):**
- Filtro `resultado !== 'completada'` aplicado en dos lugares: "Últimas tareas" del dashboard y sección "Tareas pendientes" del perfil del cliente.
- Botones ✓ Completar y ✗ Eliminar en cada tarea del perfil. Completar hace UPDATE resultado='completada'. Eliminar hace DELETE con confirm().
- Funciones: `cobCompletarTarea(id)` y `cobBorrarTarea(id)`. Ambas recargan notas y re-renderizan.
- SQL: constraint resultado ampliado con 'completada'. Policy UPDATE creada para notas_cobro (permiso edicion en cobros).

**Orden de tabla principal:**
- Default sort: USD primero (monto desc), DOP al final (monto desc), clientes sin data al final.
- Reemplaza el sort anterior por score que venía de `cobBuildClientList`.
- Headers "Pendiente" y "Mayor atraso" son clickeables (↕ inactivo, ▼▲ activo). Click alterna desc/asc.
- Variables de estado: `cobSortField` ('default'|'monto'|'dias') y `cobSortDir` ('desc'|'asc').
- Funciones: `cobToggleSort(field)` y `cobSortArrow(field)`.

**Fix DELETE silencioso:**
- El DELETE no funcionaba porque la policy RLS original exigía permiso `eliminar`, pero el usuario solo tenía `edicion`. Supabase no devuelve error en ese caso, simplemente no borra nada.
- Fix SQL: policy DELETE ahora acepta `edicion` OR `eliminar`.
- Fix JS: `cobBorrarTarea` ahora usa `.delete().eq('id', id).select()` y verifica que data tenga filas. Si no, muestra "No se pudo eliminar. Verifica permisos."

**Dashboard "Últimas tareas" clickeables:**
- Cada tarea en el dashboard ahora es clickeable y navega al perfil del cliente (`cobOpenDetalle`).
- Nombre del cliente en azul con flecha (→). Muestra descripción (sin "Asignada a:"), fecha límite y asignada en texto pequeño.
- Helper `cobParseTarea(nota)` extrae el "Asignada a: X." del inicio de la nota y devuelve `{ asignada, desc }`.

**Tareas en detalle rediseñadas como tabla:**
- Tabla con columnas: Creada, Fecha tarea, Seguimiento, Descripción, Asignada a, Estatus, botones ✎/✓/✗.
- Labels del modal renombrados: "Fecha límite" → "Fecha tarea", "Fecha de seguimiento" → "Fecha seguimiento".
- Fecha tarea se muestra en rojo con bold si ya venció.

**Botón editar tarea (✎):**
- `cobEditarTarea(id)` abre el modal prellenado con datos de la tarea existente (asignada, fecha tarea, seguimiento, descripción).
- `cobSaveNota` ahora detecta si hay `cobNotaEditId` y hace UPDATE en vez de INSERT.
- Campo hidden `cobNotaEditId` agregado al modal.

**Fix RLS notas_cobro — ruta JSONB incorrecta (bug root cause):**
- Todas las policies usaban ruta de 2 niveles (`cobros->edicion`) pero el JSONB real tiene 3 niveles (`cobros->cobros->edicion`) porque módulo y screen se llaman igual "cobros" en MODULOS.
- Reescritas TODAS las policies (SELECT, INSERT, UPDATE, DELETE) con ambas rutas (2 y 3 niveles) para compatibilidad.
- Eliminadas policies temporales que habían quedado de la sesión anterior.

**Búsqueda sin recargar dona:**
- `cobOnSearch` ya no llama `cobRenderApp()`. Usa `cobRenderTableOnly()` que solo actualiza el div `#cob-table-wrap`.
- `cobToggleSort` también usa `cobRenderTableOnly()`.
- Variable `cobFilteredClientes` cachea la lista después de filtros pill/aging, antes de search.

**Dashboard últimas tareas con scroll:**
- Muestra TODAS las tareas pendientes (no solo 3). Título "Tareas pendientes (N)".
- Container con `max-height:280px; overflow-y:auto`.

**Pills de movimiento en Outsourcing (tab Servicios):**
- 5 stat cards debajo de las de servicio: Total clientes, Inicio mes, Nuevos, Churn, Cierre.
- Clickeables, filtran la tabla. Mutuamente excluyentes con el filtro de servicio (uno limpia el otro).
- Variable `ccServMovFiltro` ('total'|'inicio'|'nuevos'|'churn'|'cierre').
- Función `ccServMovFilter(tipo)`. Al cambiar de mes se limpian ambos filtros.
- Filter indicator con botón "Ver todos".
- Lógica de filtro: inicio = activos sin nuevos + churn; nuevos = fecha_entrada en el mes; churn = fecha_salida en el mes; cierre = activos.

**Tricargo duplicado:**
- Tabla `clientes` no tiene UNIQUE en `nombre`. Tricargo tenía 2 registros (uno real con fecha_entrada 2024-07-01, uno duplicado sin fecha_entrada creado 2026-05-29). Duplicado eliminado manualmente.
- Pendiente: agregar validación de nombre duplicado en `clSaveClient()` antes de INSERT.

**Archivos modificados:**
- `pages/gerencia.html` — todo lo anterior
- `db/cobros-completar-tarea.sql` — constraint + todas las policies de notas_cobro reescritas

**Pendientes:**
- Scheduled task para sync automático de cobros desde Adm Cloud
- Probar notas de cobro con Esmeralda (necesita grupo con permisos cobros)
- Agregar validación de nombre duplicado en `clSaveClient()` para evitar registros duplicados en `clientes`

## Sesión 2026-05-28

### Cambios completados
- **portal-admin.html + portal-clientes.html**: Calendario ITBIS actualizado. Día 14: Contabilidad envía borrador a Impuestos. Día 19: Impuestos devuelve aprobado + último día para que cliente revise. "Último recordatorio" ahora es dinámico: usa `CALENDARIO_DGII_2026[mesIdx].itbis.d` (varía entre 20-22 según el mes). TIMELINE_ENTRIES actualizado. Template de correo: f18→f19.
- **implementaciones.html**: Resumen rediseñado. Eliminado Chart.js y donut de implementadora. Ahora usa barras HTML redondeadas (funnel style) para ambos gráficos, side-by-side: "Por tipo" (4 barras: FE en proceso, FE completada, Adm en proceso, Adm completada) + "Pipeline por fase" (5 fases). Labels alineados con `min-width:120px`.
- **Adm Cloud MCP**: Login exitoso. Collections devuelve data agregada (P1-P12). CreditInvoices devuelve registros completos (muy grandes). AR y Customers/Extended devuelven 404 (endpoints no disponibles en esta versión de la API).

### Módulo de Cobros — COMPLETADO

**Ubicación:** Pill "Cobros" en gerencia.html, entre Clientes y Personal.

**Arquitectura final:** Sync periódico a Supabase. CORS impide llamadas directas del browser a Adm Cloud. Credenciales de Adm Cloud NO están en el frontend.
- Tabla `cobros_facturas`: snapshot de facturas pendientes (sync manual desde Cowork vía MCP)
- Tabla `notas_cobro`: historial de gestiones de cobro
- El portal lee de Supabase, no de Adm Cloud directamente
- Para sincronizar: pedir a Claude "sincroniza cobros" desde Cowork

**Adm Cloud MCP:** v0.5.0 funcional. Basic Auth + appid/company/role como query params. API base: `https://api.admcloud.net/api`. Endpoint: CreditInvoices. Necesita `$skip` para paginar (50 por página). Campos clave: RelationshipName, TotalAmount, AppliedPayments, DaysSinceCreation, CurrencyID, DocID, Void. Nuevo appid para portal: `cbea40cc-096d-4ebd-fade-08debd059b88`.

**Vista Resumen (estilo dashboard):**
- Greeting personalizado (Buenos días/tardes/noches)
- Pills de score arriba: Todos, Buen pagador, Pago ocasional tarde, Pago recurrente tarde
- Botón/estado de sync de Adm Cloud
- 4 tarjetas de urgencia por aging (clickeables, filtran la tabla): 90+, 60-90, 30-60, 0-30 días
- 2 gráficos side-by-side: barras de monto por antigüedad (RD$) + dona de deuda por cliente
- Barra de búsqueda por nombre
- Tabla con columnas: #, Cliente, Moneda, Pendiente, Facturas, Mayor atraso, Score, Última nota, Acciones
- Montos con `font-variant-numeric: tabular-nums` para alineación
- Moneda (USD/DOP) en columna separada del monto

**Vista detalle de cliente:** Header con score + monto total, tabla de facturas (con moneda separada), historial de notas de cobro con badges de tipo/resultado.

**Templates:** Estado de cuenta, correo y WhatsApp. Todos funcionan con o sin datos de Adm (texto genérico si no hay facturas).

**Score (del invoice-chase):** 3 tiers hardcoded en COB_SCORES: repeat (11 clientes), occasional (21 clientes), good (2 clientes). Match parcial por nombre para emparejar nombres de Adm Cloud (con Srl) vs scores (sin Srl).

**Permisos:** Pantalla "cobros" en MODULOS de usuarios.html. Esmeralda (rol cobros / "Facturación y Cobros").

**Tablas Supabase:**
- `cobros_facturas`: adm_id, cliente_nombre, doc_id, total, balance, fecha_factura, dias_atraso, moneda, referencia, tipo_doc, synced_at. RLS: SELECT para autenticados.
- `notas_cobro`: id, cliente_nombre, tipo_contacto, resultado, fecha_promesa, monto_prometido, fecha_seguimiento, nota, facturas_ref, created_by, created_at. RLS: SELECT/INSERT para cobros/admin.

**Pendientes para próxima sesión:**
- **Tareas de cobro: completar y borrar.** Agregar botones ✓ (completar) y ✗ (borrar) en cada tarea del perfil del cliente. Completar = UPDATE resultado='completada'. Borrar = DELETE. Tareas completadas no deben aparecer en "Últimas tareas" ni en la sección Tareas del perfil (filtrar por resultado='pendiente'). Agregar 'completada' al constraint de resultado si no está.
- **Orden de la tabla principal:** DOP al final, USD de mayor a menor por monto. Agregar botones/headers clickeables para ordenar por: monto (mayor a menor) y días de atraso (mayor a menor).
- **Fix importante ya resuelto:** RLS de notas_cobro — SELECT y INSERT ahora permiten cualquier usuario autenticado (policies temporales). Los constraints de tipo_contacto y resultado ya incluyen 'tarea' y 'pendiente'. El escape de nombres con `&` usa `cobEsc()` (no `esc()`) para evitar corromper `&` a `&amp;`.
- **Datos cacheados:** `cobDataLoaded` flag evita recargar de Supabase en cada render (mejora búsqueda). Se resetea con `cobDataLoaded = false` al guardar notas.
- Scheduled task para sync automático de cobros desde Adm Cloud
- Probar notas de cobro con Esmeralda (necesita grupo con permisos cobros)

**Archivos SQL ejecutados en esta sesión:**
- `notas-cobro-setup.sql` + policy temporal INSERT + policy temporal SELECT (auth.uid() IS NOT NULL)
- `cobros-facturas-setup.sql` + ALTER ADD tipo_doc
- `cobros-sync-inicial.sql` (datos reales del reporte de CxC de Adm Cloud)
- ALTER constraints: tipo_contacto admite 'tarea', resultado admite 'pendiente'

### 2026-05-27 — Resumen de Implementaciones rediseñado

Se reescribió el tab Resumen de implementaciones.html siguiendo el mismo patrón visual de contabilidad e impuestos. Componentes:
- Greeting con nombre del usuario y resumen de estado.
- 3 tarjetas de urgencia: Vencidas (pasaron fecha fin), Próximas a vencer (7 días o menos), En riesgo (tiempo >50% pero progreso <40%).
- Funnel horizontal por fase (Servicio, Onboarding, Gerencia, Implementación, Transición) mostrando cuántos clientes activos hay en cada etapa. La fase se determina por el siguiente paso pendiente del checklist.
- Barras horizontales FE vs Adm (en proceso + completadas).
- Donut por implementadora (solo activas).
- Secciones agrupadas por cliente para cada categoría de urgencia (igual que contabilidad).
- Tabla completa con columna Fase y Estado clickeable (navega al detalle).
- Insights: implementadora con más implementaciones con atención requerida.

Se agregó Chart.js CDN (no lo tenía antes). Se copiaron las clases CSS `.res-*` de contabilidad con adición de `.res-funnel-*` para el funnel.

**Archivos modificados:** implementaciones.html.

---

### 2026-05-27 — Digitación: tooltip fechas y columna "Fuera del mes"

Mejoras al KPI de digitación en contabilidad.html:
- Las celdas vuelven al layout limpio (sin labels C:/D:). Los headers de semana mantienen sub-labels "C" verde y "D" azul para referencia.
- Al pasar el mouse por una celda aparece un tooltip negro con las fechas: "Resp: YYYY-MM-DD" (fecha de respuesta al ¿Cargo?) y "Carga: YYYY-MM-DD" (fecha en que el cliente cargó).
- Nueva columna "Fuera del mes" (index 5 en el array) después de la semana 5, con fondo beige (#fdf8f0). No usa flujo ¿Cargo? sino inputs directos de carga y digitado.
- `emptyWeeks()` retorna 6 entries en vez de 5. Migración automática: arrays existentes con 5 entries se padean a 6.
- Totales por fila y columna incluyen la columna fuera. El score también la incluye.

**Decisión:** Felix probó los labels C:/D: pero prefirió el layout limpio original. Las fechas van en tooltip, no inline ni en columnas separadas.

**Archivo modificado:** contabilidad.html.

### 2026-05-27 — Calendario: prefijo de responsable + labels DGII descriptivos

En el grid del calendario (ambos portales), cada evento ahora muestra quién es responsable:
- Verde: **"Cliente:"** + tarea
- Azul: **"AO:"** + tarea
- Rojo: "Pagar TSS", "Pagar IR-3 / IR-17", "Pagar Anticipo ISR", "Pagar ITBIS" (antes solo decía "TSS", "IR-3 / IR-17", etc.)

**Archivos modificados:** portal-admin.html, portal-clientes.html.

### 2026-05-27 — Digitación separada: carga del cliente + digitado por contadora

La tabla de digitación del KPI ahora tiene dos valores por semana por cliente, apilados verticalmente en cada celda:
- **Carga** (verde): lo que el cliente subió. Se ingresa con el flujo ¿Cargo? existente.
- **Digitado** (azul): lo que la contadora procesó. Input nuevo, independiente.

**Cambio de estructura de datos:** cada week object pasó de `{qty, fecha, fecha_respuesta}` a `{carga, dig, fecha, fecha_respuesta}`. La migración mapea `qty → carga` y `qty → dig` para preservar data existente de mayo.

**Score:** los 50 puntos de digitación ahora se calculan con `dig` (lo digitado realmente), no con `carga` (lo que el cliente subió). Esto refleja mejor el trabajo real de la contadora.

**Stats:** se agregó tarjeta "Tx cargadas" (4 stats en vez de 3). **Columna "Contratado":** eliminada de la tabla para ganar espacio para las celdas duales.

**Funciones nuevas:** `getWeekCarga(w)`, `handleCargaChange(input)`. **Funciones modificadas:** `emptyWeeks()` (carga+dig), `getWeekQty()` (retorna dig), `handleDigConfirm()` (guarda carga), `handleDigChange()` (guarda dig), `handleKpiSave()` (recoge .carga-input y .dig-input), `getEffectiveAdm()` (fallback w.dig || w.qty).

**Archivos modificados:** contabilidad.html.

### 2026-05-26 — Calendario visual (grid) en portal-admin y portal-clientes

Se agregó un calendario visual con grid de días al inicio del tab Calendario en ambos portales. El grid muestra las responsabilidades del mes distribuidas en los días reales, desde el ~25 del mes de trabajo hasta el ~22 del mes siguiente.

**Datos hardcodeados para 2026:**
- `CALENDARIO_DGII_2026`: fechas reales de IR-3, IR-17, Anticipo ISR e ITBIS por mes (del calendario oficial del contribuyente).
- `CALENDARIO_TSS_2026`: fechas reales de TSS por mes (del calendario oficial de la TSS).
- `CAL_RESPONSABILIDADES`: 12 responsabilidades con día relativo, periodo (trabajo/siguiente), tipo (cliente/ao/dgii) y label corto.

**Funciones:**
- `getCalendarEvents(mesIdx)`: construye mapa de eventos por día cruzando responsabilidades relativas + fechas DGII/TSS. Clave = `YYYY-MM-DD`.
- `renderCalGrid()`: genera pills de mes + filter pills (Todos/Cliente/AO/DGII) + grid visual. Cada celda muestra número de día con mes abreviado (ej: "25 abr") + lista de responsabilidades filtradas por `calActiveFilter`. Colores: verde (cliente), azul (AO), rojo (DGII).
- `calSwitchFilter(f)`: cambia `calActiveFilter` y re-renderiza. El filtro aplica globalmente al grid, al Resumen (accordion) y a Cómo se ve un mes (timeline).
- `getEventStyle(tipo)`: retorna CSS de color según tipo.

**Mejoras 2026-05-26:**
- Mes abreviado en cada número de día (ej: "25 abr", "1 may") para distinguir los dos meses.
- Descripciones completas en `CAL_RESPONSABILIDADES` en vez de labels cortos.
- Filtro global `calActiveFilter` (`todos`|`cliente`|`ao`|`dgii`) controla grid + renderCalResumen + renderCalMes. Eliminado el sub-filtro `calActivePerspective` en renderCalMes.
- renderCalResumen: filtra tareas dentro de OBLIGACIONES según `calActiveFilter`, oculta obligaciones sin tareas para el filtro activo.
- renderCalMes: filtra TIMELINE_ENTRIES directamente por `calActiveFilter`, muestra mensaje "No hay entradas" si el filtro no tiene resultados.

**Integración:** `renderCalendario()` llama `renderCalGrid()` al inicio, antes de los pills de vista (Resumen / Cómo se ve un mes). El grid siempre se muestra arriba, las perspectivas de texto siguen abajo.

**Archivos modificados:** portal-admin.html, portal-clientes.html.

### 2026-05-26 — KPI bono: narrativa invertida (deductiva)

Se invirtió la visualización del progreso del bono. Antes la contadora veía su score subiendo desde 0. Ahora arranca en 100 y cada tarea pendiente le resta puntos visibles.

**Cambios en score overview:**
- El número grande sigue mostrando el total, pero ahora debajo dice "-X pts perdidos" en rojo cuando hay deducciones.
- Las barras de progreso muestran el fondo completo tenue y el fill con lo ganado. Al lado, si hay pérdida, aparece "-X" en rojo en vez del total de pts.
- Los comp-score-pill de cada componente cambiaron de "X/10 → Y pts" a "Y/50 pts (-Z)" mostrando la pérdida.

**Función `calcPenalties(contadora, mes)`:** Calcula deducciones específicas por área y cliente. Retorna array de `{pts, area, detail, color}`. Áreas: Digitacion (si < 100% de tx), Llenado Portal (por cada cliente sin entregar), Correo/Reunion (por cada cliente sin completar). Los puntos perdidos se reparten proporcionalmente entre clientes.

**Log de deducciones:** Sección dentro de la bono-card que lista cada penalidad individual con puntos perdidos, área y detalle (nombre del cliente). Si no hay deducciones, muestra "Sin deducciones. Tienes los 100 puntos completos."

**Mensajes del bono invertidos:** Tres estados: (1) score perfecto → "Score perfecto, vas a cobrar X", (2) con pérdidas pero con bono → "Tienes X asegurados si mantienes este nivel", (3) sin bono → "Perdiste demasiados puntos, necesitas subir a 70+".

**Month pills en bono:** Cambiaron de "May: 85 → 100" a "May: 85 (-15)" para meses en curso, y "100 ✓" cuando está perfecto.

**Archivos modificados:** contabilidad.html.

### 2026-05-26 — KPI contabilidad: 3 mejoras

**1. Digitación de facturas — confirmación semanal + fechas reales:** Headers de semana ahora muestran rangos de fechas reales (ej: "1-7 may") usando `getWeekRanges(mesIdx)`. Se agregó botón "¿Cargo?" por semana donde la contadora confirma si el cliente cargó facturas. Si responde Sí, se pide cantidad y se guarda `{qty, fecha, fecha_respuesta}`. Si responde No, se guarda `{qty:0, fecha:'', fecha_respuesta}`. El campo `fecha_respuesta` se persiste en el JSONB de `kpi_detalle`. Tres estados visuales: sin confirmar (botón), confirmado No (label rojo + fecha), confirmado Sí (input editable + fecha). `emptyWeeks()` y `getDetalle()` migran automáticamente datos existentes para incluir `fecha_respuesta`.

**2. Renombrar Resumenes → Llenado del Portal de Clientes:** El componente 2 del KPI pasó de llamarse "Resumenes de declaracion" a "Llenado del Portal de Clientes" en todos los labels visibles (comp-title, score overview). Los keys de datos (`d.resumenes`, `scores.resScore`) no cambiaron.

**3. Video/Reunión → Correo mensual:** En meses que no son cierre trimestral (donde `vidTipo !== 'Reunion'`), el componente 3 ahora se titula "Correo mensual a clientes" y la columna cambia a "Correo enviado?". Se agrega columna "Correo" con botón "Ver template" que abre modal con texto predefinido. El template incluye nombre del cliente y de la contadora auto-llenados. Modal con botón "Copiar al portapapeles" + toast. CSS: `.kpi-tpl-overlay`, `.kpi-tpl-modal`. Funciones: `verTplCorreo()`, `copiarTplCorreo()`, `cerrarTplCorreo()`.

**Archivos modificados:** contabilidad.html.

### 2026-05-26 — Franja de fechas en checklist + botón correo

**Franja de fechas (portal-clientes.html + portal-admin.html):** Se agregó una franja visual debajo del header de cada obligación en el checklist mostrando las 4 fechas clave: A tiempo (verde), Tarde (ámbar), AO procesa (azul), Límite DGII (rojo). Las fechas vienen de `OBLIGACIONES[].fechas`. Helper `getObligacion(impId)` mapea el ID del checklist (TSS, IR-3, etc.) al entry correcto de OBLIGACIONES via `OBL_MAP`. CSS: `.fechas-row`, `.fecha-col`, `.fecha-lbl`, clases de color `fv-green/fv-amber/fv-blue/fv-red`. Las fechas van DENTRO del `<div class="task-section">` como primer hijo, antes de la barra de progreso (no como franja separada encima del card).

**Botón "Enviar correo" (portal-admin.html):** Botón azul en el dashboard de cada cliente que muestra un modal con las responsabilidades fiscales pendientes del mes seleccionado. El texto separa las tareas en dos secciones: "Lo que necesitamos de ti" (tareas del cliente) y "Lo que hacemos nosotros" (tareas de AO). Las tareas ya completadas en el checklist se excluyen via `TAREA_DONE_MAP` que mapea cada tarea de OBLIGACIONES a su item correspondiente en CHECKLIST. Si todo está completo, muestra toast informativo. El modal tiene botón "Copiar al portapapeles" (con fallback execCommand para navegadores sin clipboard API). Funciones: `generarCorreo()`, `copiarCorreo()`, `cerrarCorreo()`.

**Agrupación por contadora (portal-admin.html):** Los clientes ahora se agrupan por `contadora_contabilidad` (la contadora que se reúne con el cliente) en vez de `contadora_impuestos` (la analista de impuestos). Cambio en query SELECT, `getContadorasFromClientes()`, filtro non-admin, y sort en `renderAdminIndex`.

**Archivos modificados:** portal-clientes.html, portal-admin.html.

### 2026-05-26 — Sesión de mejoras: impuestos pills, KPI semanas

**impuestos.html — Pills filtradas por analistas de impuestos:**
- Antes: pills mostraban todas las contadoras (blacklist con `CONTADORA_EXCLUIDAS`). Ahora: whitelist con `ANALISTAS_IMPUESTOS = ['Karina', 'Lovelis', 'Doriluz']`.
- `CONTADORA_ORDER` actualizado a `['Karina', 'Lovelis', 'Doriluz', 'Sin asignar']`.
- `sortContadoras()` cambiado de blacklist a whitelist.
- `getClientsForMonth()` ya no filtra por `isContadoraExcluida()`: todos los clientes con responsabilidad de impuestos aparecen en "Todas", pero solo las analistas tienen pill propia.

**kpi.html — Headers de semana con rangos de fechas:**
- Función `getWeekRanges(mesIdx)` calcula 5 semanas por mes. Semana 1 incluye los días antes del primer lunes. Resto son semanas lun-dom.
- Headers cambian de "Sem 1" a "S1" con subtexto "1-3 may", "4-10 may", etc.

**contabilidad.html — Resumen ya excluye clientes sin responsabilidad:**
- Verificado: `resBuildPendientes()` → `getClientesForContadora()` → `CLIENTES_CONTAB` (solo `responsabilidad_contabilidad=true`). No hubo cambio necesario.

**impuestos.html — Fix esAnalista() para matching por nombre completo:**
- Bug: después de la whitelist, solo aparecía Karina porque la DB guarda nombres completos ("Lovelis Guzman", "Doriluz Crisóstomo") y el filtro original usaba match exacto. Fix: `esAnalista()` usa `indexOf` case-insensitive para matching parcial.

**gerencia.html — Modelo rol+dedicación para personal:**
- Pill "Contadoras" renombrado a "Personal" (en CC tabs y BD sub-tabs).
- Modal de contadoras: reemplazado dropdown único `tipo` por dos dropdowns: `rol` (contadora/analista) y `dedicacion` (tiempo_completo/freelance).
- Tabla: columnas "Tipo" reemplazadas por "Rol" + "Dedicación". Labels con diccionarios `ROL_LABELS`/`DED_LABELS`.
- Summary cards: "Tiempo completo" reemplazado por "Contadoras" (rol=contadora) y "Analistas imp." (rol=analista).
- CSS: `.bd-tipo-impuestos { background:#fef3c7; color:#92400e }` para badge de analistas.
- Dropdown "Analista Imp." en Asignaciones: filtra `bdContadoras` por `rol === 'analista'` en vez de mostrar todas.
- Ambas copias del código actualizadas (comentada ~4585+ y activa ~4993+).

**SQL: contadoras-rol-dedicacion.sql:**
- ALTER TABLE contadoras ADD COLUMN rol TEXT DEFAULT 'contadora', ADD COLUMN dedicacion TEXT DEFAULT 'tiempo_completo'.
- Migración: plena/null → contadora+tiempo_completo, freelance → contadora+freelance, facturacion → contadora+tiempo_completo, impuestos → analista+tiempo_completo.
- Campo `tipo` no se elimina todavía (se eliminará después de verificar).

**Pendiente:** Felix debe ejecutar el SQL, registrar a Lovelis y Doriluz en la tabla contadoras con rol=analista, y subir gerencia.html + impuestos.html a GitHub.

**personal.html — Organigrama y Directorio:**
- Dos tabs nuevos: Organigrama (visual tree con Felix arriba, 4 departamentos debajo) y Directorio (tabla con nombre, cargo, departamento, email).
- `TEAM_DIRECTORY` constante con 5 departamentos (Dirección, Comercial, Implementación, Impuestos, Contabilidad), 14 personas.
- Milka Paulino y Doriluz Crisóstomo incluidas con badge "Freelance".
- Botón "Copiar todos los correos" copia los 14 correos separados por punto y coma.
- Clic en cualquier correo individual lo copia al portapapeles con toast de confirmación.
- Correos generados con patrón inicial+apellido@accountone.do.
- Tab activo por defecto sigue siendo Wow Board.
- Subtítulo del header cambiado a "Equipo, directorio y reconocimiento".

### 2026-05-26 — Sesión continuación: Resumen impuestos, personal, contabilidad

**contabilidad.html — Filtro inicio_responsabilidad_fiscal:**
- Clientes con `inicio_responsabilidad_fiscal` en el futuro no aparecen en Resumen ni checklist para meses previos a su fecha de inicio.
- `INICIO_FISCAL` lookup map + `clienteActivoEnMes(clienteNombre, mesIdx)` filtra en ASIGNACIONES y `resBuildPendientes()`.
- Ejemplo: Constructora Leidomi (julio) e ICSAN (junio) no aparecen en mayo.

**personal.html — Correcciones de posiciones:**
- Lissette → Implementadora 1, Claudia → Implementadora 2, Naomi → Business Developer.
- Karina → Subgerente de impuestos, Lovelis → Analista de impuestos 1, Doriluz → Analista de impuestos 2.
- Morelia/Taina/Milka → Contadora 2 (Beliani/Yessica/Victoria siguen como Contadora 1).

**impuestos.html — Tab Resumen (nuevo):**
- Tab "Resumen" como primera pestaña (antes de Checklist y KPI). Se muestra por defecto al entrar.
- Chart.js CDN agregado.
- Greeting dinámico, tarjetas de urgencia (urgente/por vencer/próximo), insights para admin, charts por impuesto y por cliente.
- Urgencia basada en deadline del impuesto: urgente = pasado deadline, vencido = 0-3 días, próximo = 4-7 días.
- Una declaración se considera "pendiente" si el último paso de su CHECKLIST_ITEMS no está completo.
- Admin (tengoPermiso edición): ve todas las analistas con pills de filtro. Individual: solo ve sus propios clientes.
- Secciones agrupadas por analista→cliente con tabla de impuesto/mes/límite/días.
- Variable `resAnalista` para filtro de pills del resumen (independiente de `selectedContadora` del checklist).

### 2026-05-18 — Tab Resumen en contabilidad.html (rediseño completo)

**Cambio solicitado por Félix:** Nuevo tab "Resumen" como primera pestaña en contabilidad.html. Rediseño inspirado en el dashboard de gerencia.html: vista personal para cada contadora, agrupado por cliente.

**Diseño visual:**
- Greeting header (navy, "Buenas tardes, Lissette") con resumen de pendientes.
- Tres tarjetas de urgencia: Urgente (10+ días, rojo), Vencido (1-9 días, ámbar), Próximo a vencer (5 días antes del deadline, azul).
- Dos gráficos Chart.js: barras horizontales por tipo de impuesto + dona por cliente (top 8).
- Secciones agrupadas por cliente: cada cliente es un card colapsable con sus items pendientes dentro, mostrando el label completo ("Subir autorizacion de pago de TSS"), mes, y días de atraso.
- Notas CRUD al final.

**Vista personal:** Contadoras solo ven sus propios clientes (filtro por `userName.includes(contadora)`). Admin ve todo con pills de contadora para filtrar.

**Funciones nuevas:** `getGreeting()`, `getResFirstName()`, `resBuildPendientes()` (retorna {pendientes, proximos}), `resRenderCategorySection()` (agrupa por cliente), `resRenderProximoSection()`, `resRenderCharts()`.

**Otros cambios:**
- Labels de autorización unificados a "Subir autorizacion de pago de [X]" (6 items).
- `currentUserId` global seteada en `loadUserProfile()`.
- `getClientesForContadora(contadora)` para obtener clientes de CLIENTES_CONTAB sin depender del mes.
- `showToast()` + div toast + CSS + Chart.js CDN agregados.
- `loadNotasContadora()` en `Promise.all` de `showApp()`.
- Bug fix: deadline ahora usa `getDeadlineDate()` que respeta `mesRel` (TSS de abril vence el 3 de mayo, no el 3 de abril).

**SQL nuevo:** `db/notas-contadora-setup.sql` — CREATE TABLE notas_contadora con RLS por grupos.

---

### 2026-05-18 — Presupuesto MSH: eliminar Obra y % dinámico

**Cambio solicitado por Félix:** Simplificar el presupuesto de MSH quitando la sección "Obra" (violeta, con Ingreso de Obra / Costos de Obra / Resultado de Obra) y el porcentaje dinámico que aparecía en la label de Gastos (ej: "Gastos (42%)"). Ahora la label dice solo "Gastos".

**Archivos modificados:**
- portal-admin.html: eliminado `gastosPctLabel`, eliminada sección Obra del render, eliminados inputs de Obra en `renderAdminDatosSimple`, limpiados `pmUpdateSimpEjFields` y `pmSaveEjecucionSimple` (ya no preservan/guardan ingreso_obra/costos_obra), limpiada función de save de ejecución regular.
- portal-clientes.html: sincronizado con los mismos cambios visuales (read-only). Eliminada sección Obra, eliminada variable `gastosPctLabel`, reemplazadas 4 referencias por 'Gastos'.

**Nota:** Las columnas `ingreso_obra` y `costos_obra` siguen existiendo en la tabla `portal_ejecucion` de Supabase. No se eliminaron a nivel de BD, simplemente ya no se leen ni escriben desde el frontend.

---

### 2026-05-15 — Editar/eliminar notas en impuestos.html

Se agregaron botones Edit y Eliminar a cada nota en el modal de notas del checklist ITBIS. Edición inline con textarea, marca la fecha con "(editado)". Eliminar pide confirmación. Funciones: `editNota()`, `cancelEditNota()`, `saveEditNota()`, `deleteNota()`. CSS: `.nota-actions`, `.nota-btn-edit`, `.nota-btn-del`, `.nota-edit-area`.

### 2026-05-15 — Fix RLS rutas anidadas (bug permisos Lovelis)

**Bug encontrado:** Lovelis (contadora de impuestos) no podía guardar el checklist de impuestos. Error 403 de Supabase. La causa raíz: desacople entre la estructura de permisos que guarda usuarios.html (anidada: `impuestos → checklist → adicion`) y la que buscan las políticas RLS (plana: `impuestos → adicion`). El frontend `tengoPermiso()` navega correctamente la estructura anidada, así que la UI permite editar, pero el RLS de Supabase rechaza la escritura.

**Fix global:** Script `db/fix-all-rls-nested.sql` que actualiza las políticas RLS de 5 tablas para buscar en ambas rutas (plana como fallback + anidada). Tablas afectadas: impuestos_checklist, implementaciones_completas, implementaciones_fe, impl_checklist_fe, impl_checklist_adm. Además, impl_checklist_adm se migra del sistema viejo (get_my_role()) al sistema de grupos.

**SQL pendiente:** `db/fix-all-rls-nested.sql` (reemplaza el anterior fix-impuestos-rls-nested.sql que solo cubría impuestos).

### 2026-05-14 — Checkboxes impl en modal Software + pasos ITBIS con notas

**Checkboxes FE/Adm en modal Software (gerencia.html):** Se agregaron los mismos checkboxes de implementación que existen en el modal de Outsourcing. Al guardar un cliente Software con checkbox marcado, se crea el checklist en impl_checklist_fe (15 pasos) o impl_checklist_adm (18 pasos). Ambas copias de swSaveClient actualizadas. Los checkboxes se deshabilitan si el checklist ya existe.

**Nuevos pasos ITBIS (impuestos.html):** Se agregaron "Borrador devuelto" y "Borrador recibido corregido" después de "Borrador presentado por contadora" en el checklist ITBIS. Ambos pasos tienen soporte de notas históricas: botón en columna dedicada que abre modal con historial de notas (texto + fecha + usuario) y campo para agregar nuevas. Las notas se almacenan en el campo JSONB `datos` existente, dentro de cada item: `datos[itemId].notas = [{texto, fecha, usuario}]`.

**Archivos modificados:** gerencia.html, impuestos.html.

---

### 2026-05-14 — Modal outsourcing reorganizado + fechas impl separadas FE/Adm

**Cambio visual del modal de clientes Outsourcing en gerencia.html:** La sección "Servicio contratado" se reorganizó en subsecciones claras: Contabilidad (tipo de servicio + transacciones), Licencia (licencia Adm), Implementación (servicio + 4 campos de fecha). Se creó sección nueva "Checklist de servicios" con Contabilidad (responsabilidad + contadora), Impuestos (responsabilidad + contadora) e Implementación (checkboxes FE/Adm). La sección Fechas ahora solo tiene fecha de entrada e inicio responsabilidad fiscal.

**Fechas de implementación separadas:** Se reemplazó el par único (fecha_inicio_impl, fecha_fin_impl) por 4 campos: fecha_inicio_impl_fe, fecha_fin_impl_fe, fecha_inicio_impl_adm, fecha_fin_impl_adm. Esto permite calcular riesgo independiente para cada tipo de checklist. `ccBuildImplDates` y `ccImplIsEnRiesgo` actualizados con estructura `{inicio_fe, fin_fe, inicio_adm, fin_adm}`. implementaciones.html actualizado con la misma estructura.

**Modal software actualizado:** Se agregó servicio_impl (dropdown FE/FE+Adm) y 4 campos de fecha separados al modal de clientes Software, misma estructura que Outsourcing. ccLoadSoftwareClientes y bdLoadSoftware ahora mapean los campos nuevos. implementaciones.html lee las 4 columnas separadas de ambas tablas.

**SQL pendientes:** `db/impl-dates-separadas.sql` (4 columnas nuevas en tabla clientes + migración), `db/impl-dates-separadas-software.sql` (servicio_impl + 4 columnas nuevas en clientes_software + migración de datos existentes a _fe).

**Archivos modificados:** gerencia.html, implementaciones.html.

---

### 2026-05-14 — Fixes varios + fechas de implementación en clientes

Varios fixes y una feature nueva:

1. **KPI permisos (contabilidad.html):** Las contadoras con permiso de edición en KPI podían ver el KPI de todas las contadoras. Se creó `isKpiAdmin()` que distingue admin (ve todos) de contadora (solo ve el suyo). La contadora se detecta comparando userName contra KPI_CONTADORAS.

2. **Tab Resumen en implementaciones.html:** Nueva pestaña por defecto que muestra stats (Total activas, FE, Adm, En riesgo) y tabla unificada con progreso y badges de tipo/riesgo. Replica la vista que existe en gerencia.html > Clientes > Implementaciones.

3. **Búsqueda pierde foco (gerencia.html):** El oninput de los inputs de búsqueda en Outsourcing y Software hacía un re-render completo que destruía el DOM del input. Fix: funciones helper (clSearchInput, swSearchInput, swSearchCrudInput) que re-renderizan y luego refocusean el input por ID.

4. **Fechas de implementación en modales de clientes (gerencia.html):** Se agregaron campos fecha_inicio_impl y fecha_fin_impl al modal de Software. El modal de Outsourcing ya los tenía. Ambos modales leen y guardan las fechas. Se creó `ccBuildImplDates()` que construye el mapa de fechas desde bdClientes + ccSOFTWARE_CLIENTES (ya no lee de la tabla `implementaciones`). Se llama después de cargar clientes y después de cada save.

5. **implementaciones.html actualizado:** `loadData()` ahora lee fechas de impl desde `clientes` y `clientes_software` en vez de la tabla `implementaciones`.

**SQL pendiente:** `db/impl-dates-software.sql` — agrega fecha_inicio_impl y fecha_fin_impl a clientes_software.

**Archivos modificados:** gerencia.html, contabilidad.html, implementaciones.html, db/impl-dates-software.sql.

---

### 2026-05-14 — Pill "Link Dashboard" cambiado a dashboard TV

Félix indicó que los links de portal de clientes (tokens) ya están en el módulo Portal de Clientes y no deben repetirse aquí. El pill "Link Dashboard" ahora muestra la URL del dashboard público (dashboard-publico.html), el que se usa en la televisión de la oficina. Vista simple: ícono de monitor, campo readonly con la URL, botón Copiar, y link para abrir en nueva pestaña. Se eliminó bdLoadTokens, bdTokens, y su llamada en showApp.

**Archivos modificados:** gerencia.html.

### 2026-05-14 — Resumen de Implementaciones reescrito

Felix pidió eliminar las cards detalladas de implementación (Dior Legal, Igsan, etc.) que venían de la tabla `implementaciones`. El Resumen del pill Implementaciones ahora se alimenta exclusivamente de los checklists que llenan las implementadoras (`impl_checklist_fe` e `impl_checklist_adm`).

Stats cards: Total activas, Impl. FE, Impl. Adm, Por iniciar (0%), En riesgo. Tabla unificada con tipo (FE/Adm), progreso, pasos, y badge de estado. Criterio de riesgo: avance < 40% cuando pasó > 50% del tiempo (cruzando con fechas inicio/fin de la tabla `implementaciones`).

Eliminados: `ccIMPLEMENTACIONES`, `ccSOLO_IMPLEMENTACION`, `ccIMPLEMENTACIONES_RIESGO`, `ccRenderImplCard`, `ccGetImplStatus`, `ccFormatFecha`, `ccDiasRestantes`, CSS de `.impl-card`. `ccLoadImplementaciones` simplificada: solo carga fechas inicio/fin por cliente para el cálculo de riesgo.

**Archivos modificados:** gerencia.html.

### 2026-05-14 — Fase 5 cerrada: validación en vivo completada

Sub-fase E completada. Los 8 pills de gerencia.html validados en portal-accountone.vercel.app:
- Dashboard: stats de outsourcing, chart, resumen mensual OK
- Outsourcing: analytics + toggle CRUD con tabla, modales, búsqueda OK
- Software: analytics con pills de licencia + toggle CRUD OK
- Implementaciones: sub-pills Resumen/Checklist FE (2/15)/Checklist Adm (0/18) OK
- Contadoras: tabla maestra con 7 contadoras, CRUD OK
- Asignaciones: grid editable con dropdowns, stats OK
- Link Dashboard: URL del dashboard TV con botón copiar OK
- Facturación: facturas del mes con cambios outsourcing/software OK

Fase 5 cerrada en plan.md.

### 2026-05-13 — Fase 5 Sub-fase D: catálogo MODULOS en usuarios.html

Actualizado el array MODULOS en usuarios.html para reflejar la nueva estructura de 8 pills de gerencia. Cambios de labels: Servicios→Outsourcing, Implementación→Implementaciones, Links portal→Link Dashboard. Subtabs reordenados (Software antes de Implementaciones dentro de `clientes`). Los IDs se mantienen idénticos para no romper los permisos ya guardados en Supabase.

**Archivos modificados:** usuarios.html.

### 2026-05-13 — Fase 5 Sub-fase C: sub-pills Implementaciones FE/Adm

**Qué se hizo:**
- Pill Implementaciones ahora tiene 3 sub-pills internos: Resumen (vista original) | Checklist FE | Checklist Adm
- Datos cargados de `impl_checklist_fe` y `impl_checklist_adm` en paralelo al iniciar
- Variables: `ccImplSubPill`, `ccImplFEData`, `ccImplAdmData`
- Funciones: `ccLoadImplFE()`, `ccLoadImplAdm()`, `ccImplSwitchPill()`, `ccRenderImplChecklist()`, `ccCalcImplProgress()`, `ccImplProgressColor()`
- Arrays de labels: `FE_ITEMS_GER` (15 pasos) y `ADM_ITEMS_GER` (18 pasos) con nombres exactos
- Vista checklist: tabla read-only con Cliente, Implementadora, barra de progreso, pasos completados
- Colores: muted (0%), red (<50%), amber (<100%), green (100%)
- `ccNavigateMain()` resetea `ccImplSubPill = 'resumen'` al cambiar de pill

**Estado Sub-fase C:** Todos los 8 pills migrados y funcionales. Pendientes menores en Outsourcing (reordenar stats, bloques Nuevos/Churn en vista analítica).

**Archivos modificados:** gerencia.html.

### 2026-05-13 — Fase 5 Sub-fases B+C: migración CRUD Outsourcing y Software

**Sub-fase B+C parcial (sesión anterior):** Se crearon 8 pills en el módulo CC (Dashboard, Outsourcing, Software, Implementación, Contadoras, Asignaciones, Link Dashboard, Facturación). Se migraron Contadoras, Asignaciones y Link Dashboard desde el bloque BD comentado.

**Sub-fase C completa (esta sesión):** Migradas funciones CRUD de Clientes Outsourcing y Clientes Software desde el bloque comentado (líneas ~3152-4665).

**Qué se migró:**
- Variables: `bdClientes`, `bdPendientes`, `bdSoftwareClientes`, `bdClMes`, `bdSwMes`, `clSearch`, `clEditingId`, `clFilter`, `clModalActivo`, `clOrigContab`, `clOrigImp`, `clPendienteId`, `swSearch`, `swEditingId`, `swFilter`, `swModalActivo`, `swPendienteId`.
- Data loading: `bdLoadClientes()`, `bdLoadPendientes()`, `bdLoadSoftware()`, `bdDismissPendientes()`.
- Outsourcing CRUD: `bdRenderClientes()`, `bdSwitchClMes()`, `clSetFilter()`, `bdGetClientesForMes()`, `clFormatDate()`, `clPopulateContadoraSelects()`, `clRenderActivoBtn()`, `clToggleActivo()`, `clToggleQuedaAdm()`, `clOnFechaSalidaChange()`, `clCheckContadoraChanged()`, `clOpenModal()`, `clEditClient()`, `clCloseModal()`, `clShowHistory()`, `clSaveClient()` (con wrapper de pendientes), `clCreateFromPendiente()`.
- Software CRUD: `bdRenderSoftwareCrud()` (renombrada de `bdRenderSoftware` para evitar conflicto), `bdSwitchSwMes()`, `swGetClientesForMes()`, `swSetFilter()`, `swOpenModal()`, `swEditClient()`, `swDeleteClient()`, `swCloseModal()`, `swSaveClient()`, `swCreateFromPendiente()`, `swToggleActivo()`, `swRenderActivoBtn()`.

**Adaptaciones realizadas:**
1. Todas las funciones render usan `document.getElementById('cc-content')` en vez de `'bd-content'`.
2. `bdLoadClientes()` carga `select('*')` y sincroniza `ccAllClientes = bdClientes` para que las vistas analíticas usen los mismos datos.
3. `bdLoadSoftware()` carga y sincroniza `ccSOFTWARE_CLIENTES` con el formato mapeado que esperan las vistas analíticas.
4. `bdRenderSubTabs()` y `bdRenderAll()` NO se migraron (ya no existen sub-tabs de BD).
5. En el wrapper de `clSaveClient`, se eliminó la referencia a `bdRenderSubTabs()`.
6. `showApp()` carga `bdLoadClientes()` y `bdLoadSoftware()` después de `ccLoadData()` para que BD sea la fuente autoritativa.

**Toggle analytics/CRUD:**
- Nuevas variables `ccServView` y `ccSwView` ('analytics' o 'crud').
- `ccRenderServicios()` y `ccRenderSoftware()` verifican el view mode y delegan a `bdRenderClientes()` / `bdRenderSoftwareCrud()` cuando es 'crud'.
- Botón "Base de datos" en la barra de month-tabs de las vistas analíticas.
- Botón "Volver a vista analítica" al inicio de las vistas CRUD.
- `ccNavigateMain()` resetea ambos toggles a 'analytics' al cambiar de pill.

**Modales:** Los HTML de modales (`cl-modal-overlay`, `sw-modal-overlay`, `cl-hist-overlay`) ya existían fuera del bloque comentado. No se tocaron.

**Bloque comentado:** No se modificó. Sigue en líneas ~3152-4665 como referencia.

### Entrada 2026-05-13 — Correcciones varias + Fase 5 Sub-fase A

**Correcciones realizadas:**
- personal.html: corregido nombre "Lissete Peña" → "Lissette Peña" (doble t).
- implementaciones.html: corregido nombre "Lisete Peña" → "Lissette Peña" + botón "Eliminar checklist" en vista detalle (solo con permiso de edición).
- usuarios.html: agregados roles marketing y cobros al dropdown de invitación + ROLE_GRUPO mapping. Filtro de departamento ahora usa renderUsuariosOnly() en vez de recargar todo.
- portal-admin.html: fix switchMainTab() para llamar renderAdminNav() y limpiar pills al cambiar de tab (bug del Calendario).
- impuestos.html: fix ocultar navArea (pills mes/contadora) al entrar en vista detalle de cliente.

**Nuevos roles:**
- marketing y cobros agregados a profiles_rol_check constraint en Supabase.
- Función invite_user() recreada con los roles nuevos.
- SQL: db/add-roles-marketing-cobros.sql (ejecutado).

**Fase 5 Sub-fase A (cerrada):**
- Versionado: gerencia.html copiado a pages/version-anterior/gerencia-2026-05-20.html.
- Eliminado módulo top-level "Base de Datos" del HTML (div bd-area), del array de tabs, de switchGerTab() y de showApp().
- Funciones BD (~líneas 3114-4627) comentadas con `/* PENDIENTE MIGRAR */` para reutilizar en Sub-fase C.
- Links Portal (bdGetPortalBaseUrl, bdRenderLinks, bdCopyLink, bdCopyAllLinks, bdRenderLinkDashboard, bdCopyDashLink) eliminado completamente (no se migra).
- CSS de BD dejado intacto para reutilización.

**Archivos modificados:** gerencia.html, implementaciones.html, impuestos.html, portal-admin.html, usuarios.html, personal.html.

### 2026-05-13 — Calendario de entregas (portal-admin + portal-clientes)

Nuevo tab **Calendario** en ambos portales. Dos sub-vistas: **Resumen** (tabla con fechas límite + accordion que expande tareas al hacer clic en cada obligación) y **Vista mensual** (timeline cronológico con pills de mes, agrupado por día).

**Obligaciones incluidas:** TSS, IR-3, IR-17, Anticipo ISR, ITBIS. Los datos están hardcodeados en JS (no Supabase) porque son reglas fijas del calendario fiscal.

**Tareas por obligación (dictadas por Felix, corregidas iterativamente):**
- TSS (5): informar novedades nómina (D25, tarde D30), cargar nómina (D25, tarde D30), volantes pago (D30, tarde D3), recibir autorización TSS (D1, AO), pagar TSS (D1, AO)
- IR-3 (2): enviar autorización IR-3 (D5, AO), confirmar recibido y pagar IR-3 (D5, cliente, tarde D10)
- IR-17 (7): informar pagos informales (D1, tarde D6), cargar Excel informales (D1, tarde D6), cargar volantes informales (D1, tarde D6), registrar gastos proveedores (D3, AO), borrador IR-17 (D5, AO), enviar borrador (D5, AO), pagar IR-17 (D5, cliente, tarde D10)
- Anticipo (2): enviar autorización (D10, AO), recibir y pagar anticipo (D10, cliente, tarde D15)
- ITBIS (8): cargar facturas en Basecamp (semanal, tarde D30), registrar facturas en Adm (diario, AO), cargar Excel facturas (D30, tarde D5, nota facturas tardías), estados de cuenta bancos (D5, tarde D10), confirmar facturas atrasadas (D5, tarde D20), recibir borrador ITBIS (D16-20, AO), aprobar borrador (D15, tarde D16-20), pagar ITBIS (D16, tarde D16-20)

**Decisiones de diseño:**
- Solo 2 vistas: **Resumen** + **Cómo se ve un mes** (renombrado de "Vista mensual").
- "Tareas por obligación" se fusionó como accordion dentro del resumen.
- Columnas del resumen: Obligación → A tiempo (verde) → Tarde (ámbar) → AO procesa (azul) → Límite DGII (rojo) → Tareas/Resp.
- Cada tarea de cliente tiene fechaTarde (todas rellenas, sin celdas vacías).
- Responsable Cliente en verde, Account One en azul.
- ITBIS tiene nota de advertencia sobre facturas tardías.

**"Cómo se ve un mes" (segunda vista):**
- 3 pills de perspectiva: Cliente, Account One, DGII (reemplazan los 12 pills de meses).
- **Cliente** muestra responsabilidades del cliente + fechas límite DGII.
- **Account One** muestra solo tareas de la firma.
- **DGII** muestra solo fechas límite.
- Fondo blanco con bordes sutiles, badges de color suave (verde cliente, azul AO, rojo DGII).
- Cliente ITBIS movido a día 18 (antes día 20) para dar margen antes del límite DGII.

**Timeline entries AO (versión final):**
- D29: Procesamiento de TSS
- D30: Procesamiento de todas las facturas del mes
- D1: Subir autorización de pago de TSS (separado)
- D1: Subir autorización de pago de anticipo (separado)
- D5: Enviar borrador de IR-17
- D10: Confirmar que el cliente no tiene facturas atrasadas y que tenemos NCF de bancos
- D15: Enviar borrador ITBIS

**Timeline entries Cliente (versión final):**
- D25: Nómina y documentos de personal
- D30: Volantes de nómina y facturas en Basecamp
- D1: Documentación de proveedores informales
- D5: Estados de cuenta bancarios y día tope para entrega de facturas del mes anterior
- D18: Aprobación de borrador y pago de ITBIS

**Timeline entries DGII:**
- D3: Fecha límite de pago de TSS
- D10: Fecha límite de pago IR-3 e IR-17
- D15: Fecha límite de pago anticipo ISR
- D20: Fecha límite de pago de ITBIS

**Otros cambios de esta sesión (2026-05-13):**
- ventas.html: queries de loadData() y loadChecklistComercial() ahora corren en paralelo con Promise.all (performance).
- personal.html: corregido nombre "Lissette Peña" → "Lissette Peña".

**Archivos modificados:** portal-admin.html, portal-clientes.html, ventas.html, personal.html.

---

### 2026-05-13 — Fix sub-tabs sin filtro de permisos en gerencia.html

Se descubrió que las funciones `ccRenderMainTabs()` y `bdRenderSubTabs()` renderizaban TODAS las pills sin verificar permisos. Naomi (Comercial) veía Dashboard de clientes, Contadores y Asignaciones en BD, aunque su grupo los tenía en `consulta=false`.

**Fix:** Se agregó `.filter()` con `tengoPermiso()` a ambas funciones. Si el tab activo queda oculto, se auto-selecciona el primero visible. Para BD, se usa un mapa `permKey` porque los IDs de pills no coinciden 1:1 con los keys de permisos (ej: pill `links` → permiso `links-portal`).

**SQL ejecutado:** `db/fix-grupos-permisos-keys.sql` — renombra claves viejas en JSONB (`control-clientes`→`clientes`, `control-contadoras`→`contadoras`, `fact-electronica`→`checklist-fe`, `impl-completa`→`checklist-adm`, módulo `usuarios`→`configuracion`) y agrega módulo `personal` + screens faltantes.

**Estado `usuario_grupos`:** Tabla estaba vacía. Felix asignó usuarios a grupos manualmente desde usuarios.html.

### 2026-05-13 — Fase 9 Sub-fases A-D completadas: migración a tengoPermiso()

**Sub-fase A:** Catálogo MODULOS actualizado en usuarios.html con los 10 módulos reales. HABILIDADES reducidas a 2 (Ver/Editar). Colspan ajustado.

**Sub-fase B (piloto contabilidad.html):** Snippet compartido `loadMisPermisos()` + `tengoPermiso()` agregado. Patrón: query usuario_grupos → grupos → merge aditivo de JSONB permisos. Admin bypass dentro de tengoPermiso. Migradas 11 referencias a userRole.

**Sub-fase C (index.html sidebar):** `hasPermiso()` y `tieneAccesoModulo()` implementadas. Sidebar filtrado por permisos de grupo en vez de roles estáticos. MENU.filter usa tieneAccesoModulo() que busca cualquier consulta=true recursivamente.

**Sub-fase D (todos los módulos):** Migración completa. Cada módulo tiene su propio snippet loadMisPermisos/tengoPermiso (porque corren en iframes independientes). Módulos migrados:
- contabilidad.html, impuestos.html, personal.html, implementaciones.html, ventas.html, gerencia.html, portal-admin.html, portal-clientes.html, checklist.html, kpi.html, usuarios.html

**Mapeo de permisos por módulo:**
- gerencia → contadoras: consulta (ver tab), edicion (vista gerencial vs contadora)
- gerencia → basedatos: edicion con subtabs clientes/contadoras/asignaciones
- comercial → roas: consulta (ver costos/ROAS, si no tiene = isVentas)
- comercial → movimiento/checklist: consulta (ver tabs)
- portal-admin/portal-clientes: checklist/presentacion-mensual → consulta (acceso), edicion (isAdminMode)
- configuracion → grupos/usuarios: consulta (ver), edicion (invitar usuarios)

**Pendiente Sub-fase E:** Verificación en vivo, limpieza de `roles:` en MENU de index.html, verificar que todos los usuarios tengan grupos asignados, test completo.

### Fase 9 — Tareas pendientes para cerrar

1. **Revisar cada módulo con usuario no-admin.** Entrar como Naomi (Comercial) y recorrer: ventas (pipeline sin montos ROAS, checklist visible, movimiento oculto), gerencia (solo sub-tabs permitidas), portal-clientes, portal-admin. Luego entrar como contadora y verificar contabilidad, impuestos, implementaciones.
2. **Ajustar permisos de grupos según lo que Felix quiera.** El grupo Comercial tiene `roas.consulta=true` lo cual muestra montos de venta. Felix confirmó que no debería. Falta corregir desde la UI de usuarios.html.
3. **Limpiar `roles:` del array MENU en index.html.** Las propiedades `roles:` ya no se usan (el sidebar usa `tieneAccesoModulo()`), pero siguen en el código. Eliminarlas para no confundir.
4. **Verificar que el editor de grupos en usuarios.html refleje el catálogo actual.** Confirmar que los toggles mapean correctamente a las claves JSONB nuevas (post-rename).
5. **Probar flujo completo de un usuario nuevo:** crear usuario → asignar grupo → login → verificar sidebar → verificar accesos por módulo.
6. **Documentar el sistema de permisos** para que el equipo de Account One entienda cómo funciona: qué es un grupo, cómo se asignan, qué controla cada toggle.
7. **Wow Board muestra menos personas de las que debería.** El array `TEAM_DEPARTMENTS` en personal.html define quién aparece en el tablero. Verificar que incluya a todo el roster actual (incluyendo Michelle Dijool, marketing externa). Comparar con el roster de arriba.
8. **Crear usuarios del portal para todo el equipo.** Según el roster, faltan usuarios para: verificar quiénes no tienen cuenta en profiles y crearlas. Asignar a su grupo correspondiente en usuario_grupos.

### 2026-05-13 — Checklist Adm funcional, toggle tabla/cuadros en ventas

**1. Checklist Adm (implementaciones.html):**
- Tab "Checklist Adm" ahora funcional (antes decía "Próximamente").
- 18 pasos en 4 grupos: Onboarding (1-3), Gerencia (4), Implementación (5-13), Transición (14-18).
- Pasos: correo presentación, sesión agendada, cuenta base, cuenta Adm (gerencia), sesiones 1-4, plantillas (recepción/revisión/carga), go live, firmas actas 1-4, firma go live, asignación contadora, correo contadora, link reunión contadora, sesión 5 presentación, encuesta satisfacción.
- Refactor: funciones helper `getItems()`, `getGroups()`, `getTotalSteps()`, `getTableName()`, `getRows()` para que todo el código sea tab-aware. Ya no hay referencias hardcoded a FE_ITEMS ni allRows.
- Tabla nueva: `impl_checklist_adm` (misma estructura que impl_checklist_fe).
- SQL: `db/impl-checklist-adm-setup.sql`.

**2. Gerencia → Checklist Adm:**
- Checkbox "Adm" habilitado en modal de cliente (antes estaba disabled).
- Al guardar con checkbox marcado, crea entrada en `impl_checklist_adm` (18 pasos vacíos).
- Si ya existe, aparece marcado y deshabilitado con "✓ Ya tiene checklist Adm creado".

**3. Ventas — toggle tabla/cuadros en checklist comercial:**
- Event listeners para `.chk-view-toggle-btn` y filas de tabla conectados.
- Misma estructura que contabilidad: botones Tabla/Cuadros con state `APP.chkViewMode`.

### 2026-05-13 — Plan Fase 9: migración a permisos por grupo

**Decisión:** migrar toda la UI del portal de `profiles.rol` a `hasPermiso()` con el sistema de grupos que ya existe. Felix confirmó:
- Cada módulo consulta grupos directamente (no postMessage).
- Granularidad: tabs/secciones + botones de acción (2 habilidades: consulta y edición).
- Sidebar también controlado por permisos.
- `profiles.rol` se mantiene solo para RLS de Supabase.
- Catálogo hardcodeado.

El catálogo MODULOS en usuarios.html está desactualizado: faltan Personal, Facturación, Checklist comercial, Movimiento. Implementaciones tiene la estructura vieja. Plan completo con 5 sub-fases en `docs/plan.md` (Fase 9).

### 2026-05-12 — Implementaciones rewrite, N/A toggles, Wow Board, checklist desde gerencia

**1. Implementaciones.html — reescritura completa:**
- Ahora tiene dos tabs: Checklist FE (activo) y Checklist Adm (próximamente).
- Tabla nueva `impl_checklist_fe`: per-client (no mensual), JSONB `datos` con 15 pasos, columna `notas`.
- Pills de implementadoras: Claudia Carrion, Lissette Peña.
- 15 pasos de FE agrupados: Servicio (Esmeralda, 1-3), Gerencia (Felix, 4-5), Implementación (6-15).
- Toggle Si/No/N/A por paso. N/A cuenta como completado.
- Vista detalle con progress bar, botón guardar arriba (no abajo), campo de notas.
- Vista listado con toggle tabla/cuadros y botón "Agregar checklist".
- **Bug resuelto:** el agente escribió `profiles.select('role, full_name')` pero la tabla tiene `rol` y `nombre`. Corregido.

**2. Checklist de implementación desde gerencia.html:**
- Modal de cliente: sección "Checklist de implementación" con checkboxes (FE y Adm disabled).
- Al marcar FE y guardar, se crea automáticamente la entrada en `impl_checklist_fe`.
- Si el cliente ya tiene checklist, el checkbox aparece marcado y deshabilitado con "✓ Ya tiene checklist FE creado".
- El nombre del cliente se toma exactamente del modal (evita inconsistencias de nombres).

**3. N/A toggle (contabilidad.html + impuestos.html):**
- Tercer botón "N/A" (violeta, #5b21b6) en checklist de responsabilidades y obligaciones.
- Estado `'na'` (string) junto a `true`/`false`. Cuenta como completado para progreso.
- CSS: `.toggle-opt.active-na { background:#f5f3ff; color:#5b21b6; border-color:#c4b5fd; }`

**4. Wow Board (personal.html):**
- Cards reducidas (minmax 220px, gap 10px, padding compacto).
- Tab renombrado: "Tablero" → "Wow Board".
- Heading dinámico: "🎉 Va ganando [nombre] con X puntos 🏆🔥".

**5. Ventas → Implementaciones bridge:**
- `dbCreateImplFEFromLead()`: al cerrar lead como "Ganado" con categoría "Facturacion Electronica", auto-crea en `impl_checklist_fe`.

**6. Nota ISR vs Activos (portal-admin + portal-clientes):**
- Rediseño estilo CRS (navy background, pill con total en amarillo, asterisco).
- Tamaño reducido, margin-bottom 24px antes de anticipos.

### 2026-05-12 — Dashboard TV, tipo contribuyente, fixes ventas, módulo Personal

**1. Dashboard TV (dashboard-publico.html):**
- Rediseño completo: layout dos columnas (chart + listas), chart con eje Y y grid lines.
- Pills renombrados: "Nuevos 2026", "Churn 2026". Título: "Clientes y Churn".
- Headers de tabla (nombre, servicio, transacciones, fecha) con tamaño intermedio entre título y nombres.
- `renderChart()` reemplaza `renderVBars()`: barras absolutas con calc(), Y-axis dinámico.

**2. Tipo contribuyente (portal-admin + portal-clientes):**
- Selector en form de impuestos: empresa (12 anticipos mensuales, tramo 1+2) vs persona física (3 cuotas jun/sep/dic).
- Persona física: ISR ÷ 3. Se reutiliza anticipo_tramo1 como cuota. Tramo 2 se oculta.
- Ambos portales: condicional en renderProyeccionDetail(), tablas de anticipos, summary pills.
- Amarillo de proyección cambiado de #fefce8 a #fef08a (más visible).
- SQL: `ALTER TABLE portal_impuestos_config ADD COLUMN tipo_contribuyente TEXT NOT NULL DEFAULT 'empresa'`.

**3. Fixes ventas.html:**
- **Delete con await:** `dbDeleteLead` ahora retorna boolean, handler es `async` con `await`. Evita ghost leads.
- **Demo date → mes:** Al editar un lead, si la fecha demo apunta a otro mes, mueve el lead. Handler es `async`, update de `mes` con `await`.
- **Nuevo lead con demo:** Al crear lead con fecha demo, deriva `targetMonth` del demo en vez de usar `APP.currentMonth`.

**4. Módulo Personal (personal.html) — NUEVO:**
- Sistema Wow Points: reconocimiento del equipo con puntos variables (50 o 100).
- Al llegar a 1,000 puntos → bono de RD$3,000, ciclo se reinicia.
- Naomi (rol comercial) y admin pueden dar puntos y registrar pagos. RLS: `get_my_role() IN ('admin', 'comercial')`.
- Todo el equipo puede ver el tablero (cards con barra de progreso) y el historial.
- Tabs: Tablero (cards por departamento) + Historial (tabla con filtro).
- Tabla Supabase: `wow_points` con campo `empleado TEXT` (nombre, no UUID). No depende de profiles.
- `TEAM_DEPARTMENTS` en frontend define el roster por departamento.
- index.html: "Personal" agregado al sidebar, visible para todos los roles.

**Equipo Account One (mayo 2026) — Roster completo:**
- **Comercial:** Felix Rosa, Naomi Villar
- **Implementación:** Claudia Carrion, Lissette Peña
- **Impuestos:** Karina Sánchez, Lovelis Guzman
- **Contadoras:** Beliani Brito, Yessica Diaz, Victoria Vasquez, Taina Ramirez, Morelia Matos
- **Marketing (externa):** Michelle Dijool
- **Excluidas de Wow Points:** Milka (su servicio no aplica)
- **Ya no están:** Maurice, Yolenny

### 2026-05-11 — Acceso comercial + pill Total software + checklist compartido

**1. Acceso rol comercial a módulos:**
- index.html: sidebar — gerencia y portal-clientes ahora accesibles para rol 'comercial' (agregado al array `roles`).
- gerencia.html: `renderGerMainTabs()` filtra tab "Contadoras" para comercial. Solo ve "Clientes" y "Base de Datos". Botones de edición ya estaban protegidos con `if (userRole === 'admin')`.
- ventas.html: tab Checklist ahora visible para comercial. Condición cambiada de `!== 'comercial'` a `=== 'admin' || === 'comercial'`.
- portal-clientes.html: 'comercial' agregado a `allowedRoles` (antes solo admin/contadores/impuestos).

**2. Gerencia Software — pill "Total clientes":**
- Pill "Total clientes" ahora muestra el total del cierre del mes seleccionado (`swActivos.length`) en vez del total global de activos.
- Es clickeable (filtro 'total') y muestra todos los clientes del mes abajo.
- Listado de clientes ahora ordena alfabéticamente por nombre (antes ordenaba por tipo de licencia).

**3. Gerencia — botón "Desestimar" en banners pendientes:**
- Botón agregado junto a "Crear" en banners de clientes pendientes (outsourcing y software) en Base de Datos.
- Función `bdDismissPendientes(destino)` actualiza estado a 'desestimado' en tabla `clientes_pendientes`.

**4. Checklist comercial — acceso compartido:**
- Felix y Naomi ven todos los checklists (no filtrado por responsable). Default es "Todos".
- Campo `responsable` registra quién cerró el cliente (para comisiones).
- RLS permite que comercial lea/edite cualquier registro.

**5. Checklist comercial — fechas y notas:**
- JSONB cambió de `{item_id: true/false}` a `{item_id: {done, fecha, nota}}`.
- Al marcar "Si" se guarda fecha automáticamente. Al desmarcar se borra.
- Campo de notas por tarea. Tabla detalle ahora tiene 5 columnas: #, Tarea, Estado, Fecha, Notas.
- Backward compatibility via `chkIsDone()`, `chkGetNota()`, `chkGetFecha()`.

### 2026-05-10 — Correcciones portal + categorías + checklist comercial

Sesión con múltiples cambios:

**1. Portal de clientes — fix nombre + proyección + colores ganancia:**
- portal-clientes.html: nombre del cliente ahora se muestra en el header de las 4 vistas detalle de Presentación Mensual (antes solo salía "Presentación Mensual" sin identificar al cliente).
- Proyección de Impuestos: meses reales en fondo blanco, meses proyectados con fondo amarillo (#fffbeb). Números en negro (no ámbar).
- Ganancia/pérdida: colores cambiados de binario (verde/rojo) a 3 niveles usando pmPctColor: verde ≥90%, ámbar 66-89%, rojo ≤65%.
- Mismos cambios aplicados a portal-admin.html (regla de sincronización).

**2. index.html — skip role picker para admin:**
- Temporalmente quitado el role picker al login. Admin entra directo a showApp() sin pasar por showRolePicker().

**3. ventas.html — filtro categorías en Movimiento:**
- Las pills de categoría (Adm, Implementacion, etc.) ahora funcionan como filtro toggle. Click filtra la tabla de ganados, segundo click quita el filtro.
- Fix normalización: CAT_NORMALIZE map para unificar "ADM" y "Adm" como "Adm".
- Fix visual: labels de categoría con `text-transform:none` para mostrar "Adm" en vez de "ADM".

**4. Checklist Comercial (ventas.html) — módulo nuevo:**
- Tabla Supabase: `checklist_comercial` con JSONB `data`, UNIQUE(lead_id). RLS para admin y comercial. SQL en `db/checklist-comercial-setup.sql`.
- Nuevo tab "Checklist" en ventas.html (junto a ROAS, Pipeline, Movimiento).
- Month pills + persona pills (Felix/Naomi/Todos) + summary stats (Clientes/Completados/En progreso/Sin iniciar/Avance).
- Client cards grid con barra de progreso y conteo de tareas.
- Vista detalle con tabla de 14 items agrupados en 4 secciones: Cierre (5), Implementación (3), Contrato (3), Post-firma (3). Sub-tareas indentadas con estilo diferenciado.
- Toggle Si/No por item + botón Guardar.
- Creación manual con botón "+ Nuevo checklist" (prompts para cliente/empresa/responsable).
- Auto-creación al cerrar lead como "Cerrado Ganado" via `dbCreateChecklistFromLead()` (hook en dbUpdateLead). Marca automáticamente el item `lead_cerrado`.
- CSS con prefijo `chk-` para evitar conflictos.

**SQL pendiente de ejecutar:** `db/checklist-comercial-setup.sql`.
**Archivos para subir a GitHub:** `pages/ventas.html`, `pages/portal-clientes.html`, `pages/portal-admin.html`, `pages/index.html`.

### 2026-05-09 (cont.) — Tab Facturación completo en gerencia.html

Sesión larga dedicada a construir el tab de Facturación dentro de Clientes > Comercial (gerencia.html). Incluye precios, descuentos, montos reales y estadísticas de facturación.

**1. Rename productos software:**
- "Starter" → "Start" (en todo el código: licOrder, licColors, licSortOrder, modales, dropdowns).
- "Nómina" (producto independiente) → "Premium+Nómina" (ahora es un add-on del Premium).
- Premium ahora existe como producto separado a $84.

**2. Precios software actualizados (PRECIOS_SOFTWARE):**
- Start=$24, Start+FE=$36, Basic=$36, Basic+FE=$54, Basic+FE+POS=$94, Standard=$60, Standard+FE=$90, Premium=$84, Premium+FE=$126, Premium+Nómina=$144, Premium+Nómina+FE=$216, Manufactura=$144, Manufactura+FE=$216.

**3. Precios outsourcing (PRECIOS_OUTSOURCING):**
- Lookup table por tipo_servicio (Contabilidad, Tax One, Cont+Tax) × transacciones (50, 100, 150).
- >150 transacciones = "Cotizar" (no se puede calcular automáticamente).

**4. Tab Facturación — estructura:**
- Outsourcing: tablas "Cambios del mes" y "Lista completa" con 3 columnas de monto: Monto Serv. | Monto Soft. | Total.
- Software: tablas "Cambios del mes" y "Lista completa" con columnas: Cliente | Licencia | Monto | Desc. | Monto real | Nota | Acción.
- Monto real siempre visible (repite monto si no hay descuento, muestra decimal si hay: `+(precio * (1 - pct/100)).toFixed(1)`).
- Total row al final de ambas listas completas.

**5. Sistema de descuentos (en tabla clientes_software):**
- Campos: `descuento_pct` (integer), `descuento_vence` (date), `descuento_nota` (text).
- Se cargan y guardan desde el modal de cliente software (3 inputs nuevos).
- Descuento aplica automáticamente si `descuento_vence >= último día del mes seleccionado`.
- SQL: `db/facturacion-descuentos-setup.sql` (ALTER TABLE ADD COLUMN IF NOT EXISTS × 3).

**6. Stats facturación (reducidos con clase `.stats-sm`):**
- 6 cards: Facturas del mes, Agregar, Quitar, Nuevo servicio (RD$ outsourcing), Nuevo software (US$), Facturación perdida (RD$ outsourcing churn).
- Facturación perdida = suma de precios de servicio de clientes outsourcing con fecha_salida en el mes.

**7. CSS `.stats-sm`:**
- padding: 12px 14px, stat-value: 20px, labels/sub: 10px. Solo aplica en facturación.

**SQL ejecutado por Felix:**
- `db/facturacion-descuentos-setup.sql` — ALTER TABLE clientes_software (3 columnas de descuento). ✓
- Rename Starter→Start y Nómina→Premium+Nómina en datos. ✓
- `pages/gerencia.html` subido a GitHub. ✓

**Archivos modificados:** `pages/gerencia.html`.

### 2026-05-09 (cont.) — Modal reorganizado, dashboard público, fixes index.html

**1. Modal de clientes reorganizado en 3 secciones:**
- Datos del cliente (nombre, RNC, contacto, email, teléfono)
- Servicio contratado: tipo de servicio + transacciones contratadas (fila 1), licencia Adm + servicio de implementación (fila 2), servicio recurrente (fila 3). Sub-sección "Fechas" con fecha entrada, inicio impl, fin impl esperado, inicio responsabilidad fiscal.
- Empresa (tipo empresa, estado contabilidad)

**2. Cambios en dropdowns del modal:**
- Licencia Adm: quitadas Standard+FE+POS, Premium+FE+POS, POS, POS+FE (no existen). Default cambiado de "—" a "No aplica".
- Transacciones contratadas: guarda valores numéricos (50, 100, 150, 200) pero muestra labels ("0 a 50", "51 a 100", etc.).
- Servicio de implementación: convertido de input texto a select con 3 opciones + "No aplica".

**3. Dashboard público (`pages/dashboard-publico.html`):**
- Página standalone sin auth, texto "Account One" arriba a la derecha.
- Consulta clientes, clientes_software, asignaciones via anon key.
- 3 secciones: Outsourcing, Software, General con Chart.js.
- RLS policies creadas: `db/dashboard-publico-rls.sql` (anon read en 3 tablas). **Ejecutado.**

**4. "Link Dashboard" pill en gerencia.html Base de Datos:**
- Nuevo sub-tab al final de BD con URL copiable del dashboard público.

**5. Fixes en index.html:**
- Transacciones: `parseInt(c.monto_adm)` para sumar correctamente (antes concatenaba strings).
- Categorías: cambio de `===` a `indexOf` para soportar multi-select de ventas.html.

**6. monto_adm revertido a integer:**
- SQL ejecutado: mapeo de rangos texto ('0-50'→50, '51-100'→100, etc.) + ALTER COLUMN TYPE integer.

**7. servicio_impl limpieza:**
- SQL ejecutado: mapeo de texto libre a las 3 opciones del dropdown.

**SQLs ejecutados:** revert monto_adm a integer, dashboard-publico-rls.sql, limpieza servicio_impl.
**Archivos subidos a GitHub:** `pages/gerencia.html`, `pages/index.html`, `pages/dashboard-publico.html`.

**Fix fecha_entrada preexistentes:** clientes outsourcing y software sin fecha_entrada recibieron `2025-12-01` como fecha por defecto. Esto corrige el dashboard público que no contaba clientes sin esa fecha. SQL ejecutado en ambas tablas (`clientes` y `clientes_software`).

**Ejecutado por Felix (2026-05-09):** DROP TABLE perfiles_clientes ✓, DROP TABLE software_clientes ✓. Ambas tablas eliminadas.

### 2026-05-09 (cont.) — Eliminación de perfiles_clientes y merge a tabla clientes

Se decidió eliminar el sistema separado de perfiles (`perfiles_clientes` en Supabase, `ccPERFILES` en frontend) y unificar los campos relevantes directamente en la tabla `clientes`.

**Campos agregados a tabla `clientes`:** software, servicio_impl, servicio_recurrente, tipo_empresa, estado_contabilidad, fecha_inicio_impl (date), fecha_fin_impl (date). SQL en `db/clientes-perfil-columns.sql`.

**Modal de edición de clientes actualizado:** nuevas secciones "Servicio contratado" y "Empresa" con los 7 campos. `clOpenModal` carga los datos, `clSaveClient` los guarda via upsert.

**Código eliminado de gerencia.html:**
- CSS: todas las clases `.perfil-*` (card, header, body, section, grid, field, btn, empty, arrow, name, actions).
- JS: `ccPERFIL_FIELDS`, `ccTogglePerfil`, `ccStartEditPerfil`, `ccCancelEditPerfil`, `ccSavePerfil`, `ccAddPerfil`, `ccDeletePerfil`, `ccGetPerfilCompleteness`, `ccParseFiscalOrder`, `ccRenderPerfiles`.
- JS: `bdOpenPerfil`, `bdRenderPerfilModal`, `bdSavePerfilModal`, `bdDeletePerfilModal`, `bdClosePerfilModal`.
- Variables: `ccPERFILES`, `ccPerfilOpen`, `ccPerfilEditing` (eliminadas en paso previo).
- DB functions: `ccLoadPerfilesFromDB`, `ccSavePerfilToDB`, `ccInsertPerfilToDB`, `ccDeletePerfilFromDB` (eliminadas en paso previo).
- Botón 📋 en tabla outsourcing.

**Archivos modificados:** `pages/gerencia.html`, `db/clientes-perfil-columns.sql`.
**SQL ejecutado por Felix (2026-05-09):** `db/clientes-perfil-columns.sql` ✓.

### 2026-05-09 (cont.) — Filtros completos y perfiles en gerencia.html

Cambios adicionales sobre la sesión anterior:

**1. CC Software: cards reescritas (Inicio/Nuevos/Churn/Cierre):**
- Se eliminaron las pills de tipo de licencia del módulo CC > Software.
- Se reemplazaron con cards clickeables Inicio/Nuevos/Churn/Cierre (misma UX que BD).
- Filtro toggle: click en card activa/desactiva. `ccSwFiltro` (null = todos).
- Inicio para enero = clientes pre-2026 (sin fecha_entrada o fecha_entrada < 2026-01-01).

**2. CC sub-tab "Clientes" → "Outsourcing":**
- En el array de tabs de CC, label cambiado.

**3. Resumen mensual (CC > Outsourcing) — fix click:**
- Antes: click en fila cambiaba el mes seleccionado (UX confusa).
- Ahora: filas expandibles con `ccToggleServDetail()`. Muestra badges con nombres de quién entró/salió.

**4. BD sub-tabs renombrados y reordenados:**
- "Clientes" → "Outsourcing", "Clientes Software" → "Software".
- Orden final: Outsourcing, Software, Contadores, Asignaciones, Links Portal.
- Perfiles eliminado como pill independiente.

**5. Perfil por fila (BD > Outsourcing):**
- Botón 📋 por cada cliente en la tabla outsourcing.
- `bdOpenPerfil(nombre)`: busca perfil existente en `ccPERFILES` por nombre, si no existe crea uno nuevo en Supabase.
- Modal overlay con todos los campos editables. Funciones: `bdRenderPerfilModal`, `bdSavePerfilModal`, `bdDeletePerfilModal`, `bdClosePerfilModal`.

**6. BD Clientes (Outsourcing) — Inicio/Cierre clickeables:**
- Cards Inicio y Cierre ahora son clickeables con `clSetFilter('inicio'|'cierre')`.
- Filter indicator actualizado: maneja 4 estados (nuevos/churn/inicio/cierre) con colores y labels apropiados.
- Filter logic: inicio = activos al cierre del mes anterior (o pre-2026 para enero), cierre = activos del mes actual.

**7. Fix base count (Inicio):**
- Clientes sin fecha_entrada se cuentan como pre-existentes: `!c.fecha_entrada || c.fecha_entrada < '2026-01-01'`.

**Archivos modificados:** `pages/gerencia.html`.
**Pendiente subir a GitHub:** `pages/gerencia.html`.

### 2026-05-09 (cont.) — Rediseño completo tabs y vistas en gerencia.html

Sesión larga con muchos cambios estéticos y funcionales en gerencia.html:

**1. Cards Inicio/Nuevos/Churn/Cierre (BD Software y BD Clientes):**
- Reemplazaron las cards Activos/Inactivos/Total en ambas sub-tabs.
- Fórmula: Inicio = Cierre - Nuevos + Churn (del mes seleccionado).
- Nuevos y Churn son clickeables (filtro toggle). Sin signos +/-.
- Al hacer click se filtra la tabla para mostrar solo los clientes que entraron o salieron ese mes.
- Click en el mismo filtro activo = deseleccionar.

**2. Tabla de licencias simplificada (BD Software):**
- Antes: accordion "Clientes por tipo de licencia" con headers expandibles.
- Ahora: tabla plana colapsable con columnas Tipo/Cantidad/Clientes.
- Solo muestra clientes actualmente activos (filtra por fecha_salida > hoy).
- Toggle colapsable con `ccToggleSwLicTable()`.

**3. Campo tipo_licencia en modal de software:**
- Select dropdown con todas las opciones: Starter, Basic, Standard, Premium, Nómina, Manufactura, POS y combinaciones con +FE/+POS.
- Agregado al load, clear y save del modal.
- Columna nueva en la tabla BD Software (entre Cliente y RNC).

**4. Rename PdV → POS:**
- En todo el código JS (licencia order array, colores, labels).
- SQL `db/fix-licencia-pos.sql` para actualizar datos existentes en Supabase. **Ejecutado por Felix.**

**5. Tabs principales renombrados:**
- "Control de Clientes" → "Clientes"
- "Control de Contadoras" → "Contadoras"

**6. Sub-tabs CC reordenados:**
- Orden: Dashboard, Clientes (antes "Servicios"), Software, Implementaciones.
- "Perfiles" movido a Base de Datos.

**7. BD sub-tabs actualizados:**
- Orden: Contadores, Perfiles (nuevo, movido desde CC), Links Portal.
- `ccRenderPerfiles()` reutilizado pasando el contenedor BD.

**8. Resumen mensual en CC > Clientes:**
- Tabla colapsable con movimiento mes a mes (Inicio/Nuevos/Churn/Cierre acumulativo).
- Filas clickeables cambian el mes seleccionado.
- Base = clientes con fecha_entrada antes de 2026 o sin fecha.

**9. Month pills + stats con filtros en CC > Software:**
- Rewrite completo de `ccRenderSoftware()`.
- Nuevas variables: `ccSwMes`, `ccSwFiltro`.
- Función `ccSwGetActivosMes(mesKey)` para filtrado temporal.
- Stats clickeables: Total + cada tipo de licencia como filtro.
- Resumen mensual colapsable con filas expandibles (detalle de quién entró/salió).
- Listado agrupado por tipo de licencia, filtrable por mes y tipo.

**Archivos subidos a GitHub:** `pages/gerencia.html`, `pages/index.html`.
**SQL ejecutado:** `db/fix-licencia-pos.sql`.
**Pendiente:** Task #53 (DROP TABLE software_clientes) cuando Felix confirme que todo funciona bien con la tabla nueva.

### 2026-05-09 — Clientes Software + puente comercial → BD + tracking salidas

**1. Líneas de negocio separadas:**
- Decisión: clientes recurrentes (servicio contable) y clientes software (Adm como producto) son dos bases de datos separadas con facturación independiente.
- Caso borde: lead con FE pero sin Adm = servicio puntual, no genera entrada en ninguna BD (ej: Río Blanco, César Subero).
- Nomenclatura: "Adm" (primera mayúscula, resto minúscula), nunca "ADM".

**2. Nueva tabla `clientes_software` (SQL: `db/clientes-software-setup.sql`):**
- Campos: nombre, rnc, contacto, email, telefono, monto_mensual, fecha_entrada, fecha_salida, activo, motivo_salida, nota_salida, notas.
- RLS: admin full access, authenticated read.

**3. Nueva tabla `clientes_pendientes` (puente comercial → BD):**
- Cuando un lead pasa a "Cerrado Ganado" en ventas.html, se inserta un pendiente con destino='software' o 'recurrente' según categorías.
- Campos: lead_nombre, lead_empresa, categorias, destino, monto_vendido, mes_cierre, anio_cierre, estado (pendiente/creado/descartado), cliente_id.
- En gerencia.html se muestra alerta amarilla con badge en sub-tabs y botón "Crear" que pre-carga datos.

**4. Sub-tab "Clientes Software" en gerencia.html Base de Datos:**
- Nueva pill entre "Clientes" y "Asignaciones".
- Month pills, summary cards (activos/inactivos/total/facturación mensual), tabla con búsqueda, modal crear/editar.
- Toggle activo/inactivo con motivo de salida (select predefinido) + nota libre.
- Alerta de pendientes de software con botón para crear directamente desde el pendiente.

**5. Campos motivo_salida y nota_salida en clientes (recurrentes):**
- ALTER TABLE `clientes` + dos columnas.
- Modal de editar cliente: al marcar inactivo, aparecen los campos motivo (select: Cambio a otra firma, Cierre de empresa, Reducción de costos, Insatisfacción, No pago, Internalización, Otro) + nota libre.
- En la tabla, clientes inactivos muestran "Salida: dd/mm/yyyy · motivo" inline.

**6. Categoría "ADM" renombrada a "Adm" en ventas.html:**
- Constante CATEGORIAS y catColors actualizados.

**Archivos modificados:** `pages/ventas.html`, `pages/gerencia.html`, `db/clientes-software-setup.sql`.
**SQL pendiente de ejecutar:** `db/clientes-software-setup.sql` en Supabase SQL Editor.

---

### 2026-05-09 (cont.) — Fix filtro temporal clientes software (Dime Siete)

**Problema:** Dime Siete aparecía como inactivo en todos los meses (enero, febrero) aunque estuvo activo hasta marzo. Causa: el código usaba `c.activo !== false` como filtro fijo en las vistas temporales. Un cliente con `activo = false` quedaba excluido de todas las vistas mensuales, sin importar sus fechas de entrada/salida.

**Solución:**
1. Felix puso `fecha_salida = 2026-03-30` directo en el portal para Dime Siete.
2. Se quitó `&& c.activo !== false` de `swGetClientesForMes()` en gerencia.html (línea ~3212). Ahora la función solo usa `fecha_entrada` y `fecha_salida` para determinar si un cliente estaba activo en un mes dado.
3. Se quitó `&& c.activo !== false` de las dos líneas de conteo temporal en index.html (softTotal y softPrev).
4. El campo `activo` se sigue usando para el badge visual (Activo/Inactivo) y para el modal de edición, pero ya no bloquea la aparición temporal.

**Archivos modificados:** `pages/gerencia.html`, `pages/index.html`.

---

### 2026-05-09 (cont.) — Unificación tablas software: software_clientes → clientes_software

**Problema:** existían dos tablas de clientes software: `software_clientes` (vieja, usada por Control de Clientes > Software) y `clientes_software` (nueva, usada por Base de Datos > Clientes Software). La vieja tenía el campo `licencia` (tipo de plan Adm) que la nueva no tenía.

**Solución:**
1. Se agregó columna `tipo_licencia` a `clientes_software`.
2. Se migró el valor de licencia desde `software_clientes` via cross-reference por nombre.
3. Se corrigieron nombres: Canvas→Canvas Design Media Chaer, Luis Abreu→Luisa Abreu, Viajes Pat→Agente de Viajes Pat, Phillips Electronica→Phillips Electrónica.
4. K&G se mantienen como 7 registros individuales (Felix quiere contar licencias individuales).
5. Dime Siete queda inactivo en la nueva (confirmado por Felix).
6. Se actualizó `ccLoadSoftwareClientes()` y `ccGetSoftwareStats()` en gerencia.html para leer de `clientes_software`.
7. Se actualizó `ccRenderSoftware()` para usar `fecha_entrada` en vez de `periodo`.
8. Se actualizó index.html para leer de `clientes_software` en el KPI de software.
9. Cards "Nuevos" y "Churn" clickeables en Base de Datos > Clientes Software con filtro toggle.

**SQL:** `db/unificar-software-clientes.sql` (ALTER + correcciones + migración licencias).
**Archivos modificados:** `pages/gerencia.html`, `pages/index.html`.
**Ejecutado por Felix (2026-05-09):** SQL corrido en Supabase ✓. gerencia.html e index.html subidos a GitHub ✓. DROP TABLE software_clientes ejecutado ✓.

### 2026-05-08 — Tab Movimiento + categorías multi-select + fix ROAS guardado

**1. Categorías multi-select en leads (ventas.html):**
- El campo `categoria` pasó de ser un select simple a checkboxes multi-select.
- Categorías: ADM, Implementacion, Facturacion Electronica, Servicios Recurrentes.
- Se guarda como texto separado por comas en la misma columna `categoria` (sin cambio en Supabase).
- Funciones helper: `parseCats()`, `renderCatBadges()`, `renderCatChecks()`.
- Ambos formularios (editar lead y nuevo lead) actualizados para recoger checkboxes.
- Constante `CATEGORIAS` definida para consistencia.

**2. Tab "Movimiento" (solo admin):**
- Nuevo tab en ventas.html, visible solo para roles != comercial.
- Pills de mes para navegar + cards con cantidad de clientes "Cerrado Ganado" por categoría.
- Acumulado anual debajo de las cards del mes.
- Tabla detalle con cliente, empresa, categorías (badges) y monto vendido.
- Alerta amarilla cuando hay clientes ganados sin categoría asignada.

**3. Fix ROAS — guardado con upsert:**
- `dbUpdateRoas()` cambiado de solo UPDATE a upsert (INSERT si no existe `_id`).
- Problema: meses sin fila en `roas_mensual` (mayo en adelante) no guardaban porque `_id` era undefined.
- Botón "Guardar" explícito por fila en la tabla de ROAS con feedback visual (Guardando → Guardado).

**4. Alineamiento trimestre completo (portal-admin + portal-clientes):**
- Columnas Meta/Ejecutado/% cambiadas de `pm-text-right` a `pm-text-center` para alinear con headers.
- Headers de Presupuesto y Ejecución en portal-clientes cambiados a navy background.

**Archivos modificados:** `pages/ventas.html`, `pages/portal-admin.html`, `pages/portal-clientes.html`.

### 2026-05-06 — Split ingreso_financiero + botón marcar checklist + seed declaraciones + % costos ejecución

**1. Split ingreso_financiero en dos campos:**
- La columna `ingreso_financiero` (que contenía un neto positivo/negativo) se reemplazó por dos columnas separadas: `ingreso_no_operacional` y `gasto_no_operacional`.
- Tablas afectadas: `portal_presupuesto` (columnas `_anual`) y `portal_ejecucion`.
- SQL de migración: `db/split-ingreso-financiero.sql` — pone valores positivos en ingreso, absoluto de negativos en gasto. **Pendiente de ejecución por Felix.**
- Frontend: formularios, Excel parser, funciones de guardado, todas las vistas de render y proyección actualizados en ambos portales.
- Presentación: una sola fila con el neto (ingreso - gasto), etiquetada "Ing./Gto. No Op."
- El Excel parser ahora clasifica: sección `ingresos_financieros` → `ingreso_no_operacional`, sección `otros_gastos > gastos_fin` → `gasto_no_operacional`, `otros_ingresos` → distribuye según signo.

**2. Botón "Marcar todo como realizado" en Checklist (portal-admin.html):**
- Ubicado en `renderDashboard()` al final del Resumen de Impuestos.
- Marca todos los items del checklist del mes seleccionado como completados (yesno=true, monto=1, upload=placeholder file).
- Propósito: para meses pasados donde el portal no se estaba usando, que el cliente vea 100%.

**3. Seed declaraciones enero y febrero:**
- SQL `db/seed-declaraciones-ene-feb.sql` — inserta todas las obligaciones para todos los clientes activos con `fecha_presentado = fecha_limite`, que produce amarillo en el portal del cliente.
- **Ejecutado por Felix el 2026-05-06.**

**4. % costos vs ventas en ejecución mensual:**
- En la tabla de Ejecución del "Mes en curso", la fila de Costos ahora muestra `(X% de ventas)` al lado del monto ejecutado.
- Se calcula como `costos_operativos / ventas_it1 * 100` del mes.

**5. Ganancia proyectada en rojo cuando negativa (proyección de impuestos):**
- El summary card y la fila de ISR aplican `projGanColor` (rojo si negativa, verde si positiva).

**Archivos modificados:** `pages/portal-admin.html`, `pages/portal-clientes.html`, `pages/contabilidad.html`.
**SQL nuevo:** `db/split-ingreso-financiero.sql` (ejecutado 2026-05-09), `db/seed-declaraciones-ene-feb.sql` (ejecutado).

### 2026-05-06 — % costos en label + fix colores negativos (completo + MSH)

**1. Porcentaje de costos en la etiqueta:**
- En ambos portales (admin y clientes), la etiqueta "Costos" ahora muestra el porcentaje del presupuesto: "Costos (40%)".
- Se calcula como `costos_operativos_anual / ventas_it1_anual * 100` para el presupuesto completo.
- Para MSH simplificado: `gastos_simple_anual / ventas_simple_anual * 100`, label "Gastos (X%)".
- Se aplica en tres lugares por cada función de render: conceptos (trimestre por mes), presRows (presupuesto planificado), qRows (trimestre completo).

**2. Fix colores negativos en ganancia/pérdida:**
- Bug: cuando ganancia y meta son ambas negativas, el cociente da positivo y el porcentaje se pintaba verde.
- Fix: la condición ahora es `(ganancia >= 0 && pct >= 100)` en vez de solo `pct >= 100`. Si la ganancia es negativa, siempre rojo.
- Aplicado en TODAS las secciones de ambos portales: trimestre por mes, mes en curso (ejecución rows + resultado operativo + ganancia), trimestre completo.
- También aplicado en `renderPresupuestoMSH()` de ambos portales: beneficio trimestral por mes, beneficio ejecución mes en curso, beneficio trimestre completo.

**3. Color en % Logro de ejecución:**
- Las filas de ejecución del "Mes en curso" no tenían color en la columna de porcentaje. Ahora usan `pmPctColor(pct, invert)`.
- Aplicado tanto en presupuesto completo como en MSH simplificado, en ambos portales.

**Archivos modificados:** `pages/portal-admin.html`, `pages/portal-clientes.html`.
**No hay SQL nuevo.**

### 2026-05-06 — Notas en checklist + botón "Marcar todo" + RLS comercial + declaraciones compactas

**1. Notas en checklist (contabilidad.html):**
- Nueva columna "Nota" con ícono de lápiz (✎) en cada tarea del checklist.
- Ícono azul cuando tiene nota, gris cuando está vacío.
- Modal con textarea para escribir/editar la nota. Guarda automáticamente en el JSONB `datos` (campo `nota`).
- Botón "✓ Marcar todo como realizado" en la save-bar: marca todas las tareas como done con fecha de hoy y guarda.

**2. Declaraciones 6 en línea (portal-admin.html):**
- `.pm-decl-grid` cambiado de `repeat(5, 1fr)` a `repeat(6, 1fr)`. Padding y font reducidos para que quepan las 6 obligaciones.

**3. RLS rol comercial (`db/fix-rls-ventas-a-comercial.sql`):**
- Felix renombró el rol `ventas` a `comercial` en profiles pero las RLS policies no se actualizaron. Naomi Villar no podía grabar leads.
- Políticas actualizadas: `leads` (INSERT/UPDATE), `roas_mensual` (SELECT), `perfiles_clientes` (ALL) ahora aceptan `comercial`.
- **SQL ejecutado por Felix el 2026-05-06.**

**4. Botón "Marcar todas como presentadas" (portal-admin.html):**
- En la vista Resumen Declaración, botón verde que marca las 6 obligaciones del mes como `a_tiempo` con `fecha_presentado = hoy`.
- Calcula `fecha_limite` automáticamente según `PM_DIA_LIMITE`.
- Preserva montos existentes. Solo visible en portal-admin (contadoras/impuestos), no en portal-clientes.

**Archivos subidos a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`, `pages/contabilidad.html`.
**SQLs ejecutados:** `db/fix-rls-ventas-a-comercial.sql`.
**SQLs pendientes de la sesión anterior:** `db/costos-obra-migration.sql`, `db/fix-declaraciones-rls.sql` (confirmar con Felix si ya se ejecutaron).

### 2026-05-05 — Separación completa de datos MSH + RLS de declaraciones + 4 tabs MSH

**1. Separación de datos simplificado vs completo (MSH):**
- Problema: la carga de presupuesto/ejecución del Excel completo sobrescribía los datos del simplificado porque compartían columnas (`ventas_it1`, `gastos`, `costos_operativos`).
- Solución: 5 columnas nuevas en Supabase (`db/costos-obra-migration.sql`):
  - `portal_ejecucion`: `costos_obra`, `ventas_simple`, `gastos_simple`
  - `portal_presupuesto`: `ventas_simple_anual`, `gastos_simple_anual`
- Dos botones "Cargar Datos" para MSH: "Datos Simplificado" (navy) y "Datos Completo" (azul). Cada uno graba solo sus columnas y preserva las del otro con los valores existentes.
- `renderPresupuestoMSH()` actualizado para leer de columnas `_simple` y `costos_obra`.

**2. Grid 2x2 para MSH (4 cards de navegación):**
- MSH tiene 4 secciones: Presupuesto Simplificado, Presupuesto Completo, Proyección Impuestos, Resumen Declaración. Se muestran en grid 2x2 (`.pm-grid-2x2`).
- Replicado en portal-clientes.html.

**3. Fix RLS declaraciones + Infotep (`db/fix-declaraciones-rls.sql`):**
- Check constraint de `portal_declaraciones.obligacion` no incluía 'Infotep'. Recreado con 6 valores.
- Políticas RLS: `contadores` e `impuestos` ahora pueden escribir en las 4 tablas de presentación (`portal_presupuesto`, `portal_ejecucion`, `portal_impuestos_config`, `portal_declaraciones`).

**4. Fix TET:** fórmula usaba `totalV` (ventas reales) en vez de `projV` (proyección anual). Corregido en ambos portales.

### 2026-05-01 — Vista simplificada MSH + fix visual Proyección + limpieza código muerto

**1. Vista simplificada Presupuesto vs Ejecución para MSH Interiorismo:**
- Se creó `renderPresupuestoMSH()` en ambos portales (admin y clientes). Es una función completamente separada de `renderPresupuestoDetail()` para mantener el código limpio.
- `renderPresupuestoDetail()` hace `return renderPresupuestoMSH()` al inicio si el cliente empieza con "MSH".
- La vista MSH tiene 3 secciones:
  1. **Trimestre por mes**: solo Ventas, Gastos, Beneficio (sin desglose de costos/IF/GNA).
  2. **Panel de Obra** (violeta #5b21b6): Ingreso de Obra, Costos de Obra, Resultado. Reemplaza lo que antes era "Mes en curso".
  3. **Trimestre completo**: resumen con Ventas, Gastos, Beneficio y banner de ganancia/pérdida.
- Detección por `clienteNombre.indexOf('MSH') === 0` (startsWith-style, tolera variaciones del nombre).

**2. Formulario Cargar Datos reorganizado para MSH:**
- Para MSH: el campo "Costos Operativos" se oculta de la sección principal y aparece en una sección separada "Obra" con borde violeta.
- Sección Obra tiene dos campos: "Ingreso de Obra" (→ columna `ingreso_obra`) y "Costos de Obra" (→ columna `costos_operativos`, misma data, diferente label).
- Campos normales para MSH: Ventas, Gastos, Ing./Gasto Fin., Gtos. No Admitidos (sin Costos Operativos visible).
- `pmSaveEjecucion()` incluye `ingreso_obra` condicionalmente solo para MSH.

**3. Fix visual — Proyección de Impuestos headers inconsistentes:**
- Panel "Realidad hasta hoy" tenía fondo blanco vs navy del panel izquierdo. Cambiado a `pm-panel-dark`.
- Panel "Proyección Anticipo Próx. Año" tenía header ámbar vs navy del de arriba. Cambiado a `pm-panel-dark`.
- Ambos cambios en portal-admin.html y portal-clientes.html.

**4. Limpieza de código muerto:**
- El bloque viejo de "Panel de Obra" dentro de `renderPresupuestoDetail()` (~50 líneas en cada archivo) era inalcanzable porque MSH se intercepta con `return renderPresupuestoMSH()` al inicio. Eliminado de ambos archivos.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`, `pages/contabilidad.html`.

### 2026-05-01 — Fix RLS contadoras + separar IR-3 del checklist

**1. Fix RLS — Jessica no podía guardar checklists (dos problemas encadenados):**
- Problema 1: las políticas RLS usaban el rol viejo `'contadora'` en vez de `'contadores'`. SQL: `db/fix-rls-checklist-contadores.sql` — actualiza checklist_contadores, kpi_detalle, kpi_scores, checklist_mensual, reporte_mensual.
- Problema 2: la comparación de nombre era exacta (`contadora = profiles.nombre`) pero profiles almacena nombre completo ("Yessica Diaz") mientras que las tablas almacenan solo el primer nombre ("Yessica"). SQL: `db/fix-rls-nombre-parcial.sql` — cambia a `profiles.nombre ILIKE contadora || '%'` en checklist_contadores, kpi_detalle, kpi_scores, reporte_mensual.
- Patrón recurrente: todas las contadora_contabilidad son primer nombre solo (Beliani, Karina, Milka, Taina, Victoria, Yessica).
- Ambos SQL ejecutados por Félix. Jessica puede guardar.

**2. Fix ISR en Proyección de Impuestos:**
- El cálculo usaba `gananciaNeta` (ganancia acumulada hasta los meses cargados) en vez de `projGanancia` (proyección a 12 meses).
- Corregido en portal-admin.html y portal-clientes.html.

**3. Fecha límite mostraba mes incorrecto:**
- Mostraba el mismo mes de trabajo ("3 de marzo" para marzo) en vez del mes siguiente ("3 de abril").
- Corregido en ambos archivos.

**4. Separar IR-3 del grupo TSS en contabilidad.html:**
- Antes: TSS e IR-3 eran un solo grupo (7 items, presentación día 3).
- Ahora: TSS es su propio grupo (6 items, día 3) e IR-3 es grupo aparte (1 item: "Subir autorizacion de IR-3 al cliente", día 10).
- ITEM_GROUPS pasa de 5 a 6 grupos. Los items 0-5 son TSS (impuesto='TSS'), item 6 es IR-3 (impuesto='IR-3', dia:10).

**5. Panel "Ingreso de Obra" para MSH Interiorismo:**
- Customización hardcodeada para un solo cliente (`clienteNombre === 'MSH Interiorismo'`).
- Nueva columna `ingreso_obra` en `portal_ejecucion` (SQL: `db/portal-msh-ingreso-obra.sql`).
- En Cargar Datos (portal-admin.html): campo extra "Ingreso de Obra (4.12.01)" visible solo para MSH. Se guarda en el upsert.
- En Presupuesto vs Ejecución (ambos portales): panel adicional debajo del trimestre completo con tabla de 3 filas: Ingreso de Obra, Costos Operativos (mismos costos ya cargados), Resultado de Obra (diferencia). Color violeta (#5b21b6) para diferenciar del panel principal.
- Los costos no son datos nuevos: se reutilizan los `costos_operativos` ya existentes.
- Dato proviene de la cuenta 4.12.01 en ADM Cloud.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`, `pages/contabilidad.html`.
**SQL ejecutado:** `db/portal-msh-ingreso-obra.sql` (corrido por Félix 2026-05-01).

### 2026-04-30 — Permisos contadoras, pre-filtro, Infotep, fechas declaraciones

**1. Permisos de escritura para contadoras/impuestos en portal:**
- `db/permisos-portal-contadoras.sql`: INSERT/UPDATE en `portal_clientes_data` (ya existía), más acceso sidebar al módulo portal-admin.
- `db/fix-rls-portal-escritura.sql`: INSERT/UPDATE en `portal_presupuesto` y `portal_impuestos_config` para roles contadores/impuestos. DELETE en `portal_clientes_archivos`.
- `index.html`: sidebar portal-admin ampliado a `roles: ['admin', 'contadores', 'impuestos']`.
- Frontend: quitado `isAdminMode` del gate de "Cargar Datos" y nota textarea en portal-admin.html.

**2. Usuarios admin adicionales:**
- `db/set-admin-supervisores.sql`: Karina Sanchez y Maurice de Castro como admin (rol='admin' en profiles).
- Maurice tenía nombre vacío en profiles; actualizado con UPDATE.

**3. Pre-filtro por contadora al cargar:**
- portal-admin.html e impuestos.html: al iniciar, si el usuario no es admin, se busca su nombre en `profiles.nombre` y se cruza contra `contadora_impuestos` usando `indexOf` bidireccional (no ===) porque profiles almacena "Beliani Brito" pero contadora_impuestos almacena "Beliani".
- Variable `userNombrePortal` se asigna al login.

**4. Bug profile.role vs profile.rol:**
- Auditoría de 14 archivos HTML. Solo impuestos.html e implementaciones.html tenían el bug (`profile.role` en vez de `profile.rol`). Corregido en ambos, incluyendo el select query (`nombre, role` → `nombre, rol`).

**5. Infotep como nueva obligación:**
- `PM_OBLIGACIONES` actualizado a 6: TSS, Infotep, IR-3, IR-17, Anticipo, ITBIS.
- `PM_DIA_LIMITE`: Infotep = 3 (misma fecha que TSS).
- Índice: conteos actualizados de 5 a 6 (`getDeclCount >= 6`, labels `6/6`).
- Formulario Cargar Datos muestra card de Infotep con sus 4 campos.
- portal-clientes.html también actualizado con PM_OBLIGACIONES y PM_DIA_LIMITE.

**6. Fechas en declaraciones con fuente dual:**
- `pmGetFechaFromChecklist(mesNum, obligacion)`: busca en `impuestos_checklist` la fecha más reciente de los steps completados (pagado, anticipo_pagado, aprobado_cliente, etc.).
- `pmDeclColor()` actualizado para aceptar mesNum y obligacion, usar checklist como fallback.
- Tabla de declaraciones muestra fecha con icono ☑ si viene del checklist.
- Formulario pre-llena fecha_presentado del checklist si no hay dato manual.

**7. Auto-cálculo de fecha_limite:**
- Si el usuario no llena manualmente la fecha límite en el formulario de declaraciones, se calcula automáticamente: día del PM_DIA_LIMITE + mes siguiente al mes de trabajo.
- El formulario muestra el valor auto-calculado como default.

**Todos los archivos subidos a GitHub por Félix.** SQL ejecutados en Supabase.

**8. Fecha límite de declaraciones = mes siguiente:**
- La columna "Fecha Límite" en el detalle de declaraciones mostraba el mismo mes de trabajo (ej: "3 de marzo" para marzo). Corregido: ahora muestra el mes siguiente (ej: "3 de abril" para marzo), porque la presentación se hace en el mes posterior al mes de trabajo.
- Corregido en ambos archivos (portal-admin.html y portal-clientes.html).

**9. Mobile responsive para contabilidad.html:**
- Agregadas media queries `@media (max-width:640px)` y `@media (max-width:380px)`.
- Solo CSS, sin tocar JavaScript ni lógica de datos.
- Cambios: header comprimido, tabs con scroll horizontal, summary stats en 3 columnas, cards apilados, tablas con scroll horizontal, inputs más estrechos, pills más compactas.
- Patrón replicable a los demás módulos cuando Félix lo pida.

**Regla importante (de Félix):** todo cambio visual en portal-admin.html debe replicarse en portal-clientes.html. El portal del cliente no permite edición, pero muestra los mismos datos y la misma visualización. Si se agrega una obligación, un color, una columna o cualquier cambio de render en el admin, el archivo del cliente debe actualizarse en la misma sesión.

**Todos los archivos subidos a GitHub por Félix (2026-04-30):** `pages/portal-admin.html`, `pages/portal-clientes.html`, `pages/impuestos.html`, `pages/implementaciones.html`, `pages/index.html`, `pages/contabilidad.html`.

### 2026-04-30 — Correcciones semáforo y colores portal (ambos portales)

**Cambios aplicados a `portal-admin.html` y `portal-clientes.html`:**

1. **Semáforo bolitas en vez de badges de texto:** En todas las tablas de ejecución, los óvalos con texto ("Por debajo", "Controlado") se reemplazaron por bolitas de color sólido (clase `pm-sem-dot` con `.pm-dot` de 14px, sin fondo difuso).

2. **Rangos de color corregidos (3 funciones sincronizadas):**
   - `pmPctColor(pct, invert)`, `pmBadgeStatus(pct, tipo)`, `pmSemColor(pct, tipo)`
   - Ventas/beneficio: >=90% verde, 66-89% amarillo, <66% rojo.
   - Costos/gastos (invertido): <=100% verde, 101-120% amarillo, >120% rojo.

3. **Ing./Gastos Fin. y Gtos. No Admitidos tratados como gasto (invertido):**
   - Trimestre por mes: `pmPctColor(pctIF, true)` en vez de `false`.
   - Trimestre completo: `pmSemColor(qPctIF, 'gasto')` en vez de `'ventas'`.
   - Ejecución mensual: se agregaron bolitas `pm-sem-dot` con tipo `'gasto'` (antes las celdas estaban vacías).

4. **Diferencia en trimestre completo: todo negro.** Se eliminaron los colores inline de la columna Diferencia para todas las filas (ventas, costos, gastos, resultado op., ing. financiero, gtos. no admitidos).

5. **Porcentajes en trimestre completo usan `pmPctColor` con tipo correcto.** Ya no hay `pct >= 80` hardcodeado. Cada fila pasa su tipo para determinar si la lógica es normal o invertida.

6. **Nombre del cliente visible** en checklist y presentación mensual (detail view).

7. **Toggle tabla/cuadros** en el índice del portal admin (solo admin), copiando arquitectura de impuestos.html.

**SQL adicionales creados:** `db/set-user-password.sql` (RPC para asignar contraseña), `db/portal-rls-contadores.sql` (RLS para contadores/impuestos en tablas del portal). Todo ejecutado por Félix.

### 2026-04-30 — Permisos jerárquicos + Role picker + Fix auth

**1. Fix creación de usuarios (3 bugs encadenados):**
- `profiles_rol_check` constraint solo aceptaba roles viejos (contadora, ventas, etc.). Fix: DROP + recrear con 5 roles nuevos.
- `handle_new_user()` trigger usaba roles hardcodeados viejos. Fix: reescrito para leer de `raw_app_meta_data->>'role'` (enviado por `invite_user`), fallback a CASE por email con roles nuevos.
- `NEW.email` era NULL cuando se creaba via Admin API con `email_confirm=false`. Fix: COALESCE con `raw_user_meta_data->>'email'`.
- SQL: `db/fix-roles-constraint.sql` y `db/fix-trigger-roles.sql`.

**2. Role picker en index.html (admin):**
- Cuando un admin se logea, aparece una pantalla full con pills para elegir rol (admin, contadores, impuestos, comercial, implementaciones).
- `realRole` guarda el rol real de BD, `userRole` el seleccionado para la sesión.
- Botón "Cambiar rol" en sidebar (solo admin) para volver al picker.
- Roles no-admin van directo a su módulo home (`ROLE_HOME_MODULE`): contadores→contabilidad, impuestos→impuestos, etc.

**3. Rediseño permisos jerárquicos:**
- Estructura aprobada: módulo → pantalla → sub-tab → habilidades (consulta, adición, edición, anulación, eliminar).
- 8 módulos: Gerencia (3 pantallas, 2 con sub-tabs), Comercial (2), Contabilidad (2), Impuestos (2), Implementaciones (2), Portal admin (2), Portal clientes (2), Usuarios (2).
- `usuarios.html` reescrito: accordion por módulo con filas expandibles, cada pantalla/sub-tab tiene sus 5 toggles de habilidad.
- SQL migración: `db/migrate-permisos-jerarquicos.sql` convierte JSONB plano al formato jerárquico heredando permisos del nivel padre.
- `index.html`: nueva función `loadUserPermisos(userId)` carga permisos efectivos del usuario al login. Variable global `userPermisos` + helper `hasPermiso(mod, scr, subtab, hab)`.

**Pendientes:**
- Los módulos internos aún no consultan `window.parent.userPermisos` para ocultar tabs. El sidebar sigue filtrando solo por rol. La granularidad de permisos queda lista para implementar por módulo cuando Félix lo pida.

**Archivos subidos a GitHub:** `pages/index.html`, `pages/usuarios.html`, `pages/portal-admin.html`, `pages/portal-clientes.html`. SQL ejecutados en Supabase.

### 2026-04-30 — Restaurar y completar Ing./Gasto Fin. y GNA + estilo Ganancia/Pérdida

La simplificación inicial quitó IF y GNA de las vistas. Se restauraron y luego se refinaron en varias rondas:

**Estructura final de Presupuesto vs Ejecución (ambos archivos):**
- 7 filas: Ventas, Costos, Gastos → Resultado Op. (bold) → Ing./Gasto Fin. (muted), Gtos. No Admitidos (muted) → Ganancia/Pérdida (fondo navy, texto blanco, montos verde/rojo claro)
- Presupuesto y Ejecución muestran las mismas 7 filas (alineados)
- IF y GNA en ejecución muestran % logro cuando hay meta presupuestada, "—" si no hay
- Ganancia/Pérdida = Resultado Op. + IF - GNA

**Formulario Cargar Datos (portal-admin.html):**
- Presupuesto ahora tiene 5 campos: Ventas IT1, Costos Operativos, Gastos, Ing./Gasto Fin., Gtos. No Admitidos
- `pmSavePresupuesto()` guarda los 5 al upsert (incluye `ingreso_financiero_anual` y `gastos_no_admitidos_anual`)

**Tabla mensual (Ene/Feb/Mar):**
- IF y GNA con "—" en columna % Meta
- Ganancia/Pérdida con fondo navy, números verde/rojo claro (#4ade80/#f87171)

**Resumen trimestral:**
- IF y GNA muestran ejecutado y diferencia, sin meta (—)
- Fila Ganancia/Pérdida eliminada de la tabla (estaba de más con badge amarillo)
- Solo el banner inferior muestra Ganancia/Pérdida del trimestre

**Fix — Proyección de impuestos no abría:**
- Variables huérfanas (`totalS`, `resOpReal`, `projResOp`) y celdas extra eliminadas

**Pendiente:** Félix debe re-ejecutar `db/invite-user-function.sql` en Supabase SQL Editor para corregir el error de constraint al crear usuarios.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`

### 2026-04-30 — Roles de 5 niveles + simplificación presupuesto/ejecución/proyección

**1. Roles actualizados a 5:**
- Antes: admin, contadora. Ahora: admin, comercial, contadores, impuestos, implementaciones.
- `usuarios.html`: dropdown con 5 opciones, auto-asigna grupo al crear usuario.
- `index.html`: sidebar actualizado — cada menú item tiene su array de roles permitidos.
- `ventas.html`: todas las refs de `ventas` → `comercial`.
- `db/grupos-nuevos-roles.sql`: renombra Contadora→Contadores, Ventas→Comercial, crea Impuestos e Implementaciones.
- `db/invite-user-function.sql`: columna corregida de `role` a `rol`, default `'contadores'`.

**Pendiente:** Félix debe re-ejecutar `db/invite-user-function.sql` en Supabase SQL Editor para corregir el error de constraint al crear usuarios.

**2. Simplificación de Presupuesto vs Ejecución:**
- Salarios absorbido dentro de Gastos (ya no es línea separada).
- Estructura final de ambos paneles (presupuesto y ejecución): Ventas, Costos, Gastos → Resultado Op. → Ing./Gasto Fin., Gtos. No Admitidos → Ganancia/Pérdida (fondo navy).
- Presupuesto form admin: 5 campos (ventas, costos, gastos, ing./gasto fin., gtos. no admitidos).
- Tabla mensual (Ene/Feb/Mar): mismas 7 filas. IF y GNA muestran "—" en % Meta. Ganancia/Pérdida con fondo navy.
- Resumen trimestral: IF y GNA sin meta (—), Ganancia/Pérdida solo en banner inferior (sin fila en tabla).

**3. Simplificación de Proyección de Impuestos:**
- Antes: 6 columnas (con Salarios separado). Resultado Operacional + Ganancia Neta.
- Ahora: 5 columnas (Ventas IT1, Costos Op., Gastos, Ing./Gto.Fin., Gtos. N/A). Solo Ganancia/Pérdida.
- fórmula ganancia: `V - CO - G + IF - GNA` (directo, sin paso intermedio de resultado op.).

**4. Parser Excel:**
- Eliminado `PM_SALARY_KEYWORDS` y la lógica de acumular salarios por separado.
- `Total Gastos` ya no resta salarios: `result[m.mes].gastos = val` (antes: `val - result[m.mes].salarios`).
- Preview Excel: quitada fila Salarios.
- Save: no envía campo `salarios` al upsert.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`, `pages/index.html`, `pages/ventas.html`, `pages/usuarios.html`

### 2026-04-30 — Acceso por RNC + fechas límite fijas en declaraciones

**1. Cambio de acceso para clientes — de token directo a token + RNC:**
El portal de clientes antes daba acceso directo con el link (cualquiera con el link veía la data). Ahora el link lleva a una pantalla de contraseña donde el cliente debe ingresar su RNC para acceder. Esto agrega una capa de protección sin complicar el flujo.

**Arquitectura:**
- El link sigue siendo `portal-clientes.html?token=UUID` (el UUID es permanente, no expira)
- Al abrir, se muestra una pantalla limpia: "Portal de Clientes / Account One / Contraseña / [Acceder]"
- El cliente ingresa su RNC → se llama `verify_portal_access(token, rnc)` que valida ambos contra `portal_clientes_tokens` + `clientes`
- Si no coincide: "Contraseña incorrecta" (no revela que es el RNC)
- Si coincide: carga el portal normalmente

**RPCs SECURITY DEFINER (sin sesión Supabase):**
- `verify_portal_access(p_token, p_rnc)` — verifica acceso, devuelve nombre
- `portal_load_data(p_token)` — carga portal_clientes_data
- `portal_load_files(p_token)` — carga portal_clientes_archivos
- `portal_load_presupuesto(p_token, p_anio)` — carga presupuesto
- `portal_load_ejecucion(p_token, p_anio)` — carga ejecución mensual
- `portal_load_imp_config(p_token, p_anio)` — carga config impuestos
- `portal_load_declaraciones(p_token, p_anio)` — carga declaraciones
- Todas verifican internamente que el token sea válido y activo
- Permisos GRANT para rol `anon` y `authenticated`

**Código JS:** las funciones `loadData()`, `loadFiles()`, `loadPresentacionData()` detectan si están en modo cliente (`clienteToken && !isAdminMode`) y usan las RPCs en vez de queries directas.

**Sobre expiración:** el problema anterior de expiración probablemente venía de que el acceso dependía de una sesión de Supabase. Ahora no hay sesión: el token UUID es permanente (campo `activo` en la tabla) y las RPCs son SECURITY DEFINER.

**Prerequisito:** para que funcione, los clientes deben tener su RNC en la tabla `clientes` (campo `rnc`). Félix necesita verificar que estén cargados.

**2. Fechas límite fijas en declaraciones:**
La columna "Fecha Límite" en la tabla de declaraciones ahora muestra fechas fijas por tipo de obligación: TSS → 3, IR-3 → 10, IR-17 → 10, Anticipo → 15, ITBIS → 20. Se muestra como "3 de abril", "10 de abril", etc. Los semáforos de puntualidad siguen usando `fecha_limite` de la BD.

**SQL:** `db/portal-acceso-rnc.sql`
**Archivos para subir a GitHub:** `pages/portal-clientes.html`, `pages/portal-admin.html`

### 2026-04-30 — Scroll horizontal en proyección + alineación anticipos + tabla CRS

**1. Scroll horizontal en tablas de proyección de impuestos:**
- Las tablas "Realidad hasta hoy" y "Proyección fin de año" tienen 7 columnas y no cabían en pantalla.
- Se agregó clase CSS `.pm-table-compact` (font-size:0.75rem, headers 0.62rem, padding reducido, white-space:nowrap) + `overflow-x:auto` en el contenedor.
- Aplicado en ambos archivos.

**2. Alineación tablas Anticipos Mensuales (Ene-Jun / Jul-Dic):**
- Los headers de las tablas lado a lado se truncaban de forma distinta. Se forzó `width:100%`, `white-space:nowrap` en headers y columna Nota con `width:40%` para dar espacio consistente.
- Regla UX agregada a CLAUDE.md: paneles `.pm-dual` deben tener mismos anchos de columna y orientación simétrica.

**3. Tabla de referencia — Contribución Residuos Sólidos (CRS):**
Felix proporcionó la tabla de tarifas de la Ley 98-25 para calcular CRS según ingresos brutos anuales:

| Rango ingresos brutos anuales (RD$) | Ley 98-25 | Ley 225-20 (anterior) |
|---|---|---|
| 0 – 1,000,000 | 3,000 | 500 |
| 1,000,001 – 10,000,000 | 6,000 | 1,500 (hasta 8M) |
| 10,000,001 – 25,000,000 | 20,000 | 5,000 (8M-20M) |
| 25,000,001 – 50,000,000 | 155,000 | 30,000 (20M-50M) |
| 50,000,001 – 100,000,000 | 260,000 | 90,000 |
| Más de 100,000,001 | 675,000 | 260,000 |

~~Pendiente: integrar esta tabla en el portal para calcular CRS automáticamente según ingresos del cliente.~~ Hecho — función `pmCalcCRS(ingresosAnuales)` implementada.

**4. CRS automático:**
- Se creó función `pmCalcCRS(ingresosAnuales)` que calcula la contribución según rangos de la Ley 98-25.
- La proyección ahora usa `pmCalcCRS(projV)` (ingresos brutos proyectados a 12 meses) en vez del campo manual `pmImpConfig.crs_monto`.
- El banner CRS actualizado: muestra "Ingresos Brutos Proyectados (Anual)" y "Contribución Anual (Ley 98-25)".
- El campo `crs_monto` sigue en el formulario admin como referencia, pero ya no afecta la vista de proyección.

**5. Labels de declaraciones con nombre de mes:**
- "Pagado este mes" → "Pagado [Nombre del mes]" (ej: "Pagado Abril")
- "Mes anterior" → "[Nombre mes anterior]" (ej: "Marzo: RD$...")
- Headers tabla: "Pagado Mes Ant." → "Pagado Mar.", "Pagado Este Mes" → "Pagado Abr."
- Aplica dinámicamente según el tab de mes seleccionado.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`.

### 2026-04-30 — Fix doble conteo parser + rename + alineación paneles (ronda 2)

Félix cargó el estado de ACAN1 y encontró que el Q1 del portal (1,038,937) no cuadraba con ADM (1,059,857.71). La diferencia (~21K) venía de que el parser contaba doble los ingresos/gastos financieros.

**1. Bug del parser — doble conteo:**
- El catch-all en `pmParseEdoResultados` (línea ~2319) captura líneas individuales cuyo nombre contiene "ingresos financieros" (ej: "701.01 Ingresos Financieros"). Pero cuando el Excel tiene una sección "Ingresos Financieros" (línea ~2219 detecta el header), las líneas individuales se suman en el catch-all Y luego el "Total Ingresos Financieros" se vuelve a sumar en la captura de totales (línea ~2290).
- Fix: se agregó guard `section !== 'ingresos_financieros'` al catch-all. Así solo captura líneas sueltas que NO están dentro de la sección (para clientes que tienen "ingresos financieros" como entrada individual sin sección).

**2. Rename "Resultado Financiero" → "Ing./Gasto Fin.":**
- Félix señaló que no es un "resultado", es ingreso o gasto financiero.
- Cambiado en todos los labels de ambos archivos: paneles presupuesto/ejecución, tablas trimestrales, proyección de impuestos, formularios admin, preview de Excel.
- En headers de tablas compactas: "Res. Fin." → "Ing./Gto.Fin."

**3. Fix alineación paneles (segunda ronda):**
- A pesar del fix anterior (quitar condicionales), los paneles seguían desalineados porque las filas inferiores de ejecución usaban `colspan="2"` y `font-size:0.75rem`, dándoles diferente altura que las de presupuesto.
- Fix: se reestructuraron las 3 filas inferiores de ejecución (Ing./Gasto Fin., GNA, Ganancia/Pérdida) para usar 3 celdas separadas con label a la izquierda y valor a la derecha, igualando la estructura del presupuesto. Sin colspan, sin font-size reducido.
- portal-clientes.html además tenía las condicionales `if (ejIF || ejGNA)` que no se habían quitado en la ronda anterior. Se corrigió: ahora siempre muestra las 3 filas.

**4. Igualar altura de filas presupuesto vs ejecución:**
- Los badges de ejecución (padding:4px 14px) hacían esas filas ~8px más altas que las de presupuesto (solo texto).
- Fix CSS: `.pm-dual .pm-panel-body tbody td { height:54px; box-sizing:border-box; }` + `vertical-align:middle` en `.pm-panel-body td`.
- Aplicado en ambos archivos.

**5. Meta trimestral para Ing./Gasto Fin. y GNA:**
- La sección "¿Se cumplió la meta del trimestre?" mostraba un guion (–) en la columna Meta para IF y GNA. Félix pidió que se calculara la meta real.
- Se usa `pmGetMetaMensual('ingreso_financiero') * 3` y `pmGetMetaMensual('gastos_no_admitidos') * 3` para derivar la meta trimestral.
- IF: muestra meta, ejecutado, diferencia y %, sin badge (es un valor neto que puede ser positivo o negativo).
- GNA: muestra meta, ejecutado, diferencia, % y badge tipo 'gasto' (menos es mejor).
- Ganancia/Pérdida: ahora calcula `qMetaGanancia = qMetaResOp + qMetaIF - qMetaGNA` y muestra meta, diferencia, % y badge tipo 'beneficio'.
- Aplicado en ambos archivos.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`.

### 2026-04-30 — Parser: gastos financieros + rename Resultado Financiero + alineación paneles

Tres correcciones derivadas de la verificación contra ADM:

**1. Parser no capturaba "Otros gastos no operacionales":**
- El Excel de ADM tiene una sección "Otros gastos" con dos sub-secciones: "Gastos no admitidos" y "Otros gastos no operacionales" (donde vive 802.01 Intereses de Préstamos).
- El parser solo capturaba GNA, no los gastos financieros. Esto causaba una diferencia de Q1: portal mostraba 1,077,494.23 vs ADM 1,059,857.71 (diferencia = 17,636.52, exactamente el total de Intereses de Préstamos).
- Fix: se agregó detección de sub-secciones dentro de "Otros gastos" (`subSection = 'gna'` o `'gastos_fin'`). El total de "Otros gastos no operacionales" se resta de `ingreso_financiero` (que ahora es un valor neto: positivo = ingreso neto, negativo = gasto neto).
- También se agregó captura de "Otros ingresos" (sección propia en el Excel) que se suma a `ingreso_financiero`.

**2. Rename "Ingreso Financiero" → "Resultado Financiero":**
- En todos los labels de ambos archivos: panel presupuesto, panel ejecución, trimestral, proyección de impuestos.
- La variable de BD sigue siendo `ingreso_financiero` pero ahora almacena un valor neto.

**3. Alineación visual paneles Presupuesto vs Ejecución:**
- Cuando un panel tenía datos de Resultado Financiero/GNA y el otro no, las filas condicionales hacían que los bordes inferiores quedaran desalineados.
- Fix: se removió la lógica condicional `if (pIF || pGNA)` y `if (ejIF || ejGNA)`. Ahora ambos paneles siempre muestran las filas de Resultado Financiero, Gtos. No Admitidos y Ganancia/Pérdida (con $0.00 si no hay datos).

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`.
**SQL ejecutado:** `db/portal-ejecucion-migration.sql`, `db/portal-declaraciones-migration.sql` (ambos corridos por Félix 2026-04-30).

### 2026-04-30 — Corrección de fórmulas: Resultado Operacional y Ganancia/Pérdida

Félix detectó que los "Beneficios" no restaban salarios, causando diferencia con el Estado de Resultados de ADM.

**Cambio de esquema en ambos archivos (portal-admin.html y portal-clientes.html):**
- Antes: Beneficios = Ventas - Costos - Gastos (no incluía salarios)
- Ahora: Resultado Operacional = Ventas - Costos - Gastos - Salarios (cuadra con ADM)
- Debajo, si aplica: Ganancia / Pérdida = Resultado Op. + Ing. Financiero - Gastos No Admitidos
- El esquema se usa consistentemente en: tabla mensual de 3 meses, panel presupuesto, panel ejecución, comparación trimestral, y Proyección de Impuestos.

**Secciones corregidas:**
1. Tabla mensual (3 meses): conceptos ahora incluyen Salarios, fila resumen es "Resultado Op."
2. Panel Presupuesto: 4 filas (V, C, G, S) + Resultado Op. + condicional Ing.Fin/GNA/Ganancia
3. Panel Ejecución: misma estructura
4. Comparación trimestral: incluye Salarios en qRows y acumuladores
5. Proyección de Impuestos: `gananciaNeta = (V-C-G-S) + IF - GNA`, `projGanancia = (projV-projCO-projG-projS) + projIF - projGNA`
6. Tablas Realidad/Proyección: muestran Resultado Operacional + Ganancia/Pérdida
7. Bug fix: fila "Globales" en proyección usaba `totalS` en vez de `projS`

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`.

### 2026-04-30 — Investigación API Adm Cloud + Carga Excel Estado de Resultados

Sesión con dos bloques: investigar la API de Adm Cloud para automatización futura, e implementar carga de Excel como solución inmediata para el Estado de Resultados.

**1. Investigación API Adm Cloud:**
- Se exploró `https://apiexplorer.admcloud.net/` y se catalogaron todos los endpoints disponibles.
- Autenticación: Basic Auth (email:password en base64), params obligatorios: appid, company, role, skip.
- Hallazgos clave: no existe endpoint de Estado de Resultados ni Balance de Comprobación. El endpoint de Journals no tiene filtro por fecha. Habría que construir reportes financieros a mano combinando Journals + Accounts.
- Se creó `docs/Mapa-Contextual-API-ADM.docx` como documento de referencia con todo lo encontrado, incluyendo preguntas pendientes para Maurice (filtro de fechas, CORS, endpoints no documentados).
- Decisión: API queda como Fase 2. Fase 1 es la carga de Excel que ya funciona.

**2. Carga de Excel para Estado de Resultados (portal-admin.html):**
- Se reemplazó el textarea de paste con un sistema de carga de Excel usando SheetJS (CDN).
- Flujo: usuario sube archivo `.xlsx` → se detectan meses automáticamente (de los headers) → se parsea con `pmParseEdoResultados()` → preview con pills por mes y tabla de 6 partidas → botón "Guardar todos los meses" hace UPSERT masivo a `portal_ejecucion`.
- Los campos manuales se mantienen como fallback debajo.
- Parser `pmParseEdoResultados()` recorre filas detectando secciones (Ingresos, Costos, Gastos, Otros gastos, Ingresos financieros) por totales exactos (`lowerA === 'total ingresos'`, etc.).

**3. Regla de clasificación de salarios (corrección de Félix):**
- Salarios NO es igual a "Total Gastos de Personal". Solo incluye cuentas específicas de nómina.
- Keywords definidas en `PM_SALARY_KEYWORDS`: sueldo, incentivo, aporte sfs, aporte afp, riesgo laboral, infotep, seguro familiar, fondo de pensión.
- El parser examina cada línea de detalle dentro de Gastos de Personal y acumula solo las que coinciden con un keyword. El resto se queda en gastos generales.
- Validado con datos reales de cliente: los tres meses (Ene-Mar) cuadraron exactamente con el Excel fuente.

**Archivos para subir a GitHub:** `pages/portal-admin.html`.
**SQL ejecutado:** `db/portal-ejecucion-migration.sql`, `db/portal-declaraciones-migration.sql` (corridos por Félix 2026-04-30).
**Pendiente Félix:** hablar con Maurice sobre preguntas de la API (documentadas en Mapa Contextual).

### 2026-04-29 — Rediseño sección Declaraciones (Presentación Mensual)

Félix pidió alinear la vista de declaraciones con el checklist de impuestos y mejorar la experiencia visual.

**Cambios en la tabla principal:**
- Columnas: Obligación, Fecha Límite, Presentado, Pagado Mes Ant., Pagado Este Mes, Variación, + dots puntualidad últimos 3 meses.
- Se eliminó la tabla separada "Historial de Puntualidad" (ahora integrada como dots inline en la tabla principal).

**Semáforo de puntualidad (función `pmDeclColor`):**
- Verde: fecha_presentado <= fecha_limite - 5 días (fecha de firma).
- Amarillo: entre fecha de firma y fecha_limite.
- Rojo: después de fecha_limite.
- Gris: pendiente, no aplicó, o sin fechas.
- Solo dots de color, sin texto "A tiempo"/"Tarde"/"No aplicó".

**Summary cards actualizadas:**
- Card 1: Presentadas (X/5).
- Card 2: Pagado este mes + mes anterior.
- Card 3: Puntualidad con dots de semáforo y conteos.

**Nota general por mes:**
- Nueva columna `nota_declaraciones TEXT` en `portal_ejecucion` (migración: `db/portal-declaraciones-migration.sql`).
- En admin: textarea editable + botón "Guardar nota" (`pmSaveDeclNota()`).
- En cliente: solo lectura, se muestra si hay contenido.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`.
**SQL ejecutado:** `db/portal-declaraciones-migration.sql` (corrido por Félix 2026-04-30).

### 2026-04-29 — Rediseño Proyección de Impuestos (líneas + títulos + anticipos)

Cuatro cambios aplicados a la sección ISR dentro de Presentación Mensual, en ambos archivos (portal-admin.html y portal-clientes.html):

**1. Nuevas líneas en tablas Realidad/Proyección (+ migración DB):**
- Antes: Ventas, Costos, Gastos, Salarios (4 conceptos).
- Ahora: Ventas IT1, Costos Operativos, Gastos, Salarios, Ingreso Financiero, Gastos No Admitidos (6 conceptos).
- Fórmula ganancia neta: `ventas_it1 - costos_operativos - gastos + ingreso_financiero - gastos_no_admitidos`. Salarios se muestra pero no entra en el cálculo (igual que antes).
- Migración DB: `db/portal-ejecucion-migration.sql` renombra columnas (ventas→ventas_it1, costos→costos_operativos) y agrega nuevas (ingreso_financiero, gastos_no_admitidos en ejecución; salarios_anual, ingreso_financiero_anual, gastos_no_admitidos_anual en presupuesto).
- Formulario admin actualizado: 6 campos en presupuesto y ejecución, paste acepta 6 valores (backward compatible con 4).

**2. Título ISR igualado al de Impuesto al Activo:**
- Se eliminó el sub-header "Impuesto Sobre la Renta*" que hacía el panel más alto.
- El header principal cambió de "Proyección Impuestos" a "Impuesto Sobre la Renta".

**3. Anticipos Mensuales divididos en dos tablas:**
- Antes: una sola tabla de 12 filas (bajaba demasiado).
- Ahora: dos tablas lado a lado usando `pm-dual` (Ene-Jun / Jul-Dic), 6 filas cada una con subtotal, y Total Anual debajo.

**4. Memory actualizado** (esta entrada).

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/portal-clientes.html`.
**SQL ejecutado:** `db/portal-ejecucion-migration.sql` (corrido por Félix 2026-04-30).

### 2026-04-29 — Modo admin en portal-clientes.html

Félix necesitaba acceso fácil al listado de clientes y sus links de portal desde la vista del cliente. Se agregó modo admin a `portal-clientes.html`:

**Flujo dual:**
- **Con token** (`?token=UUID`): funciona igual que antes. El cliente ve su portal sin login.
- **Sin token**: muestra login de admin. Después del login, valida rol admin en `profiles`. Si no es admin, muestra "Acceso denegado".

**Vista admin (índice):**
- Summary stats: clientes activos, con token, sin token (ámbar si >0).
- Tabla con #, nombre del cliente, link completo del portal, botón "Copiar" y botón "Ver".
- "Copiar" copia el link al clipboard con toast de confirmación.
- "Ver" carga la vista del cliente inline (misma página), cargando datos de checklist + presentación.

**Navegación admin:**
- Al hacer click en "Ver", se oculta el índice y se muestra la vista completa del cliente (tabs Checklist/Presentación, month pills, etc.).
- En el bar de tabs aparece "← Volver al listado" para regresar al índice.
- `pcBackToIndex()` resetea todo el estado del cliente y re-renderiza el índice.

**Embed mode:** si no hay sesión, muestra "Sesión no encontrada" (mismo patrón que otros módulos).

**Namespacing:** funciones admin con prefijo `pc` (pcDoLogin, pcInitAdmin, pcRenderAdminIndex, pcOpenCliente, pcBackToIndex, pcCopyLink, pcGetBaseUrl).

**Archivos para subir a GitHub:** `pages/portal-clientes.html`.

### 2026-04-29 — Rediseño arquitectura portal-admin.html (tabs al nivel del índice)

Félix pidió un cambio estructural importante: los tabs principales (Checklist / Presentación Mensual) ahora se muestran en el nivel del índice (antes de seleccionar un cliente), no después.

**Cambios de identidad:**
- Título cambiado de "Portal Admin" a "Portal Clientes" (header, `<title>`, breadcrumb).
- Subtítulo cambiado de "Account One — Impuestos" a "Account One".
- index.html: sidebar renombrado de "Portal Admin (A)" a "Portal Clientes (A)" con icono 🌐 (mismo que Portal Clientes (C)).

**Cambios arquitectónicos en portal-admin.html:**
- `mainTabs` ahora se muestra desde `initAdmin()`, antes de que el usuario entre a un cliente.
- `renderAdminIndex()` ahora tiene dos ramas según `selectedMainTab`:
  - **'checklist'**: tabla con columnas TSS/IR-3/IR-17/Anticipo/ITBIS (la tabla original).
  - **'presentacion'**: tabla nueva con columnas Presupuesto/Ejecución/Config/Declaraciones/Estado.
- Al hacer click en un cliente, se abre el detalle del tab que esté activo (checklist → detalle checklist, presentación → detalle presentación).
- `idxBackToIndex()` ya no resetea `selectedMainTab` — el tab activo persiste al volver del detalle.
- `idxOpenCliente()` ya no fuerza `selectedMainTab = 'checklist'` — respeta el tab actual.

**Carga de datos bulk para presentación en índice:**
- 4 nuevas queries en `initAdmin()` (en paralelo con las existentes): `portal_presupuesto`, `portal_ejecucion`, `portal_impuestos_config`, `portal_declaraciones`.
- Variables bulk: `allPresupuesto`, `allEjecucionBulk`, `allImpConfigBulk`, `allDeclaracionesBulk`.
- Helper functions: `hasPresupuesto()`, `hasEjecucionMes()`, `hasImpConfig()`, `getDeclCount()`, `getEjecucionCount()`.
- Summary stats del tab Presentación: total clientes, con presupuesto, ejecución del mes, config impuestos, declaraciones 5/5.

**Archivos para subir a GitHub:** `pages/portal-admin.html`, `pages/index.html`.

### 2026-04-29 — Split portal-clientes.html en dos archivos

El archivo monolítico `portal-clientes.html` (~2141 líneas) manejaba dos flujos completamente distintos: acceso por token (cliente) y acceso admin (login Supabase). Se separó en dos archivos independientes:

**portal-clientes.html (reescrito, ~1700 líneas) — Solo vista cliente:**
- Acceso exclusivo por `?token=UUID` validado contra `portal_clientes_tokens`.
- Sin login, sin auth de Supabase. Si no hay token, muestra pantalla de error.
- Checklist completo con interactividad (toggle, upload, monto).
- Presentación Mensual con las 3 secciones (Presupuesto vs Ejecución, Proyección Impuestos, Declaraciones) en modo lectura.
- Sin botón "Cargar Datos", sin `renderAdminDatos`, sin funciones `pmSave*`.
- `isAdminMode` eliminado (siempre false implícito).

**portal-admin.html (nuevo, ~2100 líneas) — Solo vista admin:**
- Title: "Portal Admin — Account One", header: "Portal Admin".
- Login con Supabase Auth + verificación de rol admin en `profiles`.
- Índice de clientes con summary stats, tabla con barra de progreso, filtro por contadora.
- Click en cliente abre detalle con checklist interactivo + presentación con "Cargar Datos".
- Todas las funciones admin: `renderAdminDatos`, `pmSavePresupuesto`, `pmSaveEjecucion`, `pmSaveImpConfig`, `pmSaveDeclaraciones`, `pmParsePaste`, `pmUpdateEjFields`.
- `isAdminMode = true` siempre después del login.
- Soporta `?embed=1`.

Ambos archivos son completamente independientes (CSS/JS duplicado inline). Misma Supabase URL y anon key. Variable del cliente = `sb`.

**Archivos para subir a GitHub:** `pages/portal-clientes.html`, `pages/portal-admin.html`.

**index.html actualizado:** Sidebar ahora tiene dos entradas separadas: "Portal Admin (A)" → `portal-admin.html` y "Portal Clientes (C)" → `portal-clientes.html`. Ambas con `roles: ['admin']`.

**SQL ejecutado:** `db/portal-presentacion-setup.sql` (4 tablas de presentación mensual).

**Archivos para subir a GitHub:** `pages/portal-clientes.html`, `pages/portal-admin.html`, `pages/index.html`.

### 2026-04-29 — Presentación Mensual en portal-clientes.html

Félix movió la prioridad: Presentación Mensual es ahora prioridad 1 (antes era el plan de permisos/usuarios).

**Nuevas tablas Supabase (SQL: `db/portal-presentacion-setup.sql`):**
- `portal_presupuesto` — presupuesto anual por cliente (ventas/costos/gastos anuales, mensual se calcula en JS dividiendo entre 12).
- `portal_ejecucion` — ejecución mensual del estado de resultados ADM (ventas/costos/gastos/salarios por mes).
- `portal_impuestos_config` — configuración fiscal anual (anticipos tramo1 ene-abr y tramo2 may-dic, pérdidas compensables, activos, CRS).
- `portal_declaraciones` — estado por obligación por mes (TSS, IR-3, IR-17, Anticipo, ITBIS) con fechas y montos.
- Todas con RLS: admin escribe, lectura pública (clientes acceden por token sin auth).

**Cambios en portal-clientes.html:**

Sistema de tabs reestructurado a dos niveles:
- **Main tabs** (`.pm-main-tabs`): Checklist y Presentación Mensual.
- **Sub-tabs** (`.pm-sub-tabs`): Dashboard/TSS/IR-3/IR-17/Anticipo/ITBIS, solo visibles cuando Checklist está activo.
- Variables: `selectedMainTab` ('checklist'/'presentacion'), `pmDetail` (null/'presupuesto'/'proyeccion'/'declaraciones'/'admin-datos').
- `renderTabs()` reemplazado por `renderMainTabs()` + `renderSubTabs()` + `switchMainTab()`.

Tab Presentación tiene 3 section cards que abren vistas detalle:

**1. Presupuesto vs Ejecución** (`renderPresupuestoDetail()`):
- Tabla trimestral con ventas/costos/gastos por mes del quarter actual.
- Dual panel: presupuesto mensual (anual/12) vs ejecución real, con % meta y colores.
- Resultado consolidado del trimestre con barra de ganancia.

**2. Proyección de Impuestos** (`renderProyeccionDetail()`):
- 3 summary cards: ganancia proyectada, ISR 27%, anticipo mensual próximo año.
- Dual panel: realidad (datos hasta hoy) vs proyección (promedio mensual x 12).
- Dual panel: ISR detallado (base imponible, pérdidas, renta neta, anticipos, total a pagar) + impuesto al activo (1% sobre base, comparativo con ISR).
- Dual panel: anticipos año corriente (tramo 1 y 2) + proyección anticipo próximo año (TET, variación).
- Banner CRS con base de cálculo e ingresos.
- Tabla de anticipos mensuales con semáforo de tramo.

**3. Resumen de Declaraciones** (`renderDeclaracionesDetail()`):
- Summary cards: obligaciones presentadas, a tiempo, total pagado.
- Tabla detalle por obligación: fecha límite, presentado, monto, mes anterior, variación %, puntualidad.
- Historial de puntualidad (últimos 3 meses) con semáforo.

**Interfaz admin para cargar datos** (solo visible para admin):
- Botón "Cargar Datos" en la vista de section cards abre `renderAdminDatos()`.
- 4 formularios en una página:
  1. **Presupuesto anual**: 3 campos (ventas/costos/gastos anuales) con cálculo mensual automático. UPSERT a `portal_presupuesto`.
  2. **Ejecución (ADM)**: selector de mes, textarea para pegar desde Excel/CSV, 4 campos manuales (ventas/costos/gastos/salarios), parser de paste, indicador de meses ya cargados. UPSERT a `portal_ejecucion`.
  3. **Config impuestos**: 6 campos (anticipo tramo1/2, pérdidas, activos totales/exentos, CRS). UPSERT a `portal_impuestos_config`.
  4. **Declaraciones del mes**: 5 cards (una por obligación) cada una con estado/fecha límite/fecha presentado/monto. UPSERT batch a `portal_declaraciones`.
- Cada formulario guarda independiente con toast de confirmación. Al guardar, recarga datos y re-renderiza.

**CSS:** Todas las clases nuevas con prefijo `pm-` para evitar conflictos. Admin forms con prefijo `pm-admin-`.

**Admin flow corregido:**
- `idxOpenCliente()` ahora carga `loadPresentacionData()` junto con `loadData()` y `loadFiles()`.
- `idxBackToIndex()` resetea estado de presentación (pmPresupuesto, pmEjecucion, etc.) y oculta subTabs.
- `renderTabs()` eliminado completamente; todas las referencias migradas a `renderMainTabs()` + `renderSubTabs()`.

**SQL pendiente de ejecutar:** `db/portal-presentacion-setup.sql`.

**Archivos para subir a GitHub:** `pages/portal-clientes.html`.

### 2026-04-27 — Portal de Clientes + Links Portal en Gerencia + Fix impuestos spacing

**Impuestos.html — spacing fix:**
- El nav-area (month pills + contadora pills) estaba dentro de `.content`, causando espaciado incorrecto vs contabilidad.
- Fix: se extrajo `renderNav()` como función separada, se agregó `<div id="navArea">` FUERA de `.content` (entre main-tabs y content), igualando la estructura de contabilidad.html.
- `.main-tab` recibió `margin-bottom:-2px` para que la línea del tab activo quede sobre la zona blanca.

**Portal de Clientes (portal-clientes.html) — módulo nuevo:**
- 6 tabs: Dashboard, TSS, IR-3, IR-17, Anticipo, ITBIS.
- Cada tab tiene un checklist de tareas con tipos: yesno (toggle Sí/No), upload (subir archivo a Supabase Storage), monto (campo numérico), auto (hereda estado de otro tab).
- Dashboard muestra summary cards por impuesto con fecha límite, progreso y semáforo (verde/amarillo/rojo/gris).
- IR-3 hereda automáticamente el estado de nómina/volantes desde TSS via `isItemDone()`.
- ITBIS tiene sub-item condicional: "solicitar pago a cuenta" solo aparece si facturas_atrasadas = sí.
- Dual mode: cliente accede via `?token=UUID` (sin login), admin accede con sesión Supabase + dropdown selector de cliente.
- Archivos se suben a bucket `portal-clientes` en Supabase Storage, registro en tabla `portal_clientes_archivos`.
- SQL setup en `db/portal-clientes-setup.sql`: tablas `portal_clientes_tokens`, `portal_clientes_data`, `portal_clientes_archivos`. RLS admin-only por ahora.

**Gerencia.html — Links Portal (sub-tab en Base de Datos):**
- Nuevo sub-tab "Links Portal" junto a Clientes, Contadoras, Asignaciones.
- Tabla con #, cliente, link completo, botón Copiar.
- `bdLoadTokens()` lee de `portal_clientes_tokens` donde `activo=true`.
- `bdCopyLink()` copia un link individual, `bdCopyAllLinks()` copia todos como texto.
- `bdGetPortalBaseUrl()` construye la URL base dinámicamente desde `window.location`.
- Bug fix: las referencias usaban `escG()` que no existe en gerencia.html, corregido a `esc()`.

**index.html:** portal-clientes activado en sidebar (`active: true`).

**Fix login admin (mismo día):**
- El portal no tenía login propio. Cuando un admin entraba sin token y sin sesión previa, veía "Enlace no válido".
- Se agregó login-overlay con email/password (mismo patrón que los demás módulos).
- `init()` refactoreado: si no hay token ni sesión, muestra login. `doLogin()` autentica y llama a `initAdmin()`.
- `initAdmin()` extraído como función separada (reutilizada por init y doLogin).
- En embed mode sin sesión, muestra mensaje "Sesion no encontrada" (igual que gerencia.html).

**SQL ya ejecutado por Félix:** `db/portal-clientes-setup.sql`.

**Archivos para subir a GitHub:** `pages/impuestos.html`, `pages/portal-clientes.html`, `pages/index.html`, `pages/gerencia.html`.

### 2026-04-27 — Ajustes de ordenamiento, conteos y Bookkeeping

**gerencia.html — Asignaciones: fix conteos y sort:**
- `bdGetAsigForMes()` y `bdGetContadorasForAsig()` ya no excluyen contadoras con `tipo='facturacion'` (Karina). Sus clientes ahora aparecen en la tabla.
- Summary pills cambiados a: Total clientes (de maestra `bdClientes`), Asignados, Sin asignar, Contadoras activas. Asignados + Sin asignar = Total siempre cuadra.
- Sort: clientes "Sin asignar" primero (alfabético), luego asignados (alfabético).

**gerencia.html — BD Clientes: sort sin tipo primero + Bookkeeping:**
- Sort cambiado: activos sin tipo_servicio primero (alfabético), luego activos con tipo (alfabético), inactivos al final.
- Nuevo tipo_servicio: "Bookkeeping" (violeta #8b5cf6). Agregado en select del modal, badge en tabla, tab Servicios (card, filtro, grupo).
- SQL: `db/clientes-add-bookkeeping.sql` — CHECK constraint actualizado (ya ejecutado).

**contabilidad.html + impuestos.html — Sin asignar al fondo:**
- Clientes con `contadora === 'Sin asignar'` ordenados al final de la tabla (alfabético dentro de cada grupo).
- Estado muestra "Sin asignar" con badge ámbar (`.ck-status-sinasignar` / `.imp-status-sinasignar`) en vez de "Pendiente".
- Label "Total clientes activos" acortado a "Total clientes" en ambos módulos.

### 2026-04-26 — Fases B, C, D: Consolidación BD de clientes

**Sub-fase B — Migración de datos** (SQL: `db/clientes-consolidacion-fase-b.sql`):
- Poblado de `monto_adm` desde `asignaciones.serv` (la columna `adm` tiene transacciones digitadas variables, `serv` tiene el contrato: 50, 100 o 200).
- Flags corregidos por cliente: Kaizen y Centro Adorartes son RST (`resp_imp=false`). CLC, Vitalie y Fleximoney solo llevan impuestos con Karina (`resp_contab=false`, `contadora_impuestos='Karina'`). Mab Arquitectura es bookkeeping con Milka (ambos false).
- `perfiles_clientes` marcada como deprecada.

**Sub-fase C — Documentar rol de asignaciones** (SQL: `db/clientes-consolidacion-fase-c.sql`):
- COMMENT ON TABLE y COMMENT ON COLUMN documentando que `asignaciones` es ahora para excepciones mensuales. Datos de ene-abr 2026 son históricos del modelo anterior.
- Lógica de fallback: módulos leen de `clientes` (maestra) como default. Solo consultan `asignaciones` si hay excepción para ese mes.

**Sub-fase D — Refactor de módulos**:
- **contabilidad.html:** `loadAsignaciones()` reescrita. Lee clientes de `clientes` con `responsabilidad_contabilidad=true`. Nuevas variables `CLIENTES_CONTAB` y `ASIG_ADM`. Construye ASIGNACIONES desde la maestra (mismos clientes todos los meses). La columna `adm` de asignaciones solo se usa para tracking de digitación.
- **impuestos.html:** `loadContadoras()` reescrita. Lee de `clientes` con `responsabilidad_impuestos=true`. Construye `contadorasMap._maestra` como mapa único (mismo universo todos los meses).
- **implementaciones.html:** `loadContadoras()` cambió de `asignaciones` a `contadoras` (tabla propia, filtro `activa=true`).
- **gerencia.html (BD Clientes):** Modal con dos selects de contadora (contab/imp), dos checkboxes de responsabilidad, dropdown de monto_adm. Tabla muestra "N/A" cuando responsabilidad es false. Search actualizado para buscar en ambos campos de contadora.
- **gerencia.html (Control Contadoras):** Sin cambios, sigue leyendo de `asignaciones`. Se refactoreará en Fase 4.

**Estado de los módulos actualizado:**

| Módulo | Lee clientes de |
|---|---|
| contabilidad.html | `clientes` (maestra) |
| impuestos.html | `clientes` (maestra) |
| implementaciones.html | `implementaciones_*` (tablas propias) |
| gerencia.html BD Clientes | `clientes` (maestra) |
| gerencia.html Ctrl Contadoras | `asignaciones` (pendiente Fase 4) |

### 2026-04-26 — Sub-fase E: UI de gestión de clientes + historial de contadoras

Cambios en `gerencia.html` (BD Clientes):
- Al editar un cliente y cambiar la contadora (contabilidad o impuestos), aparece un campo de "Motivo del cambio" con fondo amarillo. El motivo se graba en `clientes_cambios_contadora` después de que el trigger crea el registro automático.
- Botón de historial (reloj) en cada fila de la tabla (solo admin). Abre modal con tabla de cambios: fecha, área (badge azul "Contab" o verde "Imp"), contadora anterior, nueva, motivo.
- Variables `clOrigContab` / `clOrigImp` guardan el valor original al abrir modal. `clCheckContadoraChanged()` muestra/oculta el campo motivo según si hubo cambio.
- Con esto se cierra la Fase 1 completa (5 sub-fases A-E).

### 2026-04-26 — Sesión de mejoras (toggle activo, Servicios, formato fecha, Karina)

**gerencia.html — Toggle activo/inactivo en modal BD Clientes:**
- Botón toggle Activo (verde) / Inactivo (rojo) en el modal de editar cliente. Cuando se marca inactivo, aparece campo fecha_salida. Si se pone fecha_salida, se marca inactivo automáticamente.
- `clModalActivo`, `clRenderActivoBtn()`, `clToggleActivo()`, `clOnFechaSalidaChange()`. El record de save incluye `activo: clModalActivo`.

**gerencia.html — Tab Servicios en Control de Clientes:**
- Nuevo main tab "Servicios" junto a Dashboard. Lee `tipo_servicio` de la maestra (`ccAllClientes`).
- Month tabs para filtrar por mes (misma lógica de fecha_entrada/fecha_salida que el Dashboard). Variable `ccServMes`. Función `ccServGetActivosMes()`.
- Summary stats clicables (orden): Total clientes, Tax One (azul), Contabilidad (verde), Supervisión (ámbar), Bookkeeping (violeta #8b5cf6, solo si hay), Sin asignar (gris, solo si hay). Click filtra la tabla.
- Tabla agrupada por tipo de servicio cuando se ve "Todos" (group-row headers). Orden: Tax One → Contabilidad → Supervisión → Bookkeeping → Sin asignar (al final).
- Card seleccionada tiene borde activo (`.cc-serv-stat.active`).
- Nota amarilla si hay clientes sin tipo de servicio asignado.

**impuestos.html — Formato de fecha y UX:**
- Columna FECHA en detalle ahora muestra semáforo (bolita verde/ámbar/roja) + `formatDateShort()` en vez del string ISO crudo. Compara contra firma y deadline del impuesto.
- `.nav-area` wrapper para month tabs + contadora pills (mismo patrón que contabilidad). Summary stats con Total clientes, Asignados, Sin asignar, Completados, En progreso, Sin iniciar, Avance promedio.
- Clientes "Sin asignar" al fondo de la tabla con badge de estado ámbar (`.imp-status-sinasignar`). Sort: `contadora === 'Sin asignar'` → al final, luego alfabético.
- NOTA: agrupación por contadora en tabla principal fue REVERTIDA. Félix quiere tabla alfabética general, agrupación solo al hacer click en una pill de contadora.

**contabilidad.html — Karina incluida + grupo "Sin asignar":**
- Karina removida de EXCLUIDAS (solo quedan Milka y Yolenny). Ahora aparece como contadora con sus clientes.
- Clientes sin `contadora_contabilidad` se agrupan bajo "Sin asignar" (pill al final, group en tabla).
- Clientes "Sin asignar" al fondo de la tabla con badge de estado ámbar (`.ck-status-sinasignar`). Sort: `contadora === 'Sin asignar'` → al final, luego alfabético.
- Summary stats: Total clientes, Asignados, Sin asignar (ámbar si >0), Completados, En progreso, Sin iniciar, Avance promedio.
- SQL: `db/clientes-update-fleximoney-karina.sql` — actualiza Fleximoney a `resp_contab=true`, `contadora_contab='Karina'`.

**SQL pendientes de ejecutar:**
- `db/clientes-update-fleximoney-karina.sql` — Fleximoney con Karina en contabilidad

### 2026-04-26 — Tipo de servicio, fecha de salida, orden de inactivos

Cambios en tabla `clientes` (SQL: `db/clientes-tipo-servicio.sql`):
- Nueva columna `tipo_servicio` TEXT con CHECK: 'Contabilidad completa', 'Solo impuestos', 'Solo supervisión'.
- Nueva columna `fecha_salida` DATE para registrar cuándo dejó de ser cliente.

Cambios en `gerencia.html` (BD Clientes):
- Modal: agregados select de tipo_servicio y input date de fecha_salida.
- Tabla: nueva columna "Servicio" (tipo_servicio). Se quitó columna "Contacto" para hacer espacio. Fecha de salida aparece debajo del badge "Inactivo" en la columna Estado.
- Ordenamiento: activos primero (alfabético), inactivos al final (alfabético). Filas inactivas con opacity 0.55.
- `clOpenModal()` y `clSaveClient()` actualizados para leer/grabar ambos campos.

### 2026-04-26 — Control de Clientes: datos derivados de la maestra

**Problema:** `meses_resumen` tenía datos manuales que no cuadraban (abril: inicio=29, nuevos=3, churn=2, cierre=30 cuando debía ser inicio=31, cierre=32).

**Solución:** `ccLoadData()` reescrita para derivar todo de la tabla `clientes`:
- Nuevos por mes = clientes con `fecha_entrada` en ese mes/año.
- Churn por mes = clientes con `fecha_salida` en ese mes/año.
- Cierre = conteo de clientes donde (fecha_entrada IS NULL o <= fin_mes) AND (fecha_salida IS NULL o > fin_mes).
- Serv total = suma de `monto_adm` de clientes activos con `responsabilidad_contabilidad`.
- Adm real sigue viniendo de `asignaciones`.
- Notas por mes todavía se leen de `meses_resumen` (solo el campo notas).
- `meses_resumen` ya no es fuente de totales/nuevos/churn. Se mantiene por las notas históricas.

**SQL:** `db/clientes-fechas-movimientos.sql` — pobla `fecha_entrada` y `fecha_salida` para los movimientos conocidos de ene-abr 2026 (datos de meses_resumen migrados a la maestra).

**Flujo para Félix:** para registrar entrada de un cliente nuevo, lo agrega en BD Clientes con `fecha_entrada`. Para registrar una salida, edita el cliente: `activo=false` + `fecha_salida`. El dashboard de Control de Clientes se actualiza solo.

### 2026-04-26 — Tab "Base de Datos" en Gerencia (reemplaza "Clientes")

El tab "Clientes" (directorio) en gerencia.html se reemplazó por "Base de Datos", un centro de datos con tres sub-tabs:

**Sub-tab Clientes:**
- Misma funcionalidad que el directorio anterior (tabla, búsqueda, stats, modal crear/editar).
- Namespacing cambiado: los datos ahora viven en `bdClientes` (antes `clData`). Funciones de modal siguen con prefijo `cl*`.

**Sub-tab Contadoras (nuevo):**
- Tabla de contadoras con columnas: nombre, tipo (plena/facturación/freelance), capacidad, estado (activa/inactiva), notas.
- Stats arriba: activas, plenas, inactivas.
- Modal para crear/editar contadoras (admin).
- Requiere tabla Supabase `contadoras` (SQL en `db/contadoras-table.sql`). Si la tabla no existe, muestra aviso.

**Sub-tab Asignaciones (nuevo):**
- Month pills (Ene-Dic) para navegar por mes.
- Tabla editable: cliente, contadora (dropdown), serv, adm.
- Excluye clientes de facturación electrónica (contadoras con tipo='facturacion', fallback a nombre 'Karina').
- Stats: clientes asignados, contadoras activas, sin asignar.
- Botón "+ Agregar asignación" (prompt con clientes disponibles).
- Botón "Guardar cambios" con dirty tracking (indicador visual de cambios pendientes).
- Confirmación al cambiar de mes o sub-tab con cambios sin guardar.

**Cambios técnicos:**
- Namespacing: prefijo `bd*` para Base de Datos. Sub-tabs usan clase `.bd-sub-tab`.
- `bdLoadAll()` carga clientes + contadoras + asignaciones en paralelo.
- `showApp()` ahora incluye `bdLoadAll()` en lugar de `clLoadData()`.
- Tab principal cambió de `{id:'directorio', label:'Clientes'}` a `{id:'basedatos', label:'Base de Datos'}`.
- HTML: `cl-area` → `bd-area` con sub-tabs.
- Mes de asignaciones se inicializa al mes actual (o último con datos).

**SQL pendiente de ejecutar:**
- `db/contadoras-table.sql` — crear tabla `contadoras` con datos iniciales (7 contadoras: Taina, Beliani, Yessica, Victoria, Karina, Milka, Yolenny).

### 2026-04-26 — Fase A: Consolidación de la BD de clientes

Primer paso de un plan de 5 fases para consolidar la base de datos de clientes. SQL en `db/clientes-consolidacion-fase-a.sql`.

**Cambios en tabla `clientes`:**
- Nuevas columnas: `responsabilidad_contabilidad` (bool), `responsabilidad_impuestos` (bool), `contadora_contabilidad` (text), `contadora_impuestos` (text), `monto_adm` (int, transacciones contratadas).
- Migración automática: datos de la columna vieja `contadora` copiados a `contadora_contabilidad` y `contadora_impuestos`.
- Lógica especial: Karina (facturación electrónica) queda con ambas responsabilidades en false y contadoras en NULL. Milka queda con `responsabilidad_impuestos = false`.
- DROP de la columna vieja `contadora`.

**Nueva tabla `clientes_cambios_contadora`:**
- Historial automático: cliente, área (contabilidad/impuestos), contadora anterior, contadora nueva, fecha, motivo.
- Trigger `trg_log_cambio_contadora` se dispara en cualquier UPDATE a `contadora_contabilidad` o `contadora_impuestos`.
- Función `log_cambio_contadora()` es SECURITY DEFINER para bypassear RLS al insertar.

**Impacto conocido:** gerencia.html (sub-tab BD Clientes) lee `contadora` de la tabla clientes. Después de esta migración, esa columna ya no existe. Se arregla en fases posteriores cuando se actualicen los módulos del portal.

**Decisión de Félix:** `monto_adm` es cantidad de transacciones contratadas (integer), no un valor monetario.

### 2026-04-26 — Fixes en impuestos.html (embed + filtrado por mes)

Tres problemas corregidos:

**1. Embed mode ocultaba tabs Checklist/KPI:**
- La regla CSS `body.embed .main-tabs { display:none !important; }` ocultaba la navegación interna del módulo cuando se cargaba dentro de index.html (iframe con `?embed=1`).
- Fix: se quitó `.main-tabs` de la regla de ocultación. Los otros módulos (contabilidad, gerencia) nunca ocultaban main-tabs en embed.
- Regla correcta: `body.embed .login-overlay, body.embed .header, body.embed .breadcrumb-bar { display:none !important; }`

**2. contadorasMap no filtraba por mes:**
- El map se construía plano (`{ contadora: [clients] }`) mezclando todos los meses. Contadora pills y tabla mostraban clientes de todos los meses.
- Fix: reestructurado a `{ mes: { contadora: [clients] } }`. Nueva función `getContadorasForMes(mes)`. Pills y tablas ahora filtran por mes seleccionado.

**3. Función esc() incompleta:**
- Solo escapaba comillas simples. No protegía contra HTML injection.
- Fix: `esc()` ahora escapa &, ", <, >, '. Nueva función `escJs()` para contextos de onclick/onchange en JS strings.

### 2026-04-26 — Módulo de Implementaciones
Nuevo archivo `implementaciones.html` con dos pestañas (show/hide, mismo patrón de gerencia.html):

**Tab 1 — Implementación Completa:**
- Tabla con columnas: cliente, contadora, fecha inicio, fecha fin, primer mes de responsabilidad, estatus.
- Estatus editable via dropdown (Kick-off → Sesión 2 → Sesión 3 → Sesión 4 → Sesión 5 → Go Live).
- UPDATE inmediato a Supabase al cambiar estatus, con toast de confirmación.
- Botón "+ Agregar cliente" con modal (validación: cliente y estatus obligatorios).

**Tab 2 — Facturación Electrónica:**
- Month pills arriba filtrando por `fecha_go_live_estimada`.
- Tabla: cliente, contadora, fecha go live estimada, semáforo, estatus.
- Semáforo: verde (>7 días), amarillo (0-7 días), rojo (fecha pasada y no Go Live), check verde (Go Live).
- Estatus: 5 pasos desde "Correo de requisitos iniciales" hasta "Go Live". Dropdown editable con UPDATE inmediato.
- Botón "+ Agregar cliente" con modal propio.

**Namespacing:** `ic*` para Implementación Completa, `fe*` para Facturación Electrónica.
**Permisos:** Solo admin y grupo Implementaciones pueden editar. Lectura para cualquier usuario autenticado. Las contadoras ven pero no modifican.
**Tablas Supabase:** `implementaciones_completas` e `implementaciones_fe` (SQL en `db/implementaciones-setup.sql`).
**Grupo:** "Implementaciones" creado con permisos de consulta + adición + edición. Para Claudia.
**Sidebar:** Activado con roles `['admin', 'implementaciones']`.

**Pendientes potenciales:**
- Columna de notas internas visible en tabla (campo `notas` existe en la BD pero no se muestra en UI todavía).
- Automatizaciones al llegar a Go Live (notificaciones, cambio automático de estado en otros módulos).
- Poder editar todos los campos inline, no solo el estatus (actualmente para editar otros campos hay que hacerlo desde Supabase).

### 2026-04-26 — Tab "Clientes" en Gerencia + Crear usuarios
Dos mejoras:

**Tab "Clientes" en gerencia.html:**
- Tercera pestaña en Gerencia: directorio maestro de clientes de la firma.
- Tabla con nombre, RNC, contadora, contacto, fecha de entrada, inicio responsabilidad fiscal, estado (activo/inactivo).
- Cards de estadísticas arriba: activos, inactivos, total.
- Buscador y botón "+ Nuevo cliente" con modal completo (crear y editar).
- Namespacing: `cl*` para variables y funciones del módulo.
- Tabla Supabase: `clientes` (SQL en `db/clientes-setup.sql`). RLS: admin escribe, todos leen.

**Crear usuarios desde usuarios.html:**
- Formulario de invitación dentro del tab Usuarios (solo visible para admin).
- Campos: correo (obligatorio), nombre, rol (contadora/admin).
- Llama a función de base de datos `invite_user()` que usa la Auth Admin API para crear el usuario y enviar invitación por email.
- El usuario recibe un link para crear su contraseña.
- SQL de la función en `db/invite-user-function.sql`. Requiere configurar la service_role_key en Supabase (instrucciones en el archivo).
- Toast de confirmación al enviar invitación.

**Pendientes:**
- Configurar `app.settings.service_role_key` en Supabase para que funcione la invitación (hay instrucciones en el SQL).
- La extensión `http` debe estar habilitada en Supabase (el SQL la habilita automáticamente).

### 2026-04-26 — Gran rediseño: impuestos, contabilidad y gerencia

Tres cambios estructurales grandes:

**1. Renombrar contadores-tab.html → contabilidad.html:**
- Copia del archivo con nuevo nombre y títulos actualizados (header, breadcrumb, title tag).
- index.html sidebar actualizado: id cambiado a `contabilidad`, href a `contabilidad.html`.
- El archivo mantiene solo Checklist + KPI como tabs. Control de Contadoras está en gerencia.html.

**2. Rediseño de impuestos.html — módulo lineal sin tabs:**
- Se eliminó la estructura de dos tabs (Control + Checklist). Ahora es un flujo lineal.
- Vista principal: month pills, contadora pills, filter cards, tabla matriz cliente x impuesto (igual estética que antes).
- Click en nombre de cliente → vista detalle con: month pills, back button, header card (nombre, contadora, pendientes, barra de progreso), tabla de tareas agrupadas por impuesto.
- Campo **importe** nuevo (editable por impuesto, guardado en BD). SQL migration en `db/impuestos-importe-migration.sql`.
- Cada tarea tiene checkbox inline, fecha de completado automática, badge de estatus.
- Importe y firma/deadline se muestran con rowspan en el primer item de cada grupo.
- Bug fix: `mapKey` ahora usa `||` como separador en vez de `_` (evita conflicto con nombres de clientes que contienen underscore).
- Toast de confirmación al guardar.

**3. Rediseño de Control de Contadoras en gerencia.html (vista admin):**
- Se reemplazaron las expandable sections por contadora (con mini KPIs y tabla de semáforo) por una tabla plana de clientes.
- Tabla muestra: cliente, contadora, progreso checklist (barra + x/24), progreso reportes (x/5), badge de estado.
- Click en fila de cliente → vista detalle con las 24 tareas del checklist de contadores (mismos items que contabilidad.html).
- Detalle tiene: month pills, back button, header card con barra de progreso, tabla con #, tarea, deadline, estado, fecha completado.
- Checkboxes editables que guardan inmediatamente a `checklist_contadores` (sin botón de guardar).
- Se carga `checklist_contadores` en paralelo con `reporte_mensual` al renderizar.
- KPI dashboard se mantiene arriba (facturas, reportes, video).
- Month pills y contadora pills se mantienen.
- Vista de contadora (no admin) NO se tocó.
- Nuevas variables: `ctdCHECKLIST_ITEMS` (24 items), `ctdChecklistData`, `ctdDetailCliente`, `ctdDetailContadora`.

### 2026-04-25 — Fix Milka en control-contadoras
El filtro de EXCLUIDAS usaba `indexOf` exacto pero en Supabase el nombre es "Milka (freelance)". Se cambió a función `isExcluida()` que hace match parcial (startsWith).

### 2026-04-25 — Dashboard de KPIs en inicio
Se reemplazó el grid de módulos (redundante con el sidebar) por un dashboard con tres KPI cards:
- **Clientes contabilidad**: total actual + delta vs mes anterior (de `meses_resumen`)
- **Clientes software**: total actual + delta vs mes anterior (de `software_clientes`)
- **Cierres del mes**: leads con funnel "Cerrado Ganado" del mes actual, desglose por categoría (Recurrente, Implementación, FE)
El dashboard se recarga cada vez que el usuario vuelve a Inicio.

### 2026-04-25 — Categoría en ventas.html
Se agregó columna `categoria` a leads (Implementacion, Facturacion Electronica, Recurrente). SQL: `db/leads-categoria.sql`. Badge visual en la tabla y select en los formularios de edición/creación.

### 2026-04-25 — Módulo de Impuestos
Nuevo archivo `impuestos.html` con dos pestañas:

**Tab 1 — Control de Impuestos:**
- Month pills + contadora pills (mismo patrón que control-contadoras).
- Filter cards arriba: Pendientes, Por vencer (a 2 días del deadline), En atraso (flag manual), En progreso. Los finalizados se ocultan.
- Tabla tipo matriz: fila por cliente (con nombre de contadora), columna por impuesto (TSS día 3, IR-3 día 10, IR-17 día 10, Anticipo día 15, ITBIS día 20). Cada celda muestra badge de estatus clickeable que abre el checklist.

**Tab 2 — Checklist de Impuestos:**
- Cards por cliente con badges de estatus por impuesto. Click abre detalle.
- Detalle: secciones colapsables por tipo de impuesto, cada una con sus items específicos.
- Items por impuesto: TSS y IR-3 (4 items), IR-17 (4 items con borrador), Anticipo (2 items), ITBIS (5 items incluyendo pago a cuenta con select Sí/N/A).
- Cualquiera puede marcar cualquier item. Toggle de "en atraso" por impuesto.
- UPSERT con onConflict en `cliente,mes,anio,impuesto`.

**Tabla Supabase:** `impuestos_checklist` con JSONB `datos`, flag `en_atraso`, UNIQUE constraint. RLS basado en permisos de grupo.
**Grupo nuevo:** "Impuestos" en tabla `grupos` con permisos de consulta, adición y edición para pantalla impuestos. Para Karina y Lovelis.
**SQL:** `db/impuestos-setup.sql` (tabla + grupo).
**Sidebar:** Impuestos activado con roles `['admin', 'impuestos']`.

### 2026-04-25 — Unificación de arquitectura en tabs
Se crearon dos módulos nuevos que unifican archivos independientes en vistas con pestañas:

**contadores-tab.html** (Checklist + KPI):
- Main tabs arriba: "Checklist" y "KPI". Cuando KPI activo y admin: sub-tabs "Detalle por Contadora" y "Resumen Trimestral".
- ASIGNACIONES unificado en formato objeto `{nombre, transacciones, contratado}`. Dos accessors: `getClients()` (objetos para KPI) y `getClientNames()` (strings para checklist).
- Namespacing: prefijo `ck*` para checklist, `kpi*` para KPI (variables, funciones, onclick handlers).
- `isExcluida()` compartida filtra Karina, Milka y Yoleni.

**gerencia.html** (Control de Clientes + Control de Contadoras):
- Main tabs: "Control de Clientes" y "Control de Contadoras". Show/hide de áreas (preserva estado DOM al cambiar tab).
- Namespacing: prefijo `cc*` para Control Clientes, `ctd*` para Control Contadoras.
- CSS estandarizado a variables del design system (`--navy: #1a2332`, no el `#1e3a5f` que tenía contadores.html).
- Header sólido navy, sin gradiente. `userName` unificado (antes contadores.html usaba `APP_userName`).
- CTD tiene su propio `ctdEXCLUIDAS = ['Karina', 'Milka']` (sin Yoleni, que sí se excluye en checklist/KPI).
- Chart.js incluido para los gráficos del módulo CC.

**index.html**: Sidebar actualizado. Gerencia y Contadores cambiaron de secciones expandibles con hijos a enlaces directos a los módulos unificados.

Archivos originales (checklist.html, kpi.html, contadores.html, control-contadoras.html) preservados como fallback hasta que Félix confirme que todo funciona.

### 2026-04-25 — Corrección de fechas y grupos en checklist
Félix proporcionó las fechas reales por grupo de impuesto. Cambios:
- Nómina → TSS / IR-3: todos los items comparten deadline día 3 del mes siguiente, firma día 28. IR-3 se fusionó en este grupo (antes tenía deadline día 10).
- IR-17 renombrado a **Proveedores informales**: deadline día 10, firma día 5.
- Anticipo: día 15, firma día 10 (sin cambio).
- ITBIS: todos los items comparten deadline día 20, firma día 15.
- Cierre renombrado a **Presentación mensual**: "Registrar gastos" deadline día 5 con firma día 1 (firmaOffset:4 en vez de 5). Presupuesto, proyección, resumen y video deadline día 30, firma día 25.
- Yoleni agregada a EXCLUIDAS.
- Sort: Taina primero, luego alfabético, Sin asignar al final.

### 2026-04-25 — Checklist Contadores (módulo nuevo)
Nuevo módulo `checklist.html` con 23 items ordenados cronológicamente. Cada item tiene tipo de impuesto (TSS/IR-3, IR-17, Anticipo, ITBIS, Cierre), fecha de firma (5 días antes) y fecha límite de presentación. Deadlines por impuesto: TSS día 3, IR-3 e IR-17 día 10, Anticipo día 15, ITBIS día 20 (del mes siguiente al de trabajo).
- Tabla nueva `checklist_contadores` con JSONB (SQL en `db/checklist-contadores-setup.sql`)
- Una fila por contadora + cliente + mes, UNIQUE constraint
- Toggle Sí/No por item, guarda fecha automática al marcar
- Semáforo: verde antes de firma, ámbar entre firma y límite, rojo después del límite
- Items vencidos sin completar se marcan con fondo rojo y texto "Vencido"
- Vista de cards con progreso (X/23 tareas) por cliente, click para ver detalle
- Admin ve todas las contadoras con filter pills, contadora ve solo sus clientes
- Excluidas: Karina y Milka (mismo patrón que control-contadoras)
- Menú en index.html renombrado de "Contadoras" a "Contadores", checklist activo

### 2026-04-24 — Documentos para cuenta de equipo
Se crearon archivos en `Projects/AI-para-el-equipo/` para cargar en una cuenta Claude del equipo: About Account One, writing rules, memory, context map, CLAUDE.md. Todo adaptado para que no tenga info personal de Félix.

---

### 2026-04-24 — Segunda ronda de cambios en kpi.html
Félix revisó el KPI y pidió ajustes. Cambios aplicados:
- **Visibilidad admin/contadora:** admin ve todas las contadoras y el tab Resumen Trimestral. La contadora solo ve su propio perfil, sin selector ni tab trimestral. Botón "Volver" solo para admin.
- **Friday dots en digitación:** al llenar transacciones se guarda la fecha. Si fue viernes, puntito verde; si no, rojo. Formato JSONB cambió de `[number]` a `[{qty, fecha}]` con migración automática.
- **MV Creative exception:** Beliani tiene el cliente Mv Creative donde Adm=0, excluido del scoring, fila con opacity 0.6 y label "MV 0".
- **Adm dinámico:** la meta de transacciones de cada cliente se toma del total digitado el mes anterior. Si no hay dato previo, fallback a `asignaciones.adm`.
- **Columnas Contratado + Adm:** la tabla de digitación ahora muestra ambas columnas. Contratado viene de `asignaciones.serv`.
- **Link en vez de foto:** en resúmenes y video, el campo foto se reemplazó por link (URL). Migración automática de datos viejos.
- **Fecha automática al toggle:** al marcar "Sí" en resúmenes o video, se registra la fecha de hoy. Al marcar "No", se limpia fecha y link.
- **Semáforo en resúmenes y video:** verde si entregó antes del 25, ámbar entre 25 y 30, rojo después del 30 del mes de la vista.

### 2026-04-24 — Rediseño completo de kpi.html
Se reconstruyó el módulo KPI desde la versión vieja (localStorage) adaptándolo a Supabase. Cambios:
- Nueva tabla `kpi_detalle` con JSONB para datos granulares (SQL en `db/kpi-detalle-setup.sql`)
- Digitación ahora es por cliente por semana (tabla con 5 columnas de semana por cada cliente), no global
- Resúmenes por cliente con toggle Sí/No y campo de foto
- Video/Reunión por cliente con toggle y link
- Score overview con barras de progreso y escala de bono en pesos
- Calculadora de bono trimestral con proyección optimista para meses abiertos
- Dos tabs: "Detalle por Contadora" (llenado) + "Resumen Trimestral" (tabla comparativa)
- Selector de contadora al entrar, quarter bar y month tabs para navegar
- Al guardar, sincroniza automáticamente kpi_scores para la vista trimestral
- Asignaciones se leen de Supabase (columna `adm` = transacciones asignadas)
- Salarios hardcodeados por ahora (decisión de Félix)
- Fórmula: Digitación 50% + Resúmenes 30% + Video/Reunión 20%, cada componente sobre 10, total sobre 100

### 2026-04-24 — Definiciones funcionales por módulo
Sesión de planeación antes de seguir construyendo. Se definió qué hace cada módulo pendiente. Cambios estructurales importantes:
- **Gerencia** entra como módulo nuevo: super reporte ojo de águila para Félix, agrupa vistas de clientes, contadoras, impuestos e implementaciones.
- **Checklist Mensual deja de ser módulo independiente** y pasa a ser submódulo / modal dentro de Control de Contadoras.
- **KPI se rehace**: nota mensual sobre 100, bono trimestral con tabla de tramos (excelente / bueno / aceptable / sin bono).
- **Impuestos**: tabla cliente x impuesto, columnas TSS / IR-17 / Anticipos / IR-3 / 606 / 607 / ITBIS, vista por cliente prioritaria + vista por contadora.
- **Implementaciones**: dos pestañas (FE y normales), Claudia como responsable.
- **Portal de Clientes**: link único por cliente, checklist atado a impuestos, cargas semanales de NCF Bancos / nómina / proveedores informales.

Orden de ejecución acordado: terminar gerencia → contadoras → impuestos → implementaciones → portal de clientes. Comercial está cerrado, no se toca.

Vocabulario corregido: **NCF Bancos**, no NSF.

### 2026-04-24 — Rediseño de control-contadoras
Cambios aplicados:
- Month pills (estilo ventas.html): Ene, Feb, Mar... en botones redondeados
- Contadora filter pills: Todas + cada nombre
- KPI dashboard: 3 barras (Facturas, Reportes, Video/Reunión) con % de cumplimiento
- Barras de color: verde >=80%, amarillo >=50%, rojo debajo
- Mini KPIs dentro de cada sección expandible
- Colores neutrales (navy para todos los avatares)
- Karina y Milka excluidas (`EXCLUIDAS = ['Karina', 'Milka']`)
- Cuadros de perfil eliminados, reemplazados por filter pills
- Sin asignar siempre al final del sort

### 2026-04-24 — Separación control-contadoras vs checklist
Félix aclaró que son dos módulos distintos. Control de Contadoras = reporte mensual (facturas, presupuesto, proyección, resumen, video). Checklist = algo diferente que se va a diseñar después. Se activó `control-contadoras.html` en el menú y se desactivó `checklist-mensual.html` (pendiente).

### 2026-04-24 — Permisos por grupo
Félix rechazó el sistema de permisos planos (per-user). Se rediseñó completamente:
- Tabla `grupos` con JSONB `permisos` (matriz pantalla x habilidad)
- Tabla `usuario_grupos` (many-to-many)
- Permisos aditivos: unión de todos los grupos del usuario
- 3 grupos iniciales: Admin (todo), Contadora (checklist+kpi), Ventas (comercial)
- UI en `usuarios.html` con dos tabs: Grupos (matriz con toggles) y Usuarios (checkbox de grupos)

### 2026-04-23 — Auth y contadores
Supabase Auth con email/password. Tabla `profiles` para nombre y rol. Función `get_my_role()` como SECURITY DEFINER. Tabla `asignaciones` para mapear contadora-cliente-mes. Checklist y KPI creados.

### 2026-04-19 — Migración a Supabase (ventas)
Primer módulo migrado. Se creó el proyecto Supabase, tablas leads y roas_mensual. 103 leads migrados. RLS con políticas permisivas temporales. Variable del cliente = `sb`. GitHub Pages como hosting.

---

## Problemas resueltos

### contadorasMap vacío para contadoras (vista contadora)
El RLS de `asignaciones` no dejaba que la contadora viera sus clientes via el map general. Fix: fallback que consulta `asignaciones` directamente con el nombre de la contadora.

### Embed mode ocultando main-tabs en impuestos.html
La regla CSS de embed incluía `.main-tabs` junto con header y breadcrumb. Esto hacía que los tabs Checklist/KPI desaparecieran cuando el módulo se cargaba dentro de index.html (iframe con `?embed=1`). Los otros módulos nunca ocultaban main-tabs. Fix: quitar `.main-tabs` de la regla. **Regla para todos los módulos:** en embed mode, solo se ocultan `.login-overlay`, `.header`, `.breadcrumb-bar` (y `.footer` si aplica). Los main-tabs internos del módulo siempre deben quedarse visibles.

### Variable `supabase` conflicto con CDN
El CDN de Supabase exporta una variable global `supabase`. Si el cliente se llama igual, conflicto. Solución: variable se llama `sb`.

### Sort de contadoras
Félix quería orden específico. Se creó `sortContadoras()` con array de "últimas" (Sin asignar).

### Write tool error ("File has not been read yet")
Archivos creados via `bash cp` no se pueden escribir con Write hasta que se lean con Read primero. Solución: siempre leer antes de escribir.

---

## Descripciones funcionales por módulo (definidas 2026-04-24)

Estas descripciones son la fuente de verdad. Si durante la construcción algo empieza a salirse de aquí, parar y confirmar con Félix antes de seguir.

### Gerencia (super reporte ojo de águila)
Vista exclusiva para Félix. No es donde se llena información, es donde se consume. Cuatro vistas en una:
- **Clientes:** estado general de la cartera.
- **Contadoras:** carga de cada una y cómo van con su trabajo del mes.
- **Impuestos:** cuántos se presentaron a tiempo, cuántos tarde, dónde están los huecos.
- **Implementaciones:** estado de implementaciones de Facturación Electrónica y de implementaciones normales.

Funciona como un panel de control para que Félix vea cómo va cada departamento de la firma sin tener que entrar a cada módulo.

### Control de Contadoras (con submódulo Checklist Mensual)
El módulo principal de las contadoras. Hace dos cosas:

1. **Checklist Mensual** (submódulo / modal): por cliente, asignado a contadora. Lista de tareas universal con items opcionales que se activan según el cliente. La contadora marca sí/no por item, registra la fecha de cuando lo presentó, y cada item tiene su propia fecha límite. Semáforo verde/amarillo/rojo según los días faltantes contra esa fecha. Algunos items pueden tener instrucciones embebidas. Sirve para que la contadora no se le quede nada y para que vaya viendo su propio desempeño.
2. **KPI mensual** (sección dentro del mismo módulo): documento rellenable, nota sobre 100. La contadora registra cómo fue llenando las transacciones, en qué fecha presentó el resumen de declaración al cliente, y en qué fecha tuvo la reunión o grabó el video. La fórmula exacta para llegar a la nota mensual está pendiente de que Félix la describa.

### KPI / Bono trimestral
La nota es mensual (sobre 100) pero el **bono se paga trimestral** sumando el desempeño de los tres meses. Reglas del bono:
- 90-100 (Excelente): 1/3 del sueldo.
- 80-89 (Bueno): 1/4 del sueldo (75% del tercio).
- 70-79 (Aceptable): 1/6 del sueldo (50% del tercio).
- 0-69: sin bono.

Ejemplo: contadora con sueldo RD$45,000 → tercio = RD$15,000 → excelente paga RD$15,000, bueno RD$11,250, aceptable RD$7,500.

El portal debe mostrar la proyección de bono mientras la contadora va llenando, no solo al final del trimestre.

### Impuestos
Para Karina, gerente de impuestos. Tabla única cliente x impuesto con semáforo por celda según fecha límite. Columnas separadas: TSS, IR-17, Anticipos, IR-3, 606, 607, ITBIS. (IR-17 va separado de Anticipos, 606 y 607 también van separados.)

Dos vistas:
- **Por cliente** (prioridad): para ver mes por mes qué impuesto se presentó a cada cliente, fecha de presentación, si fue a tiempo o tarde.
- **Por contadora** (secundaria): mismo dato pero agrupado por quién es responsable.

Este módulo alimenta el dato de "impuestos a tiempo vs tarde" que aparece en la vista de Gerencia.

### Implementaciones
Para Claudia, encargada del área. Dos pestañas separadas en la UI:
- **Facturación Electrónica**
- **Implementaciones Normales**

Cada pestaña con su tabla. Por cliente registra:
- Status / fase (kick-off, sesión 2, sesión 3, sesión 4, etc.)
- Información que falta del cliente
- Semáforo verde / amarillo / rojo
- Fecha estimada de completar
- Responsable y contador asignado

### Portal de Clientes
Portal de trabajo para los clientes de la firma. Acceso por **link único por cliente** (sin login con password). Más interactivo que el checklist interno de la contadora.

El cliente ve un checklist atado a tipos de impuesto (TSS, IR-3, IR-17, ITBIS). Sus tareas:
- Descargar facturas
- Cargar **NCF Bancos** semanalmente
- Cargar nómina
- Cargar Excel de proveedores informales

A medida que se va acercando la fecha de cada responsabilidad, el portal le va mostrando qué tiene que entregar para esa declaración. El cliente ve si entregó a tiempo o tarde; cuando entrega tarde se le prende banderita roja. Esto también sirve para que el cliente vaya aprendiendo sus responsabilidades fiscales sobre la marcha.

Storage de archivos cargados: por definir cuando lleguemos al módulo.

---

## Vocabulario / convenciones

- **NCF Bancos** (no NSF). Son los Números de Comprobante Fiscal de los movimientos bancarios que el cliente sube semanalmente.
- **RST** = Régimen Simplificado de Tributación. Clientes en RST no llevan los impuestos regulares (TSS, ITBIS, etc.). Ejemplos: Kaizen, Centro Adorartes.
- **Comercial** = ventas. El módulo se llama Pipeline de Ventas pero internamente nos referimos a él como Comercial.
- **Karina y Milka** están excluidas del control de contadoras (su servicio no aplica). Karina sí es protagonista del módulo de Impuestos como gerente del área.
- **Claudia** es la encargada del módulo de Implementaciones.

---

## Decisiones pendientes

- ~~**Fórmula exacta del KPI mensual**: Definida 2026-04-24. Digitación 50% + Resúmenes 30% + Video/Reunión 20%.~~
- **Items concretos del Checklist Mensual:** lista universal con items opcionales por cliente. Falta la lista base.
- **Storage de archivos del Portal de Clientes:** Supabase Storage vs OneDrive. Se decide al construir el módulo.
- **Objetivo de Victoria en KPI** (provisional en 500).
- **RLS de leads/roas_mensual:** todavía permisivas (anon), pendiente restringir.
- **Tab "Resumen" con atrasos (contabilidad + impuestos):** Idea de Félix (2026-05-15). Al entrar al portal, cada contadora debería ver sus responsabilidades atrasadas (ej: Beliani no marcó anticipo de abril y ya estamos en mayo 15). Para admin, agregar una tercera pestaña "Resumen" en contabilidad e impuestos que muestre atrasos de todas las contadoras, con pill por contadora (sin filtro de mes), y de entrada una tabla con todo lo atrasado. También aplicaría como pantalla de inicio personalizada por usuario. No planificar todavía, solo registrar la idea.

---

## Conexión Supabase

- **Proyecto:** Portal Account One
- **Región:** us-east-1
- **URL:** `https://ouetusstqvpyjeycfdio.supabase.co`
- **Anon Key:** en los archivos HTML (key pública, safe para frontend)
- **Repo GitHub:** `themoneycoachrd/portal-accountone`
- **URL pública:** `portal-accountone.vercel.app`

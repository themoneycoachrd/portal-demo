# Memory: Portal Account One

Memoria específica del proyecto. Detalles técnicos, decisiones, problemas resueltos, estado de cada módulo.

---

## Estado actual por módulo

| Módulo | Estado | Último cambio |
|---|---|---|
| index.html (inicio + sidebar) | Funcional | 2026-04-26: Sidebar actualizado. Contadores renombrado a Contabilidad, apunta a contabilidad.html. |
| ventas.html (Comercial) | Funcional. | 2026-04-25: Agregada columna `categoria` (Implementacion, FE, Recurrente). |
| **contabilidad.html** (Contabilidad) | **Funcional** — Checklist + KPI | 2026-04-26: Karina incluida, grupo "Sin asignar", summary stats ampliados. |
| ~~contadores-tab.html~~ | Renombrado a contabilidad.html | 2026-04-26 |
| **gerencia.html** (Gerencia) | **Funcional** — Control Clientes + Contadoras + Base de Datos | 2026-04-26: Tab Servicios en CC, toggle activo/inactivo en BD, tipo_servicio + fecha_salida. |
| ~~checklist.html~~ | Reemplazado por contabilidad.html | 2026-04-25 |
| ~~kpi.html~~ | Reemplazado por contabilidad.html | 2026-04-25 |
| ~~contadores.html~~ | Reemplazado por gerencia.html | 2026-04-25 |
| ~~control-contadoras.html~~ | Reemplazado por gerencia.html | 2026-04-25 |
| usuarios.html | Funcional | 2026-04-26: Formulario de invitación de usuarios. Usa función BD `invite_user()`. |
| **impuestos.html** (Impuestos) | **Funcional** — Checklist + KPI con tabs | 2026-04-26: Lee clientes de maestra (`responsabilidad_impuestos=true`). |
| **implementaciones.html** (Implementaciones) | **Funcional** — Implementación Completa + FE | 2026-04-26: loadContadoras lee de tabla `contadoras` (activas). |
| Portal de clientes | Pendiente. Acceso por link único. | — |

---

## Entradas

### 2026-04-19 — Migración a Supabase (ventas)
Primer módulo migrado. Se creó el proyecto Supabase, tablas leads y roas_mensual. 103 leads migrados. RLS con políticas permisivas temporales. Variable del cliente = `sb`. GitHub Pages como hosting.

### 2026-04-23 — Auth y contadores
Supabase Auth con email/password. Tabla `profiles` para nombre y rol. Función `get_my_role()` como SECURITY DEFINER. Tabla `asignaciones` para mapear contadora-cliente-mes. Checklist y KPI creados.

### 2026-04-24 — Permisos por grupo
Félix rechazó el sistema de permisos planos (per-user). Se rediseñó completamente:
- Tabla `grupos` con JSONB `permisos` (matriz pantalla x habilidad)
- Tabla `usuario_grupos` (many-to-many)
- Permisos aditivos: unión de todos los grupos del usuario
- 3 grupos iniciales: Admin (todo), Contadora (checklist+kpi), Ventas (comercial)
- UI en `usuarios.html` con dos tabs: Grupos (matriz con toggles) y Usuarios (checkbox de grupos)

### 2026-04-24 — Separación control-contadoras vs checklist
Félix aclaró que son dos módulos distintos. Control de Contadoras = reporte mensual (facturas, presupuesto, proyección, resumen, video). Checklist = algo diferente que se va a diseñar después. Se activó `control-contadoras.html` en el menú y se desactivó `checklist-mensual.html` (pendiente).

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

### 2026-04-25 — Corrección de fechas y grupos en checklist
Félix proporcionó las fechas reales por grupo de impuesto. Cambios:
- Nómina → TSS / IR-3: todos los items comparten deadline día 3 del mes siguiente, firma día 28. IR-3 se fusionó en este grupo (antes tenía deadline día 10).
- IR-17 renombrado a **Proveedores informales**: deadline día 10, firma día 5.
- Anticipo: día 15, firma día 10 (sin cambio).
- ITBIS: todos los items comparten deadline día 20, firma día 15.
- Cierre renombrado a **Presentación mensual**: "Registrar gastos" deadline día 5 con firma día 1 (firmaOffset:4 en vez de 5). Presupuesto, proyección, resumen y video deadline día 30, firma día 25.
- Yoleni agregada a EXCLUIDAS.
- Sort: Taina primero, luego alfabético, Sin asignar al final.

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

### 2026-04-26 — Tipo de servicio, fecha de salida, orden de inactivos

Cambios en tabla `clientes` (SQL: `db/clientes-tipo-servicio.sql`):
- Nueva columna `tipo_servicio` TEXT con CHECK: 'Contabilidad completa', 'Solo impuestos', 'Solo supervisión'.
- Nueva columna `fecha_salida` DATE para registrar cuándo dejó de ser cliente.

Cambios en `gerencia.html` (BD Clientes):
- Modal: agregados select de tipo_servicio y input date de fecha_salida.
- Tabla: nueva columna "Servicio" (tipo_servicio). Se quitó columna "Contacto" para hacer espacio. Fecha de salida aparece debajo del badge "Inactivo" en la columna Estado.
- Ordenamiento: activos primero (alfabético), inactivos al final (alfabético). Filas inactivas con opacity 0.55.
- `clOpenModal()` y `clSaveClient()` actualizados para leer/grabar ambos campos.

### 2026-04-26 — Sesión de mejoras (toggle activo, Servicios, formato fecha, Karina)

**gerencia.html — Toggle activo/inactivo en modal BD Clientes:**
- Botón toggle Activo (verde) / Inactivo (rojo) en el modal de editar cliente. Cuando se marca inactivo, aparece campo fecha_salida. Si se pone fecha_salida, se marca inactivo automáticamente.
- `clModalActivo`, `clRenderActivoBtn()`, `clToggleActivo()`, `clOnFechaSalidaChange()`. El record de save incluye `activo: clModalActivo`.

**gerencia.html — Tab Servicios en Control de Clientes:**
- Nuevo main tab "Servicios" junto a Dashboard. Lee `tipo_servicio` de la maestra (`ccAllClientes`).
- Month tabs para filtrar por mes (misma lógica de fecha_entrada/fecha_salida que el Dashboard). Variable `ccServMes`. Función `ccServGetActivosMes()`.
- Summary stats clicables (orden): Total clientes, Tax One (azul), Contabilidad (verde), Supervisión (ámbar), Sin asignar (gris, solo si hay). Click filtra la tabla.
- Tabla agrupada por tipo de servicio cuando se ve "Todos" (group-row headers). Orden: Tax One → Contabilidad → Supervisión → Sin asignar (al final).
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

### 2026-04-26 — Sub-fase E: UI de gestión de clientes + historial de contadoras

Cambios en `gerencia.html` (BD Clientes):
- Al editar un cliente y cambiar la contadora (contabilidad o impuestos), aparece un campo de "Motivo del cambio" con fondo amarillo. El motivo se graba en `clientes_cambios_contadora` después de que el trigger crea el registro automático.
- Botón de historial (reloj) en cada fila de la tabla (solo admin). Abre modal con tabla de cambios: fecha, área (badge azul "Contab" o verde "Imp"), contadora anterior, nueva, motivo.
- Variables `clOrigContab` / `clOrigImp` guardan el valor original al abrir modal. `clCheckContadoraChanged()` muestra/oculta el campo motivo según si hubo cambio.
- Con esto se cierra la Fase 1 completa (5 sub-fases A-E).

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

### 2026-04-25 — Categoría en ventas.html
Se agregó columna `categoria` a leads (Implementacion, Facturacion Electronica, Recurrente). SQL: `db/leads-categoria.sql`. Badge visual en la tabla y select en los formularios de edición/creación.

### 2026-04-25 — Dashboard de KPIs en inicio
Se reemplazó el grid de módulos (redundante con el sidebar) por un dashboard con tres KPI cards:
- **Clientes contabilidad**: total actual + delta vs mes anterior (de `meses_resumen`)
- **Clientes software**: total actual + delta vs mes anterior (de `software_clientes`)
- **Cierres del mes**: leads con funnel "Cerrado Ganado" del mes actual, desglose por categoría (Recurrente, Implementación, FE)
El dashboard se recarga cada vez que el usuario vuelve a Inicio.

### 2026-04-25 — Fix Milka en control-contadoras
El filtro de EXCLUIDAS usaba `indexOf` exacto pero en Supabase el nombre es "Milka (freelance)". Se cambió a función `isExcluida()` que hace match parcial (startsWith).

### 2026-04-24 — Documentos para cuenta de equipo
Se crearon archivos en `Projects/AI-para-el-equipo/` para cargar en una cuenta Claude del equipo: About Account One, writing rules, memory, context map, CLAUDE.md. Todo adaptado para que no tenga info personal de Félix.

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

---

## Conexión Supabase

- **Proyecto:** Portal Account One
- **Región:** us-east-1
- **URL:** `https://ouetusstqvpyjeycfdio.supabase.co`
- **Anon Key:** en los archivos HTML (key pública, safe para frontend)
- **Repo GitHub:** `themoneycoachrd/portal-accountone`
- **URL pública:** `themoneycoachrd.github.io/portal-accountone/`

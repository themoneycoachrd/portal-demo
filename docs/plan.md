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
- [ ] Fase 2 — KPI (rehacer)
- [ ] Fase 3 — Checklist Mensual (submódulo de Contadoras)
- [ ] Fase 4 — Control de Contadoras (consolidación)
- [ ] Fase 5 — Gerencia (super reporte)
- [ ] Fase 6 — Impuestos
- [ ] Fase 7 — Implementaciones
- [ ] Fase 8 — Portal de Clientes

---

## Orden de ejecución

| # | Fase | Estado | Notas |
|---|---|---|---|
| 0 | Comercial (ventas.html) | Cerrado | No se toca |
| 1 | ~~**Consolidación BD de clientes**~~ | Cerrado 2026-04-26 | 5 sub-fases completadas. Fundacional: todos los módulos leen de la maestra |
| 2 | KPI (rehacer) | Por iniciar | Bloqueado: falta fórmula mensual sobre 100. Depende de Fase 1 |
| 3 | Checklist Mensual (submódulo de Contadoras) | Pendiente | Lista de items por definir |
| 4 | Control de Contadoras (consolidación) | Pendiente | Integrar KPI + Checklist en un módulo coherente |
| 5 | Gerencia (super reporte) | Pendiente | Depende de Contadoras y de Impuestos |
| 6 | Impuestos | Pendiente | — |
| 7 | Implementaciones | Pendiente | — |
| 8 | Portal de Clientes | Pendiente | Storage por definir al construir |

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

## Fase 5 — Gerencia (super reporte)

**Objetivo:** vista exclusiva para Félix, ojo de águila de toda la firma. No se llena información aquí, se consume.

**Alcance:**
- Cuatro vistas en el mismo módulo: Clientes, Contadoras, Impuestos, Implementaciones.
- **Clientes:** estado general de la cartera (cuántos activos, distribución, etc.).
- **Contadoras:** carga del mes y desempeño (alimentado por Fase 2 KPI + Fase 3 Checklist).
- **Impuestos:** % a tiempo vs tarde (alimentado por Fase 6).
- **Implementaciones:** cuántas en proceso, semáforos agregados (alimentado por Fase 7).
- Acceso solo para Félix (rol admin).

**Tablas Supabase:**
- No crea tablas nuevas. Lee y agrega de las que alimentan los otros módulos.

**Bloqueadores:**
- Necesita que estén Contadoras (Fases 2-4) e Impuestos (Fase 6) para que la vista tenga datos reales. Implementaciones puede entrar después.

---

## Fase 6 — Impuestos

**Objetivo:** que Karina pueda controlar el estado de cumplimiento fiscal de cada cliente por mes.

**Alcance:**
- Tabla principal cliente x impuesto. Columnas separadas: TSS, IR-17, Anticipos, IR-3, 606, 607, ITBIS.
- Cada celda con: fecha límite, fecha de presentación, estado (a tiempo / tarde / pendiente), semáforo.
- Vista por cliente (prioridad).
- Vista por contadora (secundaria).
- Filtros por mes y por contadora.

**Tablas Supabase:**
- `impuestos_calendario` (nueva): catálogo de tipos de impuesto con su fecha límite por defecto (puede variar por cliente).
- `impuestos_presentacion` (nueva): registro por cliente / mes / tipo de impuesto con fecha de presentación y estado.

**Bloqueadores:**
- Confirmar las fechas límite de cada impuesto (¿son fijas mensuales o cambian?).
- ¿Quién registra la presentación: la contadora del cliente, Karina, o ambas?

---

## Fase 7 — Implementaciones

**Objetivo:** que Claudia controle el avance de los clientes nuevos en proceso de implementación.

**Alcance:**
- Dos pestañas separadas: **Facturación Electrónica** e **Implementaciones Normales**.
- Cada pestaña con su tabla de clientes en proceso.
- Por cliente: status / fase (kick-off, sesión 2, sesión 3, sesión 4, etc.), información que falta, semáforo verde / amarillo / rojo, fecha estimada de cierre, responsable, contador asignado.
- Vista de detalle por cliente para ver toda la historia de la implementación.

**Tablas Supabase:**
- `implementaciones` (nueva): cliente, tipo (FE / normal), fase actual, fecha kick-off, fecha objetivo, responsable, contador asignado, status, notas.
- `implementaciones_log` (opcional): historial de cambios de fase.

**Bloqueadores:**
- Lista exacta de fases para cada tipo (¿FE y normales tienen las mismas fases o distintas?).
- Criterios del semáforo (¿qué pone una implementación en rojo?).

---

## Fase 8 — Portal de Clientes

**Objetivo:** portal de trabajo donde el cliente entrega lo que la firma necesita para presentar sus impuestos, y ve si va a tiempo o tarde.

**Alcance:**
- Acceso por link único por cliente (sin login con password).
- Checklist atado a tipos de impuesto: TSS, IR-3, IR-17, ITBIS.
- Tareas del cliente: descargar facturas, cargar NCF Bancos semanalmente, cargar nómina, cargar Excel de proveedores informales.
- A medida que se acerca la fecha límite de cada impuesto, el portal muestra qué tiene que entregar el cliente para esa declaración.
- Banderita roja si el cliente entrega tarde.
- Capacidad de aprendizaje: el cliente va viendo sus responsabilidades fiscales por tipo de impuesto.

**Tablas Supabase:**
- `cliente_tokens` (nueva): token de acceso único por cliente.
- `cliente_entregas` (nueva): registro de entregas del cliente con fecha, tipo, estado.
- Storage de archivos: por definir (Supabase Storage vs OneDrive).

**Bloqueadores:**
- Decidir storage de archivos.
- Confirmar la lista exacta de cargas semanales / mensuales / por impuesto.
- ¿Quién genera y envía el link único al cliente: la contadora, Félix, automático?

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

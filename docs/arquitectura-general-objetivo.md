# Arquitectura General Objetivo — Portal Account One

**Qué es esto:** el plano del portal entero, visto limpio. No módulo por módulo todavía —eso viene después— sino la estructura de fondo: cómo deberían estar organizadas las tablas y cómo se conecta todo. Es el "antes de" para poder enderezar con rumbo.

**Se apoya en:** [arquitectura-referencia.md](arquitectura-referencia.md) (los 7 principios sacados de Adm Cloud). Este documento los aplica al portal completo.

**Importante:** el portal no está mal construido. Tiene buenos cimientos (permisos por grupo, RLS, roster en `equipo`). El problema es uno solo y se repite: **la identidad está fragmentada.** Arreglar eso es casi todo el trabajo.

---

## El problema en una foto

Hoy, una misma cosa vive en varios lugares:

**Las personas viven en 3 tablas:**
- `profiles` (usuarios que hacen login)
- `contadoras` (directorio de contadoras)
- `equipo` (roster de 14 personas)

→ La misma persona puede estar en las tres, con el nombre escrito distinto. Karina aparece como "Karina" y "Karina Sanchez". (Rompe principio 4: una entidad, un solo lugar.)

**Los clientes se referencian por nombre en ~12 tablas:**
`clientes`, `clientes_software`, `clientes_pendientes`, `asignaciones`, `checklist_contadores`, `impuestos_checklist`, `kpi_detalle`, `cobros_facturas`, `reporte_mensual`, `portal_clientes_*`, `portal_ejecucion`, `portal_declaraciones`...

→ Cada una guarda el nombre del cliente y se emparejan por texto. Por eso el "Srl" no casa, Tricargo se duplicó, y migrar a Taina→Morelia tocó cinco tablas a mano. (Rompe principios 1 y 3: captura única, identidad por ID.)

**La solución es la misma para los dos casos:** una sola tabla por entidad, identificada por un ID estable, y todos los demás la referencian por ese ID.

---

## La arquitectura en capas

Así debería estar organizado el portal completo. Cinco capas, cada una se apoya en la de abajo:

```
┌──────────────────────────────────────────────────────────────┐
│ CAPA 5 — VISTAS (solo leen, no guardan datos propios)         │
│ Gerencia (ojo de águila) · Portal de Clientes · Dashboard TV  │
└──────────────────────────────────────────────────────────────┘
                          ▲ leen de ▲
┌──────────────────────────────────────────────────────────────┐
│ CAPA 4 — TRANSACCIONES (pasan cada mes, apuntan por ID)       │
│ asignaciones · checklist_contab · checklist_impuestos · kpi · │
│ cobros · implementaciones · retroalimentacion · wow_points    │
│ cada fila: cliente_id + equipo_id + periodo                   │
└──────────────────────────────────────────────────────────────┘
                          ▲ apuntan a ▲
┌──────────────────────────────────────────────────────────────┐
│ CAPA 3 — CONFIGURACIÓN (se ajusta de vez en cuando)           │
│ tipos_impuesto · servicios_precios · calendario_fiscal ·      │
│ grupos (permisos) · config_kpi (objetivos, tramos de bono)    │
└──────────────────────────────────────────────────────────────┘
                          ▲ se apoya en ▲
┌──────────────────────────────────────────────────────────────┐
│ CAPA 2 — IDENTIDAD / MAESTRAS (la columna vertebral)          │
│                                                               │
│   clientes  ── id = UUID propio del portal (canónico) ◄───┐   │
│              adm_cloud_id = GUID Adm Cloud (opcional)     │   │
│              nombre, rnc, fecha_entrada, activo           │   │
│                                                          (todo│
│   equipo    ── id estable                                 se  │
│              nombre, roles[], color, capacidad, tier     refe-│
│              objetivo_kpi, activo                        rencia│
│                                                          por id)│
└──────────────────────────────────────────────────────────────┘
                          ▲ login conecta ▲
┌──────────────────────────────────────────────────────────────┐
│ CAPA 1 — ACCESO                                               │
│ profiles: auth.uid ──► equipo_id  (login enlaza a la persona) │
│ RLS en toda tabla · grupos de permisos JSONB                  │
└──────────────────────────────────────────────────────────────┘
```

**La regla que se ve en el dibujo:** las flechas siempre suben hacia la columna vertebral, por ID. Nada de la capa 4 guarda el nombre de un cliente; guarda su `cliente_id` y busca el nombre arriba cuando lo va a mostrar.

---

## Las 3 decisiones de fondo

Todo el rediseño se reduce a tres decisiones. Si tomamos estas tres, el resto cae por su peso.

### Decisión 1 — Una sola tabla de personas

Fundir `profiles`, `contadoras` y `equipo` en una sola maestra `equipo`. Una persona = una fila. Sus papeles (contadora, analista, vendedora, implementadora, gerente) son **roles**, no tablas distintas —exactamente como Adm Cloud usa `IsCustomer`/`IsVendor`/`IsEmployee` sobre una sola entidad.

- `profiles` no desaparece, pero se reduce a su único trabajo real: conectar el login (`auth.uid`) con la persona (`equipo_id`).
- Karina deja de ser "Karina" y "Karina Sanchez": es una fila con `id`.

### Decisión 2 — Una sola identidad de cliente: el UUID del portal + enlace a Adm Cloud

**Aprendizaje del PR-1 (2026-06-07):** la idea original era usar el GUID de Adm Cloud como identidad del cliente. Al mapear los 38 clientes descubrimos que **2 no tienen empresa en Adm Cloud** (Centro Adorartes se devolvió en implementación; Mab Arquitectura usa QuickBooks). Si la identidad fuera el GUID de Adm Cloud, esos dos quedarían sin identidad. Por eso:

- El **`cliente_id` canónico es el UUID propio** de `clientes.id` (ya existe para los 38, sin importar el software que use el cliente).
- El **GUID de Adm Cloud va en una columna aparte, `adm_cloud_id`, opcional (nullable)**. Lo llevan los 36 clientes que sí están en Adm Cloud; es el puente para sincronizar (cobros, estado de resultados) por match exacto.
- La tabla `clientes` se queda como única maestra. Las columnas dobladas que hoy tiene (`contadora_contabilidad`, `contadora_impuestos`, `responsabilidad_*`) **salen de la maestra** y se vuelven asignaciones (capa 4). Quién atiende a un cliente y en qué servicio es una relación, no un atributo fijo del cliente.
- `clientes_software` y `clientes_pendientes` se integran como estados/banderas del mismo cliente, no como tablas paralelas.
- Todas las tablas de la capa 4 dejan de guardar el nombre y guardan `cliente_id` (el UUID).

**Esto:** acaba con el emparejamiento por nombre para siempre (las transacciones usan el UUID), y conecta con Adm Cloud de forma sólida vía `adm_cloud_id` donde aplica. El mapeo completo está en `docs/mapeo-guid-clientes.md`.

### Decisión 3 — Un concepto de "periodo" estándar

Hoy el mes se guarda distinto según la tabla: texto `'enero'` en `asignaciones`, lógica de corte que varía entre módulos. Estandarizar a un `periodo` único (año + mes) que todas las transacciones usan igual.

- Una sola función decide "¿de qué mes estamos hablando hoy?" y todos los módulos la usan. Se acaba el bug de enero (cuando diciembre del año anterior queda inaccesible).

---

## El mapa de tablas objetivo

Cómo queda todo ordenado por capa:

| Capa | Tabla | Qué guarda | Identidad / referencias |
|---|---|---|---|
| **2 Maestra** | `clientes` | El cliente | `id` = GUID Adm Cloud |
| **2 Maestra** | `equipo` | Las personas (fusión de profiles/contadoras/equipo) | `id` estable, `roles[]` |
| **3 Config** | `tipos_impuesto` | TSS, IR-17, Anticipo, IR-3, ITBIS, 606, 607 | `id` |
| **3 Config** | `servicios_precios` | Outsourcing + software, montos, moneda | `id` |
| **3 Config** | `calendario_fiscal` | Fechas DGII/TSS por mes (hoy hardcodeado) | por periodo |
| **3 Config** | `config_kpi` | Objetivos, tramos de bono, pesos | por rol/tier |
| **3 Config** | `grupos` / `usuario_grupos` | Permisos (se conserva igual) | JSONB |
| **4 Transacción** | `asignaciones` | Cliente↔persona↔servicio por mes | `cliente_id`+`equipo_id`+periodo |
| **4 Transacción** | `checklist_contab` | Checklist contabilidad | `cliente_id`+`equipo_id`+periodo |
| **4 Transacción** | `checklist_impuestos` | Checklist impuestos | `cliente_id`+`tipo_imp_id`+periodo |
| **4 Transacción** | `kpi_mensual` | KPI de la persona | `equipo_id`+periodo |
| **4 Transacción** | `cobros` / `notas_cobro` | Cartera y gestiones | `cliente_id` |
| **4 Transacción** | `implementaciones` | FE y normales | `cliente_id`+`equipo_id` |
| **4 Transacción** | `retroalimentacion` | Quejas/errores/feedback | `equipo_id`+`cliente_id` |
| **4 Transacción** | `wow_points` | Reconocimiento | `equipo_id` |
| **4 Transacción** | `leads` / `roas` | Pipeline comercial | (lead → al ganar crea `clientes`) |
| **5 Vista** | `portal_clientes_*` | Lo que ve el cliente | filtra por `cliente_id` |
| **5 Vista** | Gerencia, Dashboard TV | Espejos de lectura | no guardan nada propio |

---

## Cómo se conecta cada módulo

Para que veas que esto no es teoría — cada módulo que ya existe encaja:

- **Comercial (ventas):** un lead que se gana **crea un cliente** en la maestra (idealmente trayendo ya su GUID de Adm Cloud al darle de alta). Se acaba la cola `clientes_pendientes` como tabla aparte: es un estado del cliente.
- **Contabilidad:** lee `asignaciones` para saber qué clientes tiene cada contadora, escribe `checklist_contab` y `kpi_mensual`, todo por `cliente_id`/`equipo_id`.
- **Impuestos:** igual, contra `tipos_impuesto` por ID en vez de strings.
- **Implementaciones, Cobros, Personal, Retroalimentación:** todos cuelgan de `cliente_id`/`equipo_id`.
- **Gerencia:** no guarda nada. Lee y suma de las transacciones. Si un número no cuadra, se arregla en la fuente.
- **Portal de Clientes:** la misma data, filtrada por el `cliente_id` del token. RLS garantiza que un cliente no vea otro.

---

## Integración con Adm Cloud

El portal y Adm Cloud comparten el `cliente_id` (el GUID). Eso abre puentes limpios:

- **Cobros:** ya sincroniza facturas desde la API. Con el GUID, el emparejamiento es exacto (no más match por nombre con "Srl").
- **Futuro:** Estado de Resultados, transacciones contratadas (`monto_adm`), y más, se pueden traer por el mismo ID sin re-digitar (principio 1).

El portal nunca duplica lo que ya vive en Adm Cloud (catálogo de cuentas, asientos, inventario). Gestiona el trabajo de la firma *sobre* esos clientes y jala datos reales por la API cuando los necesita.

---

## Camino de migración (alto nivel, no rompe nada)

No se hace de un tirón. Se hace por fases, cada una segura y reversible:

**Fase A — Unificar personas.** Fundir `profiles`/`contadoras`/`equipo` en `equipo`. Apuntar los módulos a `equipo_id`. (Ya empezada con la tabla `equipo`; falta terminar de adoptarla.)

**Fase B — Traer el GUID de Adm Cloud a `clientes`.** Agregar la columna, mapear los 40 clientes contra las 87 empresas de Adm Cloud (una vez, semi-manual). Esto no cambia nada todavía, solo agrega la identidad.

**Fase C — Migrar las transacciones a `cliente_id`, una tabla a la vez.** Empezando por la más dolorosa (cobros o impuestos). Cada tabla: agregar `cliente_id`, backfillear desde el nombre, cambiar el código a usar el ID, dejar el nombre como respaldo un tiempo. Reversible en cada paso.

**Fase D — Sacar las columnas dobladas de `clientes` a `asignaciones`.** Quién atiende qué pasa a ser relación, no atributo.

**Fase E — Mover comportamiento del código a config.** Colores, capacidades, objetivos, calendario fiscal, precios → a tablas de la capa 3.

Cada fase deja el portal funcionando. Ninguna es "apaga todo y reconstruye".

---

## Qué se conserva tal cual (no tocar)

- Sistema de **grupos de permisos** con JSONB. Es el patrón correcto. ✓
- **RLS** en todas las tablas. ✓
- **Inactivar en vez de borrar** (rastro de auditoría, como el `Void` de Adm Cloud). ✓
- El stack (HTML vanilla + Supabase + Vercel). El rediseño es de **datos**, no de tecnología.

---

*Documento vivo. Acompaña a arquitectura-referencia.md. El plan detallado módulo por módulo se construye encima de este plano.*

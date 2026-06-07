# Arquitectura de Referencia — Portal Account One

**Qué es esto:** el documento contra el cual medimos cada decisión del portal de aquí en adelante. No describe cómo está el portal hoy; describe cómo **debe** estar pensado, usando como modelo la arquitectura de Adm Cloud.

**De dónde sale:** estudiamos la Knowledge Base de Adm Cloud (32 artículos) y, lo más importante, **confirmamos la arquitectura tocando el sistema real** vía su API (87 empresas, entidades reales). Lo de abajo no es inferencia: es cómo Adm Cloud funciona de verdad.

**Cómo usarlo:** antes de construir o cambiar un módulo, léelo y pásalo por el checklist del final. Si una decisión rompe un principio, paramos y lo hablamos.

---

## Los 7 principios

### 1. Cada dato se captura una sola vez y se propaga solo

En Adm Cloud, una compra con recepción hace tres cosas con un solo guardado: sube inventario, registra la factura del proveedor y genera el asiento contable. Nadie re-digita nada.

**Regla para el portal:** ningún dato se escribe en dos lugares. Si el nombre de un cliente, su contadora asignada, o su monto contratado vive en más de una tabla, eso es un error de diseño, no una conveniencia. Se captura en su maestra y todos los demás módulos lo **leen** desde ahí.

### 2. Separa "maestras" de "transacciones"

Adm Cloud divide todo en dos mundos: **maestras** (catálogo de cuentas, clientes, artículos, secuencias de NCF) que se configuran una vez, y **transacciones** (facturas, asientos) que pasan todos los días. Las transacciones se apoyan en las maestras, nunca al revés.

**Regla para el portal:**
- **Maestras** (se configuran una vez, cambian poco): Clientes, Equipo (personas), Tipos de impuesto, Servicios/Precios, Grupos de permisos.
- **Transacciones** (pasan cada mes): Checklist mensual, KPI mensual, Asignaciones del mes, Cobros, Implementaciones, Retroalimentación.
- Toda transacción **apunta a una maestra por su ID**, no copia sus datos.

### 3. Todo cuelga de una columna vertebral, identificada por un ID estable

En Adm Cloud nada se identifica por su nombre. Cada cosa tiene un ID (un GUID) que no cambia aunque el nombre sí. El catálogo de cuentas es la columna vertebral de la contabilidad; cada transacción busca su cuenta por ID.

**Regla para el portal:** la columna vertebral es el **Cliente**. Existe **una sola tabla de clientes**, cada cliente tiene **un ID que nunca cambia**, y todos los módulos (Contabilidad, Impuestos, Cobros, Implementaciones, Portal de Clientes) lo referencian por ese ID. **Nunca por nombre.**

> **El hallazgo más importante de toda esta investigación:**
> El portal debe identificar a cada cliente por un **ID estable, no por su nombre**. La identidad canónica es el **UUID propio** de `clientes.id` (existe para todos). Y la mayoría de los clientes **ya es una empresa con un GUID permanente en Adm Cloud** (ej. `516d3a00-2f5f-4ebd-8802-...`); ese GUID se guarda como **`adm_cloud_id` (enlace opcional)** para sincronizar con Adm Cloud por match exacto. (Nota del PR-1: 2 de 38 clientes no están en Adm Cloud —uno se devolvió, otro usa QuickBooks— por eso la identidad canónica es el UUID propio, no el GUID.) Identificar por ID **acaba para siempre** los problemas de emparejar nombres que ya nos han costado horas: "Karina" vs "Karina Sanchez", "Morelia Matos" vs "Morelia", los nombres de Adm con "Srl" que no casan, los duplicados de Tricargo. Todo eso es síntoma de identificar por nombre. La cura es el ID.

### 4. Una misma entidad puede jugar varios roles (no dupliques personas ni clientes)

Adm Cloud no tiene una tabla de clientes, otra de proveedores y otra de empleados. Tiene **una sola entidad** —"Relación"— con casillas: `IsCustomer`, `IsVendor`, `IsEmployee`, `IsSalesRep`. El mismo registro puede ser cliente y proveedor a la vez. Un solo lugar donde vive cada persona o empresa.

**Regla para el portal:**
- **Personas:** una sola tabla `equipo` (ya existe). Contadora, analista, vendedora, gerente son **roles** (casillas o un campo rol), no tablas distintas. Karina es analista; Claudia es implementadora; son la misma clase de cosa con rol distinto. Esto ya se empezó bien al unificar el roster en `equipo` — el principio dice: termínalo, no vuelvas a hardcodear nombres en el código.
- **Clientes:** un cliente que también recibe servicio de implementación y de cobros sigue siendo **un solo registro de cliente**, no uno por módulo.

### 5. El comportamiento vive en los datos, no escondido en el código

En Adm Cloud, una cuenta marcada como "banco" no puede mover inventario; una cuenta con `RequireLocation` obliga a poner ubicación. Las reglas son campos de la maestra, no líneas de código enterradas.

**Regla para el portal:** los colores de cada contadora, su capacidad, su tier, el objetivo de KPI, los tramos del bono, los precios — **nada de eso va hardcodeado en el HTML**. Va en tablas (`equipo`, `precios`, una tabla de config de KPI). Cuando Félix quiera cambiar el objetivo de una contadora o sumar una persona, lo hace editando datos, no pidiendo que alguien toque código. Hoy varias de estas cosas están en el código; el principio dice: muévelas a datos.

### 6. Los reportes leen, no controlan

El reporte 606/607 de Adm Cloud no guarda datos: se alimenta solo de las facturas ya registradas. Si cambias una factura, el reporte se recalcula. La inteligencia vive **encima** de la capa operativa, como una lectura.

**Regla para el portal:** el módulo de **Gerencia** (el ojo de águila de Félix) **no tiene datos propios**. No se llena a mano ni guarda su propia copia. Lee de lo que las contadoras, Karina y Claudia ya registraron en sus módulos. Si un número en Gerencia no cuadra, el problema está en la fuente, y se arregla en la fuente. Gerencia nunca es una fuente de verdad; siempre es un espejo.

### 7. Roles y permisos en dos capas, con vistas distintas sobre la misma data

Adm Cloud separa el acceso en dos: la **licencia** (qué tipo de asiento tienes: completo, solo lectura, portal de empleado) y el **grupo** (qué permisos tienes dentro de ese asiento). Hay un admin que nadie puede degradar. Y lo clave: cliente y firma trabajan sobre **la misma data**, viendo vistas distintas según su rol — no hay copias separadas.

**Regla para el portal:**
- Mantener el sistema de **grupos de permisos** (ya existe, con matriz JSONB pantalla × habilidad). Es el patrón correcto, igual al de Adm Cloud.
- Tres vistas sobre la misma data: **Gerencia/Félix** ve todo; **la contadora** ve sus clientes; **el cliente** ve solo lo suyo por su link único. Misma fuente, filtros distintos. No se construyen tres bases de datos; se construye una con tres lentes.
- El cliente nunca ve la data de otro cliente. Eso se garantiza con RLS (ya habilitado), no confiando en que el frontend esconda cosas.

---

## El modelo de datos objetivo

Así debería verse el corazón del portal:

```
MAESTRAS (se configuran una vez)
┌─────────────────────────────────────────────┐
│ clientes        id (= GUID de Adm Cloud) ◄───┼──┐ columna vertebral
│                 nombre, rnc, fecha_entrada,  │  │
│                 servicios[], activo          │  │
│                                              │  │
│ equipo          id, nombre, rol, color,      │  │
│                 capacidad, tier, objetivo_kpi│  │
│                                              │  │
│ tipos_impuesto  id, nombre (TSS, IR-17...)   │  │
│ precios         id, servicio, monto, moneda  │  │
│ grupos          id, permisos (JSONB)         │  │
└─────────────────────────────────────────────┘  │
                                                  │ todas referencian
TRANSACCIONES (pasan cada mes, apuntan por ID) ───┘ cliente_id / equipo_id
┌─────────────────────────────────────────────┐
│ asignaciones    cliente_id, equipo_id, mes   │
│ checklist       cliente_id, equipo_id, mes   │
│ kpi_mensual     equipo_id, mes, datos        │
│ impuestos_chk   cliente_id, tipo_imp_id, mes │
│ cobros          cliente_id, factura, balance │
│ implementacion  cliente_id, tipo, fase       │
│ retroalimentac. equipo_id, cliente_id, ...   │
└─────────────────────────────────────────────┘
```

**La regla de oro visible en el dibujo:** las flechas siempre van de transacción → maestra, por **ID**. Nunca una transacción guarda el nombre del cliente; guarda su `cliente_id`. El nombre se busca en la maestra al momento de mostrar.

---

## Dónde el portal hoy se aleja (diagnóstico honesto)

No para criticar lo construido —el portal ya hace muchísimo— sino para saber qué enderezar:

1. **Clientes identificados por nombre, regados en varias tablas.** `clientes` (con registros separados para contabilidad e impuestos), `impuestos_checklist`, `reporte_mensual`, `cobros_facturas` — cada uno guarda el nombre y se emparejan por texto. Esto rompe los principios 1 y 3. **Es el arreglo de mayor impacto.** Síntomas que ya viste: duplicado de Tricargo, match parcial por "Srl", Karina/Morelia con dos nombres.

2. **Datos de comportamiento en el código.** Contadoras, colores, capacidad y objetivos hardcodeados en `gerencia.html` y otros. Rompe el principio 5. Ya se empezó a mover a `equipo` y `precios`; falta terminar.

3. **Sin ID estable compartido con Adm Cloud.** El portal ya sincroniza cobros desde Adm Cloud vía su API, pero empareja por nombre. Adoptar el GUID de la empresa de Adm Cloud como `cliente_id` cierra el principio 3 y conecta los dos sistemas de forma sólida.

**Lo que ya está bien y hay que conservar:**
- Sistema de grupos de permisos con JSONB (principio 7). ✓
- RLS habilitado en todas las tablas (principio 7). ✓
- Tabla `equipo` unificada para personas (principio 4). ✓ — terminar de adoptarla en todos los módulos.
- Inactivar en vez de borrar (rastro de auditoría, como el `Void` de Adm Cloud). ✓

---

## Checklist de decisión

Antes de construir o cambiar algo en el portal, pásalo por aquí:

- [ ] **¿Este dato ya vive en otra tabla?** Si sí, no lo copies: léelo por ID. (P1)
- [ ] **¿Esto es maestra o transacción?** Si es transacción, ¿apunta a su maestra por ID? (P2)
- [ ] **¿Estoy identificando un cliente o persona por nombre?** Si sí, párate: usa el ID. (P3)
- [ ] **¿Estoy creando una tabla nueva para algo que es un rol de una entidad que ya existe?** (P4)
- [ ] **¿Estoy escribiendo en el código un color, capacidad, objetivo o precio?** Eso va en una tabla. (P5)
- [ ] **¿Este reporte guarda datos propios?** Si es de Gerencia, debería solo leer. (P6)
- [ ] **¿La separación cliente/contadora/Félix se garantiza en la base (RLS), o solo en el frontend?** Tiene que ser en la base. (P7)

---

## Qué NO copiar de Adm Cloud

Para no caer en rabbit hole: Adm Cloud es un ERP completo, el portal es una **torre de control de la firma**. Copiamos sus **principios de diseño de datos**, no sus funciones. No necesitamos catálogo de cuentas, ni asientos, ni inventario en el portal — eso ya vive en Adm Cloud. El portal gestiona el trabajo de la firma *sobre* esos clientes, y se conecta a Adm Cloud por la API cuando necesita datos reales (como ya hace con cobros).

---

*Documento vivo. Si construyendo encontramos un principio nuevo que valga la pena, se agrega aquí.*

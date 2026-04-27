# Portal Account One — Sobre el proyecto

## Qué es

Portal interno de Account One. Una aplicación web donde el equipo gestiona operaciones diarias: control de contadoras, pipeline de ventas, checklist mensual, KPIs, permisos de usuario. Los clientes de la firma eventualmente tendrán acceso a un portal propio para ver su información.

## Por qué existe

Account One opera con 10 personas y 40 clientes. Antes de este portal, el control se hacía en Excel y WhatsApp. Este portal centraliza todo en un solo lugar con datos en tiempo real, roles de acceso, y visibilidad para Félix sin depender de que alguien le mande un archivo.

## Stack técnico

| Componente | Tecnología | Nota |
|---|---|---|
| Frontend | HTML + CSS + JS vanilla | Un archivo .html por módulo. Sin frameworks. |
| Base de datos | Supabase (PostgreSQL) | Proyecto: "Portal Account One", región us-east-1 |
| Hosting | GitHub Pages | Repo: `themoneycoachrd/portal-accountone` |
| Auth | Supabase Auth (email/password) | Usuarios creados manualmente por admin |
| Permisos | Sistema de grupos con JSONB | Tabla `grupos` + `usuario_grupos` (many-to-many) |

URL en producción: `themoneycoachrd.github.io/portal-accountone/`

## Decisiones de arquitectura que ya se tomaron

- **Variable del cliente Supabase se llama `sb`**, no `supabase`, para evitar conflicto con el CDN global.
- **Navegación iframe**: `index.html` carga cada módulo en un iframe con `?embed=1`. El parámetro `embed=1` activa la clase `body.embed` que oculta header, login y breadcrumb.
- **No hay build step**: todo es vanilla HTML/CSS/JS. Se sube directo a GitHub Pages.
- **Permisos por grupo, no por usuario**: cada grupo tiene una matriz JSONB de pantalla x habilidad. Un usuario puede pertenecer a varios grupos. Los permisos se suman (union).
- **Meses en texto**: la tabla `asignaciones` usa TEXT para el mes ('enero', 'abril'), no números.
- **UPSERT con onConflict**: para guardar datos se usa upsert con la constraint correspondiente.
- **RLS habilitado en todas las tablas**. Función `get_my_role()` (SECURITY DEFINER) para validar el rol del usuario.

## Módulos del portal

| Módulo | Archivo | Estado | Descripción |
|---|---|---|---|
| Index / Sidebar | `index.html` | Activo | Página principal con sidebar de navegación |
| Pipeline de Ventas (Comercial) | `ventas.html` | Activo (cerrado) | Funnel de ventas, leads, ROAS. No se toca. |
| Gerencia | — | Pendiente | Super reporte ojo de águila para Félix: clientes, contadoras, impuestos, implementaciones |
| Control de Contadoras | `control-contadoras.html` | Activo | Reporte mensual + KPI mensual + Checklist Mensual (submódulo) |
| Checklist (viejo) | `checklist.html` | Legacy | Será reemplazado por el submódulo dentro de Control de Contadoras |
| KPI (rehacer) | `kpi.html` | Activo, se rehace | Documento rellenable mensual, nota sobre 100, bono trimestral por tramos |
| Usuarios y Permisos | `usuarios.html` | Activo | Gestión de grupos y asignación de permisos |
| Control de Clientes | `contadores.html` | Activo | Dashboard de clientes y carga por contadora |
| Impuestos | — | Pendiente | Tabla cliente x impuesto (TSS, IR-17, Anticipos, IR-3, 606, 607, ITBIS), vista por cliente y por contadora |
| Implementaciones | — | Pendiente | Dos pestañas: Facturación Electrónica y Normales. Status, semáforo, fecha objetivo |
| Portal de Clientes | — | Pendiente | Acceso por link único. Checklist atado a impuestos, carga de NCF Bancos, nómina, proveedores informales |

Las descripciones funcionales detalladas (qué exactamente hace cada módulo) están en `memory-portal.md`, sección "Descripciones funcionales por módulo".

## Tablas en Supabase

| Tabla | Para qué | SQL de setup |
|---|---|---|
| `profiles` | Nombre y rol de cada usuario auth | `auth-setup.sql` |
| `leads` | Pipeline de ventas | `supabase-setup.sql` |
| `roas_mensual` | Métricas de publicidad | `supabase-setup.sql` |
| `asignaciones` | Qué clientes tiene cada contadora por mes | `contadores-setup.sql` |
| `reporte_mensual` | Datos del control de contadoras (facturas, fechas, links) | `reporte-setup.sql` |
| `checklist_mensual` | Items del checklist por contadora/cliente/mes | `checklist-setup.sql` |
| `grupos` | Grupos de permisos con JSONB | `permisos-setup.sql` |
| `usuario_grupos` | Asignación usuario-grupo (many-to-many) | `permisos-setup.sql` |

## Equipo relevante

| Persona | Rol en el portal |
|---|---|
| Félix | Admin. Único usuario del módulo de Gerencia |
| Taina, Beliani, Yessica, Victoria | Contadoras. Llenan checklist mensual y KPI |
| Karina | Excluida del control de contadoras. **Gerente del módulo de Impuestos** |
| Milka | Excluida del control de contadoras (su servicio no aplica) |
| Claudia | **Encargada del módulo de Implementaciones** (FE y normales) |
| Naomi | Ventas. Usa el pipeline |

## Cómo se despliega

1. Editar los archivos .html o .sql en `Projects/Portal-account-one/`
2. Subir a GitHub (repo `themoneycoachrd/portal-accountone`)
3. GitHub Pages publica automáticamente
4. Los .sql se ejecutan manualmente en el SQL Editor de Supabase

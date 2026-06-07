# Mapa de Memoria — Portal Account One

Índice temático de `memory-portal.md` para encontrar rápido sin leer 1500+ líneas. Los números de línea son aproximados.

---

## Arquitectura general
- **Stack:** HTML/CSS/JS vanilla + Supabase + GitHub Pages (~L30)
- **Variable Supabase:** `sb`, nunca `supabase`
- **Embed mode:** `?embed=1` oculta header/login/breadcrumb. Los main-tabs internos siempre quedan visibles (~L464)
- **Auth:** Supabase Auth email/password. Tabla `profiles` con nombre y rol. `get_my_role()` SECURITY DEFINER (~L33)
- **Roles:** admin, comercial, contadores, impuestos, implementaciones (~L851)

## Sistema de permisos
- Tabla `grupos` con JSONB `permisos` (pantalla × habilidad) + `usuario_grupos` many-to-many (~L36)
- Permisos aditivos (unión de grupos) (~L40)
- Crear usuarios con `invite_user()` function (~L186)

## Base de datos de clientes (tabla `clientes`)
- **Consolidación completa (5 fases A-E):** columnas de responsabilidad, contadoras dobles, monto_adm, historial de cambios (~L259-394)
- **Campos clave:** `responsabilidad_contabilidad`, `responsabilidad_impuestos`, `contadora_contabilidad`, `contadora_impuestos`, `monto_adm` (transacciones, no dinero), `tipo_servicio`, `fecha_entrada`, `fecha_salida`, `rnc`
- **Derivados:** nuevos/churn/cierre se calculan de fecha_entrada/fecha_salida, no de meses_resumen (~L312)
- **Tipos de servicio:** Contabilidad completa, Tax One (solo impuestos), Solo supervisión, Bookkeeping (~L329, ~L348)

## Módulos del portal

### ventas.html (Comercial)
- Pipeline de leads, ROAS, Movimiento (ganados por categoría), Checklist comercial (~L424, ~L1237, ~L1457+)
- Categorías: Adm, Implementacion, Facturacion Electronica, Servicios Recurrentes. Normalización con CAT_NORMALIZE
- Puente comercial: al cerrar lead como ganado → inserta en `clientes_pendientes` + crea `checklist_comercial`
- ROAS se sincroniza automáticamente desde pipeline (`syncRoasFromPipeline`)

### contabilidad.html (Checklist + KPI + Reporte)
- 23 items de checklist por cliente/contadora/mes. Deadlines por impuesto: TSS día 3, IR-3 día 3, IR-17 día 10, Anticipo día 15, ITBIS día 20 (~L98)
- KPI: Digitación 50% + Resúmenes 30% + Video/Reunión 20%. Score sobre 100, bono trimestral (~L72, ~L87)
- KPI sub-tabs: Detalle por Contadora | Resumen Trimestral | **Reporte Mensual** (2026-06-05)
- Reporte Mensual: snapshot por contadora/mes. 3 bloques (Digitación/Portal/Correo), score card, notas temporales
- Stats KPI: "Visión" (objetivo contratado), "Mes anterior" (effectiveAdm). Tabla tiene columnas Mes ant., Contrat., % después de Total
- MV Creative ya no es excepción — incluida en scoring de Beliani (2026-06-05)
- Resumen: barras HTML clickeables como filtro por tipo de impuesto + cards de urgencia clickeables
- "Proveedores" renombrado a "IR-17" en items del checklist (2026-06-05)
- Excluidas: Milka y Yolenny (Karina incluida desde 2026-04-26)
- Tablas: `checklist_contadores`, `kpi_detalle`, `kpi_scores`

### impuestos.html
- Tab Control (matriz cliente × impuesto) + Tab Checklist (detalle por cliente) (~L222)
- Importe editable por impuesto (~L154)
- Items por tipo: TSS/IR-3 (4), IR-17 (4), Anticipo (2), ITBIS (5) (~L233)
- Tabla: `impuestos_checklist` con JSONB + flag `en_atraso`

### gerencia.html
- **Módulos top-level:** Clientes y Contadoras (BD eliminado en Fase 5-A, funciones comentadas para migrar)
- **Control Clientes:** Dashboard + tab Servicios (agrupado por tipo_servicio) (~L312, ~L358)
- **Control Contadoras:** Tabla plana de clientes con progreso checklist + reportes (~L160). Lee de `asignaciones` (pendiente migrar a maestra)
- **Base de Datos:** COMENTADO — funciones BD en bloque `/* PENDIENTE MIGRAR */` (~L3114-4627). Links Portal eliminado completamente.
- **Comercial (nuevo 2026-05-09):** Clientes outsourcing + software + facturación (~L1265, ~L1415)
- Precios software: PRECIOS_SOFTWARE lookup (~L1424). Precios outsourcing: por tipo × transacciones (~L1428)
- Descuentos en `clientes_software`: pct, vence, nota (~L1438)

### implementaciones.html
- Tab Implementación Completa (6 pasos kick-off → go live) + Tab Facturación Electrónica (5 pasos + semáforo) (~L196)
- Tablas: `implementaciones_completas`, `implementaciones_fe`

### personal.html (Personal / Wow Points)
- Módulo de reconocimiento: puntos variables (50/100), bono RD$3,000 cada 1,000 pts (~L1517+)
- Naomi (ventas) y admin dan puntos, todos ven tablero y historial
- Tabla `wow_points`: tipo puntos/pago, empleado_id → profiles(id)

### portal-clientes.html (vista cliente)
- Acceso por `?token=UUID` + validación RNC (~L814). RPCs SECURITY DEFINER para carga sin sesión (~L826)
- Checklist de impuestos (6 tabs: Dashboard/TSS/IR-3/IR-17/Anticipo/ITBIS) (~L449)
- Presentación Mensual: Presupuesto vs Ejecución, Proyección de Impuestos, Declaraciones (~L480)
- Calendario de entregas: Resumen (accordion 5 obligaciones) + "Cómo se ve un mes" (3 perspectivas: Cliente/AO/DGII). Read-only, misma visual que admin.

### portal-admin.html (vista admin)
- Tabs Checklist/Presentación/Calendario a nivel de índice (antes de seleccionar cliente)
- Calendario de entregas: Resumen = tabla 6 cols con accordion. "Cómo se ve un mes" = timeline filtrado por perspectiva. CSS fondo blanco, badges de color suave. Datos hardcodeados en OBLIGACIONES y TIMELINE_ENTRIES.
- Carga de Excel para Estado de Resultados (SheetJS) (~L684)
- Parser: detecta secciones Ingresos/Costos/Gastos/Otros gastos/Ingresos financieros (~L688)
- Fórmula ganancia: V - CO - G + IF - GNA (~L871)
- CRS automático con `pmCalcCRS()` según Ley 98-25 (~L800)

### usuarios.html
- Gestión de grupos (matriz permisos) + usuarios (checkbox de grupos) (~L36)

### index.html
- Sidebar con roles por menú item. Role picker para admin (temporalmente desactivado) (~L851)
- Dashboard de inicio con 3 KPI cards (~L427)

## Tablas Supabase (referencia rápida)

| Tabla | Propósito | SQL |
|---|---|---|
| leads | Pipeline comercial | supabase-setup.sql |
| roas_mensual | Métricas ROAS | supabase-setup.sql |
| profiles | Nombre y rol de usuario | auth-setup.sql |
| asignaciones | Contadora-cliente-mes | contadores-setup.sql |
| checklist_contadores | Checklist contabilidad | checklist-contadores-setup.sql |
| kpi_detalle / kpi_scores | KPI de contadoras | kpi-detalle-setup.sql |
| impuestos_checklist | Checklist impuestos | impuestos-setup.sql |
| clientes | Maestra de clientes | clientes-setup.sql |
| clientes_cambios_contadora | Historial cambios | clientes-consolidacion-fase-a.sql |
| clientes_pendientes | Cola de onboarding | (inline en ventas) |
| clientes_software | Clientes de software | clientes-software-setup.sql |
| contadoras | Directorio contadoras | contadoras-table.sql |
| grupos / usuario_grupos | Permisos | permisos-setup.sql |
| implementaciones_completas / _fe | Implementaciones | implementaciones-setup.sql |
| portal_clientes_tokens | Tokens de acceso | portal-clientes-setup.sql |
| portal_clientes_data | Data checklist cliente | portal-clientes-setup.sql |
| portal_clientes_archivos | Uploads de clientes | portal-clientes-setup.sql |
| portal_presupuesto | Presupuesto anual | portal-presentacion-setup.sql |
| portal_ejecucion | Estado de resultados | portal-presentacion-setup.sql |
| portal_impuestos_config | Config fiscal anual | portal-presentacion-setup.sql |
| portal_declaraciones | Obligaciones por mes | portal-presentacion-setup.sql |
| checklist_comercial | Checklist post-venta | checklist-comercial-setup.sql |
| wow_points | Puntos Wow del equipo | wow-points-setup.sql |

## Decisiones importantes
- Salarios absorbido dentro de Gastos (no línea separada) (~L862)
- `monto_adm` = transacciones contratadas (integer), no dinero (~L276)
- API Adm Cloud: no hay endpoint de Estado de Resultados. Fase 2. Excel es Fase 1 (~L677)
- Contadoras excluidas del control: Milka y Yolenny. Karina incluida (~L378)
- Meses en texto ('enero', 'abril') en tabla asignaciones. No cambiar a números
- Asignaciones es tabla de excepciones mensuales; la maestra es `clientes` (~L403)

## Patrones de código recurrentes
- **Namespacing:** cada módulo usa prefijo propio (ck=checklist, kpi=kpi, cc=control clientes, ctd=control contadoras, bd=base datos, cl=clientes modal, pm=presentación mensual, chk=checklist comercial)
- **Toggle Si/No:** `.toggle-group > .toggle-opt` con `.active-yes` (verde) y `.active-no` (rojo)
- **Month pills:** `.month-tab` con `.active`, opacity baja si no hay datos
- **Summary stats:** grid de cards con label + value coloreado
- **Client cards:** grid con nombre, barra de progreso, conteo de tareas
- **Sort:** Sin asignar siempre al final, Taina primero en contabilidad

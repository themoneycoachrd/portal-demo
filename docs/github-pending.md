# Archivos pendientes de subir a GitHub

Este archivo lo mantiene Claude automáticamente. Cuando se modifica un archivo en `pages/` o se crea un SQL nuevo, se agrega aquí. Cuando Felix confirma que subió, se limpia.

## pages/ (subir a GitHub Pages)

- [x] gerencia.html — botón "Desestimar" + filtro de tabs para rol comercial
- [x] ventas.html — Checklist visible para rol comercial
- [x] portal-clientes.html — acceso permitido para rol comercial
- [x] index.html — sidebar: gerencia y portal-clientes accesibles para comercial
- [x] gerencia.html — pill "Total clientes" software muestra cierre del mes, clic filtra todos, listado alfabético
- [x] ventas.html — responsable en leads (dropdown en forms, columna en tabla, auto-detect en checklist, eliminar checklist con revert, resp read-only en detalle)
- [x] ventas.html — sincronizar responsable del checklist cuando se edita el responsable del lead
- [x] dashboard-publico.html — rediseño TV (dos columnas, chart con eje Y, listas de clientes, pills labels)
- [x] portal-admin.html — selector tipo contribuyente (empresa/persona física), amarillo proyección más fuerte
- [x] portal-clientes.html — lógica persona física (3 cuotas jun/sep/dic), amarillo proyección más fuerte
- [x] ventas.html — fix delete con await + demo date mueve lead al mes correcto + auto-crear checklist FE al ganar lead con Facturación Electrónica
- [x] personal.html — módulo nuevo: Wow Points (tablero, historial, dar puntos, pagar bono)
- [x] index.html — agregar Personal al sidebar (visible para todos los roles)
- [x] portal-admin.html — fix ISR vs Activos: nota resumen debajo de paneles (no filas inline)
- [x] portal-clientes.html — sincronizado con portal-admin: nota resumen debajo de paneles
- [x] contabilidad.html — botón N/A en checklist de responsabilidades (tercer estado, violeta)
- [x] impuestos.html — botón N/A en checklist de obligaciones (tercer estado, violeta)
- [x] implementaciones.html — reescritura completa: Checklist FE con 15 pasos, pills de implementadoras, detalle por cliente
- [x] implementaciones.html — fix profiles query + renombrar botón + toggle tabla/cuadros + nota por tarea + guardar arriba
- [x] gerencia.html — checkboxes "Checklist FE / Checklist Adm" en modal de cliente, crea en impl_checklist_fe al guardar
- [x] ventas.html — pill "Todos" en checklist comercial muestra pendientes de todos los meses
- [x] ventas.html — toggle tabla/cuadros en checklist comercial (misma estructura que contabilidad)
- [x] implementaciones.html — dropdown asignar implementadora + Checklist Adm funcional (18 pasos, misma estructura que FE)
- [x] gerencia.html — checkbox Checklist Adm habilitado, crea en impl_checklist_adm al guardar
- [x] **Fase 9 — Migración a permisos por grupo (tengoPermiso):**
  - [x] index.html — sidebar filtrado por tieneAccesoModulo() en vez de roles
  - [x] contabilidad.html — tengoPermiso reemplaza userRole checks
  - [x] impuestos.html — tengoPermiso reemplaza userRole checks
  - [x] personal.html — tengoPermiso reemplaza userRole checks
  - [x] implementaciones.html — tengoPermiso reemplaza userRole checks
  - [x] ventas.html — tengoPermiso reemplaza userRole checks
  - [x] gerencia.html — tengoPermiso reemplaza userRole checks + fix sub-tabs filtradas por permiso
  - [x] portal-admin.html — tengoPermiso reemplaza allowedRoles check
  - [x] portal-clientes.html — tengoPermiso reemplaza allowedRoles check
  - [x] checklist.html — tengoPermiso reemplaza userRole checks
  - [x] kpi.html — tengoPermiso reemplaza userRole checks
  - [x] usuarios.html — tengoPermiso reemplaza userRole checks
- [x] gerencia.html — fix sub-tabs filtradas por permisos (ccRenderMainTabs + bdRenderSubTabs)
- [x] portal-admin.html — tab Calendario de entregas (resumen con accordion, "Cómo se ve un mes" con 3 perspectivas)
- [x] portal-clientes.html — tab Calendario de entregas (misma visual, read-only)
- [x] ventas.html — queries en paralelo con Promise.all (performance)
- [x] personal.html — fix nombre Lissette Peña

## db/ (ejecutar en Supabase SQL Editor)

- [x] rls-comercial-tokens.sql — Naomi pueda ver tokens de portal_clientes_tokens
- [x] leads-responsable.sql — ALTER TABLE leads ADD COLUMN responsable TEXT
- [x] checklist-comercial-delete-policy.sql — DELETE policy para comercial en checklist_comercial
- [x] tipo-contribuyente.sql — ADD COLUMN tipo_contribuyente a portal_impuestos_config
- [x] wow-points-setup.sql — CREATE TABLE wow_points + RLS (admin/comercial insertan, todos leen)
- [x] tricargo-temporal.sql — cliente temporal Tricargo + token portal (sin fecha_entrada)
- [x] impl-checklist-fe-setup.sql — CREATE TABLE impl_checklist_fe + RLS (admin/implementaciones)
- [x] impl-checklist-adm-setup.sql — CREATE TABLE impl_checklist_adm + RLS (admin/implementaciones)
- [x] add-roles-marketing-cobros.sql — Agregar roles marketing/cobros al constraint + recrear invite_user
- [x] impl-dates-software.sql — superseded por impl-dates-separadas-software.sql

---

- [x] personal.html — fix nombre Lissette Peña (doble t)
- [x] implementaciones.html — fix nombre Lissette Peña (doble t)
- [x] usuarios.html — dropdown con roles marketing y cobros + ROLE_GRUPO mapping
- [x] portal-admin.html — fix: switchMainTab ahora llama renderAdminNav() para limpiar pills en Calendario
- [x] impuestos.html — fix: ocultar navArea (pills mes/contadora) al entrar en vista detalle de cliente
- [x] implementaciones.html — botón "Eliminar checklist" en vista detalle (solo con permiso de edición)
- [x] usuarios.html — filtro de departamento sin recargar datos (renderUsuariosOnly en vez de renderApp)
- [x] gerencia.html — Fase 5 Sub-fase A: eliminado módulo BD top-level, comentado funciones BD, eliminado Links Portal
- [x] gerencia.html — Fase 5 completa (Sub-fases A+B+C+D): 8 pills, migrado BD→CC + pill Link Dashboard ahora muestra URL del dashboard TV (no tokens de clientes)
- [x] usuarios.html — MODULOS actualizado: labels Outsourcing/Implementaciones/Link Dashboard, subtabs reordenados
- [x] gerencia.html — Resumen de Implementaciones reescrito + fix SyntaxError (llave sobrante línea 1179 que impedía login en embed)
- [x] implementaciones.html — tab Resumen (stats + tabla unificada FE/Adm con progreso y badge riesgo)
- [x] contabilidad.html — fix KPI permisos: contadoras solo ven su propio KPI (isKpiAdmin distingue admin vs contadora)
- [x] gerencia.html — fix búsqueda (const duplicado + helper functions en segunda copia) + fechas impl en modales + ccBuildImplDates desde tablas de clientes
- [x] implementaciones.html — impl dates ahora se leen de clientes/clientes_software en vez de tabla implementaciones
- [x] index.html — deep linking con hash (#gerencia, #comercial, etc.) + título dinámico del tab
- [x] gerencia.html — modal outsourcing reorganizado (secciones Contabilidad/Licencia/Implementación/Checklist de servicios) + fechas impl separadas FE/Adm + modal software con servicio_impl y fechas separadas
- [x] implementaciones.html — fechas impl separadas FE/Adm + fechas visibles en Resumen, lista FE/Adm (tabla+cuadros), y vista detalle con días restantes y % tiempo transcurrido
- [x] gerencia.html — checkboxes Checklist FE/Adm en modal de cliente Software (misma lógica que Outsourcing)
- [x] impuestos.html — 2 pasos nuevos en ITBIS (Borrador devuelto + Borrador recibido corregido) con modal de notas e historial

## db/ (ejecutar en Supabase SQL Editor)

- [x] impl-dates-separadas.sql — ALTER TABLE clientes ADD 4 columnas (fecha_inicio/fin_impl_fe/adm) + migrar datos
- [x] impl-dates-separadas-software.sql — ALTER TABLE clientes_software ADD servicio_impl + 4 columnas fechas separadas FE/Adm + migrar datos
- [x] fix-all-rls-nested.sql — Fix global de RLS: rutas anidadas en 5 tablas (impuestos_checklist, implementaciones_completas, implementaciones_fe, impl_checklist_fe, impl_checklist_adm) + migrar impl_checklist_adm de get_my_role() a grupos

## pages/ (subir a GitHub Pages)

- [x] impuestos.html — editar/eliminar notas en modal ITBIS
- [x] portal-admin.html — presupuesto MSH: eliminar sección Obra, quitar % dinámico de Gastos, limpiar referencias obra en save
- [x] portal-clientes.html — sincronizado con portal-admin: eliminar Obra, quitar % Gastos
- [x] contabilidad.html — tab Resumen rediseñado: greeting, 3 tarjetas urgencia (urgente/vencido/próximo), gráficos Chart.js (por impuesto + por cliente), agrupado por cliente, vista personal para contadoras, labels unificados, showToast, currentUserId

## db/ (ejecutar en Supabase SQL Editor)

- [x] notas-contadora-setup.sql — CREATE TABLE notas_contadora + RLS (consulta/adicion/eliminar por grupo)

## pages/ (subir a GitHub Pages)

- [x] contabilidad.html — Resumen: urgencia calendario AO, eliminado paso TSS duplicado (23 pasos), isResAdmin por permiso control-clientes, insights admin (contadora y cliente con más atrasos)
- [x] index.html — sidebar: "Gerencia" renombrado a "Clientes"
- [x] gerencia.html — título/breadcrumb "Gerencia" → "Clientes" + Asignaciones: columna Analista Imp. con dropdown editable + summary imp. asignados/sin asignar
- [x] usuarios.html — MODULOS y DEPT_PILLS: label "Gerencia" → "Clientes"
- [x] impuestos.html — pills filtradas: solo analistas de impuestos (Karina, Lovelis, Doriluz) en vez de todas las contadoras
- [x] kpi.html — headers de semana con rangos de fechas (S1: 1-3 may, S2: 4-10 may, etc.)
- [ ] gerencia.html — pill "Personal" (antes Contadoras), modelo rol+dedicación, dropdown Analista Imp. filtrado por rol, labels "tiempo completo"
- [ ] impuestos.html — fix esAnalista() para matching por nombre parcial (Lovelis, Doriluz ahora aparecen)
- [ ] personal.html — tabs Organigrama + Directorio con botón "Copiar todos los correos", incluye Milka Paulino y Doriluz Crisóstomo
- [ ] contabilidad.html — filtro inicio_responsabilidad_fiscal: clientes con fecha futura no aparecen en Resumen ni checklist para meses previos a su inicio
- [ ] impuestos.html — tab Resumen + pills primer nombre + filtro inicio_responsabilidad_fiscal + meses desde abril
- [x] portal-clientes.html — franja de fechas (A tiempo/Tarde/AO/DGII) en cada obligación del checklist
- [x] portal-admin.html — fechas dentro del card + botón "Enviar correo" + clientes agrupados por contadora_contabilidad (no analista impuestos)
- [x] contabilidad.html — KPI: bono invertido (100→abajo con deducciones), fechas semanas, confirmación semanal, Llenado Portal, template correo + digitación doble (carga/dig)
- [x] portal-admin.html — tab Calendario: grid visual + filtro global + mes abreviado + descripciones + prefijo responsable en celdas
- [x] portal-clientes.html — tab Calendario: sincronizado con portal-admin (grid + filtro + mes abreviado + descripciones + prefijo responsable)

## db/ (ejecutar en Supabase SQL Editor)

- [ ] contadoras-rol-dedicacion.sql — ALTER TABLE contadoras ADD rol + dedicacion, migrar datos desde tipo

- [x] contabilidad.html — KPI digitación: columna "Fuera del mes" (index 5, fondo beige), tooltip con fechas al hover, data migra de 5→6 entries
- [x] portal-admin.html — Calendario: celdas 70px, relleno compacto, 14 responsabilidades, template correo nuevo con fechas reales, botón "Template correo responsabilidades" movido al tab Calendario
- [x] portal-clientes.html — Calendario: sincronizado con portal-admin (celdas + responsabilidades)

- [x] implementaciones.html — Resumen rediseñado + fix barra progreso (display:block + color gradual rojo→ámbar→azul→verde)
- [x] dashboard-publico.html — fix: clientes sin fecha_entrada ahora se cuentan como preexistentes (igual que gerencia.html)
- [x] impuestos.html — borrador devuelto + recibido corregido en TSS (entre paso 1-2) e IR-17 (entre paso 1-2), con notas
- [x] portal-admin.html — calendario ITBIS: día 14 borrador a Impuestos, día 19 devuelto, día 19 cliente revisa, último recordatorio dinámico (fecha real DGII), template correo actualizado
- [x] portal-clientes.html — sincronizado con portal-admin: calendario ITBIS (día 14/19, último recordatorio dinámico, TIMELINE actualizado)

- [x] gerencia.html — pill Cobros: resumen estilo dashboard (greeting, urgency cards clickeables, gráficos aging + dona por cliente), pills score, búsqueda, moneda separada, templates correo/WhatsApp/estado de cuenta, notas de cobro, datos reales de Adm Cloud via Supabase
- [x] usuarios.html — módulo Cobros agregado al catálogo MODULOS

## db/ (ejecutar en Supabase SQL Editor)

- [x] notas-cobro-setup.sql — CREATE TABLE notas_cobro + RLS (cobros y admin)
- [x] cobros-facturas-setup.sql — CREATE TABLE cobros_facturas + RLS + columna tipo_doc
- [x] cobros-sync-inicial.sql — INSERT datos reales de cuentas por cobrar desde reporte Adm Cloud

## pages/ (subir a GitHub Pages)

- [x] gerencia.html — Cobros: completar/borrar/editar tareas, tabla con columnas, orden (DOP al final), headers clickeables, search sin recargar dona, últimas tareas clickeables + scroll + pills movimiento Outsourcing (Inicio/Nuevos/Churn/Cierre)

## db/ (ejecutar en Supabase SQL Editor)

- [x] cobros-completar-tarea.sql — constraint resultado + todas las policies notas_cobro reescritas (fix ruta JSONB 3 niveles)

## pages/ (subir a GitHub Pages)

- [x] gerencia.html — Cobros: 4 niveles templates, moneda, upload Excel, filtro asignado, botones en notas
- [x] contabilidad.html — KPI Morelia, getCurrentMonth mes en presentación
- [x] impuestos.html — getCurrentMonth mes en presentación
- [x] portal-clientes.html — modo demo ?demo=1, getCurrentMonth, título calendario
- [x] portal-admin.html — título calendario, mes default

## db/ (ejecutar en Supabase SQL Editor)

- [ ] cobros-facturas-rls-upload.sql — policies INSERT/DELETE cobros_facturas (upload desde portal)
- [x] migracion-taina-morelia.sql — UPDATE contadoras Taina→Morelia en todas las tablas
- [x] completar-abril-impuestos.sql — 85 registros abril completados para Lovelis/Doriluz

*Última actualización: 2026-06-02*
*Convención: [ ] = pendiente, [x] = ya subido/ejecutado*

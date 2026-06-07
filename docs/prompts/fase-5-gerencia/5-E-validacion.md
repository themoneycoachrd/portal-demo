# Fase 5 — Sub-fase E: Validación con Felix

## Objetivo

Cerrar la Fase 5 con una revisión completa de Felix. Probar todos los pills, validar datos, ajustar lo que haga falta y dejar el módulo estable.

## Pre-requisitos

- Sub-fases A, B, C y D cerradas.

## Plan de prueba

Felix recorre los pills uno por uno en este orden:

1. **Dashboard** — verificar cards, gráfico, tabla resumen, detalle expandible por mes.
2. **Outsourcing** — verificar orden de stats cards (Sin asignar arriba, luego Tax One / Contabilidad / Supervisión / Bookkeeping / Nuevos / Churn). Probar el filtro por mes y por tipo de servicio. Crear un cliente de prueba. Editar un cliente existente. Marcar uno como inactivo. Revertir todo al final.
3. **Software** — verificar stats, filtro por mes y licencia, CRUD.
4. **Implementaciones** — alternar entre FE y Adm. Verificar que cada pill interno muestra los datos correctos. Probar editar estatus.
5. **Contadoras (pill)** — verificar lista. Si llega una contadora nueva en producción, probar agregarla aquí y confirmar que aparece en los selects del modal de cliente en Outsourcing.
6. **Asignaciones** — filtro por mes, edición inline.
7. **Link Dashboard** — configuración del link público.
8. **Facturación** — filtro por mes, montos, desglose, comparativa.

Adicional:
- Verificar que el módulo top-level "Contadoras" (KPI + checklist) sigue funcionando intacto.
- Verificar modo embed (`?embed=1`) en al menos un pill.
- Verificar consola del navegador sin errores.

## Pendientes que se descubran

Si durante la validación aparecen ajustes pequeños, se hacen en esta sub-fase. Si aparece algo grande (cambio de alcance), se anota como pendiente para una fase posterior y se cierra la Fase 5 con la nota.

## Versión anterior

- Confirmar que `pages/version-anterior/gerencia-YYYY-MM-DD.html` está intacto por si hay que dar marcha atrás.
- Si todo está bien después de unos días de uso, se puede mover esa versión a un archivo de backup más profundo o dejarla como referencia.

## Criterios de cierre

- Los 8 pills funcionan.
- CRUD funciona en Outsourcing, Software y Contadoras.
- Felix confirma que la estructura está lista para uso diario.
- `memory-portal.md` actualizado con el cierre de la Fase 5.
- `plan.md` con todas las sub-fases tachadas y la Fase 5 marcada como "Cerrado YYYY-MM-DD".

## Después de cerrar

- Marcar la Fase 5 completa como cerrada en el checklist macro (`- [x] ~~Fase 5...~~`) y en la tabla de orden.
- Entrada en `memory-portal.md` listando todo lo que cambió.
- Considerar si la Fase 9 (migración a permisos por grupo) ya debe arrancar o esperar.

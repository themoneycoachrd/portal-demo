# Prompt para nueva sesión — Portal Account One

Copia y pega esto al inicio de una nueva sesión de este proyecto.

---

Estamos trabajando en el Portal Account One. Es un portal web interno para la firma de contabilidad Account One (República Dominicana). Stack: HTML/CSS/JS vanilla + Supabase + GitHub Pages.

## Antes de hacer cualquier cosa, lee estos archivos en este orden:

1. `Projects/Portal Account One/CLAUDE.md` — instrucciones del proyecto, reglas técnicas, estructura de archivos, qué hacer y qué no hacer.
2. `Projects/Portal Account One/docs/memory-map.md` — índice temático rápido del memory. Te dice dónde buscar sin leer las 2500+ líneas del memory completo.
3. `Projects/Portal Account One/docs/memory-portal.md` — memoria completa. Lee las últimas entradas (la sesión más reciente está arriba de "Decisiones pendientes") para saber qué se hizo en la última sesión.
4. `Projects/Portal Account One/docs/plan.md` — plan de desarrollo con fases, estados y orden de ejecución.

## Estado actual (actualizado 2026-06-05)

**Módulos funcionales:** index.html, ventas.html, contabilidad.html (Checklist + KPI + Reporte), gerencia.html (Clientes + Contadoras + Comercial + Cobros + Personal), impuestos.html, implementaciones.html, portal-clientes.html, portal-admin.html, dashboard-publico.html, personal.html, usuarios.html.

**Última sesión (2026-06-05):** Reporte mensual de KPI, reorganización columnas KPI, MV Creative incluida en scoring, filtros por tipo de impuesto y urgencia en resumen, fix moneda en cobros, y otros cambios menores. Detalles en `docs/memory-portal.md` sección "Sesión 2026-06-05".

**Próxima fase en el plan:** Fase 9 (Migración a permisos por grupo / hasPermiso). No arrancada.

## Reglas clave

- Variable del cliente Supabase = `sb`, nunca `supabase`.
- Un archivo HTML por módulo. CSS y JS inline.
- Lee el archivo antes de escribirlo. Siempre.
- Busca componentes visuales existentes antes de crear nuevos.
- Todo cambio visual en portal-admin debe replicarse en portal-clientes.
- Después de cada cambio, indica qué archivos subir a GitHub.
- Actualiza `docs/memory-portal.md` al final de la sesión.

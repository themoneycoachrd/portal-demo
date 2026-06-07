# Prompts — Fase 5 Gerencia (reorganización de pills)

Sub-fases en orden de ejecución. **Una sub-fase por sesión.** Al cerrar cada una, Felix valida y se pasa a la siguiente.

## Orden

1. `5-A-versionado-limpieza.md` — Guardar gerencia.html actual y eliminar lo que se va (BD top-level, Links Portal).
2. `5-B-estructura-pills.md` — Crear el esqueleto de los 8 pills nuevos en el orden acordado.
3. `5-C-migrar-contenido.md` — Migrar contenido pill por pill (Dashboard, Outsourcing, Software, Implementaciones, Contadoras, Asignaciones, Link Dashboard, Facturación).
4. `5-D-modulos-usuarios.md` — Actualizar el catálogo MODULOS en usuarios.html.
5. `5-E-validacion.md` — Probar con Felix, ajustar lo que haga falta y cerrar la fase.

## Reglas comunes a todas las sub-fases

- Antes de modificar `gerencia.html`, leerlo completo.
- Antes de inventar estilos, revisar variables CSS y patrones existentes.
- Variable Supabase = `sb`.
- Vanilla HTML/CSS/JS, inline. Sin frameworks.
- Embed mode (`?embed=1`) debe seguir funcionando.
- Después de cada sub-fase: actualizar `memory-portal.md` con lo que se hizo y marcar avance en `plan.md` (tachar el item del checklist macro y de la tabla de orden).

## Punto de control

Felix valida después de cada sub-fase. Si una sub-fase descubre algo que requiere decisión, parar y preguntar. No improvisar.

## Si hay que dar marcha atrás

La carpeta `pages/version-anterior/` tiene la versión previa de gerencia.html con fecha. Restaurar desde ahí si algo se rompe.

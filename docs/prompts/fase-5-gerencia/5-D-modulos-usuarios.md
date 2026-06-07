# Fase 5 — Sub-fase D: Actualizar catálogo MODULOS en usuarios.html

## Objetivo

Que el array `MODULOS` en `usuarios.html` refleje la nueva estructura de Gerencia (8 pills + pills internos de Implementaciones). Sin esto, los permisos por grupo no pueden asignarse correctamente a la UI nueva.

## Pre-requisitos

- Sub-fases A, B y C cerradas.

## Contexto

- `usuarios.html` define un array `MODULOS` que describe la estructura de cada módulo del portal (qué pantallas tiene, qué tabs tiene cada pantalla).
- Hoy ese array está desactualizado. Hay que dejarlo alineado con la realidad de Gerencia post-reorganización.
- Si la Fase 9 (migración a permisos por grupo) ya ejecutó su sub-fase A, parte de este trabajo ya está hecho. Verificar antes de duplicar.

## Cambios al array MODULOS

### Módulo Gerencia
Reemplazar el bloque actual de Gerencia por la estructura nueva:

```js
{
  id: 'gerencia',
  nombre: 'Gerencia',
  pantallas: [
    { id: 'dashboard',        nombre: 'Dashboard' },
    { id: 'outsourcing',      nombre: 'Outsourcing' },
    { id: 'software',         nombre: 'Software' },
    { id: 'implementaciones', nombre: 'Implementaciones', subtabs: [
      { id: 'fe',  nombre: 'FE' },
      { id: 'adm', nombre: 'Adm' }
    ]},
    { id: 'contadoras',       nombre: 'Contadoras' },
    { id: 'asignaciones',     nombre: 'Asignaciones' },
    { id: 'link-dashboard',   nombre: 'Link Dashboard' },
    { id: 'facturacion',      nombre: 'Facturación' }
  ]
}
```

### Quitar
- Cualquier referencia a "Base de Datos" como módulo separado.
- Cualquier referencia a "Links Portal" en Gerencia.

### Mantener
- El módulo top-level "Contadoras" (KPI + checklist) en MODULOS, sin tocar.
- El resto de módulos (Comercial, Impuestos, Contabilidad, Implementaciones, Portal Admin, Portal Clientes, Personal, Usuarios) como estén.

## Sincronizar con grupos existentes

- Revisar los grupos definidos en Supabase (tabla `grupos`).
- Si un grupo tenía permisos en "Base de Datos" o "Links Portal", esos campos quedan obsoletos. No es necesario borrarlos del JSONB, pero conviene limpiar para no acumular basura.
- Asegurar que el grupo Admin tenga acceso a todos los pills nuevos por default.

## UI de la pantalla de grupos

- Al refrescar la página de grupos en `usuarios.html`, debe aparecer la lista de pills nueva con sus toggles.
- Validar que el toggle de "Implementaciones" muestra los dos sub-tabs FE y Adm.

## Criterios de cierre

- Array MODULOS actualizado.
- La pantalla "Grupos" en usuarios.html muestra la nueva estructura de Gerencia.
- El grupo Admin tiene acceso a todos los pills nuevos.
- Felix puede crear un grupo de prueba y asignarle solo algunos pills sin errores.

## Punto de validación con Felix

Felix crea o edita un grupo desde `usuarios.html` y verifica que los pills aparezcan correctamente en la UI de configuración. No es necesario probar el comportamiento aún (eso es Fase 9), solo que la estructura se vea bien.

## Después de cerrar

- Marcar la sub-fase D como tachada.
- Entrada en `memory-portal.md`.

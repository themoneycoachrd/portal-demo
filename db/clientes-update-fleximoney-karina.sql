-- ============================================================
-- Actualizar Fleximoney: Karina ahora le lleva contabilidad
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
--
-- Antes: resp_contab = false, contadora_contabilidad = NULL
-- Ahora: resp_contab = true, contadora_contabilidad = 'Karina'
-- ============================================================

UPDATE clientes
SET responsabilidad_contabilidad = true,
    contadora_contabilidad = 'Karina'
WHERE nombre = 'Fleximoney';

-- ============================================================
-- VERIFICACIÓN:
--   SELECT nombre, responsabilidad_contabilidad, contadora_contabilidad,
--          responsabilidad_impuestos, contadora_impuestos
--   FROM clientes
--   WHERE nombre = 'Fleximoney';
-- ============================================================

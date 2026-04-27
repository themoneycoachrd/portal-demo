-- ============================================================
-- FASE B: Migración de datos — poblar monto_adm y corregir flags
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
--
-- Fuente de monto_adm: columna "serv" de asignaciones (abril 2026)
-- porque "serv" = servicio contratado (50, 100 o 200).
-- La columna "adm" de asignaciones es transacciones digitadas
-- (dato variable), no el contrato.
--
-- Correcciones de flags validadas por Félix:
--   - Kaizen: RST (Régimen Simplificado de Tributación), no lleva impuestos
--   - CLC, Vitalie: solo impuestos (Karina), no contabilidad
--   - Fleximoney: solo impuestos (Karina), contabilidad especial aparte
--   - Mab Arquitectura: bookkeeping con Milka, fuera de checklists
--   - Centro Adorartes: RST, no lleva impuestos
-- ============================================================

BEGIN;

-- ─────────────────────────────────────────────────────────────
-- 1. POBLAR monto_adm desde asignaciones.serv (abril 2026)
-- ─────────────────────────────────────────────────────────────

-- Taina
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Blackbox';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Impact';
UPDATE clientes SET monto_adm = 100 WHERE nombre = 'La Fragaria';
UPDATE clientes SET monto_adm = 100 WHERE nombre = 'MSH';
UPDATE clientes SET monto_adm = 100 WHERE nombre = 'PSC';

-- Beliani
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Iris Laura';
UPDATE clientes SET monto_adm = 100 WHERE nombre = 'La Charpente';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Maria Raquel';
UPDATE clientes SET monto_adm = 200 WHERE nombre = 'Mv Creative';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Oleica';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Sosa Arquitectura';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Suplident';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Unfold';

-- Victoria
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Dr. Maurice Morel';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Gestaf';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Grupisa';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Kaizen';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Louis Maurice Morel';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Polux';

-- Yessica
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Enlaces';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Kalma';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Mj Inversiones';
UPDATE clientes SET monto_adm = 100 WHERE nombre = 'RB Raquel Bencosme';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'SAV';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Tic Tag';

-- Karina (facturación electrónica)
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'CLC';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Fleximoney';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Vitalie';

-- Milka (freelance)
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Mab Arquitectura';

-- Sin asignar
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Centro Adorartes';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Dior Legal';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Domingo Lizardi';
UPDATE clientes SET monto_adm = 50  WHERE nombre = 'Igsan';


-- ─────────────────────────────────────────────────────────────
-- 2. CORREGIR FLAGS de responsabilidad
-- ─────────────────────────────────────────────────────────────

-- Kaizen: está en RST (Régimen Simplificado de Tributación), no lleva impuestos regulares
UPDATE clientes
SET responsabilidad_impuestos = false
WHERE nombre = 'Kaizen';

-- Centro Adorartes: también RST (Régimen Simplificado de Tributación), no lleva impuestos
UPDATE clientes
SET responsabilidad_impuestos = false
WHERE nombre = 'Centro Adorartes';

-- CLC: solo impuestos (Karina), no contabilidad
UPDATE clientes
SET responsabilidad_contabilidad = false,
    responsabilidad_impuestos = true,
    contadora_impuestos = 'Karina'
WHERE nombre = 'CLC';

-- Vitalie: solo impuestos (Karina), no contabilidad
UPDATE clientes
SET responsabilidad_contabilidad = false,
    responsabilidad_impuestos = true,
    contadora_impuestos = 'Karina'
WHERE nombre = 'Vitalie';

-- Fleximoney: solo impuestos (Karina), contabilidad especial aparte del sistema
UPDATE clientes
SET responsabilidad_contabilidad = false,
    responsabilidad_impuestos = true,
    contadora_impuestos = 'Karina'
WHERE nombre = 'Fleximoney';

-- Mab Arquitectura: bookkeeping con Milka, no lleva checklists de contabilidad ni impuestos
UPDATE clientes
SET responsabilidad_contabilidad = false,
    responsabilidad_impuestos = false
WHERE nombre = 'Mab Arquitectura';


-- ─────────────────────────────────────────────────────────────
-- 3. MARCAR perfiles_clientes como deprecada (si existe)
-- ─────────────────────────────────────────────────────────────

-- Agregar comentario a la tabla para que quede claro que está deprecada
COMMENT ON TABLE perfiles_clientes IS 'DEPRECADA — abril 2026. Reemplazada por tabla clientes. No usar.';


COMMIT;

-- ============================================================
-- VERIFICACIÓN después de correr:
--
-- 1. Verificar monto_adm poblado (solo deben ser 50, 100 o 200):
--    SELECT nombre, monto_adm FROM clientes
--    WHERE activo = true ORDER BY nombre;
--
-- 2. Verificar flags corregidos:
--    SELECT nombre, responsabilidad_contabilidad, responsabilidad_impuestos,
--           contadora_contabilidad, contadora_impuestos
--    FROM clientes
--    WHERE nombre IN ('Kaizen','Centro Adorartes','CLC','Vitalie',
--                     'Fleximoney','Mab Arquitectura')
--    ORDER BY nombre;
--
-- Esperado:
--   Kaizen:           T, F, Victoria, Victoria
--   Centro Adorartes: T, F, NULL, NULL
--   CLC:              F, T, NULL, Karina
--   Vitalie:          F, T, NULL, Karina
--   Fleximoney:       F, T, NULL, Karina
--   Mab Arquitectura: F, F, Milka, NULL
--
-- 3. Confirmar que perfiles_clientes tiene el comentario:
--    SELECT obj_description('perfiles_clientes'::regclass);
-- ============================================================

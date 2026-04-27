-- ============================================================
-- Poblar fecha_entrada y fecha_salida en clientes existentes
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
--
-- Datos extraídos de meses_resumen (ene-abr 2026).
-- Clientes sin fecha_entrada se asumen pre-existentes
-- (activos desde antes de enero 2026).
-- ============================================================

-- ── ENERO 2026: Nuevos ──
UPDATE clientes SET fecha_entrada = '2026-01-01'
WHERE nombre IN ('La Fragaria', 'Polux') AND fecha_entrada IS NULL;

-- ── ENERO 2026: Churn ──
UPDATE clientes SET fecha_salida = '2026-01-31', activo = false
WHERE nombre IN ('Bonan', 'Grupo Lisman', 'Nomad') AND fecha_salida IS NULL;

-- ── FEBRERO 2026: Nuevos ──
UPDATE clientes SET fecha_entrada = '2026-02-01'
WHERE nombre IN ('Dr. Maurice Morel', 'Louis Maurice Morel') AND fecha_entrada IS NULL;

-- ── MARZO 2026: Nuevos ──
UPDATE clientes SET fecha_entrada = '2026-03-01'
WHERE nombre IN ('Oleica', 'Tic Tag') AND fecha_entrada IS NULL;

-- ── ABRIL 2026: Nuevos ──
UPDATE clientes SET fecha_entrada = '2026-04-01'
WHERE nombre IN ('Dior Legal', 'Igsan', 'Centro Adorartes') AND fecha_entrada IS NULL;

-- ── ABRIL 2026: Churn ──
UPDATE clientes SET fecha_salida = '2026-04-30', activo = false
WHERE nombre IN ('Tricargo', 'Audiobap') AND fecha_salida IS NULL;

-- ============================================================
-- VERIFICACIÓN:
--   SELECT nombre, fecha_entrada, fecha_salida, activo
--   FROM clientes
--   WHERE fecha_entrada IS NOT NULL OR fecha_salida IS NOT NULL
--   ORDER BY COALESCE(fecha_entrada, fecha_salida);
-- ============================================================

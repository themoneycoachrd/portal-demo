-- ============================================================
-- COLUMNA: categoria en tabla leads
-- Para clasificar leads como Implementacion, FE, Recurrente.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

ALTER TABLE leads ADD COLUMN IF NOT EXISTS categoria TEXT DEFAULT '';

-- VERIFICACION:
-- SELECT id, nombre, categoria FROM leads LIMIT 5;

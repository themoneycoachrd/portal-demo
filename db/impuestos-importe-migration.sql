-- ============================================================
-- MIGRACIÓN: Agregar campo importe a impuestos_checklist
-- Ejecutar en SQL Editor de Supabase (un solo Run).
-- ============================================================

-- Campo numérico para el monto/importe de cada impuesto por cliente
ALTER TABLE impuestos_checklist
ADD COLUMN IF NOT EXISTS importe NUMERIC(12,2) DEFAULT 0;

-- ============================================================
-- VERIFICACIÓN:
-- SELECT cliente, mes, anio, impuesto, importe FROM impuestos_checklist LIMIT 10;
-- ============================================================

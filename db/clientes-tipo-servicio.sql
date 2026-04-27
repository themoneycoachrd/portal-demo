-- ============================================================
-- Agregar tipo_servicio y fecha_salida a tabla clientes
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
--
-- tipo_servicio: define qué servicio le damos al cliente.
--   Valores: 'Contabilidad completa', 'Solo impuestos', 'Solo supervisión'
--
-- fecha_salida: cuándo dejó de ser cliente activo.
--   Solo aplica cuando activo = false.
-- ============================================================

-- Nueva columna: tipo de servicio contratado
ALTER TABLE clientes ADD COLUMN tipo_servicio TEXT
  CHECK (tipo_servicio IN ('Contabilidad completa', 'Solo impuestos', 'Solo supervisión'));

COMMENT ON COLUMN clientes.tipo_servicio IS
  'Tipo de servicio contratado. Define qué hacemos por este cliente: contabilidad completa, solo impuestos, o solo supervisión.';

-- Nueva columna: fecha de salida (para clientes inactivos)
ALTER TABLE clientes ADD COLUMN fecha_salida DATE;

COMMENT ON COLUMN clientes.fecha_salida IS
  'Fecha en que el cliente dejó de estar activo. Solo relevante cuando activo = false.';

-- ============================================================
-- VERIFICACIÓN:
--   SELECT nombre, tipo_servicio, fecha_salida, activo
--   FROM clientes ORDER BY nombre;
-- ============================================================

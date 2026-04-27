-- ============================================================
-- FASE C: Redefinir rol de la tabla asignaciones
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
--
-- A partir de ahora, la tabla asignaciones deja de ser la fuente
-- del universo de clientes. Pasa a ser registro de excepciones
-- mensuales (vacaciones, licencia, monto distinto a contrato).
--
-- Lógica de los módulos (Sub-fase D):
--   1. Leer clientes de la tabla maestra "clientes"
--   2. Para contadora y monto de un mes: buscar primero en
--      "asignaciones". Si no hay registro, usar valores de "clientes".
--
-- Los datos históricos (enero-abril 2026) se conservan como referencia.
-- ============================================================

-- Documentar el nuevo rol de la tabla
COMMENT ON TABLE asignaciones IS
  'Excepciones mensuales. La fuente principal de clientes, contadoras y montos '
  'es la tabla "clientes". Solo crear registro aquí si un mes específico difiere '
  'del valor default de la maestra (ej: contadora temporal por vacaciones, '
  'monto distinto por ajuste puntual). Datos de enero-abril 2026 son históricos '
  'del modelo anterior.';

-- Documentar columnas para claridad
COMMENT ON COLUMN asignaciones.contadora IS 'Contadora para este mes específico. Si NULL o no hay fila, usar clientes.contadora_contabilidad';
COMMENT ON COLUMN asignaciones.adm IS 'Transacciones digitadas en este mes (dato real, no contrato). El contrato vive en clientes.monto_adm';
COMMENT ON COLUMN asignaciones.serv IS 'Servicio contratado para este mes. Si no hay fila, usar clientes.monto_adm';

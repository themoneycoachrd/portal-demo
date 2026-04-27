-- ============================================================
-- FASE A: Consolidación de la base de datos de clientes
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
--
-- Cambios:
--   1. Agregar columnas nuevas a la tabla clientes
--   2. Migrar datos de la columna "contadora" a las nuevas columnas
--   3. Eliminar la columna "contadora" vieja
--   4. Crear tabla de historial de cambios de contadora
--   5. Crear trigger automático para registrar cambios
--   6. Políticas RLS para la tabla nueva
--
-- IMPORTANTE: hacer backup antes de correr.
--   SELECT * FROM clientes;  -- copiar resultado por si acaso
-- ============================================================

BEGIN;

-- ─────────────────────────────────────────────────────────────
-- 1. NUEVAS COLUMNAS en tabla clientes
-- ─────────────────────────────────────────────────────────────

-- Responsabilidades: qué servicios le damos a este cliente
ALTER TABLE clientes ADD COLUMN responsabilidad_contabilidad BOOLEAN DEFAULT true;
ALTER TABLE clientes ADD COLUMN responsabilidad_impuestos BOOLEAN DEFAULT true;

-- Contadoras separadas por área
ALTER TABLE clientes ADD COLUMN contadora_contabilidad TEXT;
ALTER TABLE clientes ADD COLUMN contadora_impuestos TEXT;

-- Cantidad de transacciones contratadas en Adm Cloud
ALTER TABLE clientes ADD COLUMN monto_adm INT;


-- ─────────────────────────────────────────────────────────────
-- 2. MIGRAR datos de la columna vieja "contadora"
-- ─────────────────────────────────────────────────────────────

-- Copiar el valor actual a ambas columnas de contadora.
-- Después Félix ajustará manualmente los que difieran.
UPDATE clientes
SET contadora_contabilidad = contadora,
    contadora_impuestos    = contadora
WHERE contadora IS NOT NULL;

-- Karina solo hace facturación electrónica, no contabilidad ni impuestos regulares.
-- Limpiar sus asignaciones de contadora (queda como responsabilidad aparte).
UPDATE clientes
SET contadora_contabilidad = NULL,
    contadora_impuestos    = NULL,
    responsabilidad_contabilidad = false,
    responsabilidad_impuestos    = false
WHERE contadora = 'Karina';

-- Milka es freelance, solo lleva contabilidad de su cliente.
-- No lleva impuestos.
UPDATE clientes
SET responsabilidad_impuestos = false,
    contadora_impuestos = NULL
WHERE contadora = 'Milka';


-- ─────────────────────────────────────────────────────────────
-- 3. ELIMINAR columna vieja
-- ─────────────────────────────────────────────────────────────

ALTER TABLE clientes DROP COLUMN contadora;


-- ─────────────────────────────────────────────────────────────
-- 4. TABLA DE HISTORIAL de cambios de contadora
-- ─────────────────────────────────────────────────────────────

CREATE TABLE clientes_cambios_contadora (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
  area TEXT NOT NULL CHECK (area IN ('contabilidad', 'impuestos')),
  contadora_anterior TEXT,          -- NULL si es asignación nueva
  contadora_nueva TEXT,             -- NULL si se desasigna
  motivo TEXT,                      -- opcional, para llenar desde el portal
  fecha TIMESTAMPTZ DEFAULT now(),
  registrado_por UUID DEFAULT auth.uid()
);

ALTER TABLE clientes_cambios_contadora ENABLE ROW LEVEL SECURITY;

-- Cualquier usuario autenticado puede leer el historial
CREATE POLICY "Auth: leer cambios contadora"
  ON clientes_cambios_contadora FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Solo admin puede insertar/editar/borrar
CREATE POLICY "Auth: admin gestiona cambios contadora"
  ON clientes_cambios_contadora FOR ALL
  USING (get_my_role() = 'admin');

-- El trigger necesita poder insertar sin pasar por RLS
-- (se ejecuta como SECURITY DEFINER, así que esto es para inserts manuales)
CREATE POLICY "Auth: trigger inserta cambios"
  ON clientes_cambios_contadora FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);


-- ─────────────────────────────────────────────────────────────
-- 5. TRIGGER automático para registrar cambios de contadora
-- ─────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION log_cambio_contadora()
RETURNS TRIGGER AS $$
BEGIN
  -- Detectar cambio en contadora_contabilidad
  IF OLD.contadora_contabilidad IS DISTINCT FROM NEW.contadora_contabilidad THEN
    INSERT INTO clientes_cambios_contadora
      (cliente_id, area, contadora_anterior, contadora_nueva)
    VALUES
      (NEW.id, 'contabilidad', OLD.contadora_contabilidad, NEW.contadora_contabilidad);
  END IF;

  -- Detectar cambio en contadora_impuestos
  IF OLD.contadora_impuestos IS DISTINCT FROM NEW.contadora_impuestos THEN
    INSERT INTO clientes_cambios_contadora
      (cliente_id, area, contadora_anterior, contadora_nueva)
    VALUES
      (NEW.id, 'impuestos', OLD.contadora_impuestos, NEW.contadora_impuestos);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_log_cambio_contadora
  AFTER UPDATE ON clientes
  FOR EACH ROW
  EXECUTE FUNCTION log_cambio_contadora();


COMMIT;

-- ============================================================
-- VERIFICACIÓN después de correr:
--
-- 1. Ver columnas nuevas:
--    SELECT nombre, responsabilidad_contabilidad, responsabilidad_impuestos,
--           contadora_contabilidad, contadora_impuestos, monto_adm
--    FROM clientes ORDER BY nombre;
--
-- 2. Verificar que la columna vieja "contadora" ya no existe:
--    SELECT contadora FROM clientes;  -- debe dar error
--
-- 3. Probar el trigger (cambiar contadora de un cliente y ver el log):
--    UPDATE clientes SET contadora_contabilidad = 'Victoria'
--    WHERE nombre = 'Blackbox';
--
--    SELECT * FROM clientes_cambios_contadora;
--    -- Debe mostrar: Blackbox, contabilidad, Taina → Victoria
--
--    -- REVERTIR el cambio de prueba:
--    UPDATE clientes SET contadora_contabilidad = 'Taina'
--    WHERE nombre = 'Blackbox';
-- ============================================================

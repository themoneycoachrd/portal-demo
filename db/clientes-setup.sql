-- ============================================================
-- TABLA CLIENTES (directorio maestro) — Account One
-- Registro central de todos los clientes de la firma.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

CREATE TABLE clientes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  rnc TEXT,                          -- RNC del cliente
  contacto TEXT,                     -- nombre del contacto principal
  email TEXT,
  telefono TEXT,
  contadora TEXT,                    -- contadora asignada (nombre)
  fecha_entrada DATE,                -- cuando entro a la firma
  inicio_responsabilidad_fiscal DATE, -- primer mes que la firma asume
  activo BOOLEAN DEFAULT true,
  notas TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Trigger updated_at
CREATE OR REPLACE FUNCTION update_clientes_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER clientes_updated
  BEFORE UPDATE ON clientes
  FOR EACH ROW EXECUTE FUNCTION update_clientes_timestamp();

-- ─── RLS ───
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;

-- Admin puede todo
CREATE POLICY "Auth: admin clientes" ON clientes
  FOR ALL USING (get_my_role() = 'admin');

-- Cualquier usuario autenticado puede leer
CREATE POLICY "Auth: lectura clientes" ON clientes
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- ============================================================
-- VERIFICACION:
-- SELECT * FROM clientes;
-- ============================================================

-- ============================================================
-- TABLA: checklist_contadores
-- Almacena el checklist mensual por contadora/cliente/mes.
-- El campo "datos" es JSONB con esta estructura:
-- {
--   "solicitud_nomina": { "done": true, "fecha": "2026-03-24" },
--   "recepcion_nomina": { "done": false, "fecha": "" },
--   ...
-- }
-- Cada key es el ID del item del checklist.
--
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

-- 1. Crear la tabla
CREATE TABLE IF NOT EXISTS checklist_contadores (
  id BIGSERIAL PRIMARY KEY,
  contadora TEXT NOT NULL,
  cliente TEXT NOT NULL,
  mes TEXT NOT NULL,
  anio INTEGER NOT NULL DEFAULT 2026,
  datos JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(contadora, cliente, mes, anio)
);

-- 2. RLS
ALTER TABLE checklist_contadores ENABLE ROW LEVEL SECURITY;

-- Todos los autenticados pueden leer
CREATE POLICY "Auth: leer checklist" ON checklist_contadores
  FOR SELECT USING (auth.role() = 'authenticated');

-- Admin puede hacer todo
CREATE POLICY "Auth: admin checklist" ON checklist_contadores
  FOR ALL USING (get_my_role() = 'admin');

-- Contadora puede insertar sus propios datos
CREATE POLICY "Auth: contadora inserta checklist" ON checklist_contadores
  FOR INSERT WITH CHECK (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- Contadora puede actualizar sus propios datos
CREATE POLICY "Auth: contadora edita checklist" ON checklist_contadores
  FOR UPDATE USING (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- 3. Trigger para updated_at
CREATE OR REPLACE FUNCTION update_checklist_contadores_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_checklist_contadores_updated
  BEFORE UPDATE ON checklist_contadores
  FOR EACH ROW EXECUTE FUNCTION update_checklist_contadores_timestamp();

-- ============================================================
-- VERIFICACION: Despues de correr esto, verifica con:
-- SELECT * FROM checklist_contadores LIMIT 5;
-- SELECT policyname, cmd FROM pg_policies WHERE tablename = 'checklist_contadores';
-- ============================================================

-- ============================================================
-- TABLA: kpi_detalle
-- Almacena los datos granulares del KPI por contadora/mes.
-- El campo "datos" es JSONB con esta estructura:
-- {
--   "digitacion": { "NombreCliente": [sem1, sem2, sem3, sem4, sem5], ... },
--   "resumenes":  { "NombreCliente": { "done": bool, "fecha": "", "foto": bool }, ... },
--   "video":      { "NombreCliente": { "done": bool, "fecha": "", "link": "" }, ... }
-- }
--
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

-- 1. Crear la tabla
CREATE TABLE IF NOT EXISTS kpi_detalle (
  id BIGSERIAL PRIMARY KEY,
  contadora TEXT NOT NULL,
  mes TEXT NOT NULL,
  anio INTEGER NOT NULL DEFAULT 2026,
  datos JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(contadora, mes, anio)
);

-- 2. RLS
ALTER TABLE kpi_detalle ENABLE ROW LEVEL SECURITY;

-- Todos los autenticados pueden leer (para que admin vea todo)
CREATE POLICY "Auth: leer kpi_detalle" ON kpi_detalle
  FOR SELECT USING (auth.role() = 'authenticated');

-- Admin puede hacer todo
CREATE POLICY "Auth: admin kpi_detalle" ON kpi_detalle
  FOR ALL USING (get_my_role() = 'admin');

-- Contadora puede insertar sus propios datos
CREATE POLICY "Auth: contadora inserta kpi_detalle" ON kpi_detalle
  FOR INSERT WITH CHECK (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- Contadora puede actualizar sus propios datos
CREATE POLICY "Auth: contadora edita kpi_detalle" ON kpi_detalle
  FOR UPDATE USING (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- 3. Trigger para updated_at
CREATE OR REPLACE FUNCTION update_kpi_detalle_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_kpi_detalle_updated
  BEFORE UPDATE ON kpi_detalle
  FOR EACH ROW EXECUTE FUNCTION update_kpi_detalle_timestamp();

-- ============================================================
-- VERIFICACIÓN: Después de correr esto, verifica con:
-- SELECT * FROM kpi_detalle LIMIT 5;
-- SELECT policyname, cmd FROM pg_policies WHERE tablename = 'kpi_detalle';
-- ============================================================

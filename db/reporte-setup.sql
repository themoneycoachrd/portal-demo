-- ============================================================
-- TABLA REPORTE MENSUAL — Account One
-- Cada contadora llena una fila por cliente por mes.
-- La gerencia consume el reporte con semaforos.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

-- Borrar tabla vieja de checklist si existe (no se usa mas)
-- DROP TABLE IF EXISTS checklist_mensual;

CREATE TABLE reporte_mensual (
  id BIGSERIAL PRIMARY KEY,
  contadora TEXT NOT NULL,
  cliente TEXT NOT NULL,
  mes TEXT NOT NULL,
  anio INTEGER NOT NULL DEFAULT 2026,

  -- Facturas
  facturas_mes INTEGER DEFAULT 0,

  -- Presupuesto y ejecucion
  presupuesto_fecha DATE,
  presupuesto_link TEXT DEFAULT '',

  -- Proyeccion de impuestos
  proyeccion_fecha DATE,
  proyeccion_link TEXT DEFAULT '',

  -- Resumen de declaracion mensual
  resumen_fecha DATE,
  resumen_link TEXT DEFAULT '',

  -- Video mensual
  video_fecha DATE,
  video_link TEXT DEFAULT '',

  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(contadora, cliente, mes, anio)
);

ALTER TABLE reporte_mensual ENABLE ROW LEVEL SECURITY;

-- Admin puede leer y editar todo
CREATE POLICY "Auth: admin reporte" ON reporte_mensual
  FOR ALL USING (get_my_role() = 'admin');

-- Contadoras pueden leer solo sus registros
CREATE POLICY "Auth: contadora lee reporte" ON reporte_mensual
  FOR SELECT USING (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- Contadoras pueden insertar sus propios registros
CREATE POLICY "Auth: contadora inserta reporte" ON reporte_mensual
  FOR INSERT WITH CHECK (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- Contadoras pueden actualizar sus propios registros
CREATE POLICY "Auth: contadora actualiza reporte" ON reporte_mensual
  FOR UPDATE USING (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION update_reporte_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER reporte_updated
  BEFORE UPDATE ON reporte_mensual
  FOR EACH ROW EXECUTE FUNCTION update_reporte_timestamp();

-- ============================================================
-- VERIFICACION:
-- SELECT tablename FROM pg_tables WHERE tablename = 'reporte_mensual';
-- SELECT policyname, cmd FROM pg_policies WHERE tablename = 'reporte_mensual';
-- ============================================================

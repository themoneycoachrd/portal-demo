-- ============================================================
-- TABLA CHECKLIST MENSUAL — Account One
-- Almacena el progreso del cierre mensual por cliente.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

CREATE TABLE checklist_mensual (
  id BIGSERIAL PRIMARY KEY,
  cliente TEXT NOT NULL,
  mes TEXT NOT NULL,
  anio INTEGER NOT NULL DEFAULT 2026,
  data JSONB DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(cliente, mes, anio)
);

ALTER TABLE checklist_mensual ENABLE ROW LEVEL SECURITY;

-- Admin puede leer y editar todo
CREATE POLICY "Auth: admin checklist" ON checklist_mensual
  FOR ALL USING (get_my_role() = 'admin');

-- Contadoras pueden leer y editar checklist de sus clientes asignados
CREATE POLICY "Auth: contadora lee checklist" ON checklist_mensual
  FOR SELECT USING (
    get_my_role() = 'contadora'
    AND cliente IN (
      SELECT DISTINCT a.cliente FROM asignaciones a
      WHERE a.contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
    )
  );

CREATE POLICY "Auth: contadora edita checklist" ON checklist_mensual
  FOR INSERT WITH CHECK (
    get_my_role() = 'contadora'
    AND cliente IN (
      SELECT DISTINCT a.cliente FROM asignaciones a
      WHERE a.contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
    )
  );

CREATE POLICY "Auth: contadora actualiza checklist" ON checklist_mensual
  FOR UPDATE USING (
    get_my_role() = 'contadora'
    AND cliente IN (
      SELECT DISTINCT a.cliente FROM asignaciones a
      WHERE a.contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
    )
  );

-- Trigger para actualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_checklist_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER checklist_updated
  BEFORE UPDATE ON checklist_mensual
  FOR EACH ROW EXECUTE FUNCTION update_checklist_timestamp();

-- ============================================================
-- VERIFICACION: Despues de correr esto, verifica con:
-- SELECT tablename FROM pg_tables WHERE tablename = 'checklist_mensual';
-- SELECT policyname, cmd FROM pg_policies WHERE tablename = 'checklist_mensual';
-- ============================================================

-- ============================================================
-- TABLAS IMPLEMENTACIONES — Account One
-- Dos tablas: implementaciones completas y facturación electrónica.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

-- ─── Tabla 1: Implementaciones Completas ───
CREATE TABLE implementaciones_completas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente TEXT NOT NULL,
  contadora TEXT,
  fecha_inicio DATE,
  fecha_fin DATE,
  primer_mes_responsabilidad DATE,
  estatus TEXT CHECK (estatus IN (
    'Kick-off','Sesión 2','Sesión 3','Sesión 4','Sesión 5','Go Live'
  )),
  notas TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Tabla 2: Facturación Electrónica ───
CREATE TABLE implementaciones_fe (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente TEXT NOT NULL,
  contadora TEXT,
  fecha_go_live_estimada DATE,
  estatus TEXT CHECK (estatus IN (
    'Correo de requisitos iniciales',
    'Portal de creación de firma virtual personal',
    'Delegación de firma virtual personal',
    'Configuración en Adm Cloud',
    'Go Live'
  )),
  notas TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Triggers updated_at ───
CREATE OR REPLACE FUNCTION update_impl_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER impl_completas_updated
  BEFORE UPDATE ON implementaciones_completas
  FOR EACH ROW EXECUTE FUNCTION update_impl_timestamp();

CREATE TRIGGER impl_fe_updated
  BEFORE UPDATE ON implementaciones_fe
  FOR EACH ROW EXECUTE FUNCTION update_impl_timestamp();

-- ─── RLS ───
ALTER TABLE implementaciones_completas ENABLE ROW LEVEL SECURITY;
ALTER TABLE implementaciones_fe ENABLE ROW LEVEL SECURITY;

-- Admin puede todo
CREATE POLICY "Auth: admin impl_completas" ON implementaciones_completas
  FOR ALL USING (get_my_role() = 'admin');

CREATE POLICY "Auth: admin impl_fe" ON implementaciones_fe
  FOR ALL USING (get_my_role() = 'admin');

-- Lectura: cualquier usuario autenticado
CREATE POLICY "Auth: lectura impl_completas" ON implementaciones_completas
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Auth: lectura impl_fe" ON implementaciones_fe
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- Escritura (insert/update/delete): solo grupo Implementaciones
CREATE POLICY "Auth: impl escribe impl_completas" ON implementaciones_completas
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'implementaciones'->>'adicion')::boolean = true
    )
  );

CREATE POLICY "Auth: impl edita impl_completas" ON implementaciones_completas
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'implementaciones'->>'edicion')::boolean = true
    )
  );

CREATE POLICY "Auth: impl borra impl_completas" ON implementaciones_completas
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'implementaciones'->>'eliminar')::boolean = true
    )
  );

CREATE POLICY "Auth: impl escribe impl_fe" ON implementaciones_fe
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'implementaciones'->>'adicion')::boolean = true
    )
  );

CREATE POLICY "Auth: impl edita impl_fe" ON implementaciones_fe
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'implementaciones'->>'edicion')::boolean = true
    )
  );

CREATE POLICY "Auth: impl borra impl_fe" ON implementaciones_fe
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'implementaciones'->>'eliminar')::boolean = true
    )
  );

-- ─── Grupo Implementaciones ───
INSERT INTO grupos (nombre, permisos) VALUES
(
  'Implementaciones',
  '{
    "control-clientes":   {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "control-contadoras": {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "comercial":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "checklist":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "kpi":                {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "impuestos":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "implementaciones":   {"consulta":true,"adicion":true,"edicion":true,"anulacion":false,"eliminar":false},
    "portal-clientes":    {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "usuarios":           {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false}
  }'::jsonb
);

-- ============================================================
-- VERIFICACION:
-- SELECT * FROM implementaciones_completas;
-- SELECT * FROM implementaciones_fe;
-- SELECT * FROM grupos WHERE nombre = 'Implementaciones';
-- ============================================================

-- ============================================================
-- PERMISOS POR GRUPO — Account One
-- Grupos con matriz pantalla x habilidad.
-- Usuarios pueden pertenecer a varios grupos.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

-- Si corriste la version anterior (permisos planos), borrala:
-- DROP TABLE IF EXISTS permisos;

-- ─── Tabla de grupos ───
CREATE TABLE grupos (
  id BIGSERIAL PRIMARY KEY,
  nombre TEXT NOT NULL UNIQUE,
  permisos JSONB DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Tabla de asignacion usuario → grupo (muchos a muchos) ───
CREATE TABLE usuario_grupos (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  grupo_id BIGINT NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  UNIQUE(user_id, grupo_id)
);

-- ─── RLS ───
ALTER TABLE grupos ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuario_grupos ENABLE ROW LEVEL SECURITY;

-- Solo admin puede gestionar grupos
CREATE POLICY "Auth: admin grupos" ON grupos
  FOR ALL USING (get_my_role() = 'admin');

-- Solo admin puede gestionar asignaciones
CREATE POLICY "Auth: admin usuario_grupos" ON usuario_grupos
  FOR ALL USING (get_my_role() = 'admin');

-- Cada usuario puede ver sus propios grupos (para validar acceso)
CREATE POLICY "Auth: usuario ve sus grupos" ON usuario_grupos
  FOR SELECT USING (auth.uid() = user_id);

-- Cada usuario puede leer los grupos a los que pertenece
CREATE POLICY "Auth: usuario lee grupo" ON grupos
  FOR SELECT USING (
    id IN (SELECT grupo_id FROM usuario_grupos WHERE user_id = auth.uid())
  );

-- ─── Trigger ───
CREATE OR REPLACE FUNCTION update_grupos_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER grupos_updated
  BEFORE UPDATE ON grupos
  FOR EACH ROW EXECUTE FUNCTION update_grupos_timestamp();

-- ─── Grupos iniciales ───
INSERT INTO grupos (nombre, permisos) VALUES
(
  'Admin',
  '{
    "control-clientes":   {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "control-contadoras": {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "comercial":          {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "checklist":          {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "kpi":                {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "impuestos":          {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "implementaciones":   {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "portal-clientes":    {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true},
    "usuarios":           {"consulta":true,"adicion":true,"edicion":true,"anulacion":true,"eliminar":true}
  }'::jsonb
),
(
  'Contadora',
  '{
    "control-clientes":   {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "control-contadoras": {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "comercial":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "checklist":          {"consulta":true,"adicion":true,"edicion":true,"anulacion":false,"eliminar":false},
    "kpi":                {"consulta":true,"adicion":true,"edicion":false,"anulacion":false,"eliminar":false},
    "impuestos":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "implementaciones":   {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "portal-clientes":    {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "usuarios":           {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false}
  }'::jsonb
),
(
  'Ventas',
  '{
    "control-clientes":   {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "control-contadoras": {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "comercial":          {"consulta":true,"adicion":true,"edicion":true,"anulacion":false,"eliminar":false},
    "checklist":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "kpi":                {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "impuestos":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "implementaciones":   {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "portal-clientes":    {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "usuarios":           {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false}
  }'::jsonb
);

-- ============================================================
-- VERIFICACION:
-- SELECT * FROM grupos;
-- SELECT * FROM usuario_grupos;
-- ============================================================

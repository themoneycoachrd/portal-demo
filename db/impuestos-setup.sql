-- ============================================================
-- TABLA IMPUESTOS CHECKLIST — Account One
-- Almacena el checklist de impuestos por cliente/mes/tipo.
-- Cada fila = un cliente + un mes + un tipo de impuesto.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

CREATE TABLE impuestos_checklist (
  id BIGSERIAL PRIMARY KEY,
  contadora TEXT NOT NULL,
  cliente TEXT NOT NULL,
  mes TEXT NOT NULL,        -- 'enero', 'febrero', etc.
  anio INTEGER NOT NULL DEFAULT 2026,
  impuesto TEXT NOT NULL,   -- 'TSS', 'IR-3', 'IR-17', 'Anticipo', 'ITBIS'
  datos JSONB DEFAULT '{}', -- items del checklist con {done, fecha}
  en_atraso BOOLEAN DEFAULT false,  -- flag manual para marcar problemas
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(cliente, mes, anio, impuesto)
);

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION update_impuestos_checklist_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER impuestos_checklist_updated
  BEFORE UPDATE ON impuestos_checklist
  FOR EACH ROW EXECUTE FUNCTION update_impuestos_checklist_timestamp();

-- ─── RLS ───
ALTER TABLE impuestos_checklist ENABLE ROW LEVEL SECURITY;

-- Admin puede todo
CREATE POLICY "Auth: admin impuestos" ON impuestos_checklist
  FOR ALL USING (get_my_role() = 'admin');

-- Usuarios con permiso de impuestos pueden leer todo
CREATE POLICY "Auth: impuestos lee" ON impuestos_checklist
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'impuestos'->>'consulta')::boolean = true
    )
  );

-- Usuarios con permiso de impuestos pueden insertar
CREATE POLICY "Auth: impuestos inserta" ON impuestos_checklist
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'impuestos'->>'adicion')::boolean = true
    )
  );

-- Usuarios con permiso de impuestos pueden editar
CREATE POLICY "Auth: impuestos edita" ON impuestos_checklist
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM usuario_grupos ug
      JOIN grupos g ON g.id = ug.grupo_id
      WHERE ug.user_id = auth.uid()
      AND (g.permisos->'impuestos'->>'edicion')::boolean = true
    )
  );

-- ============================================================
-- GRUPO DE IMPUESTOS
-- Ejecutar despues de tener la tabla grupos creada.
-- ============================================================

INSERT INTO grupos (nombre, permisos) VALUES
(
  'Impuestos',
  '{
    "control-clientes":   {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "control-contadoras": {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "comercial":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "checklist":          {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "kpi":                {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "impuestos":          {"consulta":true,"adicion":true,"edicion":true,"anulacion":false,"eliminar":false},
    "implementaciones":   {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "portal-clientes":    {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false},
    "usuarios":           {"consulta":false,"adicion":false,"edicion":false,"anulacion":false,"eliminar":false}
  }'::jsonb
);

-- ============================================================
-- FORMATO DEL JSONB "datos":
--
-- Para TSS:
-- {"presentada_contadora":{"done":false,"fecha":null},"aprobada_impuestos":{"done":false,"fecha":null},"aprobado_cliente":{"done":false,"fecha":null},"pagado":{"done":false,"fecha":null}}
--
-- Para IR-3:
-- {"presentada_contadora":{"done":false,"fecha":null},"aprobada_impuestos":{"done":false,"fecha":null},"aprobado_cliente":{"done":false,"fecha":null},"pagado":{"done":false,"fecha":null}}
--
-- Para IR-17:
-- {"borrador_presentado":{"done":false,"fecha":null},"aprobada_impuestos":{"done":false,"fecha":null},"aprobado_cliente":{"done":false,"fecha":null},"pagado":{"done":false,"fecha":null}}
--
-- Para Anticipo:
-- {"autorizacion_enviada":{"done":false,"fecha":null},"anticipo_pagado":{"done":false,"fecha":null}}
--
-- Para ITBIS:
-- {"pago_a_cuenta":{"done":false,"fecha":null,"valor":""},"borrador_presentado":{"done":false,"fecha":null},"aprobada_impuestos":{"done":false,"fecha":null},"aprobado_cliente":{"done":false,"fecha":null},"pagado":{"done":false,"fecha":null}}
--
-- "pago_a_cuenta" usa "valor" en vez de simple done: puede ser "si" o "n/a"
-- ============================================================

-- VERIFICACION:
-- SELECT * FROM impuestos_checklist;
-- SELECT * FROM grupos WHERE nombre = 'Impuestos';

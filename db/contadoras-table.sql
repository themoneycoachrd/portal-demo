-- ============================================================
-- TABLA: contadoras — Directorio maestro de contadoras
-- Ejecutar en el SQL Editor de Supabase
-- ============================================================

CREATE TABLE contadoras (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre TEXT NOT NULL UNIQUE,
  tipo TEXT NOT NULL DEFAULT 'plena',
    -- 'plena' = contabilidad completa
    -- 'facturacion' = solo facturación electrónica
    -- 'freelance' = freelance externo
  activa BOOLEAN NOT NULL DEFAULT true,
  capacidad INT DEFAULT NULL,
    -- Capacidad mensual en horas/unidades (solo para contadoras con límite)
  notas TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE contadoras ENABLE ROW LEVEL SECURITY;

-- Todos los autenticados pueden leer
CREATE POLICY "Auth: leer contadoras"
  ON contadoras FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Solo admin puede insertar/editar/borrar
CREATE POLICY "Auth: admin gestiona contadoras"
  ON contadoras FOR ALL
  USING (get_my_role() = 'admin');

-- ============================================================
-- Datos iniciales (abril 2026)
-- ============================================================
INSERT INTO contadoras (nombre, tipo, activa, capacidad, notas) VALUES
('Taina',    'plena',       true,  500,  'Contadora principal'),
('Beliani',  'plena',       true,  1000, 'Inició entrenamiento marzo 2026'),
('Yessica',  'plena',       true,  1000, 'Inició entrenamiento marzo 2026'),
('Victoria', 'plena',       true,  NULL, ''),
('Karina',   'facturacion', true,  NULL, 'Solo maneja facturación electrónica'),
('Milka',    'freelance',   true,  NULL, 'Freelance, solo maneja Mab Arquitectura'),
('Yolenny',  'plena',       false, NULL, 'Salió en abril 2026');

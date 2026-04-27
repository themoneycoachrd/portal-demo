-- ============================================================
-- DATOS INICIALES: tabla clientes — abril 2026
-- Ejecutar en el SQL Editor de Supabase DESPUÉS de haber
-- creado la tabla (db/clientes-setup.sql).
--
-- 33 clientes activos extraídos del portal (contabilidad + impuestos).
-- Campos sin datos (RNC, contacto, email, teléfono, fechas) quedan
-- en NULL para completar después desde el portal.
-- ============================================================

-- Limpiar datos existentes si los hay (opcional, descomentar si necesario)
-- TRUNCATE clientes;

INSERT INTO clientes (nombre, contadora, activo, notas) VALUES

-- ─── Taina (5 clientes) ───
('Blackbox',             'Taina',    true, NULL),
('Impact',               'Taina',    true, NULL),
('La Fragaria',          'Taina',    true, NULL),
('MSH',                  'Taina',    true, NULL),
('PSC',                  'Taina',    true, NULL),

-- ─── Beliani (7 clientes) ───
('Iris Laura',           'Beliani',  true, NULL),
('La Charpente',         'Beliani',  true, NULL),
('Maria Raquel',         'Beliani',  true, NULL),
('Mv Creative',          'Beliani',  true, NULL),
('Oleica',               'Beliani',  true, NULL),
('Sosa Arquitectura',    'Beliani',  true, NULL),
('Suplident',            'Beliani',  true, NULL),
('Unfold',               'Beliani',  true, NULL),

-- ─── Victoria (6 clientes) ───
('Dr. Maurice Morel',    'Victoria', true, NULL),
('Gestaf',               'Victoria', true, NULL),
('Grupisa',              'Victoria', true, NULL),
('Kaizen',               'Victoria', true, NULL),
('Louis Maurice Morel',  'Victoria', true, NULL),
('Polux',                'Victoria', true, NULL),

-- ─── Yessica (6 clientes) ───
('Enlaces',              'Yessica',  true, NULL),
('Kalma',                'Yessica',  true, NULL),
('Mj Inversiones',       'Yessica',  true, NULL),
('RB Raquel Bencosme',   'Yessica',  true, NULL),
('SAV',                  'Yessica',  true, NULL),
('Tic Tag',              'Yessica',  true, NULL),

-- ─── Sin asignar (4 clientes — entraron en abril) ───
('Centro Adorartes',     NULL,       true, 'Entró en abril 2026, pendiente asignar contadora'),
('Dior Legal',           NULL,       true, 'Entró en abril 2026, pendiente asignar contadora'),
('Domingo Lizardi',      NULL,       true, 'Pendiente asignar contadora'),
('Igsan',                NULL,       true, 'Entró en abril 2026, pendiente asignar contadora'),

-- ─── Karina — solo facturación electrónica (3 clientes) ───
('CLC',                  'Karina',   true, 'Solo facturación electrónica'),
('Fleximoney',           'Karina',   true, 'Solo facturación electrónica'),
('Vitalie',              'Karina',   true, 'Solo facturación electrónica'),

-- ─── Milka — freelance (1 cliente) ───
('Mab Arquitectura',     'Milka',    true, 'Freelance — Milka maneja solo este cliente'),

-- ─── Clientes que salieron en abril 2026 ───
('Audiobap',             'Taina',    false, 'Salió en abril 2026'),
('Tricargo',             NULL,       false, 'Salió en abril 2026');

-- ============================================================
-- VERIFICACIÓN:
-- SELECT nombre, contadora, activo FROM clientes ORDER BY contadora, nombre;
-- Esperado: 33 activos + 2 inactivos = 35 registros
-- ============================================================

-- ============================================================
-- TABLAS DEL PORTAL DE CONTADORES — Account One
-- Ejecutar en el SQL Editor de Supabase (un solo Run)
-- ============================================================

-- ============================================================
-- 1. RESUMEN MENSUAL
-- ============================================================
CREATE TABLE meses_resumen (
  id SERIAL PRIMARY KEY,
  mes TEXT NOT NULL,
  anio INT NOT NULL DEFAULT 2026,
  total_clientes INT NOT NULL DEFAULT 0,
  nuevos TEXT[] DEFAULT '{}',
  churn TEXT[] DEFAULT '{}',
  serv_total NUMERIC DEFAULT 0,
  adm_total NUMERIC DEFAULT 0,
  notas TEXT DEFAULT '',
  UNIQUE(mes, anio)
);

ALTER TABLE meses_resumen ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Auth: leer meses" ON meses_resumen FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Auth: admin edita meses" ON meses_resumen FOR ALL USING (get_my_role() = 'admin');

INSERT INTO meses_resumen (mes, anio, total_clientes, nuevos, churn, serv_total, adm_total, notas) VALUES
('enero', 2026, 27, '{"La Fragaria","Polux"}', '{"Bonan","Grupo Lisman","Nomad"}', 1800, 1665, 'Domingo Lizardi entró pero sigue sin contar como cliente nuevo (pendiente implementación). Beliani y Yessica aún no tenían clientes (en entrenamiento).'),
('febrero', 2026, 29, '{"Dr. Maurice Morel","Louis Maurice Morel"}', '{}', 1900, 1765, 'Beliani y Yessica en entrenamiento, sin clientes asignados todavía.'),
('marzo', 2026, 31, '{"Oleica","Tic Tag"}', '{}', 2000, 1790, 'Último mes de Yolenny y Milka a tiempo completo. Beliani y Yessica empezaron entrenamiento en marzo, aún sin carga real. Oleica y Tic Tag entran sin asignar.'),
('abril', 2026, 30, '{"Dior Legal","Igsan","Centro Adorartes"}', '{"Tricargo","Audiobap"}', 2000, 1780, 'Rebalance: Yolenny salió, Milka pasa a freelance (solo Mab). Clientes redistribuidos entre Taina, Beliani y Yessica. Dior Legal, Igsan, Domingo Lizardi y Centro Adorartes pendientes de asignación.');

-- ============================================================
-- 2. ASIGNACIONES MENSUALES (contadora → cliente)
-- ============================================================
CREATE TABLE asignaciones (
  id SERIAL PRIMARY KEY,
  mes TEXT NOT NULL,
  anio INT NOT NULL DEFAULT 2026,
  contadora TEXT NOT NULL,
  cliente TEXT NOT NULL,
  serv NUMERIC DEFAULT 0,
  adm NUMERIC DEFAULT 0
);

ALTER TABLE asignaciones ENABLE ROW LEVEL SECURITY;
-- Contadoras ven solo sus asignaciones; admin ve todo
CREATE POLICY "Auth: leer asignaciones" ON asignaciones
  FOR SELECT USING (
    CASE get_my_role()
      WHEN 'admin' THEN true
      WHEN 'contadora' THEN contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
      ELSE false
    END
  );
CREATE POLICY "Auth: admin edita asignaciones" ON asignaciones FOR ALL USING (get_my_role() = 'admin');

-- ENERO 2026
INSERT INTO asignaciones (mes, anio, contadora, cliente, serv, adm) VALUES
('enero',2026,'Yolenny','Mv Creative',200,200),
('enero',2026,'Yolenny','PSC',100,80),
('enero',2026,'Yolenny','MSH',100,60),
('enero',2026,'Yolenny','La Fragaria',100,100),
('enero',2026,'Yolenny','Suplident',50,50),
('enero',2026,'Yolenny','La Charpente',100,60),
('enero',2026,'Yolenny','SAV',50,30),
('enero',2026,'Yolenny','Mj Inversiones',50,50),
('enero',2026,'Yolenny','Tricargo',100,130),
('enero',2026,'Milka','Blackbox',50,75),
('enero',2026,'Milka','Impact',50,30),
('enero',2026,'Milka','Sosa Arquitectura',50,35),
('enero',2026,'Milka','Mab Arquitectura',50,50),
('enero',2026,'Milka','Enlaces',50,15),
('enero',2026,'Taina','Iris Laura',50,30),
('enero',2026,'Taina','Maria Raquel',50,60),
('enero',2026,'Taina','RB Raquel Bencosme',100,150),
('enero',2026,'Taina','Kalma',50,30),
('enero',2026,'Taina','Audiobap',50,30),
('enero',2026,'Taina','Unfold',50,50),
('enero',2026,'Karina','CLC',50,50),
('enero',2026,'Karina','Vitalie',50,50),
('enero',2026,'Karina','Fleximoney',50,50),
('enero',2026,'Victoria','Gestaf',50,50),
('enero',2026,'Victoria','Grupisa',50,50),
('enero',2026,'Victoria','Kaizen',50,50),
('enero',2026,'Victoria','Polux',50,50),

-- FEBRERO 2026
('febrero',2026,'Yolenny','Mv Creative',200,200),
('febrero',2026,'Yolenny','PSC',100,80),
('febrero',2026,'Yolenny','MSH',100,60),
('febrero',2026,'Yolenny','La Fragaria',100,100),
('febrero',2026,'Yolenny','Suplident',50,50),
('febrero',2026,'Yolenny','La Charpente',100,60),
('febrero',2026,'Yolenny','SAV',50,30),
('febrero',2026,'Yolenny','Mj Inversiones',50,50),
('febrero',2026,'Yolenny','Tricargo',100,130),
('febrero',2026,'Milka','Blackbox',50,75),
('febrero',2026,'Milka','Impact',50,30),
('febrero',2026,'Milka','Sosa Arquitectura',50,35),
('febrero',2026,'Milka','Mab Arquitectura',50,50),
('febrero',2026,'Milka','Enlaces',50,15),
('febrero',2026,'Taina','Iris Laura',50,30),
('febrero',2026,'Taina','Maria Raquel',50,60),
('febrero',2026,'Taina','RB Raquel Bencosme',100,150),
('febrero',2026,'Taina','Kalma',50,30),
('febrero',2026,'Taina','Audiobap',50,30),
('febrero',2026,'Taina','Unfold',50,50),
('febrero',2026,'Karina','CLC',50,50),
('febrero',2026,'Karina','Vitalie',50,50),
('febrero',2026,'Karina','Fleximoney',50,50),
('febrero',2026,'Victoria','Gestaf',50,50),
('febrero',2026,'Victoria','Grupisa',50,50),
('febrero',2026,'Victoria','Kaizen',50,50),
('febrero',2026,'Victoria','Polux',50,50),
('febrero',2026,'Victoria','Dr. Maurice Morel',50,50),
('febrero',2026,'Victoria','Louis Maurice Morel',50,50),

-- MARZO 2026
('marzo',2026,'Yolenny','Mv Creative',200,200),
('marzo',2026,'Yolenny','PSC',100,80),
('marzo',2026,'Yolenny','MSH',100,60),
('marzo',2026,'Yolenny','La Fragaria',100,100),
('marzo',2026,'Yolenny','Suplident',50,50),
('marzo',2026,'Yolenny','La Charpente',100,60),
('marzo',2026,'Yolenny','SAV',50,30),
('marzo',2026,'Yolenny','Mj Inversiones',50,50),
('marzo',2026,'Yolenny','Tricargo',100,130),
('marzo',2026,'Milka','Blackbox',50,75),
('marzo',2026,'Milka','Impact',50,30),
('marzo',2026,'Milka','Sosa Arquitectura',50,35),
('marzo',2026,'Milka','Mab Arquitectura',50,50),
('marzo',2026,'Milka','Enlaces',50,15),
('marzo',2026,'Taina','Iris Laura',50,30),
('marzo',2026,'Taina','Maria Raquel',50,60),
('marzo',2026,'Taina','RB Raquel Bencosme',100,150),
('marzo',2026,'Taina','Kalma',50,30),
('marzo',2026,'Taina','Audiobap',50,30),
('marzo',2026,'Taina','Unfold',50,50),
('marzo',2026,'Karina','CLC',50,50),
('marzo',2026,'Karina','Vitalie',50,50),
('marzo',2026,'Karina','Fleximoney',50,50),
('marzo',2026,'Victoria','Gestaf',50,50),
('marzo',2026,'Victoria','Grupisa',50,50),
('marzo',2026,'Victoria','Kaizen',50,50),
('marzo',2026,'Victoria','Polux',50,50),
('marzo',2026,'Victoria','Dr. Maurice Morel',50,50),
('marzo',2026,'Victoria','Louis Maurice Morel',50,50),
('marzo',2026,'Sin asignar','Oleica',50,10),
('marzo',2026,'Sin asignar','Tic Tag',50,15),

-- ABRIL 2026
('abril',2026,'Taina','Blackbox',50,75),
('abril',2026,'Taina','Impact',50,30),
('abril',2026,'Taina','PSC',100,80),
('abril',2026,'Taina','MSH',100,60),
('abril',2026,'Taina','La Fragaria',100,100),
('abril',2026,'Beliani','Mv Creative',200,200),
('abril',2026,'Beliani','Iris Laura',50,30),
('abril',2026,'Beliani','Maria Raquel',50,60),
('abril',2026,'Beliani','Oleica',50,10),
('abril',2026,'Beliani','Sosa Arquitectura',50,35),
('abril',2026,'Beliani','Suplident',50,50),
('abril',2026,'Beliani','La Charpente',100,60),
('abril',2026,'Beliani','Unfold',50,50),
('abril',2026,'Yessica','Tic Tag',50,15),
('abril',2026,'Yessica','RB Raquel Bencosme',100,150),
('abril',2026,'Yessica','SAV',50,30),
('abril',2026,'Yessica','Enlaces',50,15),
('abril',2026,'Yessica','Kalma',50,30),
('abril',2026,'Yessica','Mj Inversiones',50,50),
('abril',2026,'Karina','CLC',50,50),
('abril',2026,'Karina','Vitalie',50,50),
('abril',2026,'Karina','Fleximoney',50,50),
('abril',2026,'Victoria','Gestaf',50,50),
('abril',2026,'Victoria','Grupisa',50,50),
('abril',2026,'Victoria','Kaizen',50,50),
('abril',2026,'Victoria','Polux',50,50),
('abril',2026,'Victoria','Dr. Maurice Morel',50,50),
('abril',2026,'Victoria','Louis Maurice Morel',50,50),
('abril',2026,'Milka (freelance)','Mab Arquitectura',50,50),
('abril',2026,'Sin asignar','Dior Legal',50,50),
('abril',2026,'Sin asignar','Igsan',50,50),
('abril',2026,'Sin asignar','Domingo Lizardi',50,50),
('abril',2026,'Sin asignar','Centro Adorartes',50,0);

-- ============================================================
-- 3. IMPLEMENTACIONES
-- ============================================================
CREATE TABLE implementaciones (
  id SERIAL PRIMARY KEY,
  cliente TEXT NOT NULL,
  tipo TEXT NOT NULL DEFAULT 'normal' CHECK (tipo IN ('normal', 'solo_impl', 'riesgo')),
  impl_inicio DATE,
  impl_fin DATE,
  primer_mes TEXT,
  contadora TEXT,
  notas TEXT DEFAULT ''
);

ALTER TABLE implementaciones ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Auth: leer impl" ON implementaciones FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Auth: admin edita impl" ON implementaciones FOR ALL USING (get_my_role() = 'admin');

INSERT INTO implementaciones (cliente, tipo, impl_inicio, impl_fin, primer_mes, contadora, notas) VALUES
('Dior Legal', 'normal', '2026-04-07', '2026-04-30', 'Mayo 2026', NULL, ''),
('Igsan', 'normal', '2026-05-01', '2026-05-30', 'Junio 2026', NULL, ''),
('Centro Adorartes', 'normal', '2026-05-01', '2026-05-30', 'Junio 2026', NULL, 'Cliente nuevo abril 2026'),
('Architectural and Civil Solutions', 'solo_impl', '2026-04-15', '2026-05-15', 'No aplica', 'No aplica', 'Solo implementación, no entra como cliente de servicio mensual'),
('Domingo Lizardi', 'riesgo', NULL, NULL, NULL, NULL, 'Pendiente de implementación desde enero 2026. Lleva 3+ meses sin avanzar.');

-- ============================================================
-- 4. SOFTWARE CLIENTES
-- ============================================================
CREATE TABLE software_clientes (
  id SERIAL PRIMARY KEY,
  cliente TEXT NOT NULL,
  licencia TEXT NOT NULL,
  monto NUMERIC NOT NULL DEFAULT 0,
  periodo TEXT NOT NULL
);

ALTER TABLE software_clientes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Auth: leer software" ON software_clientes FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Auth: admin edita software" ON software_clientes FOR ALL USING (get_my_role() = 'admin');

INSERT INTO software_clientes (cliente, licencia, monto, periodo) VALUES
('Luisa Abreu', 'Basic', 36, '2025'),
('Maquipan', 'Manufactura', 144, '2025'),
('Casa del Ingeniero', 'Standard', 60, '2025'),
('Chaer', 'Nomina', 144, '2025'),
('Canvas', 'Standard + FE', 90, '2025'),
('Occer Consulting', 'Starter + FE', 36, 'enero'),
('Dime Siete', 'Premium + FE', 126, 'enero'),
('Dime Siete Portal', 'Starter', 24, 'enero'),
('Phillips', 'Basic + FE', 54, 'enero'),
('Phillips Punto de Venta', 'Punto de Venta', 40, 'enero'),
('Agencia de Viajes Pat', 'Basic + FE', 54, 'enero'),
('Distrito Legal', 'Basic + FE', 54, 'enero'),
('Extra Quimica', 'Basic + FE', 54, 'febrero'),
('Zojaro Ventures', 'Basic + FE', 54, 'marzo'),
('Massiel Delgado', 'Basic + FE', 54, 'marzo'),
('Alba Santana', 'Basic + FE', 54, 'marzo'),
('Yilem Comunica', 'Basic + FE', 54, 'marzo'),
('Architectural and Civil', 'Standard + FE', 90, 'abril'),
('Jima', 'Basic + FE', 54, 'abril');

-- ============================================================
-- 5. FICHAS DE CLIENTES (perfiles)
-- ============================================================
CREATE TABLE perfiles_clientes (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  nombre_empresa TEXT DEFAULT '',
  rnc TEXT DEFAULT '',
  tipo_empresa TEXT DEFAULT '',
  contacto TEXT DEFAULT '',
  telefono TEXT DEFAULT '',
  email TEXT DEFAULT '',
  software TEXT DEFAULT '',
  servicio_impl TEXT DEFAULT '',
  servicio_recurrente TEXT DEFAULT '',
  inicio_impl TEXT DEFAULT '',
  inicio_fiscal TEXT DEFAULT '',
  estado_contabilidad TEXT DEFAULT '',
  contadora_asignada TEXT DEFAULT '',
  notas TEXT DEFAULT ''
);

ALTER TABLE perfiles_clientes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Auth: leer perfiles cli" ON perfiles_clientes FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Auth: admin edita perfiles cli" ON perfiles_clientes FOR ALL USING (get_my_role() IN ('admin', 'ventas'));
CREATE POLICY "Auth: insertar perfiles cli" ON perfiles_clientes FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "Auth: editar perfiles cli" ON perfiles_clientes FOR UPDATE USING (auth.uid() IS NOT NULL);

INSERT INTO perfiles_clientes (nombre, nombre_empresa, rnc, tipo_empresa, contacto, telefono, email, software, servicio_impl, servicio_recurrente, inicio_impl, inicio_fiscal, estado_contabilidad) VALUES
('Keren Jerez', 'Centro Adorartes SRL (RST)', '132-04965-9', 'Liderazgo y capacitación', '', '', '', 'Adm Basic + FE', 'Implementación ADM + FE', 'Tax One', '1ro al 30 mayo', '1ro junio', 'No sabemos'),
('Igsan', 'Igsan Interior Design EIRL', '132679229', 'Firma de Arquitectura', 'Igssel Santana', '829-648-9614', 'igs.santana14@gmail.com', 'Adm Basic + FE', 'Implementación FE + Implementación ADM', 'Tax One', '1ro de mayo al 30 de mayo', '1ro de junio', 'No sabemos'),
('Dior Legal', 'Dior Legal Partners SRL', '131749534', 'Firma de Abogados', 'Eva Ortega', '+1(829)452-4052', 'e.ortegadiaz@diazdiazlp.com', 'Adm Cloud Standard + FE', 'Implementación de Facturación Electrónica + Implementación ADM Cloud', 'Tax One (50 Trx)', '8 de abril al 30 de abril', '1ro de mayo', 'Tienen asistente administrativa');

-- ============================================================
-- 6. KPI SCORES
-- ============================================================
CREATE TABLE kpi_scores (
  id SERIAL PRIMARY KEY,
  contadora TEXT NOT NULL,
  mes TEXT NOT NULL,
  anio INT NOT NULL DEFAULT 2026,
  digitacion NUMERIC DEFAULT 0,
  resumenes NUMERIC DEFAULT 0,
  video_reunion NUMERIC DEFAULT 0,
  total NUMERIC DEFAULT 0,
  UNIQUE(contadora, mes, anio)
);

ALTER TABLE kpi_scores ENABLE ROW LEVEL SECURITY;
-- Contadoras ven solo sus KPIs; admin ve todos
CREATE POLICY "Auth: leer kpi" ON kpi_scores
  FOR SELECT USING (
    CASE get_my_role()
      WHEN 'admin' THEN true
      WHEN 'contadora' THEN contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
      ELSE false
    END
  );
CREATE POLICY "Auth: admin edita kpi" ON kpi_scores FOR ALL USING (get_my_role() = 'admin');

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
SELECT 'meses_resumen' AS tabla, COUNT(*) AS filas FROM meses_resumen
UNION ALL SELECT 'asignaciones', COUNT(*) FROM asignaciones
UNION ALL SELECT 'implementaciones', COUNT(*) FROM implementaciones
UNION ALL SELECT 'software_clientes', COUNT(*) FROM software_clientes
UNION ALL SELECT 'perfiles_clientes', COUNT(*) FROM perfiles_clientes
UNION ALL SELECT 'kpi_scores', COUNT(*) FROM kpi_scores;

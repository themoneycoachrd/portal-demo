-- ============================================================
-- PORTAL DE VENTAS — Account One
-- Script de creación de tablas + datos iniciales
-- Ejecutar en el SQL Editor de Supabase (supabase.com > proyecto > SQL Editor)
-- ============================================================

-- ============================================================
-- PASO 1: CREAR TABLAS
-- ============================================================

-- Tabla de leads (pipeline de ventas)
CREATE TABLE leads (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mes TEXT NOT NULL,           -- enero, febrero, marzo, abril
  anio INT NOT NULL DEFAULT 2026,
  nombre TEXT NOT NULL,        -- Nombre del contacto
  tipo TEXT DEFAULT '',        -- Tipo de negocio
  empresa TEXT DEFAULT '',     -- Nombre de la empresa
  temperatura TEXT DEFAULT 'Tibio',  -- Caliente, Tibio, Frio
  demo DATE,                   -- Fecha del demo
  funnel TEXT NOT NULL,        -- Etapa: Esperando Demo, Cotización Enviada, etc.
  impl NUMERIC(10,2) DEFAULT 0,  -- Monto implementación
  fe NUMERIC(10,2) DEFAULT 0,    -- Monto facturación electrónica
  serv NUMERIC(10,2) DEFAULT 0,  -- Monto servicio recurrente
  soft NUMERIC(10,2) DEFAULT 0,  -- Monto software/licencia
  descuento NUMERIC(5,2) DEFAULT 25,  -- Porcentaje de descuento
  notas TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de métricas ROAS por mes
CREATE TABLE roas_mensual (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mes TEXT NOT NULL,
  anio INT NOT NULL DEFAULT 2026,
  leads INT DEFAULT 0,
  presupuesto NUMERIC(10,2) DEFAULT 0,
  ejecutado NUMERIC(10,2) DEFAULT 0,
  cierres INT DEFAULT 0,
  vendido NUMERIC(12,2) DEFAULT 0,
  cotizado NUMERIC(12,2) DEFAULT 0,
  cpa NUMERIC(10,2) DEFAULT 0,
  retorno NUMERIC(12,2) DEFAULT 0,
  roas NUMERIC(8,2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(mes, anio)
);

-- ============================================================
-- PASO 2: INSERTAR DATOS — ROAS MENSUAL
-- ============================================================

INSERT INTO roas_mensual (mes, anio, leads, presupuesto, ejecutado, cierres, vendido, cotizado, cpa, retorno, roas) VALUES
  ('enero',   2026, 28, 600,  600,  6, 11500, 34304,    100,    10900, 19.17),
  ('febrero', 2026, 25, 495,  495,  4, 2950,  53440,    123.75, 2455,  5.96),
  ('marzo',   2026, 28, 1000, 950,  7, 3806,  17431.80, 135.71, 2856,  4.01),
  ('abril',   2026, 22, 1000, 375,  5, 8272,  24560,    75,     7897,  22.06);

-- ============================================================
-- PASO 3: INSERTAR DATOS — LEADS ENERO
-- ============================================================

INSERT INTO leads (mes, anio, nombre, tipo, empresa, temperatura, demo, funnel, impl, fe, serv, soft, descuento, notas) VALUES
  ('enero', 2026, 'Angel Sanchez', 'Importador', 'Grupo Sanchez Alegria', 'Caliente', '2026-01-06', 'Cerrado Perdido', 500, 500, 400, 54, 0, ''),
  ('enero', 2026, 'Luz Goico', '4 Empresas', 'Inmobiliaria Goico', 'Caliente', '2026-01-13', 'Cotización Enviada', 1500, 500, 0, 54, 0, 'Prioridad Inmobiliaria'),
  ('enero', 2026, 'Nicole Suazo', 'No Show', 'Realtor', 'Caliente', '2026-01-08', 'No Show', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Juan Saladin', '', 'Fábrica de Tabaco', 'Frio', '2026-01-08', 'No Aplica', 0, 0, 0, 0, 0, 'No quiere cotización todavía'),
  ('enero', 2026, 'Nelson Bautista', 'Letreros y Alquiler de Impresoras', 'Contador', 'Frio', '2026-01-12', 'Esperando Cotización', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Angel Ventura', 'No Show', '', 'Frio', '2026-01-06', 'No Show', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Jose Larrauri', 'No Show', '', 'Frio', '2026-01-06', 'No Show', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Carlos Guillen', '', '', 'Frio', '2026-01-12', 'No Aplica', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Laura Lezama', 'Producciones Audiovisuales', 'Shooting Lab', 'Caliente', '2026-01-08', 'Cotización Enviada', 1500, 500, 400, 54, 0, ''),
  ('enero', 2026, 'Moises Delgado', '', 'Empresa de reparación celulares', 'Frio', '2026-01-08', 'Cotización Enviada', 1500, 0, 0, 54, 0, ''),
  ('enero', 2026, 'Oleica Jimenez', 'Centro de Estimulación Infantil', 'Psicología', 'Caliente', '2026-01-01', 'Cerrado Ganado', 500, 500, 400, 54, 0, ''),
  ('enero', 2026, 'Sonia Rodriguez', '', 'Cliente Adm', 'Caliente', '2026-01-12', 'Cotización Enviada', 500, 0, 0, 60, 0, ''),
  ('enero', 2026, 'Elsa Torres', 'Fabricación Muebles', 'Elsa Decoraciones', 'Tibio', '2026-01-20', 'Esperando Demo', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Laura Toral', 'Mantenimiento Villas', '', 'Frio', '2026-01-15', 'No Aplica', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Carmen Garcia', '', 'Constructora Topropaint', 'Tibio', '2026-01-15', 'Cotización Enviada', 1500, 500, 0, 54, 0, ''),
  ('enero', 2026, 'Nadime Bacha', 'Agencia Influencer', 'Dime 7', 'Caliente', '2026-01-15', 'Cerrado Ganado', 2000, 500, 0, 150, 0, ''),
  ('enero', 2026, 'Carlos Espinal', 'Tech Fiao'' Colmado', 'Altagracia Tech', 'Tibio', '2026-01-19', 'Cotización Enviada', 1500, 500, 400, 54, 0, ''),
  ('enero', 2026, 'Sebastian Monterroza', '', '', 'Tibio', '2026-01-20', 'No Aplica', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Nicole Aja', 'Tienda de Accesorios', 'Tete Store', 'Tibio', '2026-01-22', 'Esperando Cotización', 1500, 500, 0, 0, 0, ''),
  ('enero', 2026, 'Sara de Jesus', 'Restaurant', 'La cocina de Sara', 'Tibio', '2026-02-02', 'Esperando Demo', 1500, 500, 0, 54, 0, ''),
  ('enero', 2026, 'Marie Tic Tag', 'Eventos y Materiales', 'Tic Tag', 'Tibio', '2026-01-22', 'Cerrado Ganado', 2000, 500, 400, 54, 0, ''),
  ('enero', 2026, 'Leinny Jimenez', 'Venta de químicos', 'Extra Química', 'Tibio', '2026-01-26', 'Cotización Enviada', 2000, 500, 0, 54, 0, ''),
  ('enero', 2026, 'Massiel de Leon', 'Publicidad', 'Leonsit Media', 'Tibio', '2026-01-26', 'Cotización Enviada', 1500, 500, 0, 54, 0, ''),
  ('enero', 2026, 'Darlyn Reyes', '', '', 'Tibio', '2026-01-26', 'No Aplica', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Roxanna Gomez', '', '', 'Tibio', '2026-01-28', 'Esperando Demo', 0, 0, 0, 0, 0, ''),
  ('enero', 2026, 'Lizardi Gonzalez', 'Constructora', 'Lidomi Constructora', 'Caliente', '2026-01-26', 'Cerrado Ganado', 2000, 500, 400, 54, 0, ''),
  ('enero', 2026, 'Paloma Viajes Pat', 'Agencia de Viajes', 'Viajes Pat', 'Caliente', '2026-01-29', 'Cerrado Ganado', 1000, 500, 0, 0, 0, ''),
  ('enero', 2026, 'Carolina Arbaje', 'Firma de Abogados', 'Distrito Legal', 'Caliente', '2026-01-29', 'Cerrado Ganado', 1000, 500, 0, 0, 0, '');

-- ============================================================
-- PASO 4: INSERTAR DATOS — LEADS FEBRERO
-- ============================================================

INSERT INTO leads (mes, anio, nombre, tipo, empresa, temperatura, demo, funnel, impl, fe, serv, soft, descuento, notas) VALUES
  ('febrero', 2026, 'Tess Amiel Medina', 'Centro Cosmetólogo', 'Tera Wellness & Aesthetic', 'Caliente', '2026-02-02', 'Seguimiento', 1500, 500, 400, 54, 25, ''),
  ('febrero', 2026, 'Karina Inoa', 'Alimento Equino', 'Grupo Blanco', 'Caliente', '2026-02-02', 'Seguimiento', 2000, 500, 400, 54, 25, ''),
  ('febrero', 2026, 'Deyanira', '', '', 'Frio', '2026-02-03', 'Cotización Enviada', 1500, 500, 0, 0, 25, ''),
  ('febrero', 2026, 'Chaer Decoraciones', 'Diseño de Muebles', 'Chaer Decoraciones', 'Caliente', '2026-02-03', 'Cotización Enviada', 500, 0, 0, 0, 25, ''),
  ('febrero', 2026, 'Sarah Wu', 'Colegio', 'Allegro', 'Tibio', '2026-02-04', 'Cotización Enviada', 1500, 500, 400, 54, 25, 'Colegio Espacial Contabilidad Completa'),
  ('febrero', 2026, 'Noelle Herrera', 'Estudio de Moda', 'Noelle Herrera Designs', 'Caliente', '2026-02-04', 'Cerrado Perdido', 2000, 500, 400, 54, 25, ''),
  ('febrero', 2026, 'Maria Fernanda Joa', 'Alquiler para Eventos', 'Joa Inversiones', 'Frio', '2026-02-05', 'Esperando Cotización', 2000, 500, 400, 54, 25, ''),
  ('febrero', 2026, 'Phillip Escoto', 'Electrónica', 'Phillips Electronica', 'Caliente', '2026-02-04', 'Cerrado Ganado', 1160, 290, 0, 94, 0, ''),
  ('febrero', 2026, 'Anyelin Pereyra', 'Almacenes', 'Giuliani Almacenes Diversos', 'Tibio', '2026-02-03', 'Cotización Enviada', 0, 0, 0, 0, 25, ''),
  ('febrero', 2026, 'Mildred Leiva y Marcia Ureña', 'Firma Arquitectos', 'Ormarquitectos', 'Tibio', '2026-02-03', 'Cotización Enviada', 2000, 500, 0, 90, 25, ''),
  ('febrero', 2026, 'Sara de Jesus Lazala', 'Comida Empresarial', 'D Sara Delicatessen', 'Tibio', '2026-02-03', 'Cotización Enviada', 2000, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Victor Polanco', 'Buzos de Barcos', 'Caribe Divers Works', 'Tibio', '2026-02-11', 'Cotización Enviada', 2000, 500, 600, 54, 25, ''),
  ('febrero', 2026, 'Lucia Sánchez', 'Andamios', 'Andamios y Encofrados del Caribe', 'Tibio', '2026-02-10', 'Cotización Enviada', 2000, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Lucia Sánchez', 'Grúas', 'Grúas Dominicanas, Grudom', 'Caliente', '2026-02-10', 'Cotización Enviada', 2000, 500, 400, 54, 25, ''),
  ('febrero', 2026, 'Johanna Simpson', 'Salud', 'CLC', 'Caliente', '2026-02-12', 'Cerrado Ganado', 0, 500, 0, 0, 0, ''),
  ('febrero', 2026, 'Johanna Simpson', 'Salud', 'Vitalie', 'Caliente', '2026-02-12', 'Cerrado Ganado', 0, 500, 0, 0, 0, ''),
  ('febrero', 2026, 'Rolando Fermin', '', 'Isfar Group', 'Caliente', '2026-02-12', 'Cotización Enviada', 0, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Rolando Fermin', 'Agencia de Viajes', 'Novalty Travel', 'Caliente', '2026-02-12', 'Cotización Enviada', 0, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Tamara Finch', '', 'Realtor', 'Caliente', '2026-02-12', 'Cotización Enviada', 2000, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Leinny Jimenez', 'Venta de químicos', 'Extra Química', 'Caliente', '2026-01-26', 'Cerrado Ganado', 500, 0, 0, 54, 0, ''),
  ('febrero', 2026, 'Stephany Hernandez', 'Transporte Empresarial', 'Transpriem', 'Caliente', '2026-02-16', 'Esperando Cotización', 1500, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Alba Santana', 'Empresa de Letreros', '', 'Caliente', '2026-02-20', 'Cotización Enviada', 0, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Ricardo Santana', 'Firma de Abogados', '', 'Caliente', '2026-02-20', 'Esperando Demo', 1500, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Raúl Aristy', '', '', 'Caliente', '2026-02-20', 'Esperando Demo', 1500, 500, 0, 54, 25, ''),
  ('febrero', 2026, 'Guillermo Mendez', '', '', 'Caliente', '2026-02-20', 'Esperando Demo', 1500, 500, 0, 54, 25, '');

-- ============================================================
-- PASO 5: INSERTAR DATOS — LEADS MARZO
-- ============================================================

INSERT INTO leads (mes, anio, nombre, tipo, empresa, temperatura, demo, funnel, impl, fe, serv, soft, descuento, notas) VALUES
  ('marzo', 2026, 'Dilepsia Polanco', 'Empresa de Embutidos', '', 'Tibio', NULL, 'Cotización Enviada', 0, 0, 0, 0, 25, 'Envié correo el 12/03'),
  ('marzo', 2026, 'Ilis Vasquez', 'Courrier', 'Madre 13 Agencias', 'Caliente', NULL, 'Esperando Cotización', 0, 0, 0, 0, 25, 'Pidió presupuesto y fecha'),
  ('marzo', 2026, 'Annalisa', 'Empresa de Catering Pequeña', '', 'Caliente', '2026-03-10', 'Cotización Enviada', 750, 500, 400, 54, 25, 'Dar seguimiento Lunes 16'),
  ('marzo', 2026, 'Alba Santana', 'Letreros', '', 'Caliente', '2026-03-10', 'Cerrado Ganado', 0, 500, 0, 54, 0, 'Pagará mañana'),
  ('marzo', 2026, 'Lucia', 'Mes pasado', '', 'Frio', NULL, 'Cotización Enviada', 0, 1000, 0, 108, 25, ''),
  ('marzo', 2026, 'Angelo (Esposo Luz)', '', 'Novus Paradigma', 'Caliente', '2026-03-10', 'Cotización Enviada', 0, 500, 0, 54, 25, 'Dar seguimiento a final de mes'),
  ('marzo', 2026, 'Jennifer García', '', 'Jennifer Garcia Beauty Center', 'Tibio', '2026-03-10', 'Cotización Enviada', 0, 500, 0, 54, 25, 'Centro de Belleza, Microblading'),
  ('marzo', 2026, 'Ruby Polanco', 'No Show', '', 'Frio', '2026-03-11', 'No Show', 0, 0, 0, 0, 25, ''),
  ('marzo', 2026, 'Daniel Sanchez', 'Manejo de propiedades', 'Casa de', 'Caliente', '2026-03-11', 'Cotización Enviada', 0, 500, 0, 54, 25, '15 Propiedades que son 15 empresas'),
  ('marzo', 2026, 'Massiel Delgado', 'RST Anual 2 Empresas', '', 'Tibio', '2026-03-11', 'Cerrado Ganado', 0, 0, 0, 54, 0, 'Paso Software'),
  ('marzo', 2026, 'Adris Cid', '', 'Mia Vision TV', 'Tibio', '2026-03-11', 'Esperando Cotización', 0, 500, 0, 0, 25, ''),
  ('marzo', 2026, 'Adris Cid', '', 'Blue Vic Boutique', 'Tibio', '2026-03-11', 'Esperando Cotización', 0, 0, 0, 54, 25, ''),
  ('marzo', 2026, 'Jonathan Romero', '', '', 'Tibio', '2026-03-13', 'Esperando Cotización', 0, 0, 0, 0, 25, 'Agendó para el viernes 13/03'),
  ('marzo', 2026, 'Madre Janet Contreras', 'Tenedoras de Propiedades', '', 'Tibio', NULL, 'Esperando Demo', 0, 0, 0, 0, 25, ''),
  ('marzo', 2026, 'Carlos Moretta', 'Oftálmologo', '', 'Tibio', NULL, 'Esperando Demo', 0, 0, 0, 0, 25, 'Lead por Instagram'),
  ('marzo', 2026, 'Mary Gomez', 'Constructora', '', 'Tibio', NULL, 'Esperando Demo', 0, 0, 0, 0, 25, 'Hicimos primera demo, harán 2da'),
  ('marzo', 2026, 'Oscar de Leon', 'Asesoría Turismo', '', 'Caliente', '2026-03-13', 'Cerrado Ganado', 0, 375, 0, 54, 0, ''),
  ('marzo', 2026, 'Black Box', 'Importación', '', 'Frio', NULL, 'Cotización Enviada', 0, 500, 0, 0, 25, ''),
  ('marzo', 2026, 'Amelia Cespedes', 'Distribución Arroz', '', 'Frio', '2026-03-20', 'No Show', 0, 0, 0, 0, 25, 'Hablando por whatsapp'),
  ('marzo', 2026, 'Nikarlie', 'No Prospectado', '', 'Frio', '2026-03-24', 'No Show', 0, 0, 0, 0, 25, 'Hablando por whatsapp'),
  ('marzo', 2026, 'Elvyn Soa', 'GPS', '', 'Frio', '2026-03-24', 'Cotización Enviada', 1500, 500, 400, 54, 25, 'Colegio Espacial Contabilidad Completa'),
  ('marzo', 2026, 'Alicia Puello', '', 'My Studio Club', 'Caliente', '2026-03-26', 'Cotización Enviada', 1500, 500, 0, 54, 25, 'Firma de Contadores. Hija queriendo modernizar'),
  ('marzo', 2026, 'Yamile Ortiz Burgos', '', 'Ortiz Burgos Contadores', 'Caliente', '2026-03-26', 'Cotización Enviada', 1125, 0, 400, 90, 25, 'Firma de Abogados, lo ha intentado antes'),
  ('marzo', 2026, 'Eva Ortega', '', 'Dior Legal Partners', 'Caliente', '2026-03-27', 'Cerrado Ganado', 1125, 0, 400, 90, 0, ''),
  ('marzo', 2026, 'Janet Contreras', '', 'Inversiones Saclar', 'Caliente', '2026-03-23', 'Cerrado Ganado', 500, 0, 250, 0, 0, ''),
  ('marzo', 2026, 'Janet Contreras', '', 'Vista Catalina', 'Caliente', '2026-03-23', 'Cerrado Ganado', 500, 0, 250, 0, 0, ''),
  ('marzo', 2026, 'Kumiko Kasahara', '', '', 'Frio', NULL, 'Esperando Demo', 0, 0, 0, 0, 25, ''),
  ('marzo', 2026, 'Yilem Comunica', '', '', 'Caliente', '2026-03-31', 'Cerrado Ganado', 500, 0, 0, 54, 0, '');

-- ============================================================
-- PASO 6: INSERTAR DATOS — LEADS ABRIL
-- ============================================================

INSERT INTO leads (mes, anio, nombre, tipo, empresa, temperatura, demo, funnel, impl, fe, serv, soft, descuento, notas) VALUES
  ('abril', 2026, 'Raul Aristy', 'Constructora', 'Architectural & Civil', 'Caliente', '2026-04-01', 'Cerrado Ganado', 1500, 500, 0, 90, 25, 'Friday 10/04'),
  ('abril', 2026, 'Igssel Santana', 'Firma de Arquitectura', 'Igsan', 'Caliente', '2026-04-13', 'Cerrado Ganado', 1500, 500, 400, 54, 25, 'Firma Puerto Plata. Quiere todo'),
  ('abril', 2026, 'Keren Jerez', 'Membresías RST', 'Centro Adorartes SRL', 'Caliente', '2026-04-16', 'Cerrado Ganado', 1500, 500, 400, 54, 25, 'RST. Pago 50% ahora, 50% el 03 de Mayo'),
  ('abril', 2026, 'Jima', '2da Empresa Paloma', '', 'Caliente', '2026-04-01', 'Cerrado Ganado', 0, 500, 0, 0, 0, '2da Empresa Paloma'),
  ('abril', 2026, 'Kumiko Kasahara', 'K&G', '', 'Caliente', '2026-04-01', 'Cerrado Ganado', 0, 3074, 0, 0, 0, '8 FE con 25% y 7 Adm Basic con 70% de Descuento'),
  ('abril', 2026, 'Rosangela Padilla', 'Firma de Arquitectura', '', 'Tibio', '2026-04-01', 'Cotización Enviada', 1500, 500, 0, 90, 25, ''),
  ('abril', 2026, 'Mireya Gonzalez', 'Constructora', '', 'Tibio', '2026-04-01', 'Cotización Enviada', 1500, 500, 0, 90, 25, ''),
  ('abril', 2026, 'Yelissa Solano', 'Firma de Arquitectura', '', 'Tibio', '2026-03-31', 'Esperando Demo', 0, 500, 0, 90, 25, 'Hablando con contador para confirmar'),
  ('abril', 2026, 'Denisse Salazar', 'Firma de Arquitectura', '', 'Tibio', '2026-03-31', 'Esperando Demo', 0, 500, 0, 90, 25, 'Hablando con contador para confirmar'),
  ('abril', 2026, 'Raynel Marte', 'Firma de Arquitectura', '', 'Caliente', '2026-03-31', 'Cotización Enviada', 0, 500, 0, 90, 25, 'Monday 06/04'),
  ('abril', 2026, 'Jessica Pitchan', 'Firma de Arquitectura', '', 'Caliente', '2026-04-06', 'Cotización Enviada', 1500, 500, 0, 90, 25, 'Firma Isaias 43. Motivar a empezar con FE'),
  ('abril', 2026, 'Geovanna y Tatiana', 'Firma de Arquitectura', '', 'Caliente', '2026-04-06', 'Cotización Enviada', 1500, 500, 0, 90, 25, 'Quiere su 25%. Motivar a empezar con FE'),
  ('abril', 2026, 'Jomny Johanna', 'Firma de Asesoría en Procesos', '', 'Caliente', '2026-04-06', 'Cotización Enviada', 0, 500, 0, 90, 25, 'Posible intercambio. Le interesa más FE'),
  ('abril', 2026, 'Fausto Mejía', '', '', 'Frio', '2026-04-06', 'Esperando Demo', 1500, 500, 0, 90, 25, ''),
  ('abril', 2026, 'Nelson José', '', '', 'Frio', NULL, 'Esperando Demo', 0, 0, 0, 0, 25, ''),
  ('abril', 2026, 'Patricia Merca', '', '', 'Frio', NULL, 'Esperando Demo', 0, 0, 0, 0, 25, ''),
  ('abril', 2026, 'Kamila S Herrera', '2 Empresas Diseño y Construcción', '', 'Caliente', '2026-04-13', 'Esperando Cotización', 3000, 1000, 0, 216, 25, 'Tiene socios, lo hablará esta tarde'),
  ('abril', 2026, 'Gabriela Melendez', 'Diseño y Redes', '', 'Caliente', '2026-04-13', 'Esperando Cotización', 0, 500, 0, 36, 25, 'Empresa Pequeña'),
  ('abril', 2026, 'Beatriz Khon', '', '', 'Frio', NULL, 'No Show', 0, 0, 0, 0, 25, ''),
  ('abril', 2026, 'Luz del Alba', '', '', 'Frio', NULL, 'No Show', 0, 0, 0, 0, 25, ''),
  ('abril', 2026, 'Sol Rojas', 'Asesora Manufactura', '', 'Tibio', NULL, 'Esperando Cotización', 1500, 500, 0, 216, 25, ''),
  ('abril', 2026, 'Angela Martinez', 'Realtor', '', 'Tibio', NULL, 'Esperando Cotización', 1500, 500, 400, 216, 25, '');

-- ============================================================
-- VERIFICACIÓN: Corre esto para confirmar que todo entró bien
-- ============================================================

-- Debe dar: enero 28, febrero 25, marzo 28, abril 22
SELECT mes, COUNT(*) as leads FROM leads GROUP BY mes ORDER BY
  CASE mes WHEN 'enero' THEN 1 WHEN 'febrero' THEN 2 WHEN 'marzo' THEN 3 WHEN 'abril' THEN 4 END;

-- Debe dar 4 filas con los totales de ROAS
SELECT mes, leads, vendido, roas FROM roas_mensual ORDER BY
  CASE mes WHEN 'enero' THEN 1 WHEN 'febrero' THEN 2 WHEN 'marzo' THEN 3 WHEN 'abril' THEN 4 END;

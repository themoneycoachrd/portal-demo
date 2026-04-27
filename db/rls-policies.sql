-- ============================================================
-- POLÍTICAS DE ACCESO (RLS) — Portal de Ventas
-- Ejecutar en el SQL Editor de Supabase
-- ============================================================
-- Por ahora: acceso abierto para el rol anon (público).
-- Cuando activemos autenticación (Paso 2), cambiaremos estas
-- políticas para que cada rol solo vea lo que le corresponde.
-- ============================================================

-- Políticas para la tabla LEADS
CREATE POLICY "Permitir lectura de leads" ON leads
  FOR SELECT USING (true);

CREATE POLICY "Permitir insertar leads" ON leads
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir editar leads" ON leads
  FOR UPDATE USING (true);

CREATE POLICY "Permitir eliminar leads" ON leads
  FOR DELETE USING (true);

-- Políticas para la tabla ROAS_MENSUAL
CREATE POLICY "Permitir lectura de roas" ON roas_mensual
  FOR SELECT USING (true);

CREATE POLICY "Permitir insertar roas" ON roas_mensual
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir editar roas" ON roas_mensual
  FOR UPDATE USING (true);

CREATE POLICY "Permitir eliminar roas" ON roas_mensual
  FOR DELETE USING (true);

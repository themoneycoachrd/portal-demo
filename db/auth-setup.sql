-- ============================================================
-- AUTENTICACIÓN Y PERFILES — Portal Account One
-- Ejecutar en el SQL Editor de Supabase (un solo Run)
-- ============================================================

-- ============================================================
-- PASO 1: Tabla de perfiles (vincula auth.users con roles)
-- ============================================================
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  nombre TEXT NOT NULL DEFAULT '',
  rol TEXT NOT NULL DEFAULT 'contadora'
    CHECK (rol IN ('admin', 'ventas', 'contadora', 'implementadora', 'analista')),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Cualquier usuario autenticado puede leer perfiles
CREATE POLICY "Usuarios autenticados leen perfiles" ON profiles
  FOR SELECT USING (auth.uid() IS NOT NULL);

-- ============================================================
-- PASO 2: Función para obtener el rol del usuario actual
-- (Se usa en las políticas RLS de las demás tablas)
-- ============================================================
CREATE OR REPLACE FUNCTION get_my_role()
RETURNS TEXT AS $$
  SELECT rol FROM public.profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ============================================================
-- PASO 3: Trigger que crea el perfil automáticamente
-- cuando se registra un usuario en Supabase Auth.
-- Ya viene con el rol correcto según el email.
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  user_role TEXT;
  user_nombre TEXT;
BEGIN
  CASE NEW.email
    WHEN 'frosa@accountone.do' THEN
      user_role := 'admin'; user_nombre := 'Felix Rosa';
    WHEN 'nvillar@accountone.do' THEN
      user_role := 'ventas'; user_nombre := 'Naomi Villar';
    WHEN 'bbrito@accountone.do' THEN
      user_role := 'contadora'; user_nombre := 'Beliani Brito';
    WHEN 'tramirez@accountone.do' THEN
      user_role := 'contadora'; user_nombre := 'Taina Ramirez';
    WHEN 'ksanchez@accountone.do' THEN
      user_role := 'contadora'; user_nombre := 'Karina Sanchez';
    WHEN 'vvasquez@accountone.do' THEN
      user_role := 'contadora'; user_nombre := 'Victoria Vasquez';
    WHEN 'ydiaz@accountone.do' THEN
      user_role := 'contadora'; user_nombre := 'Yessica Diaz';
    WHEN 'ccarrion@accountone.do' THEN
      user_role := 'implementadora'; user_nombre := 'C. Carrion';
    WHEN 'lpena@accountone.do' THEN
      user_role := 'implementadora'; user_nombre := 'Lisette Pena';
    WHEN 'lguzman@accountone.do' THEN
      user_role := 'analista'; user_nombre := 'Lovelis Guzman';
    ELSE
      user_role := 'contadora'; user_nombre := '';
  END CASE;

  INSERT INTO public.profiles (id, email, nombre, rol)
  VALUES (NEW.id, NEW.email, user_nombre, user_role);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- PASO 4: Quitar las políticas viejas (acceso anónimo abierto)
-- ============================================================
DROP POLICY IF EXISTS "Permitir lectura de leads" ON leads;
DROP POLICY IF EXISTS "Permitir insertar leads" ON leads;
DROP POLICY IF EXISTS "Permitir editar leads" ON leads;
DROP POLICY IF EXISTS "Permitir eliminar leads" ON leads;

DROP POLICY IF EXISTS "Permitir lectura de roas" ON roas_mensual;
DROP POLICY IF EXISTS "Permitir insertar roas" ON roas_mensual;
DROP POLICY IF EXISTS "Permitir editar roas" ON roas_mensual;
DROP POLICY IF EXISTS "Permitir eliminar roas" ON roas_mensual;

-- ============================================================
-- PASO 5: Nuevas políticas — solo usuarios autenticados
-- ============================================================

-- LEADS: admin y ventas pueden leer, insertar y editar.
-- Solo admin puede eliminar.
CREATE POLICY "Auth: leer leads" ON leads
  FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Auth: insertar leads" ON leads
  FOR INSERT WITH CHECK (
    get_my_role() IN ('admin', 'ventas')
  );

CREATE POLICY "Auth: editar leads" ON leads
  FOR UPDATE USING (
    get_my_role() IN ('admin', 'ventas')
  );

CREATE POLICY "Auth: eliminar leads" ON leads
  FOR DELETE USING (
    get_my_role() = 'admin'
  );

-- ROAS: admin y ventas pueden leer. Solo admin edita/inserta/elimina.
CREATE POLICY "Auth: leer roas" ON roas_mensual
  FOR SELECT USING (
    get_my_role() IN ('admin', 'ventas')
  );

CREATE POLICY "Auth: insertar roas" ON roas_mensual
  FOR INSERT WITH CHECK (
    get_my_role() = 'admin'
  );

CREATE POLICY "Auth: editar roas" ON roas_mensual
  FOR UPDATE USING (
    get_my_role() = 'admin'
  );

CREATE POLICY "Auth: eliminar roas" ON roas_mensual
  FOR DELETE USING (
    get_my_role() = 'admin'
  );

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
-- Después de correr este SQL, ve a Authentication > Users en
-- el dashboard de Supabase y crea los usuarios uno por uno:
--   1. Click "Add user" > "Create new user"
--   2. Email: frosa@accountone.do
--   3. Password: (la que quieras, se la pasas a cada persona)
--   4. Desmarca "Auto Confirm User" si quieres que confirmen por email,
--      o déjalo marcado para que entren directo.
--   5. Repite para cada miembro del equipo.
--
-- El trigger creará automáticamente el perfil con el rol correcto.
--
-- Para verificar que los perfiles se crearon bien:
-- SELECT * FROM profiles;
-- ============================================================

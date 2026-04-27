-- ============================================================
-- FUNCION PARA INVITAR USUARIOS — Account One
-- Función de base de datos que crea un usuario y le envía
-- invitación por email usando la API interna de Supabase Auth.
--
-- IMPORTANTE: Esta es una función SECURITY DEFINER que solo
-- puede ser llamada por admin. Ejecutar en SQL Editor.
-- ============================================================

-- Habilitar la extensión http si no está activa
-- (necesaria para llamar a la Auth Admin API desde SQL)
CREATE EXTENSION IF NOT EXISTS http WITH SCHEMA extensions;

-- Función que invita un usuario nuevo
CREATE OR REPLACE FUNCTION invite_user(
  p_email TEXT,
  p_nombre TEXT DEFAULT '',
  p_role TEXT DEFAULT 'contadora'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_service_key TEXT;
  v_project_url TEXT;
  v_response extensions.http_response;
  v_body JSONB;
  v_result JSONB;
  v_user_id UUID;
BEGIN
  -- Solo admin puede invitar
  IF get_my_role() != 'admin' THEN
    RETURN jsonb_build_object('error', 'Solo admin puede invitar usuarios');
  END IF;

  v_project_url := 'https://ouetusstqvpyjeycfdio.supabase.co';

  -- PEGA TU SERVICE ROLE KEY AQUI (el token largo que empieza con eyJ...)
  v_service_key := 'PEGA-TU-SERVICE-ROLE-KEY-AQUI';

  -- Preparar el body para la Admin API
  v_body := jsonb_build_object(
    'email', p_email,
    'email_confirm', false,
    'user_metadata', jsonb_build_object('nombre', p_nombre),
    'app_metadata', jsonb_build_object('role', p_role)
  );

  -- Llamar a la Auth Admin API para crear el usuario
  SELECT * INTO v_response FROM extensions.http((
    'POST',
    v_project_url || '/auth/v1/admin/users',
    ARRAY[
      extensions.http_header('apikey', v_service_key),
      extensions.http_header('Authorization', 'Bearer ' || v_service_key),
      extensions.http_header('Content-Type', 'application/json')
    ],
    'application/json',
    v_body::text
  )::extensions.http_request);

  v_result := v_response.content::jsonb;

  -- Si hubo error en la creación
  IF v_response.status >= 400 THEN
    RETURN jsonb_build_object('error', COALESCE(v_result->>'msg', v_result->>'message', 'Error al crear usuario'));
  END IF;

  -- Obtener el ID del usuario creado
  v_user_id := (v_result->>'id')::UUID;

  -- Crear el perfil
  INSERT INTO profiles (id, nombre, role)
  VALUES (v_user_id, p_nombre, p_role)
  ON CONFLICT (id) DO UPDATE SET nombre = p_nombre, role = p_role;

  -- Enviar email de invitación (magic link para que ponga su contraseña)
  SELECT * INTO v_response FROM extensions.http((
    'POST',
    v_project_url || '/auth/v1/admin/generate_link',
    ARRAY[
      extensions.http_header('apikey', v_service_key),
      extensions.http_header('Authorization', 'Bearer ' || v_service_key),
      extensions.http_header('Content-Type', 'application/json')
    ],
    'application/json',
    jsonb_build_object(
      'email', p_email,
      'type', 'invite',
      'redirect_to', v_project_url
    )::text
  )::extensions.http_request);

  RETURN jsonb_build_object(
    'success', true,
    'user_id', v_user_id,
    'email', p_email,
    'nombre', p_nombre,
    'role', p_role
  );
END;
$$;

-- Revocar acceso público
REVOKE ALL ON FUNCTION invite_user FROM PUBLIC;

-- Solo usuarios autenticados pueden llamarla (la función verifica internamente que sea admin)
GRANT EXECUTE ON FUNCTION invite_user TO authenticated;

-- ============================================================
-- CONFIGURACION REQUERIDA:
--
-- Para que esta función pueda crear usuarios, necesitas configurar
-- la service_role_key como un secret de Supabase.
--
-- Opción A: Usando Vault (recomendado)
-- 1. Ve a Supabase Dashboard > Project Settings > API
-- 2. Copia la "service_role key" (la secreta, NO la anon)
-- 3. En SQL Editor, ejecuta:
--    ALTER DATABASE postgres SET app.settings.service_role_key = 'tu-service-role-key-aqui';
--
-- Opción B: Hardcoded (menos seguro pero funciona)
-- Reemplaza la línea que dice v_service_key := current_setting(...)
-- con: v_service_key := 'tu-service-role-key-aqui';
--
-- PRUEBA:
-- SELECT invite_user('test@accountone.do', 'Usuario Test', 'contadora');
-- ============================================================

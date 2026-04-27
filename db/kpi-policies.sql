-- ============================================================
-- POLÍTICAS ADICIONALES PARA KPI_SCORES
-- Para que cada contadora pueda llenar sus propios scores.
-- Ejecutar en el SQL Editor de Supabase (un solo Run).
-- ============================================================

-- Permitir a contadoras insertar sus propios KPIs
CREATE POLICY "Auth: contadora inserta kpi" ON kpi_scores
  FOR INSERT WITH CHECK (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- Permitir a contadoras actualizar sus propios KPIs
CREATE POLICY "Auth: contadora edita kpi" ON kpi_scores
  FOR UPDATE USING (
    get_my_role() = 'contadora'
    AND contadora = (SELECT nombre FROM profiles WHERE id = auth.uid())
  );

-- ============================================================
-- VERIFICACIÓN: Después de correr esto, verifica con:
-- SELECT policyname, cmd FROM pg_policies WHERE tablename = 'kpi_scores';
-- Deberías ver 4 políticas:
--   1. Auth: leer kpi (SELECT)
--   2. Auth: admin edita kpi (ALL)
--   3. Auth: contadora inserta kpi (INSERT)
--   4. Auth: contadora edita kpi (UPDATE)
-- ============================================================

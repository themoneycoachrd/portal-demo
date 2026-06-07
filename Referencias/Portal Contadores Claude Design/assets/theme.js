/* ============================================================================
   Account One — Portal Refinado · theme.js
   Reemplaza emojis del sidebar y módulos por íconos Lucide line.
   No toca lógica del portal.
   ============================================================================ */
(function () {
  // ─── Lucide icons (subset, currentColor, stroke 1.75) ────────────────
  const LUCIDE = {
    building:'<path d="M3 21h18"/><path d="M5 21V7l6-4v18"/><path d="M19 21V11l-8-4"/><path d="M9 9v.01"/><path d="M9 12v.01"/><path d="M9 15v.01"/><path d="M9 18v.01"/>',
    trending:'<polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/>',
    target:'<circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/>',
    clipboard:'<rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><line x1="8" y1="11" x2="16" y2="11"/><line x1="8" y1="15" x2="14" y2="15"/>',
    rocket:'<path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"/><path d="M12 15l-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z"/><path d="M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5"/>',
    globe:'<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>',
    star:'<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>',
    settings:'<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>',
    users:'<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>',
    home:'<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>',
    bell:'<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/>',
    check:'<polyline points="20 6 9 17 4 12"/>',
    list:'<line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/>',
    money:'<line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>',
    chart:'<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>'
  };

  // Mapa: emoji char → lucide name (cubre todos los del portal)
  const EMOJI_MAP = {
    '🏢':'building',
    '📈':'trending',
    '🎯':'target',
    '📋':'clipboard',
    '🚀':'rocket',
    '🌐':'globe',
    '⭐':'star',
    '⚙':'settings', '⚙️':'settings',
    '👥':'users', '👤':'users',
    '🏠':'home',
    '🔔':'bell',
    '✅':'check', '✓':'check',
    '📊':'chart', '📉':'chart',
    '💰':'money', '💵':'money',
    '📝':'list'
  };

  function svg(name) {
    const inner = LUCIDE[name];
    if (!inner) return '';
    return '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"'
         + ' stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"'
         + ' style="display:block">' + inner + '</svg>';
  }

  function swapNode(el) {
    if (!el || el.dataset.lucideSwapped === '1') return;
    const txt = (el.textContent || '').trim();
    if (!txt) return;
    // detectar emoji (todo lo no-ASCII de un char "alto")
    const first = Array.from(txt)[0];
    const lucide = EMOJI_MAP[first];
    if (!lucide) return;
    // limpiar background inline (color amarillo claro etc)
    if (el.style && el.style.background) el.style.background = '';
    el.innerHTML = svg(lucide);
    el.classList.add('has-lucide');
    el.dataset.lucideSwapped = '1';
  }

  function run() {
    // 1) Sidebar nav-icons
    document.querySelectorAll('.nav-icon').forEach(swapNode);
    // 2) module-card icons (dashboard de inicio: .module-card .module-icon)
    document.querySelectorAll('.module-icon, .pm-icon').forEach(swapNode);
  }

  // Observer: el sidebar se renderiza via JS (renderSidebar) — reaccionar a cambios
  function observe() {
    const sidebar = document.querySelector('.sidebar') || document.body;
    const mo = new MutationObserver(() => { run(); });
    mo.observe(sidebar, { childList: true, subtree: true });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => { run(); observe(); });
  } else {
    run(); observe();
  }
})();

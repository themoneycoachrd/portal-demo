// Portal Account One — B Claro · Interactive prototype
// Nav with mini descriptions, clickable sidebar, breadcrumb topbar

const { useState } = React;

const NAV = [
  { id:'home',      icon:'home',     label:'Inicio',            desc:'Resumen ejecutivo de la firma' },
  { id:'clientes',  icon:'building', label:'Clientes',          desc:'Cartera de contabilidad · 42 recurrentes' },
  { id:'comercial', icon:'trending', label:'Comercial',         desc:'Pipeline de ventas · 12 cierres' },
  { id:'conta',     icon:'target',   label:'Contabilidad',      desc:'Cierres y estados financieros' },
  { id:'imp',       icon:'receipt',  label:'Impuestos',         desc:'Declaraciones DGII · 4 pendientes', badge:'4' },
  { id:'impl',      icon:'rocket',   label:'Implementaciones',  desc:'Onboarding de nuevos clientes' },
  { id:'portal',    icon:'globe',    label:'Portal clientes',   desc:'Acceso externo y reportes' },
  { id:'personal',  icon:'star',     label:'Personal',          desc:'Equipo · 5 contadoras asignadas' },
];

/* ── Sidebar ───────────────────────────────────────────────────────────── */
const Sidebar = ({ activeId, onNav }) => (
  <aside className="side">
    <div className="side-brand">
      <div className="side-mark">
        <svg viewBox="0 0 28 28" width="20" height="20" fill="currentColor">
          <path d="M14 3c-1.5 3.5-4 6-7.5 7.5 3.5 1.5 6 4 7.5 7.5 1.5-3.5 4-6 7.5-7.5C18 9 15.5 6.5 14 3z" opacity=".95"/>
          <path d="M14 11c-.8 2-2.3 3.5-4.3 4.3 2 .8 3.5 2.3 4.3 4.3.8-2 2.3-3.5 4.3-4.3-2-.8-3.5-2.3-4.3-4.3z" opacity=".55"/>
        </svg>
      </div>
      <div>
        <div className="side-brand-name">Account One</div>
        <div className="side-brand-tag">Portal interno</div>
      </div>
    </div>

    <nav className="side-nav">
      {NAV.map(n => (
        <div key={n.id}
             className={`nav-item${n.id === activeId ? ' is-active' : ''}`}
             onClick={() => onNav(n.id)}>
          <span className="nav-icon"><Icon name={n.icon} size={16}/></span>
          <div className="nav-text">
            <span className="nav-label">{n.label}</span>
            <span className="nav-desc">{n.desc}</span>
          </div>
          {n.badge && <span className="nav-badge">{n.badge}</span>}
        </div>
      ))}

      <div className="nav-section">Configuración</div>
      <div className={`nav-item${activeId === 'settings' ? ' is-active' : ''}`}
           onClick={() => onNav('settings')}>
        <span className="nav-icon"><Icon name="settings" size={16}/></span>
        <div className="nav-text">
          <span className="nav-label">Usuarios y permisos</span>
          <span className="nav-desc">Roles y acceso al portal</span>
        </div>
      </div>
    </nav>

    <div className="side-user">
      <div className="side-avatar">FB</div>
      <div className="side-uinfo">
        <div className="side-uname">Felipe Báez</div>
        <div className="side-urole">Administrador</div>
      </div>
      <button className="side-logout" title="Salir"><Icon name="logout" size={14}/></button>
    </div>
    <div className="side-ver">v1.04 · Portal Account One</div>
  </aside>
);

/* ── Topbar ─────────────────────────────────────────────────────────────── */
const Topbar = ({ trail, actions }) => (
  <header className="topbar">
    <div className="top-left">
      <div className="top-trail">
        {trail.map((t, i) => (
          <React.Fragment key={i}>
            {i > 0 && <span className="top-sep">/</span>}
            <span className={i === trail.length - 1 ? 'top-cur' : 'top-crumb'}>{t}</span>
          </React.Fragment>
        ))}
      </div>
    </div>
    <div className="top-right">
      {actions}
      <span className="top-date">Jueves 5 de junio, 2026</span>
      <button className="top-icon" title="Notificaciones">
        <Icon name="bell" size={15}/><span className="top-dot"/>
      </button>
      <div className="top-avatar">FB</div>
    </div>
  </header>
);

/* ── Shared small components ───────────────────────────────────────────── */
const Pill = ({ children, tone }) => <span className={`pill pill-${tone}`}>{children}</span>;
const Dot  = ({ tone }) => <span className={`dot dot-${tone}`}/>;

const StatCard = ({ label, value, tone, sub }) => (
  <div className="stat">
    <div className="stat-lbl">{label}</div>
    <div className={`stat-val t-${tone || 'ink'}`}>{value}</div>
    {sub && <div className="stat-sub">{sub}</div>}
  </div>
);

const PillStat = ({ label, tone, items }) => (
  <div className="stat stat-pills">
    <div className={`stat-lbl lbl-${tone}`}>{label}</div>
    <div className="pills">
      {items.map(n => <Pill key={n} tone={tone}>{n}</Pill>)}
    </div>
  </div>
);

const MiniStat = ({ label, value, tone }) => (
  <div className="mini">
    <div className="mini-lbl">{label}</div>
    <div className={`mini-val t-${tone || 'ink'}`}>{value}</div>
  </div>
);

/* ── Home ───────────────────────────────────────────────────────────────── */
const HomeContent = () => (
  <>
    <section className="welcome">
      <div className="welcome-eye">Junio 2026 · Resumen ejecutivo</div>
      <h1 className="welcome-h1">Buenas tardes, Felipe.</h1>
      <p className="welcome-sub">Resumen de la firma al día de hoy.</p>
    </section>

    <section className="block">
      <div className="block-head">
        <h2 className="block-title">Clientes recurrentes</h2>
        <span className="block-sub">Junio 2026</span>
      </div>
      <div className="g5">
        <StatCard label="Total junio" value="42"/>
        <StatCard label="Crecimiento neto" value="+3" tone="green" sub="+7.7% vs mayo"/>
        <PillStat label="Entraron" tone="green" items={["Ferretería Acme","JM Bufete","Tech Quisqueya"]}/>
        <PillStat label="Salieron" tone="red" items={["Comercial Rivera"]}/>
        <StatCard label="Transacciones" value="1,847" sub="Adm: 1,623"/>
      </div>
    </section>

    <section className="block">
      <div className="block-head">
        <h2 className="block-title">Clientes software</h2>
        <span className="block-sub">Junio 2026</span>
      </div>
      <div className="g5">
        <StatCard label="Software actual" value="68" sub="Base 2026: 54"/>
        <StatCard label="Crecimiento último mes" value="+5" tone="green" sub="+8.1% vs mayo"/>
        <PillStat label="Nuevos en junio" tone="green" items={["Gómez & Co.","Bávaro Foods","RD Logistics","Café Altamira","Tropical Spa"]}/>
      </div>
    </section>

    <section className="block">
      <div className="block-head">
        <h2 className="block-title">Cierres equipo comercial</h2>
        <span className="block-sub">Junio 2026</span>
      </div>
      <div className="g5">
        <MiniStat label="Total leads"       value="184"/>
        <MiniStat label="Costo x lead"      value="US$ 45"   tone="amber"/>
        <MiniStat label="Cierres"           value="12"       tone="green"/>
        <MiniStat label="Costo adquisición" value="US$ 687"  tone="amber"/>
        <MiniStat label="% de cierre"       value="6.5%"     tone="green"/>
      </div>
      <div className="g5">
        <MiniStat label="Total cotizado" value="US$ 24,600" tone="sky"/>
        <MiniStat label="Total vendido"  value="US$ 18,400" tone="green"/>
        <MiniStat label="Invertido"      value="US$ 8,250"  tone="amber"/>
        <MiniStat label="Ganancia"       value="US$ 10,150" tone="green"/>
        <MiniStat label="ROAS"           value="2.23x"      tone="sky"/>
      </div>
    </section>
  </>
);

/* ── Work / Clientes ────────────────────────────────────────────────────── */
const WorkContent = () => {
  const meses = ["Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"];
  const bars = [
    { name:"María Pérez",    count:11, pct:26, tone:'sky' },
    { name:"Andrea Ramírez", count:10, pct:24, tone:'navy' },
    { name:"Luz Castillo",   count:9,  pct:21, tone:'green' },
    { name:"Karina Méndez",  count:7,  pct:17, tone:'amber' },
    { name:"Patricia Liz",   count:5,  pct:12, tone:'red' },
  ];
  const rows = [
    ["Ferretería Acme",         "M. Pérez",    "TaxOne", 92, "green","green","amber","Hoy"],
    ["Distribuidora del Cibao", "A. Ramírez",  "Adm",    78, "green","amber","gray", "Ayer"],
    ["JM Bufete & Asoc.",       "L. Castillo", "TaxOne",100, "green","green","green","Hace 2 días"],
    ["Tech Quisqueya SRL",      "K. Méndez",   "Adm",    54, "amber","amber","gray", "Hace 3 días"],
    ["Inversiones Bávaro",      "M. Pérez",    "TaxOne", 38, "red",  "gray", "gray", "Hace 5 días"],
    ["Comercial San Pedro",     "P. Liz",      "Adm",   100, "green","green","green","Hoy"],
  ];

  return (
    <>
      <div className="work-head">
        <div>
          <div className="work-eye">Clientes</div>
          <h1 className="work-h1">Cartera de contabilidad</h1>
          <p className="work-sub">42 clientes recurrentes · 5 contadoras · cierre del mes en <strong>18 días</strong></p>
        </div>
      </div>

      <div className="tabs">
        {["Dashboard","Contadoras","Detalle mensual","Implementaciones","Software"].map((t,i) => (
          <div key={t} className={`tab${i===0?' is-active':''}`}>{t}</div>
        ))}
      </div>

      <div className="months">
        {meses.map(m => (
          <span key={m} className={`mo${m==='Jun'?' is-active':''}`}>{m}</span>
        ))}
        <span className="mo-yr">2026</span>
      </div>

      <div className="work-stats">
        <StatCard label="Total clientes"      value="42"        sub="+3 este mes"/>
        <StatCard label="Reportes entregados" value="38"        tone="green" sub="90.5% del cierre"/>
        <StatCard label="En proceso"          value="3"         tone="amber"/>
        <StatCard label="Sin asignar"         value="1"         tone="red"/>
        <StatCard label="Facturación junio"   value="US$ 9,840" tone="navy"/>
      </div>

      <div className="panel">
        <div className="panel-head">
          <div>
            <div className="panel-eye">Distribución</div>
            <h3 className="panel-title">Carga por contadora</h3>
          </div>
          <div className="panel-meta">Total: 42 clientes</div>
        </div>
        <div className="bar-list">
          {bars.map(r => (
            <div className="bar-row" key={r.name}>
              <div className="bar-name">{r.name}</div>
              <div className="bar-track">
                <div className={`bar-fill bar-${r.tone}`} style={{width: r.pct+'%'}}>
                  <span>{r.count} clientes</span>
                </div>
              </div>
              <div className="bar-meta">{r.pct}%</div>
            </div>
          ))}
        </div>
      </div>

      <div className="panel">
        <div className="panel-head">
          <div>
            <div className="panel-eye">Estado del cierre · Junio</div>
            <h3 className="panel-title">Clientes este mes</h3>
          </div>
          <div className="panel-meta-row">
            <span className="legend"><Dot tone="green"/> Al día</span>
            <span className="legend"><Dot tone="amber"/> En proceso</span>
            <span className="legend"><Dot tone="red"/> Atrasado</span>
            <span className="legend"><Dot tone="gray"/> No aplica</span>
          </div>
        </div>
        <table className="wtable">
          <thead><tr>
            <th>Cliente</th><th>Contadora</th><th>Servicio</th>
            <th>Avance</th><th className="c">ITBIS</th>
            <th className="c">IR-17</th><th className="c">Cierre</th>
            <th>Última actividad</th>
          </tr></thead>
          <tbody>
            {rows.map(([cli,co,tipo,av,it,ir,ci,act]) => (
              <tr key={cli}>
                <td className="td-name">{cli}</td>
                <td className="td-muted">{co}</td>
                <td><span className={`tag tag-${tipo==='TaxOne'?'sky':'navy'}`}>{tipo}</span></td>
                <td>
                  <div className="prog-row">
                    <div className="prog"><div className="prog-fill" style={{width:av+'%'}}/></div>
                    <span className="prog-txt">{av}%</span>
                  </div>
                </td>
                <td className="td-c"><Dot tone={it}/></td>
                <td className="td-c"><Dot tone={ir}/></td>
                <td className="td-c"><Dot tone={ci}/></td>
                <td className="td-muted">{act}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
};

/* ── Placeholder for unbuilt modules ────────────────────────────────────── */
const PlaceholderContent = ({ nav }) => (
  <div className="placeholder">
    <div className="placeholder-icon"><Icon name={nav?.icon || 'grid'} size={56} sw={1.2}/></div>
    <h2>{nav?.label || 'Módulo'}</h2>
    <p>{nav?.desc || ''}</p>
  </div>
);

/* ── App ────────────────────────────────────────────────────────────────── */
function PortalApp() {
  const [view, setView] = useState('home');
  const navItem = NAV.find(n => n.id === view);
  const trail = view === 'home'
    ? ['Inicio']
    : ['Inicio', navItem?.label || 'Configuración'];

  const topActions = (
    <>
      <button className="top-btn"><Icon name="download" size={13}/> Exportar</button>
      <button className="top-btn"><Icon name="filter" size={13}/> Filtros</button>
    </>
  );

  return (
    <div className="sh">
      <Sidebar activeId={view} onNav={setView}/>
      <div className="main">
        <Topbar trail={trail} actions={topActions}/>
        <div className="page">
          {view === 'home' ? <HomeContent/> :
           view === 'clientes' ? <WorkContent/> :
           <PlaceholderContent nav={navItem || { icon:'settings', label:'Usuarios y permisos', desc:'Roles y acceso al portal' }}/>}
        </div>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<PortalApp/>);

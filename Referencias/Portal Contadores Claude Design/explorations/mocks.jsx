// Theme-agnostic markup. Same DOM gets restyled per theme via the .theme-X wrapper.
// Icon comes from window.Icon (icons.jsx loaded first).

const NAV = [
  { id:'home', icon:'home', label:'Inicio', active:true },
  { id:'clientes', icon:'building', label:'Clientes' },
  { id:'comercial', icon:'trending', label:'Comercial' },
  { id:'conta', icon:'target', label:'Contabilidad' },
  { id:'imp', icon:'receipt', label:'Impuestos', badge:'4' },
  { id:'impl', icon:'rocket', label:'Implementaciones' },
  { id:'portal', icon:'globe', label:'Portal clientes' },
  { id:'personal', icon:'star', label:'Personal' },
];

const Sidebar = ({ activeId='home' }) => (
  <aside className="sh-side">
    <div className="sh-brand">
      <div className="sh-brand-mark">
        {/* Simplified lotus glyph */}
        <svg viewBox="0 0 28 28" width="20" height="20" fill="currentColor">
          <path d="M14 3c-1.5 3.5-4 6-7.5 7.5 3.5 1.5 6 4 7.5 7.5 1.5-3.5 4-6 7.5-7.5C18 9 15.5 6.5 14 3z" opacity=".95"/>
          <path d="M14 11c-.8 2-2.3 3.5-4.3 4.3 2 .8 3.5 2.3 4.3 4.3.8-2 2.3-3.5 4.3-4.3-2-.8-3.5-2.3-4.3-4.3z" opacity=".55"/>
        </svg>
      </div>
      <div className="sh-brand-text">
        <div className="sh-brand-name">Account One</div>
        <div className="sh-brand-tag">Portal interno</div>
      </div>
    </div>
    <nav className="sh-nav">
      {NAV.map(n => (
        <div key={n.id} className={`sh-nav-item${n.id===activeId ? ' is-active':''}`}>
          <span className="sh-nav-icon"><Icon name={n.icon} size={16}/></span>
          <span className="sh-nav-label">{n.label}</span>
          {n.badge && <span className="sh-nav-badge">{n.badge}</span>}
        </div>
      ))}
      <div className="sh-nav-section">Configuración</div>
      <div className="sh-nav-item">
        <span className="sh-nav-icon"><Icon name="settings" size={16}/></span>
        <span className="sh-nav-label">Usuarios y permisos</span>
      </div>
    </nav>
    <div className="sh-user">
      <div className="sh-user-avatar">FB</div>
      <div className="sh-user-info">
        <div className="sh-user-name">Felipe Báez</div>
        <div className="sh-user-role">Administrador</div>
      </div>
      <button className="sh-user-out" title="Salir"><Icon name="logout" size={14}/></button>
    </div>
    <div className="sh-version">v1.04 · Portal Account One</div>
  </aside>
);

const Topbar = ({ trail }) => (
  <header className="sh-top">
    <div className="sh-top-trail">
      {trail.map((t,i) => (
        <React.Fragment key={i}>
          {i>0 && <span className="sh-top-sep">/</span>}
          <span className={i===trail.length-1 ? 'sh-top-current' : 'sh-top-crumb'}>{t}</span>
        </React.Fragment>
      ))}
    </div>
    <div className="sh-top-meta">
      <span className="sh-top-date">Jueves 4 de junio, 2026</span>
      <button className="sh-top-icon" title="Notificaciones"><Icon name="bell" size={15}/><span className="sh-top-dot"/></button>
      <div className="sh-top-avatar">FB</div>
    </div>
  </header>
);

// ─── HOME ──────────────────────────────────────────────────────────────────
const Pill = ({ children, tone }) => <span className={`pill pill-${tone}`}>{children}</span>;

const StatCard = ({ label, value, valueTone, sub, trend }) => (
  <div className="stat">
    <div className="stat-label">{label}</div>
    <div className={`stat-value tone-${valueTone||'ink'}`}>{value}</div>
    {sub && <div className="stat-sub">{sub}</div>}
    {trend && <div className={`stat-trend trend-${trend.dir}`}>{trend.dir==='up'?'↑':'↓'} {trend.val}</div>}
  </div>
);

const PillStat = ({ label, tone, items }) => (
  <div className="stat stat-pills">
    <div className={`stat-label label-${tone}`}>{label}</div>
    <div className="stat-pills-list">
      {items.map(n => <Pill key={n} tone={tone}>{n}</Pill>)}
    </div>
  </div>
);

const MiniStat = ({ label, value, tone }) => (
  <div className="mini">
    <div className="mini-label">{label}</div>
    <div className={`mini-value tone-${tone||'ink'}`}>{value}</div>
  </div>
);

const HomeView = () => (
  <>
    <Topbar trail={['Inicio']}/>
    <div className="page page-home">
      <section className="welcome">
        <div className="welcome-eyebrow">Junio 2026 · Resumen ejecutivo</div>
        <h1 className="welcome-title">Buenas tardes, Felipe.</h1>
        <p className="welcome-sub">Resumen de la firma al día de hoy.</p>
      </section>

      <section className="block">
        <div className="block-head">
          <h2 className="block-title">Clientes recurrentes</h2>
          <span className="block-sub">Junio 2026</span>
        </div>
        <div className="grid-5">
          <StatCard label="Total junio" value="42"/>
          <StatCard label="Crecimiento neto" value="+3" valueTone="green" sub="+7.7% vs mayo"/>
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
        <div className="grid-5">
          <StatCard label="Software actual" value="68" sub="Base 2026: 54"/>
          <StatCard label="Crecimiento último mes" value="+5" valueTone="green" sub="+8.1% vs mayo"/>
          <PillStat label="Nuevos en junio" tone="green" items={["Gómez & Co.","Bávaro Foods","RD Logistics","Café Altamira","Tropical Spa"]}/>
        </div>
      </section>

      <section className="block">
        <div className="block-head">
          <h2 className="block-title">Cierres equipo comercial</h2>
          <span className="block-sub">Junio 2026</span>
        </div>
        <div className="grid-5 grid-mini">
          <MiniStat label="Total leads"      value="184"/>
          <MiniStat label="Costo x lead"     value="US$ 45"   tone="amber"/>
          <MiniStat label="Cierres"          value="12"       tone="green"/>
          <MiniStat label="Costo adquisición" value="US$ 687" tone="amber"/>
          <MiniStat label="% de cierre"      value="6.5%"     tone="green"/>
        </div>
        <div className="grid-5 grid-mini">
          <MiniStat label="Total cotizado" value="US$ 24,600" tone="sky"/>
          <MiniStat label="Total vendido"  value="US$ 18,400" tone="green"/>
          <MiniStat label="Invertido"      value="US$ 8,250"  tone="amber"/>
          <MiniStat label="Ganancia"       value="US$ 10,150" tone="green"/>
          <MiniStat label="ROAS"           value="2.23x"      tone="sky"/>
        </div>
      </section>
    </div>
  </>
);

// ─── WORK SCREEN (Clientes / Gerencia) ────────────────────────────────────
const Dot = ({ tone }) => <span className={`dot dot-${tone}`}/>;

const WorkView = () => {
  const meses = ["Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"];
  const bars = [
    { name: "María Pérez",     count: 11, pct: 26, tone: 'sky' },
    { name: "Andrea Ramírez",  count: 10, pct: 24, tone: 'navy' },
    { name: "Luz Castillo",    count:  9, pct: 21, tone: 'green' },
    { name: "Karina Méndez",   count:  7, pct: 17, tone: 'amber' },
    { name: "Patricia Liz",    count:  5, pct: 12, tone: 'red' },
  ];
  const rows = [
    ["Ferretería Acme",         "M. Pérez",    "TaxOne",  92, "green","green","amber", "Hoy"],
    ["Distribuidora del Cibao", "A. Ramírez",  "Adm",     78, "green","amber","gray",  "Ayer"],
    ["JM Bufete & Asoc.",       "L. Castillo", "TaxOne", 100, "green","green","green", "Hace 2 días"],
    ["Tech Quisqueya SRL",      "K. Méndez",   "Adm",     54, "amber","amber","gray",  "Hace 3 días"],
    ["Inversiones Bávaro",      "M. Pérez",    "TaxOne",  38, "red",  "gray", "gray",  "Hace 5 días"],
    ["Comercial San Pedro",     "P. Liz",      "Adm",    100, "green","green","green", "Hoy"],
  ];
  return (
    <>
      <Topbar trail={['Inicio','Clientes']}/>
      <div className="page page-work">
        <div className="work-head">
          <div className="work-head-l">
            <div className="work-eyebrow">Clientes</div>
            <h1 className="work-title">Cartera de contabilidad</h1>
            <p className="work-sub">42 clientes recurrentes · 5 contadoras · cierre del mes en <strong>18 días</strong></p>
          </div>
          <div className="work-head-r">
            <button className="btn btn-ghost"><Icon name="download" size={14}/> Exportar</button>
            <button className="btn btn-ghost"><Icon name="filter" size={14}/> Filtros</button>
            <button className="btn btn-primary"><Icon name="plus" size={14}/> Nuevo cliente</button>
          </div>
        </div>

        <div className="work-tabs">
          {["Dashboard","Contadoras","Detalle mensual","Implementaciones","Software"].map((t,i)=>(
            <div key={t} className={`work-tab${i===0?' is-active':''}`}>{t}</div>
          ))}
        </div>

        <div className="work-monthrow">
          {meses.map(m => (
            <span key={m} className={`month-pill${m==='Jun'?' is-active':''}`}>{m}</span>
          ))}
          <span className="work-monthrow-year">2026</span>
        </div>

        <div className="work-stats">
          <StatCard label="Total clientes"        value="42"        sub="+3 este mes"/>
          <StatCard label="Reportes entregados"   value="38"        valueTone="green" sub="90.5% del cierre"/>
          <StatCard label="En proceso"            value="3"         valueTone="amber"/>
          <StatCard label="Sin asignar"           value="1"         valueTone="red"/>
          <StatCard label="Facturación junio"     value="US$ 9,840" valueTone="navy"/>
        </div>

        <div className="work-panel">
          <div className="panel-head">
            <div>
              <div className="panel-eyebrow">Distribución</div>
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

        <div className="work-panel">
          <div className="panel-head">
            <div>
              <div className="panel-eyebrow">Estado del cierre · Junio</div>
              <h3 className="panel-title">Clientes este mes</h3>
            </div>
            <div className="panel-meta-row">
              <span className="legend"><Dot tone="green"/> Al día</span>
              <span className="legend"><Dot tone="amber"/> En proceso</span>
              <span className="legend"><Dot tone="red"/> Atrasado</span>
              <span className="legend"><Dot tone="gray"/> No aplica</span>
            </div>
          </div>
          <table className="work-table">
            <thead><tr>
              <th>Cliente</th>
              <th>Contadora</th>
              <th>Servicio</th>
              <th>Avance</th>
              <th className="th-c">ITBIS</th>
              <th className="th-c">IR-17</th>
              <th className="th-c">Cierre</th>
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
                      <div className="prog"><div className="prog-fill" style={{width: av+'%'}}/></div>
                      <span className="prog-text">{av}%</span>
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
      </div>
    </>
  );
};

// Wrapper used by every artboard
const PortalMock = ({ view='home' }) => (
  <div className="sh-root">
    <Sidebar activeId={view==='home' ? 'home' : 'clientes'}/>
    <div className="sh-main">
      {view==='home' ? <HomeView/> : <WorkView/>}
    </div>
  </div>
);

Object.assign(window, { Sidebar, Topbar, HomeView, WorkView, PortalMock });

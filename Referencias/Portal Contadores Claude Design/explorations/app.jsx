// Mounts the design canvas with 6 artboards: 3 directions x 2 views.

const { DesignCanvas, DCSection, DCArtboard, DCPostIt } = window;

function ExplorationApp() {
  return (
    <DesignCanvas>
      <DCSection
        id="shell-home"
        title="Shell + Inicio"
        subtitle="Sidebar, topbar y dashboard de bienvenida"
      >
        <DCArtboard id="a-home" label="A · Refinado" width={1280} height={900}>
          <div className="theme-a"><PortalMock view="home"/></div>
        </DCArtboard>
        <DCArtboard id="b-home" label="B · Claro" width={1280} height={900}>
          <div className="theme-b"><PortalMock view="home"/></div>
        </DCArtboard>
        <DCArtboard id="c-home" label="C · Editorial" width={1280} height={900}>
          <div className="theme-c"><PortalMock view="home"/></div>
        </DCArtboard>
      </DCSection>

      <DCSection
        id="work"
        title="Pantalla de trabajo · Clientes"
        subtitle="Tabs, filtros mensuales, KPIs y tabla operativa con semáforos"
      >
        <DCArtboard id="a-work" label="A · Refinado" width={1280} height={1140}>
          <div className="theme-a"><PortalMock view="work"/></div>
        </DCArtboard>
        <DCArtboard id="b-work" label="B · Claro" width={1280} height={1140}>
          <div className="theme-b"><PortalMock view="work"/></div>
        </DCArtboard>
        <DCArtboard id="c-work" label="C · Editorial" width={1280} height={1140}>
          <div className="theme-c"><PortalMock view="work"/></div>
        </DCArtboard>
      </DCSection>
    </DesignCanvas>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<ExplorationApp/>);

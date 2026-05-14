export default function Sidebar() {
  const links = [
    { id: 'kpis',      label: 'KPI Summary' },
    { id: 'revenue',   label: 'Revenue Trends' },
    { id: 'customers', label: 'Customer Analysis' },
    { id: 'products',  label: 'Product Performance' },
    { id: 'insights',  label: 'Business Insights' },
  ]

  const upcoming = ['Segmentation ML', 'Forecasting', 'GenAI Bot']

  return (
    <aside style={{
      position: 'fixed', left: 0, top: 0, bottom: 0, width: 220,
      background: 'var(--bg2)', borderRight: '1px solid var(--border)',
      display: 'flex', flexDirection: 'column', padding: '1.5rem 0', zIndex: 100
    }}>
      {/* Logo */}
      <div style={{ padding: '0 1.25rem 1.5rem', borderBottom: '1px solid var(--border)', marginBottom: '1rem' }}>
        <div style={{ fontSize: 14, fontWeight: 600 }}>🛒 EcomAnalytics</div>
        <div style={{ fontSize: 11, color: 'var(--text3)', fontFamily: 'DM Mono', marginTop: 2 }}>SQL Project · 2023–2024</div>
      </div>

      {/* Nav Links */}
      <div style={{ padding: '0 0.75rem', marginBottom: '0.25rem' }}>
        <div style={{ fontSize: 10, fontWeight: 500, color: 'var(--text3)', letterSpacing: '0.08em', textTransform: 'uppercase', padding: '0 0.5rem', marginBottom: '0.25rem' }}>
          Overview
        </div>
        {links.map(link => (
          <a key={link.id} href={`#${link.id}`} style={{
            display: 'flex', alignItems: 'center', gap: 8,
            padding: '7px 10px', borderRadius: 'var(--radius-sm)',
            fontSize: 13, color: 'var(--text2)', textDecoration: 'none',
            transition: 'all 0.15s', marginBottom: 2
          }}
          onMouseEnter={e => { e.currentTarget.style.background = 'var(--bg3)'; e.currentTarget.style.color = 'var(--text)' }}
          onMouseLeave={e => { e.currentTarget.style.background = 'transparent'; e.currentTarget.style.color = 'var(--text2)' }}
          >
            <span style={{ width: 6, height: 6, borderRadius: '50%', background: 'var(--blue)', opacity: 0.7 }} />
            {link.label}
          </a>
        ))}
      </div>

      {/* Upcoming */}
      <div style={{ padding: '0 0.75rem', marginTop: '1rem' }}>
        <div style={{ fontSize: 10, fontWeight: 500, color: 'var(--text3)', letterSpacing: '0.08em', textTransform: 'uppercase', padding: '0 0.5rem', marginBottom: '0.25rem' }}>
          Pipeline
        </div>
        {upcoming.map(item => (
          <div key={item} style={{
            display: 'flex', alignItems: 'center', gap: 8,
            padding: '7px 10px', fontSize: 13, color: 'var(--text3)', opacity: 0.5
          }}>
            <span style={{ width: 6, height: 6, borderRadius: '50%', background: 'var(--text3)' }} />
            {item}
          </div>
        ))}
      </div>

      {/* Footer */}
      <div style={{ marginTop: 'auto', padding: '1rem 1.25rem', borderTop: '1px solid var(--border)' }}>
        <span style={{
          fontSize: 11, fontFamily: 'DM Mono', color: 'var(--green)',
          background: 'var(--green-dim)', border: '1px solid rgba(62,207,142,0.2)',
          padding: '4px 10px', borderRadius: 99, display: 'inline-block'
        }}>Project 1 of 4</span>
        <div style={{ fontSize: 11, color: 'var(--text3)', marginTop: 8 }}>Priti · PCU Pune</div>
      </div>
    </aside>
  )
}
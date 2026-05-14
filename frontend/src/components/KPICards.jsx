import { useApi } from '../hooks/useApi'

const cards = [
  { key: 'total_revenue',     label: 'Total Revenue',     color: 'var(--blue)',   format: v => `₹${(v/100000).toFixed(1)}L`,  change: '↑ 34% YoY growth',    up: true  },
  { key: 'total_orders',      label: 'Total Orders',      color: 'var(--green)',  format: v => v,                              change: '↑ 28% vs 2023',       up: true  },
  { key: 'active_customers',  label: 'Active Customers',  color: 'var(--amber)',  format: v => v,                              change: '100% retention',      up: true  },
  { key: 'avg_order_value',   label: 'Avg Order Value',   color: 'var(--purple)', format: v => `₹${(v/1000).toFixed(1)}K`,    change: '↑ 12% increase',      up: true  },
  { key: 'cancellation_rate', label: 'Cancellation Rate', color: 'var(--red)',    format: v => `${v}%`,                        change: 'Mostly COD orders',   up: false },
]

export default function KPICards() {
  const { data, loading } = useApi('/kpis')

  return (
    <section id="kpis" style={{ marginBottom: '2rem' }}>
      <div style={{ fontSize: 11, fontWeight: 500, color: 'var(--text3)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: '1rem' }}>
        Key metrics
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5,1fr)', gap: 12 }}>
        {cards.map(card => (
          <div key={card.key} style={{
            background: 'var(--bg2)', border: '1px solid var(--border)',
            borderRadius: 'var(--radius)', padding: '1.25rem',
            borderTop: `2px solid ${card.color}`, transition: 'border-color 0.2s'
          }}>
            <div style={{ fontSize: 11, color: 'var(--text3)', marginBottom: 4 }}>{card.label}</div>
            <div style={{ fontSize: 24, fontWeight: 600, letterSpacing: '-0.02em', marginBottom: 6 }}>
              {loading ? '...' : data ? card.format(data[card.key]) : '--'}
            </div>
            <div style={{ fontSize: 12, color: card.up ? 'var(--green)' : 'var(--text3)' }}>
              {card.change}
            </div>
          </div>
        ))}
      </div>
    </section>
  )
}
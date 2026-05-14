const insights = [
  { icon: '📈', text: 'Revenue grew 34% YoY — Q4 (Oct–Dec) peaks due to festive season. Increase inventory 2 months before Diwali.', color: 'var(--green)' },
  { icon: '💳', text: 'UPI dominates at 45% of payments. COD has highest cancellation rate — discourage for high-value orders.', color: 'var(--blue)' },
  { icon: '💻', text: 'Apple products generate 30%+ profit margins — focus marketing during salary credit week (1st–5th of month).', color: 'var(--purple)' },
  { icon: '👑', text: 'Top 20% customers (Champions + Loyal) contribute 60%+ revenue — implement loyalty program for these 14 users.', color: 'var(--amber)' },
  { icon: '🗺️', text: 'Maharashtra + Delhi = 56% of revenue. Karnataka is next growth opportunity — run targeted Bangalore campaigns.', color: 'var(--amber)' },
  { icon: '⚠️', text: '6 At-Risk customers identified via RFM — last purchase 180+ days ago. Send win-back email with 10% discount.', color: 'var(--red)' },
]

export default function Insights() {
  return (
    <section id="insights" style={{ marginBottom: '2rem' }}>
      <div style={{ fontSize: 11, fontWeight: 500, color: 'var(--text3)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: '1rem' }}>
        Business insights from SQL analysis
      </div>
      <div style={{ background: 'var(--bg2)', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '1.5rem' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          {insights.map((ins, i) => (
            <div key={i} style={{ display: 'flex', gap: 12, alignItems: 'flex-start', background: 'var(--bg3)', borderRadius: 'var(--radius-sm)', padding: '10px 14px', fontSize: 13, color: 'var(--text2)', lineHeight: 1.6 }}>
              <span style={{ fontSize: 16, flexShrink: 0 }}>{ins.icon}</span>
              <span>{ins.text}</span>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
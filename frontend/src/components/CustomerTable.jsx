import { useApi } from '../hooks/useApi'

const tiers = ['Champion','Champion','Loyal','Loyal','Potential']
const tierColors = { Champion: 'var(--blue)', Loyal: 'var(--green)', Potential: 'var(--amber)' }
const tierBg    = { Champion: 'var(--blue-dim)', Loyal: 'var(--green-dim)', Potential: 'var(--amber-dim)' }

export default function CustomerTable() {
  const { data, loading } = useApi('/customers/top')

  return (
    <div style={{ background: 'var(--bg2)', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '1.5rem' }}>
      <div style={{ fontSize: 13, fontWeight: 500, marginBottom: '1.25rem' }}>Top 5 customers by lifetime value</div>
      {loading ? <div style={{ color: 'var(--text3)', fontSize: 13 }}>Loading...</div> : (
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              {['#','Customer','City','Orders','Total Spent','Tier'].map(h => (
                <th key={h} style={{ fontSize: 11, fontWeight: 500, color: 'var(--text3)', textAlign: 'left', padding: '8px 12px', borderBottom: '1px solid var(--border)', textTransform: 'uppercase', letterSpacing: '0.04em' }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {data?.map((row, i) => (
              <tr key={i} style={{ borderBottom: '1px solid var(--border)' }}>
                <td style={{ padding: '10px 12px', fontSize: 12, color: 'var(--text3)', fontFamily: 'DM Mono' }}>0{i+1}</td>
                <td style={{ padding: '10px 12px', fontSize: 13, fontWeight: 500 }}>{row.name}</td>
                <td style={{ padding: '10px 12px', fontSize: 13, color: 'var(--text2)' }}>{row.city}</td>
                <td style={{ padding: '10px 12px', fontSize: 13, color: 'var(--text2)' }}>{row.total_orders}</td>
                <td style={{ padding: '10px 12px', fontSize: 13, fontFamily: 'DM Mono', fontWeight: 500 }}>₹{Number(row.total_spent).toLocaleString('en-IN')}</td>
                <td style={{ padding: '10px 12px' }}>
                  <span style={{ fontSize: 11, fontWeight: 500, padding: '3px 10px', borderRadius: 99, background: tierBg[tiers[i]], color: tierColors[tiers[i]] }}>
                    {tiers[i]}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}
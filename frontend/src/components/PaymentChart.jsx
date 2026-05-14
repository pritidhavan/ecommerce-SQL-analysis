import { useApi } from '../hooks/useApi'
import { PieChart, Pie, Cell, Tooltip, ResponsiveContainer } from 'recharts'

const COLORS = ['#4f8ef7','#3ecf8e','#f5a524','#f16464','#a78bfa']

export default function PaymentChart() {
  const { data, loading } = useApi('/revenue/payments')

  return (
    <div style={{ background: 'var(--bg2)', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '1.5rem' }}>
      <div style={{ fontSize: 13, fontWeight: 500, marginBottom: '1.25rem' }}>Payment method distribution</div>
      {loading ? <div style={{ color: 'var(--text3)', fontSize: 13 }}>Loading...</div> : (
        <>
          <ResponsiveContainer width="100%" height={180}>
            <PieChart>
              <Pie data={data} dataKey="percentage" nameKey="payment_method" cx="50%" cy="50%" innerRadius={50} outerRadius={80}>
                {data?.map((_, i) => <Cell key={i} fill={COLORS[i % COLORS.length]} />)}
              </Pie>
              <Tooltip
                contentStyle={{ background: 'var(--bg3)', border: '1px solid var(--border2)', borderRadius: 8, fontSize: 12 }}
                formatter={v => [`${v}%`]}
              />
            </PieChart>
          </ResponsiveContainer>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10, marginTop: 8 }}>
            {data?.map((item, i) => (
              <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 11, color: 'var(--text2)' }}>
                <span style={{ width: 10, height: 10, borderRadius: 2, background: COLORS[i] }} />
                {item.payment_method} {item.percentage}%
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  )
}
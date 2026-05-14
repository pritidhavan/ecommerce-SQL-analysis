import { useApi } from '../hooks/useApi'
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Legend } from 'recharts'

export default function RevenueChart() {
  const { data, loading } = useApi('/revenue/monthly')

  const formatted = data?.map(row => ({
    month: row.month_name.slice(0, 3),
    '2023': parseFloat((row.rev_2023 / 100000).toFixed(2)),
    '2024': parseFloat((row.rev_2024 / 100000).toFixed(2)),
  }))

  return (
    <div style={{ background: 'var(--bg2)', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '1.5rem' }}>
      <div style={{ fontSize: 13, fontWeight: 500, marginBottom: '1.25rem' }}>Monthly revenue — 2023 vs 2024</div>
      {loading ? <div style={{ color: 'var(--text3)', fontSize: 13 }}>Loading...</div> : (
        <ResponsiveContainer width="100%" height={220}>
          <BarChart data={formatted} barGap={2}>
            <XAxis dataKey="month" tick={{ fill: '#8b90a0', fontSize: 11 }} axisLine={false} tickLine={false} />
            <YAxis tick={{ fill: '#8b90a0', fontSize: 11 }} axisLine={false} tickLine={false} tickFormatter={v => `₹${v}L`} />
            <Tooltip
              contentStyle={{ background: 'var(--bg3)', border: '1px solid var(--border2)', borderRadius: 8, fontSize: 12 }}
              formatter={v => [`₹${v}L`]}
            />
            <Bar dataKey="2023" fill="#4f8ef7" radius={[3,3,0,0]} barSize={14} />
            <Bar dataKey="2024" fill="#3ecf8e" radius={[3,3,0,0]} barSize={14} />
          </BarChart>
        </ResponsiveContainer>
      )}
    </div>
  )
}
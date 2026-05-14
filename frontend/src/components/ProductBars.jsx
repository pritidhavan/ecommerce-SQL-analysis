import { useApi } from '../hooks/useApi'

export default function ProductBars() {
  const { data: products, loading: p1 } = useApi('/products/top')
  const { data: categories, loading: p2 } = useApi('/products/categories')

  const maxP = products ? Math.max(...products.map(p => p.revenue)) : 1
  const maxC = categories ? Math.max(...categories.map(c => c.revenue)) : 1

  const BarRow = ({ label, value, max, color }) => (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
      <span style={{ fontSize: 12, color: 'var(--text2)', width: 110, flexShrink: 0, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{label}</span>
      <div style={{ flex: 1, height: 20, background: 'var(--bg3)', borderRadius: 4, overflow: 'hidden' }}>
        <div style={{ width: `${(value/max)*100}%`, height: '100%', background: color, borderRadius: 4, display: 'flex', alignItems: 'center', paddingLeft: 8 }}>
          <span style={{ fontSize: 11, fontWeight: 500, color: '#0d0f14', fontFamily: 'DM Mono' }}>
            ₹{(value/100000).toFixed(1)}L
          </span>
        </div>
      </div>
    </div>
  )

  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
      <div style={{ background: 'var(--bg2)', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '1.5rem' }}>
        <div style={{ fontSize: 13, fontWeight: 500, marginBottom: '1.25rem' }}>Top products by revenue</div>
        {p1 ? <div style={{ color: 'var(--text3)', fontSize: 13 }}>Loading...</div> :
          products?.map((p, i) => <BarRow key={i} label={p.product_name} value={p.revenue} max={maxP} color={i < 3 ? '#4f8ef7' : i < 5 ? '#3ecf8e' : '#f5a524'} />)
        }
      </div>
      <div style={{ background: 'var(--bg2)', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '1.5rem' }}>
        <div style={{ fontSize: 13, fontWeight: 500, marginBottom: '1.25rem' }}>Revenue by category</div>
        {p2 ? <div style={{ color: 'var(--text3)', fontSize: 13 }}>Loading...</div> :
          categories?.map((c, i) => <BarRow key={i} label={c.category_name} value={c.revenue} max={maxC} color={i < 2 ? '#4f8ef7' : i < 4 ? '#3ecf8e' : '#f5a524'} />)
        }
      </div>
    </div>
  )
}
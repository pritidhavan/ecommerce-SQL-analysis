const segments = [
  { title: 'Champions',  desc: 'Buy often, spend most',      count: 6,  cls: 'blue'   },
  { title: 'Loyal',      desc: 'High frequency buyers',      count: 8,  cls: 'green'  },
  { title: 'Potential',  desc: 'Growing spend trend',        count: 10, cls: 'amber'  },
  { title: 'At Risk',    desc: 'Inactive high spenders',     count: 6,  cls: 'red'    },
]

const colors = {
  blue:  { bg: 'var(--blue-dim)',   border: 'rgba(79,142,247,0.2)',   text: 'var(--blue)'   },
  green: { bg: 'var(--green-dim)',  border: 'rgba(62,207,142,0.2)',   text: 'var(--green)'  },
  amber: { bg: 'var(--amber-dim)',  border: 'rgba(245,165,36,0.2)',   text: 'var(--amber)'  },
  red:   { bg: 'var(--red-dim)',    border: 'rgba(241,100,100,0.2)',  text: 'var(--red)'    },
}

export default function RFMSegments() {
  return (
    <div style={{ background: 'var(--bg2)', border: '1px solid var(--border)', borderRadius: 'var(--radius)', padding: '1.5rem' }}>
      <div style={{ fontSize: 13, fontWeight: 500, marginBottom: '1.25rem' }}>RFM segmentation</div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
        {segments.map(seg => {
          const c = colors[seg.cls]
          return (
            <div key={seg.title} style={{ background: c.bg, border: `1px solid ${c.border}`, borderRadius: 'var(--radius-sm)', padding: '1rem' }}>
              <div style={{ fontSize: 13, fontWeight: 600, color: c.text, marginBottom: 2 }}>{seg.title}</div>
              <div style={{ fontSize: 11, color: 'var(--text3)', marginBottom: 8 }}>{seg.desc}</div>
              <div style={{ fontSize: 22, fontWeight: 600, color: c.text }}>{seg.count}</div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
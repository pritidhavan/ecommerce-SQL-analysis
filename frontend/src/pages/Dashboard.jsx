import Sidebar       from '../components/Sidebar'
import KPICards      from '../components/KPICards'
import RevenueChart  from '../components/RevenueChart'
import PaymentChart  from '../components/PaymentChart'
import CustomerTable from '../components/CustomerTable'
import RFMSegments   from '../components/RFMSegments'
import ProductBars   from '../components/ProductBars'
import Insights      from '../components/Insights'

export default function Dashboard() {
  return (
    <div style={{ display: 'flex' }}>
      <Sidebar />

      <main style={{ marginLeft: 220, minHeight: '100vh', width: '100%' }}>
        {/* Topbar */}
        <header style={{
          background: 'var(--bg2)', borderBottom: '1px solid var(--border)',
          padding: '1rem 2rem', display: 'flex', alignItems: 'center',
          justifyContent: 'space-between', position: 'sticky', top: 0, zIndex: 50
        }}>
          <div style={{ fontSize: 15, fontWeight: 500 }}>E-Commerce Analytics Dashboard</div>
          <div style={{ fontSize: 12, color: 'var(--text3)', fontFamily: 'DM Mono' }}>
            <span style={{ display: 'inline-block', width: 7, height: 7, borderRadius: '50%', background: 'var(--green)', boxShadow: '0 0 6px var(--green)', marginRight: 6 }} />
            MySQL · 120 orders · 30 customers
          </div>
        </header>

        {/* Content */}
        <div style={{ padding: '2rem' }}>
          <KPICards />

          <div style={{ fontSize: 11, fontWeight: 500, color: 'var(--text3)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: '1rem' }}>
            Revenue trends
          </div>
          <section id="revenue" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginBottom: '1.5rem' }}>
            <RevenueChart />
            <PaymentChart />
          </section>

          <div style={{ fontSize: 11, fontWeight: 500, color: 'var(--text3)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: '1rem' }}>
            Customer analysis
          </div>
          <section id="customers" style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 16, marginBottom: '1.5rem' }}>
            <CustomerTable />
            <RFMSegments />
          </section>

          <div style={{ fontSize: 11, fontWeight: 500, color: 'var(--text3)', letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: '1rem' }}>
            Product performance
          </div>
          <section id="products" style={{ marginBottom: '1.5rem' }}>
            <ProductBars />
          </section>

          <Insights />

          <div style={{ textAlign: 'center', padding: '1.5rem 0', fontSize: 12, color: 'var(--text3)', borderTop: '1px solid var(--border)' }}>
            E-Commerce SQL Analysis · Project 1 of 4 · Priti · B.Tech AI & DS · PCU Pune
          </div>
        </div>
      </main>
    </div>
  )
}
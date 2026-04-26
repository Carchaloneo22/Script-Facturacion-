/* =========================================================
   FACTURACIÓN · script.js
   Conecta la UI con los endpoints PHP del módulo de facturación.
   ========================================================= */

/* ---------- Configuración ---------- */
const API_BASE = './api/';   // ⚙️  ajusta esta ruta si tu API está en otro lugar
const API = {
  listar:       API_BASE + 'listar_facturas.php',
  obtener:      API_BASE + 'obtener_factura.php',
  crearCert:    API_BASE + 'crear_factura_certificado.php',
  anular:       API_BASE + 'anular_factura.php',
  inscPagables: API_BASE + 'listar_inscripciones_pagables.php',
};

/* ---------- Estado global ---------- */
const state = {
  filtros: { tipo: '', estado: '', desde: '', hasta: '', q: '', limit: 25, offset: 0 },
  inscSeleccionada: null,
  ultimaListado: [],
  facturaParaAnular: null,
};

/* =========================================================
   UTILIDADES
   ========================================================= */

const $  = (sel, ctx = document) => ctx.querySelector(sel);
const $$ = (sel, ctx = document) => Array.from(ctx.querySelectorAll(sel));

const formatoCOP = new Intl.NumberFormat('es-CO', {
  style: 'currency',
  currency: 'COP',
  minimumFractionDigits: 0,
  maximumFractionDigits: 0,
});

const formatoFecha = (val) => {
  if (!val) return '—';
  try {
    const d = new Date(val);
    if (isNaN(d)) return val;
    return d.toLocaleDateString('es-CO', { day: '2-digit', month: 'short', year: 'numeric' });
  } catch { return val; }
};

const fmtMoney = (v) => {
  const n = Number(v ?? 0);
  return isNaN(n) ? '—' : formatoCOP.format(n);
};

/** Acceso seguro a campos con varios nombres posibles (defensivo ante backend) */
const pick = (obj, ...keys) => {
  if (!obj) return undefined;
  for (const k of keys) {
    if (obj[k] !== undefined && obj[k] !== null && obj[k] !== '') return obj[k];
  }
  return undefined;
};

const escapeHtml = (str) => String(str ?? '')
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
  .replace(/"/g, '&quot;').replace(/'/g, '&#39;');

/* ---------- Toasts ---------- */
function toast(msg, tipo = 'info') {
  const wrap = $('#toastWrap');
  const el = document.createElement('div');
  el.className = `toast ${tipo}`;
  el.textContent = msg;
  wrap.appendChild(el);
  setTimeout(() => {
    el.style.transition = 'opacity .3s, transform .3s';
    el.style.opacity = '0';
    el.style.transform = 'translateX(40px)';
    setTimeout(() => el.remove(), 320);
  }, 3500);
}

/* ---------- Fetch helper ---------- */
async function api(url, opts = {}) {
  try {
    const res = await fetch(url, {
      headers: { 'Accept': 'application/json', ...(opts.headers || {}) },
      ...opts,
    });
    const txt = await res.text();
    let data;
    try { data = JSON.parse(txt); }
    catch { throw new Error('Respuesta no válida del servidor.'); }
    if (!res.ok || data.success === false) {
      throw new Error(data.message || 'Error al procesar la solicitud.');
    }
    return data;
  } catch (e) {
    console.error('[api]', url, e);
    throw e;
  }
}

/* =========================================================
   NAVEGACIÓN
   ========================================================= */
function setView(name) {
  $$('.view').forEach(v => v.classList.toggle('active', v.id === `view-${name}`));
  $$('.nav-item').forEach(b => b.classList.toggle('active', b.dataset.view === name));
  document.body.classList.remove('menu-open');
  $('#sidebar').classList.remove('open');
  window.scrollTo({ top: 0, behavior: 'smooth' });

  // Cargas perezosas según vista
  if (name === 'dashboard') cargarDashboard();
  if (name === 'facturas')  cargarFacturas();
}

$$('.nav-item').forEach(btn =>
  btn.addEventListener('click', () => setView(btn.dataset.view))
);
$$('[data-goto]').forEach(btn =>
  btn.addEventListener('click', () => setView(btn.dataset.goto))
);

/* Mobile menu */
$('#hamburger').addEventListener('click', () => {
  $('#sidebar').classList.toggle('open');
  document.body.classList.toggle('menu-open');
});
document.addEventListener('click', (e) => {
  if (window.innerWidth <= 768 &&
      $('#sidebar').classList.contains('open') &&
      !e.target.closest('#sidebar') &&
      !e.target.closest('#hamburger')) {
    $('#sidebar').classList.remove('open');
    document.body.classList.remove('menu-open');
  }
});

/* =========================================================
   DASHBOARD
   ========================================================= */
async function cargarDashboard() {
  // Reset stats con skeletons
  ['total','mes','emitidos','anuladas'].forEach(k => {
    const el = document.querySelector(`[data-stat="${k}"]`);
    if (el) el.innerHTML = '<span class="skel" style="width:120px"></span>';
  });
  $('#tablaRecientes tbody').innerHTML =
    '<tr><td colspan="6" class="empty">Cargando…</td></tr>';

  try {
    const data = await api(`${API.listar}?limit=8&offset=0`);
    const stats = data.estadisticas || {};

    setStat('total',    pick(stats, 'total_facturado', 'total', 'monto_total'));
    setStat('mes',      pick(stats, 'mes_actual', 'mes', 'total_mes'));
    setStat('emitidos', pick(stats, 'total_documentos', 'emitidas', 'cantidad'), false);
    setStat('anuladas', pick(stats, 'total_anuladas', 'anuladas'), false);

    pintarTablaRecientes(data.data || []);
  } catch (e) {
    toast(e.message, 'error');
    $('#tablaRecientes tbody').innerHTML =
      `<tr><td colspan="6" class="empty">No se pudieron cargar los datos.</td></tr>`;
  }
}

function setStat(key, valor, esMonto = true) {
  const el = document.querySelector(`[data-stat="${key}"]`);
  if (!el) return;
  if (valor === undefined || valor === null) { el.textContent = '—'; return; }
  el.textContent = esMonto ? fmtMoney(valor) : Number(valor).toLocaleString('es-CO');
}

function pintarTablaRecientes(lista) {
  const tbody = $('#tablaRecientes tbody');
  if (!lista.length) {
    tbody.innerHTML = `<tr><td colspan="6" class="empty">Aún no hay facturas registradas.</td></tr>`;
    return;
  }
  tbody.innerHTML = lista.slice(0, 6).map(f => `
    <tr>
      <td><span class="num-doc">${escapeHtml(getNumero(f))}</span></td>
      <td><span class="badge badge-tipo">${escapeHtml(getTipo(f))}</span></td>
      <td>${escapeHtml(getCliente(f))}</td>
      <td class="num">${fmtMoney(getValor(f))}</td>
      <td>${badgeEstado(getEstado(f))}</td>
      <td>${formatoFecha(getFecha(f))}</td>
    </tr>
  `).join('');
}

/* =========================================================
   LISTADO DE FACTURAS
   ========================================================= */
$('#filtros').addEventListener('submit', (e) => {
  e.preventDefault();
  const fd = new FormData(e.target);
  state.filtros.tipo   = fd.get('tipo')   || '';
  state.filtros.estado = fd.get('estado') || '';
  state.filtros.desde  = fd.get('desde')  || '';
  state.filtros.hasta  = fd.get('hasta')  || '';
  state.filtros.q      = fd.get('q')      || '';
  state.filtros.offset = 0;
  cargarFacturas();
});

$('#btnLimpiar').addEventListener('click', () => {
  state.filtros = { tipo: '', estado: '', desde: '', hasta: '', q: '', limit: 25, offset: 0 };
  setTimeout(cargarFacturas, 0);
});

$('#btnRefrescar').addEventListener('click', cargarFacturas);

$('#btnPrev').addEventListener('click', () => {
  if (state.filtros.offset > 0) {
    state.filtros.offset = Math.max(0, state.filtros.offset - state.filtros.limit);
    cargarFacturas();
  }
});
$('#btnNext').addEventListener('click', () => {
  if (state.ultimaListado.length === state.filtros.limit) {
    state.filtros.offset += state.filtros.limit;
    cargarFacturas();
  }
});

async function cargarFacturas() {
  const tbody = $('#tablaFacturas tbody');
  tbody.innerHTML = `<tr><td colspan="7" class="empty">Cargando…</td></tr>`;

  const qs = new URLSearchParams();
  Object.entries(state.filtros).forEach(([k, v]) => {
    if (v !== '' && v !== null && v !== undefined) qs.set(k, v);
  });

  try {
    const data = await api(`${API.listar}?${qs}`);
    const lista = data.data || [];
    state.ultimaListado = lista;

    if (!lista.length) {
      tbody.innerHTML = `<tr><td colspan="7" class="empty">No se encontraron facturas con esos filtros.</td></tr>`;
    } else {
      tbody.innerHTML = lista.map(f => {
        const tipo = getTipo(f);
        const id   = getId(f);
        const estadoTxt = (getEstado(f) || '').toUpperCase();
        const puedeAnular = estadoTxt !== 'ANULADA';
        return `
          <tr>
            <td><span class="num-doc">${escapeHtml(getNumero(f))}</span></td>
            <td><span class="badge badge-tipo">${escapeHtml(tipo)}</span></td>
            <td>${escapeHtml(getCliente(f))}</td>
            <td class="num">${fmtMoney(getValor(f))}</td>
            <td>${badgeEstado(getEstado(f))}</td>
            <td>${formatoFecha(getFecha(f))}</td>
            <td class="acciones">
              <div class="row-actions">
                <button class="icon-btn" title="Ver detalle"
                        data-action="ver" data-tipo="${tipo}" data-id="${id}">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                  </svg>
                </button>
                ${puedeAnular ? `
                <button class="icon-btn danger" title="Anular"
                        data-action="anular" data-tipo="${tipo}" data-id="${id}">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
                  </svg>
                </button>` : ''}
              </div>
            </td>
          </tr>
        `;
      }).join('');
    }

    // Resumen y paginación
    $('#resumenLista').textContent =
      `Mostrando ${lista.length} resultado${lista.length === 1 ? '' : 's'}`;
    $('#paginaInfo').textContent =
      `Página ${Math.floor(state.filtros.offset / state.filtros.limit) + 1}`;

    // Bind acciones
    $$('[data-action="ver"]', tbody).forEach(b =>
      b.addEventListener('click', () => abrirDetalle(b.dataset.tipo, b.dataset.id)));
    $$('[data-action="anular"]', tbody).forEach(b =>
      b.addEventListener('click', () => abrirAnular(b.dataset.tipo, b.dataset.id)));

  } catch (e) {
    toast(e.message, 'error');
    tbody.innerHTML = `<tr><td colspan="7" class="empty">Error al cargar facturas.</td></tr>`;
  }
}

/* =========================================================
   DETALLE DE FACTURA
   ========================================================= */
async function abrirDetalle(tipo, id) {
  const modal = $('#modalDetalle');
  const body  = $('#modalDetalleBody');
  body.innerHTML = '<p style="text-align:center;color:var(--muted);padding:20px">Cargando detalle…</p>';
  modal.classList.add('open');
  modal.setAttribute('aria-hidden', 'false');

  try {
    const data = await api(`${API.obtener}?tipo=${encodeURIComponent(tipo)}&id=${encodeURIComponent(id)}`);
    pintarDetalle(data.factura || {});
  } catch (e) {
    body.innerHTML = `<p style="color:var(--danger);text-align:center;padding:20px">${escapeHtml(e.message)}</p>`;
  }
}

function pintarDetalle(f) {
  const items = [
    ['Número',          getNumero(f)],
    ['Tipo',            getTipo(f)],
    ['Estado',          (getEstado(f) || '').toUpperCase()],
    ['Fecha emisión',   formatoFecha(getFecha(f))],
    ['Cliente',         getCliente(f)],
    ['Documento',       pick(f, 'documento', 'cedula', 'identificacion', 'cliente_documento') || '—'],
    ['Email',           pick(f, 'email', 'correo', 'cliente_email') || '—'],
    ['Teléfono',        pick(f, 'telefono', 'celular', 'cliente_telefono') || '—'],
    ['Concepto',        pick(f, 'concepto', 'descripcion', 'detalle', 'servicio', 'curso') || '—'],
    ['Método de pago',  metodoPagoLabel(pick(f, 'metodo_pago', 'metodo', 'forma_pago')) || '—'],
  ];

  const motivo = pick(f, 'motivo_anulacion', 'motivo');
  const html = `
    <div class="detalle-grid">
      ${items.map(([k, v]) => `
        <div class="item">
          <span class="item-label">${escapeHtml(k)}</span>
          <span class="item-val">${escapeHtml(v)}</span>
        </div>
      `).join('')}
      ${motivo ? `
        <div class="item full">
          <span class="item-label">Motivo de anulación</span>
          <span class="item-val">${escapeHtml(motivo)}</span>
        </div>
      ` : ''}
    </div>
    <div class="detalle-total">
      <span class="label">Total</span>
      <span class="valor">${fmtMoney(getValor(f))}</span>
    </div>
  `;
  $('#modalDetalleBody').innerHTML = html;
}

/* =========================================================
   ANULAR FACTURA
   ========================================================= */
function abrirAnular(tipo, id) {
  state.facturaParaAnular = { tipo, id };
  const modal = $('#modalAnular');
  $('#motivo').value = '';
  modal.classList.add('open');
  modal.setAttribute('aria-hidden', 'false');
  setTimeout(() => $('#motivo').focus(), 100);
}

$('#formAnular').addEventListener('submit', async (e) => {
  e.preventDefault();
  const motivo = $('#motivo').value.trim();
  if (motivo.length < 5) {
    toast('El motivo debe tener al menos 5 caracteres.', 'error');
    return;
  }
  if (!state.facturaParaAnular) return;

  const submitBtn = e.target.querySelector('button[type="submit"]');
  submitBtn.disabled = true;
  submitBtn.textContent = 'Anulando…';

  try {
    const r = await api(API.anular, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        tipo: state.facturaParaAnular.tipo,
        id:   Number(state.facturaParaAnular.id),
        motivo,
      }),
    });
    toast(r.message || 'Soporte anulado correctamente.', 'success');
    cerrarModales();
    state.facturaParaAnular = null;
    cargarFacturas();
  } catch (err) {
    toast(err.message, 'error');
  } finally {
    submitBtn.disabled = false;
    submitBtn.textContent = 'Anular soporte';
  }
});

/* =========================================================
   CREAR FACTURA CERTIFICADO
   ========================================================= */
let inscBuscadorTimer;
$('#buscadorInsc').addEventListener('input', (e) => {
  clearTimeout(inscBuscadorTimer);
  inscBuscadorTimer = setTimeout(() => buscarInscripciones(e.target.value.trim()), 300);
});

async function buscarInscripciones(q) {
  const lista = $('#inscList');
  if (!q) {
    lista.innerHTML = `<li class="empty">Escribe para buscar inscripciones pagables.</li>`;
    return;
  }
  lista.innerHTML = `<li class="empty">Buscando…</li>`;

  try {
    const data = await api(`${API.inscPagables}?q=${encodeURIComponent(q)}`);
    const items = data.data || [];
    if (!items.length) {
      lista.innerHTML = `<li class="empty">Sin resultados.</li>`;
      return;
    }
    lista.innerHTML = items.map(i => {
      const id = pick(i, 'id_inscripcion', 'id');
      return `
        <li data-id="${id}" data-json='${escapeHtml(JSON.stringify(i))}'>
          <span class="insc-nombre">${escapeHtml(pick(i, 'nombre', 'nombres', 'cliente', 'estudiante') || '—')}</span>
          <span class="insc-meta">
            ${escapeHtml(pick(i, 'documento', 'cedula', 'identificacion') || '')}
            ${i.curso || i.servicio ? ' · ' + escapeHtml(i.curso || i.servicio) : ''}
            ${ pick(i, 'valor', 'precio', 'total') ? ' · ' + fmtMoney(pick(i, 'valor', 'precio', 'total')) : '' }
          </span>
        </li>
      `;
    }).join('');

    $$('li[data-id]', lista).forEach(li =>
      li.addEventListener('click', () => seleccionarInscripcion(li)));
  } catch (e) {
    lista.innerHTML = `<li class="empty">Error: ${escapeHtml(e.message)}</li>`;
  }
}

function seleccionarInscripcion(li) {
  $$('#inscList li').forEach(x => x.classList.remove('selected'));
  li.classList.add('selected');
  let info = {};
  try { info = JSON.parse(li.dataset.json); } catch {}
  state.inscSeleccionada = info;
  pintarResumenInsc(info);
  $('#btnGenerar').disabled = false;
}

function pintarResumenInsc(i) {
  const cont = $('#resumenInsc');
  if (!i) {
    cont.innerHTML = `<p class="placeholder">Aún no has seleccionado ninguna inscripción.</p>`;
    return;
  }
  const valor = pick(i, 'valor', 'precio', 'total', 'monto') || 0;
  cont.innerHTML = `
    <div class="item"><span>Estudiante</span><span>${escapeHtml(pick(i, 'nombre', 'nombres', 'cliente') || '—')}</span></div>
    <div class="item"><span>Documento</span><span>${escapeHtml(pick(i, 'documento', 'cedula') || '—')}</span></div>
    <div class="item"><span>Curso</span><span>${escapeHtml(pick(i, 'curso', 'servicio', 'nombre_curso') || '—')}</span></div>
    <div class="item"><span>Inscripción</span><span>${escapeHtml(pick(i, 'id_inscripcion', 'id') || '—')}</span></div>
    <div class="total">
      <span>Total a facturar</span>
      <span class="monto">${fmtMoney(valor)}</span>
    </div>
  `;
}

$('#formCrear').addEventListener('submit', async (e) => {
  e.preventDefault();
  if (!state.inscSeleccionada) {
    toast('Selecciona una inscripción primero.', 'error');
    return;
  }
  const fd = new FormData(e.target);
  const mp = Number(fd.get('metodo_pago'));
  const idInsc = Number(pick(state.inscSeleccionada, 'id_inscripcion', 'id'));
  if (!idInsc || !mp) {
    toast('Datos incompletos.', 'error');
    return;
  }

  const btn = $('#btnGenerar');
  btn.disabled = true;
  btn.textContent = 'Generando…';

  try {
    const r = await api(API.crearCert, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id_inscripcion: idInsc, metodo_pago: mp }),
    });
    toast(r.message || 'Soporte generado correctamente.', 'success');

    // Reset form
    state.inscSeleccionada = null;
    $('#formCrear').reset();
    $('#inscList').innerHTML = `<li class="empty">Escribe para buscar inscripciones pagables.</li>`;
    $('#buscadorInsc').value = '';
    pintarResumenInsc(null);
    btn.disabled = true;

    // Saltar al detalle de la nueva factura si vino el id
    const fId = pick(r.factura || {}, 'id', 'id_factura');
    if (fId) abrirDetalle('CERTIFICADO', fId);

  } catch (err) {
    toast(err.message, 'error');
  } finally {
    btn.textContent = 'Generar soporte de pago';
    if (state.inscSeleccionada) btn.disabled = false;
  }
});

/* =========================================================
   MODALES (cerrado)
   ========================================================= */
function cerrarModales() {
  $$('.modal').forEach(m => {
    m.classList.remove('open');
    m.setAttribute('aria-hidden', 'true');
  });
}
$$('[data-close]').forEach(el => el.addEventListener('click', cerrarModales));
document.addEventListener('keydown', (e) => { if (e.key === 'Escape') cerrarModales(); });

/* =========================================================
   HELPERS DE EXTRACCIÓN
   ========================================================= */
const getId      = (f) => pick(f, 'id', 'id_factura', 'factura_id');
const getNumero  = (f) => pick(f, 'numero', 'consecutivo', 'numero_factura', 'no') || `#${getId(f) ?? '—'}`;
const getTipo    = (f) => (pick(f, 'tipo', 'tipo_factura') || '').toUpperCase();
const getCliente = (f) => pick(f, 'cliente', 'nombre_cliente', 'nombre', 'usuario', 'estudiante') || '—';
const getValor   = (f) => pick(f, 'valor', 'total', 'monto', 'precio') ?? 0;
const getEstado  = (f) => pick(f, 'estado', 'status') || 'PENDIENTE';
const getFecha   = (f) => pick(f, 'fecha', 'fecha_emision', 'created_at', 'creada_en');

function badgeEstado(estado) {
  const e = (estado || '').toUpperCase();
  let clase = 'badge-pendiente';
  if (e === 'PAGADA' || e === 'PAGADO') clase = 'badge-pagada';
  if (e === 'ANULADA' || e === 'ANULADO') clase = 'badge-anulada';
  return `<span class="badge ${clase}">${escapeHtml(e || 'PENDIENTE')}</span>`;
}

function metodoPagoLabel(v) {
  const map = { 1: 'Efectivo', 2: 'Transferencia', 3: 'Tarjeta' };
  if (typeof v === 'number') return map[v];
  if (typeof v === 'string' && /^[123]$/.test(v)) return map[Number(v)];
  return v;
}

/* =========================================================
   INIT
   ========================================================= */
document.addEventListener('DOMContentLoaded', () => {
  cargarDashboard();
});

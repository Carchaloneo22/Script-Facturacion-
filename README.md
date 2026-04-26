[README.md](https://github.com/user-attachments/files/27106996/README.md)
# 📄 Panel de Facturación

Interfaz web moderna y responsiva para la gestión de soportes de pago y facturación de servicios y certificados. Construida con HTML, CSS y JavaScript puros (sin frameworks) y conectada a una API en PHP.

![status](https://img.shields.io/badge/status-stable-2c4a3d)
![license](https://img.shields.io/badge/license-MIT-b35a35)
![stack](https://img.shields.io/badge/stack-HTML%20%7C%20CSS%20%7C%20JS%20%7C%20PHP-1a1714)

---

## ✨ Características

- 🎨 **Diseño editorial refinado** con tipografías *Fraunces* + *Manrope*.
- 📱 **100 % responsive** con `media queries` adaptadas a móvil, tablet y escritorio.
- ⚡ **Sin dependencias externas** de JavaScript: vanilla JS puro.
- 🧭 **Navegación SPA** entre tres vistas: Resumen, Listado y Generación de soportes.
- 🔍 **Filtros avanzados** por tipo, estado, rango de fechas y búsqueda libre.
- 🧾 **Detalle de factura** en modal con todos los campos del soporte.
- ❌ **Anulación de soportes** con motivo obligatorio y confirmación visual.
- 🆕 **Asistente de creación** en dos pasos: buscar inscripción ➜ confirmar método de pago.
- 🔔 **Sistema de notificaciones** (toasts) para acciones exitosas o errores.
- ♿ **Accesibilidad básica**: roles ARIA, foco visible, soporte de teclado (`Esc` cierra modales).
- 🌗 Respeta `prefers-reduced-motion` para usuarios sensibles al movimiento.

---

## 📁 Estructura

```
facturacion/
├── index.html          # Estructura de la interfaz
├── styles.css          # Estilos (paleta, layout, responsive)
├── script.js           # Lógica de UI + llamadas a la API
├── README.md           # Este archivo
└── api/                # (No incluido) Scripts PHP del backend
    ├── listar_facturas.php
    ├── obtener_factura.php
    ├── crear_factura_certificado.php
    ├── anular_factura.php
    └── listar_inscripciones_pagables.php
```

---

## 🚀 Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/<tu-usuario>/facturacion-panel.git
cd facturacion-panel
```

### 2. Colocar los scripts PHP

Copia los archivos PHP de tu módulo de facturación dentro de la carpeta `api/`. Asegúrate de que el archivo `includes/config.php` y el módulo `modules/facturacion.php` también estén configurados correctamente.

### 3. Configurar la ruta del API

Abre `script.js` y ajusta la constante `API_BASE` si tu backend está en otra ruta:

```js
const API_BASE = './api/';   // ⚙️ ajusta según tu estructura
```

Ejemplos:
- `./api/`              → mismo dominio, carpeta `api/`
- `/sistema/api/`       → ruta absoluta dentro del servidor
- `https://miapp.com/api/` → dominio diferente (requiere CORS habilitado)

### 4. Servir el sitio

Sirve el directorio con cualquier servidor web (Apache, Nginx, XAMPP, Laragon…).

```bash
# Opción rápida con PHP
php -S localhost:8000
```

Luego abre `http://localhost:8000` en tu navegador.

---

## 🔌 Endpoints del API

| Método | Endpoint                              | Descripción                                       |
|:------:|---------------------------------------|---------------------------------------------------|
| `GET`  | `listar_facturas.php`                 | Lista facturas con filtros y estadísticas globales |
| `GET`  | `obtener_factura.php`                 | Devuelve el detalle de una factura específica     |
| `POST` | `crear_factura_certificado.php`       | Genera un nuevo soporte de pago para certificado  |
| `POST` | `anular_factura.php`                  | Anula un soporte indicando un motivo              |
| `GET`  | `listar_inscripciones_pagables.php`   | Lista inscripciones aprobadas y aún sin pagar     |

### Ejemplo: listar facturas con filtros

```
GET /api/listar_facturas.php?tipo=CERTIFICADO&estado=PAGADA&desde=2025-01-01&limit=25
```

```json
{
  "success": true,
  "data": [
    {
      "id": 12,
      "numero": "FC-0012",
      "tipo": "CERTIFICADO",
      "cliente": "Juan Pérez",
      "valor": 50000,
      "estado": "PAGADA",
      "fecha": "2025-04-25"
    }
  ],
  "estadisticas": {
    "total_facturado": 12500000,
    "mes_actual": 850000,
    "total_documentos": 124,
    "total_anuladas": 3
  }
}
```

### Ejemplo: anular factura

```
POST /api/anular_factura.php
Content-Type: application/json

{
  "tipo": "CERTIFICADO",
  "id": 12,
  "motivo": "Pago duplicado por error del cliente"
}
```

---

## 🎨 Personalización visual

Toda la paleta y la tipografía están en variables CSS al inicio de `styles.css`:

```css
:root {
  --bg:        #f6f2ea;
  --surface:   #fdfaf4;
  --ink:       #1a1714;
  --primary:   #2c4a3d;   /* verde bosque */
  --accent:    #b35a35;   /* cobre cálido */
  --danger:    #a8341c;
  --success:   #3d6b4c;
  /* ...tipografía... */
  --font-display: 'Fraunces', serif;
  --font-body:    'Manrope', sans-serif;
}
```

Cambia esas variables para ajustar el branding sin tocar el resto del CSS.

---

## 📱 Breakpoints responsive

| Breakpoint | Pantalla       | Comportamiento                          |
|------------|----------------|------------------------------------------|
| ≥ 1100 px  | Escritorio     | Sidebar fija + grid de 4 columnas        |
| 900-1100   | Tablet grande  | Filtros en 3 columnas, stats en 2        |
| 768-900    | Tablet         | Formulario de creación apilado           |
| 480-768    | Móvil          | Sidebar colapsable, stats en 1 columna   |
| < 480 px   | Móvil pequeño  | Filtros apilados, paginación centrada    |

---

## 🌐 Compatibilidad

| Navegador        | Versión mínima |
|------------------|----------------|
| Chrome / Edge    | 90+            |
| Firefox          | 88+            |
| Safari           | 14+            |
| Opera            | 76+            |

Se utilizan características modernas como `:has()`, `Intl.NumberFormat`, `fetch` y CSS Grid.

---

## 🛠️ Desarrollo

### Convenciones

- Mantén el código JavaScript en `script.js` agrupado por secciones (utilidades, navegación, dashboard, etc.).
- Las funciones que extraen campos del backend usan `pick()` para tolerar distintos nombres (`id`, `id_factura`, etc.).
- Usa `toast(mensaje, 'success' | 'error' | 'info')` para mostrar notificaciones.

### Añadir un nuevo método de pago

1. En `index.html`, agrega otro `<label class="radio-card">` dentro de `.radios`.
2. En `script.js`, actualiza el objeto `metodoPagoLabel`:
   ```js
   const map = { 1: 'Efectivo', 2: 'Transferencia', 3: 'Tarjeta', 4: 'PSE' };
   ```
3. Asegúrate de que el backend acepte ese nuevo valor.

### Añadir una nueva vista

1. Añade un `<button class="nav-item" data-view="reportes">` en el sidebar.
2. Crea una `<section class="view" id="view-reportes">…</section>` en `index.html`.
3. En `script.js`, añade la lógica de carga dentro de `setView()`.

---

## 🧪 Datos de prueba

Si quieres probar la UI sin backend, abre `script.js` y reemplaza la función `api()` con un mock:

```js
async function api(url) {
  await new Promise(r => setTimeout(r, 300)); // simula latencia
  if (url.includes('listar_facturas')) {
    return {
      success: true,
      data: [{ id: 1, numero: 'F-001', tipo: 'CERTIFICADO',
               cliente: 'María Gómez', valor: 50000,
               estado: 'PAGADA', fecha: '2025-04-20' }],
      estadisticas: { total_facturado: 1250000, mes_actual: 350000,
                      total_documentos: 24, total_anuladas: 1 }
    };
  }
  return { success: true, data: [] };
}
```

---

## 🤝 Contribuir

1. Haz fork del proyecto
2. Crea una rama: `git checkout -b feature/mi-mejora`
3. Haz commit: `git commit -m "feat: añade gráfica de ingresos"`
4. Push: `git push origin feature/mi-mejora`
5. Abre un Pull Request

---

## 📜 Licencia

Distribuido bajo licencia **MIT**. Consulta el archivo `LICENSE` para más información.

---

## 📷 Capturas

> Coloca tus capturas en `/docs/screenshots/` y enlázalas aquí.

```
docs/
└── screenshots/
    ├── dashboard.png
    ├── listado.png
    ├── crear.png
    └── mobile.png
```

---

<p align="center">
  Hecho con cuidado por el equipo de desarrollo · 2025
</p>

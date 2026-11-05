/**
 * Tabla Deacero - Visualizacion personalizada tipo tabla para Looker (core)
 *
 * Funciones:
 *  - Dimensiones, medidas, calculos de tabla y pivotes
 *  - Ordenamiento por columna (clic en encabezado)
 *  - Buscador de texto sobre todas las columnas
 *  - Paginacion configurable
 *  - Fila de totales (usa los totales de Looker: activar "Totals" en el explore)
 *  - Formato condicional en columnas numericas: barras o escala de color
 *  - Drill (links de Looker) y crossfilter en dashboards
 *  - Primera columna fija, densidad, zebra, ajuste de texto
 *
 * Nota: el archivo usa solo ASCII (acentos/flechas con escapes \uXXXX)
 * para evitar problemas de codificacion al servirse desde Looker.
 */

(function () {
    'use strict';

    var CSS = [
        '.tdx-wrap{width:100%;height:100%;display:flex;flex-direction:column;font-family:Roboto,"Noto Sans",Arial,sans-serif;font-size:12px;color:#3c4043;box-sizing:border-box;}',
        '.tdx-wrap *{box-sizing:border-box;}',
        '.tdx-top{flex:0 0 auto;display:flex;align-items:center;gap:12px;padding:6px 8px 8px;flex-wrap:wrap;}',
        '.tdx-title{font-size:14px;font-weight:500;color:#202124;}',
        '.tdx-count{font-size:12px;color:#80868b;}',
        '.tdx-spacer{flex:1 1 auto;}',
        '.tdx-search{height:28px;min-width:180px;padding:0 10px;border:1px solid #dadce0;border-radius:14px;font-size:12px;outline:none;color:#3c4043;background:#fff;}',
        '.tdx-search:focus{border-color:#1a73e8;box-shadow:0 0 0 1px #1a73e8;}',
        '.tdx-scroll{flex:1 1 0;min-height:0;overflow:auto;border:1px solid #e8eaed;border-radius:4px;}',
        '.tdx-table{width:100%;border-collapse:separate;border-spacing:0;}',
        '.tdx-table.tdx-nowrap td,.tdx-table.tdx-nowrap th{white-space:nowrap;}',
        '.tdx-table th{position:sticky;top:0;z-index:2;text-align:left;font-weight:500;border-bottom:2px solid #dadce0;cursor:pointer;user-select:none;vertical-align:bottom;}',
        '.tdx-table th:hover{filter:brightness(0.96);}',
        '.tdx-table th .tdx-sort{margin-left:4px;font-size:10px;opacity:.45;}',
        '.tdx-table th .tdx-sort.on{opacity:1;}',
        '.tdx-table th .tdx-pivot{display:block;font-weight:400;font-size:11px;opacity:.75;}',
        '.tdx-table td{border-bottom:1px solid #f1f3f4;background:#fff;}',
        '.tdx-table.tdx-zebra tbody tr:nth-child(even) td{background:#fafafa;}',
        '.tdx-table tbody tr:hover td{background:#eef3fd !important;}',
        '.tdx-table tbody tr.tdx-sel td{background:#d2e3fc !important;font-weight:500;}',
        '.tdx-table tbody tr.tdx-dim td{opacity:.55;}',
        '.tdx-table tfoot td{position:sticky;bottom:0;z-index:2;background:#f1f3f4;font-weight:600;border-top:2px solid #dadce0;}',
        '.tdx-d-compacta th,.tdx-d-compacta td{padding:3px 8px;}',
        '.tdx-d-normal th,.tdx-d-normal td{padding:6px 12px;}',
        '.tdx-d-amplia th,.tdx-d-amplia td{padding:10px 14px;}',
        '.tdx-num{text-align:right !important;font-variant-numeric:tabular-nums;}',
        '.tdx-rownum{color:#9aa0a6;text-align:right;width:1%;}',
        '.tdx-freeze{position:sticky;left:0;z-index:1;box-shadow:1px 0 0 #e8eaed;}',
        '.tdx-table th.tdx-freeze{z-index:3;}',
        '.tdx-table tfoot td.tdx-freeze{z-index:3;}',
        '.tdx-link{cursor:pointer;}',
        '.tdx-link:hover{text-decoration:underline;}',
        '.tdx-pager{flex:0 0 auto;display:flex;align-items:center;justify-content:flex-end;gap:6px;padding:6px 4px 0;color:#5f6368;}',
        '.tdx-pager button{height:24px;min-width:28px;border:1px solid #dadce0;background:#fff;border-radius:4px;cursor:pointer;color:#3c4043;}',
        '.tdx-pager button:disabled{opacity:.4;cursor:default;}',
        '.tdx-empty{padding:24px;text-align:center;color:#80868b;}'
    ].join('\n');

    var ARROW_UP = ' \u25B2', ARROW_DOWN = ' \u25BC', ARROW_BOTH = ' \u21C5';

    // ---------- utilidades ----------
    function esc(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function isNumericField(f) {
        return !!(f && (f.is_numeric || f.type === 'number' || f.type === 'count' ||
            f.type === 'sum' || f.type === 'average' || f.type === 'count_distinct'));
    }

    function cellText(cell) {
        if (!cell) return '';
        if (cell.rendered != null && cell.rendered !== '') return String(cell.rendered);
        return cell.value == null ? '' : String(cell.value);
    }

    function cellHtml(cell) {
        if (!cell) return '';
        try {
            if (typeof LookerCharts !== 'undefined' && LookerCharts.Utils && LookerCharts.Utils.htmlForCell) {
                return LookerCharts.Utils.htmlForCell(cell);
            }
        } catch (e) { /* fallback abajo */ }
        return esc(cellText(cell));
    }

    function hexToRgb(hex) {
        var h = String(hex || '').replace('#', '');
        if (h.length === 3) h = h[0] + h[0] + h[1] + h[1] + h[2] + h[2];
        var n = parseInt(h, 16);
        if (isNaN(n)) return [26, 115, 232];
        return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
    }

    function mix(c1, c2, t) {
        var a = hexToRgb(c1), b = hexToRgb(c2);
        return 'rgb(' + Math.round(a[0] + (b[0] - a[0]) * t) + ',' +
            Math.round(a[1] + (b[1] - a[1]) * t) + ',' +
            Math.round(a[2] + (b[2] - a[2]) * t) + ')';
    }

    function luminance(rgbStr) {
        var m = rgbStr.match(/\d+/g) || [255, 255, 255];
        return (0.299 * m[0] + 0.587 * m[1] + 0.114 * m[2]) / 255;
    }

    function hexWithAlpha(hex, alpha) {
        var c = hexToRgb(hex);
        return 'rgba(' + c[0] + ',' + c[1] + ',' + c[2] + ',' + alpha + ')';
    }

    // ---------- construccion de columnas (soporta pivotes) ----------
    function buildColumns(data, qr) {
        var fields = qr.fields || {};
        var dims = fields.dimension_like || fields.dimensions || [];
        var meas = fields.measure_like || (fields.measures || []).concat(fields.table_calculations || []);
        var pivots = qr.pivots || [];
        var sample = data[0] || {};
        var cols = [];

        dims.forEach(function (f) {
            cols.push({
                key: f.name, field: f, label: f.label_short || f.label || f.name,
                numeric: isNumericField(f),
                get: function (row) { return row[f.name]; }
            });
        });

        meas.forEach(function (f) {
            var s = sample[f.name];
            var isPivoted = pivots.length > 0 && s && !('value' in s);
            if (!isPivoted) {
                cols.push({
                    key: f.name, field: f, label: f.label_short || f.label || f.name,
                    numeric: isNumericField(f) || f.is_numeric !== false,
                    get: function (row) { return row[f.name]; }
                });
            } else {
                pivots.forEach(function (p) {
                    var pk = p.key;
                    var pLabel = pk === '$$$_row_total_$$$' ? 'Total fila' :
                        (p.data ? Object.keys(p.data).map(function (k) {
                            return cellText(p.data[k]) || String(p.data[k] && p.data[k].value || '');
                        }).join(' | ') : pk);
                    cols.push({
                        key: f.name + '||' + pk, field: f, pivotKey: pk,
                        label: f.label_short || f.label || f.name, pivotLabel: pLabel,
                        numeric: true,
                        get: function (row) { return row[f.name] ? row[f.name][pk] : null; }
                    });
                });
            }
        });
        return cols;
    }

    // ---------- definicion de la visualizacion ----------
    var vis = {
        id: 'deacero-tabla',
        label: 'Tabla (Deacero)',
        options: {
            // Tabla
            titulo: { type: 'string', label: 'T\u00EDtulo', default: '', section: 'Tabla', order: 1 },
            mostrar_buscador: { type: 'boolean', label: 'Mostrar buscador', default: true, section: 'Tabla', order: 2 },
            filas_por_pagina: { type: 'number', label: 'Filas por p\u00E1gina (0 = todas)', default: 50, section: 'Tabla', order: 3 },
            mostrar_numero_fila: { type: 'boolean', label: 'Mostrar n\u00FAmero de fila', default: true, section: 'Tabla', order: 4 },
            mostrar_totales: { type: 'boolean', label: 'Mostrar totales (activar Totals en el explore)', default: true, section: 'Tabla', order: 5 },
            fijar_primera_columna: { type: 'boolean', label: 'Fijar primera columna', default: false, section: 'Tabla', order: 6 },
            // Estilo
            densidad: {
                type: 'string', label: 'Densidad', display: 'select', default: 'normal', section: 'Estilo', order: 1,
                values: [{ 'Compacta': 'compacta' }, { 'Normal': 'normal' }, { 'Amplia': 'amplia' }]
            },
            zebra: { type: 'boolean', label: 'Filas alternadas', default: true, section: 'Estilo', order: 2 },
            ajustar_texto: { type: 'boolean', label: 'Ajustar texto en celdas', default: false, section: 'Estilo', order: 3 },
            color_encabezado: { type: 'string', label: 'Color de encabezado', display: 'color', default: '#f5f5f5', section: 'Estilo', order: 4 },
            color_texto_encabezado: { type: 'string', label: 'Color de texto de encabezado', display: 'color', default: '#202124', section: 'Estilo', order: 5 },
            // Formato condicional
            formato_condicional: {
                type: 'string', label: 'Tipo', display: 'select', default: 'ninguno', section: 'Formato', order: 1,
                values: [{ 'Ninguno': 'ninguno' }, { 'Barras de datos': 'barras' }, { 'Escala de color': 'escala' }]
            },
            columnas_formato: {
                type: 'string', label: 'Columnas (nombres separados por coma, vac\u00EDo = todas las num\u00E9ricas)',
                default: '', section: 'Formato', order: 2
            },
            color_min: { type: 'string', label: 'Color m\u00EDnimo', display: 'color', default: '#ffffff', section: 'Formato', order: 3 },
            color_max: { type: 'string', label: 'Color m\u00E1ximo / barra', display: 'color', default: '#1a73e8', section: 'Formato', order: 4 }
        },

        create: function (element) {
            var style = document.createElement('style');
            style.textContent = CSS;
            element.appendChild(style);

            this._wrap = document.createElement('div');
            this._wrap.className = 'tdx-wrap';
            element.appendChild(this._wrap);

            this._state = { sortKey: null, asc: true, query: '', page: 0, lastSig: null };
        },

        updateAsync: function (data, element, config, queryResponse, details, done) {
            var self = this;
            this.clearErrors();

            var fields = (queryResponse && queryResponse.fields) || {};
            var nDims = (fields.dimension_like || fields.dimensions || []).length;
            var nMeas = (fields.measure_like || fields.measures || []).length;
            if (nDims + nMeas === 0) {
                this.addError({ title: 'Sin campos', message: 'Agrega al menos una dimensi\u00F3n o medida.' });
                done(); return;
            }

            config = config || {};
            this._ctx = {
                data: data || [],
                config: config,
                qr: queryResponse,
                details: details || {},
                cols: buildColumns(data || [], queryResponse)
            };

            // Reinicia pagina si cambio la consulta
            var sig = (data ? data.length : 0) + '|' + this._ctx.cols.map(function (c) { return c.key; }).join(',');
            if (sig !== this._state.lastSig) {
                this._state.page = 0;
                this._state.lastSig = sig;
                if (this._state.sortKey && !this._ctx.cols.some(function (c) { return c.key === self._state.sortKey; })) {
                    this._state.sortKey = null;
                }
            }

            this._renderShell();
            this._renderTable();
            done();
        },

        // Encabezado superior (titulo, conteo, buscador) - se construye una vez por update
        _renderShell: function () {
            var self = this, cfg = this._ctx.config, w = this._wrap;
            w.innerHTML = '';

            var top = document.createElement('div');
            top.className = 'tdx-top';
            if (cfg.titulo) {
                var t = document.createElement('span');
                t.className = 'tdx-title';
                t.textContent = cfg.titulo;
                top.appendChild(t);
            }
            this._countEl = document.createElement('span');
            this._countEl.className = 'tdx-count';
            top.appendChild(this._countEl);

            var sp = document.createElement('span');
            sp.className = 'tdx-spacer';
            top.appendChild(sp);

            if (cfg.mostrar_buscador !== false) {
                var inp = document.createElement('input');
                inp.type = 'search';
                inp.className = 'tdx-search';
                inp.placeholder = 'Buscar\u2026';
                inp.value = this._state.query;
                var timer = null;
                inp.addEventListener('input', function () {
                    clearTimeout(timer);
                    timer = setTimeout(function () {
                        self._state.query = inp.value;
                        self._state.page = 0;
                        self._renderTable();
                    }, 150);
                });
                top.appendChild(inp);
            } else {
                this._state.query = '';
            }
            w.appendChild(top);

            this._scroll = document.createElement('div');
            this._scroll.className = 'tdx-scroll';
            w.appendChild(this._scroll);

            this._pager = document.createElement('div');
            this._pager.className = 'tdx-pager';
            w.appendChild(this._pager);
        },

        _filteredSortedRows: function () {
            var st = this._state, cols = this._ctx.cols;
            var rows = this._ctx.data.slice();

            var q = (st.query || '').trim().toLowerCase();
            if (q) {
                rows = rows.filter(function (row) {
                    for (var i = 0; i < cols.length; i++) {
                        if (cellText(cols[i].get(row)).toLowerCase().indexOf(q) !== -1) return true;
                    }
                    return false;
                });
            }

            if (st.sortKey) {
                var col = cols.filter(function (c) { return c.key === st.sortKey; })[0];
                if (col) {
                    var dir = st.asc ? 1 : -1;
                    rows.sort(function (a, b) {
                        var ca = col.get(a), cb = col.get(b);
                        var va = ca ? ca.value : null, vb = cb ? cb.value : null;
                        // nulos siempre al final
                        if (va == null && vb == null) return 0;
                        if (va == null) return 1;
                        if (vb == null) return -1;
                        if (col.numeric && !isNaN(Number(va)) && !isNaN(Number(vb))) {
                            return (Number(va) - Number(vb)) * dir;
                        }
                        return String(va).localeCompare(String(vb), 'es', { numeric: true, sensitivity: 'base' }) * dir;
                    });
                }
            }
            return rows;
        },

        _formatTargets: function () {
            var cfg = this._ctx.config;
            if (!cfg.formato_condicional || cfg.formato_condicional === 'ninguno') return null;
            var list = String(cfg.columnas_formato || '').split(',')
                .map(function (s) { return s.trim(); }).filter(Boolean);
            var targets = {};
            this._ctx.cols.forEach(function (c) {
                if (!c.numeric) return;
                if (list.length && list.indexOf(c.field.name) === -1) return;
                targets[c.key] = { min: Infinity, max: -Infinity };
            });
            return targets;
        },

        _renderTable: function () {
            var self = this;
            var ctx = this._ctx, cfg = ctx.config, st = this._state, cols = ctx.cols;
            var details = ctx.details;
            var xf = !!details.crossfilterEnabled;

            var rows = this._filteredSortedRows();
            var total = rows.length;

            // Paginacion
            var per = Number(cfg.filas_por_pagina);
            if (isNaN(per) || per < 0) per = 50;
            var pages = per > 0 ? Math.max(1, Math.ceil(total / per)) : 1;
            if (st.page >= pages) st.page = pages - 1;
            var pageRows = per > 0 ? rows.slice(st.page * per, st.page * per + per) : rows;
            var offset = per > 0 ? st.page * per : 0;

            // Conteo
            var allCount = ctx.data.length;
            this._countEl.textContent = (st.query ? total + ' de ' + allCount : allCount) + ' registros';

            // Min/max para formato condicional (sobre filas filtradas)
            var fmt = this._formatTargets();
            if (fmt) {
                rows.forEach(function (row) {
                    cols.forEach(function (c) {
                        var t = fmt[c.key]; if (!t) return;
                        var cell = c.get(row);
                        var v = cell ? Number(cell.value) : NaN;
                        if (!isNaN(v) && cell.value != null) {
                            if (v < t.min) t.min = v;
                            if (v > t.max) t.max = v;
                        }
                    });
                });
            }

            var table = document.createElement('table');
            table.className = 'tdx-table tdx-d-' + (cfg.densidad || 'normal') +
                (cfg.zebra !== false ? ' tdx-zebra' : '') +
                (cfg.ajustar_texto ? '' : ' tdx-nowrap');

            var showNum = cfg.mostrar_numero_fila !== false;
            var freeze = !!cfg.fijar_primera_columna;
            var hdrBg = cfg.color_encabezado || '#f5f5f5';
            var hdrFg = cfg.color_texto_encabezado || '#202124';

            // ----- THEAD -----
            var thead = document.createElement('thead');
            var hr = document.createElement('tr');
            if (showNum) {
                var th0 = document.createElement('th');
                th0.className = 'tdx-rownum' + (freeze ? ' tdx-freeze' : '');
                th0.style.background = hdrBg; th0.style.color = hdrFg; th0.style.cursor = 'default';
                th0.textContent = '#';
                hr.appendChild(th0);
            }
            cols.forEach(function (c, idx) {
                var th = document.createElement('th');
                var cls = [];
                if (c.numeric) cls.push('tdx-num');
                if (freeze && idx === 0 && !showNum) cls.push('tdx-freeze');
                th.className = cls.join(' ');
                th.style.background = hdrBg; th.style.color = hdrFg;
                if (c.field && c.field.description) th.title = c.field.description;

                if (c.pivotLabel != null) {
                    var pv = document.createElement('span');
                    pv.className = 'tdx-pivot';
                    pv.textContent = c.pivotLabel;
                    th.appendChild(pv);
                }
                th.appendChild(document.createTextNode(c.label));
                var s = document.createElement('span');
                var on = st.sortKey === c.key;
                s.className = 'tdx-sort' + (on ? ' on' : '');
                s.textContent = on ? (st.asc ? ARROW_UP : ARROW_DOWN) : ARROW_BOTH;
                th.appendChild(s);

                th.addEventListener('click', function () {
                    // Ciclo: direccion inicial -> inversa -> sin orden
                    // (numericas inician descendente, texto ascendente)
                    var initialAsc = !c.numeric;
                    if (st.sortKey !== c.key) { st.sortKey = c.key; st.asc = initialAsc; }
                    else if (st.asc === initialAsc) { st.asc = !initialAsc; }
                    else { st.sortKey = null; st.asc = true; }
                    self._renderTable();
                });
                hr.appendChild(th);
            });
            thead.appendChild(hr);
            table.appendChild(thead);

            // ----- TBODY -----
            var tbody = document.createElement('tbody');
            if (!pageRows.length) {
                var er = document.createElement('tr');
                var ed = document.createElement('td');
                ed.colSpan = cols.length + (showNum ? 1 : 0);
                ed.className = 'tdx-empty';
                ed.textContent = st.query ? 'Sin coincidencias para "' + st.query + '"' : 'Sin datos para los filtros actuales';
                er.appendChild(ed); tbody.appendChild(er);
            }

            pageRows.forEach(function (row, i) {
                var tr = document.createElement('tr');

                if (xf && typeof LookerCharts !== 'undefined') {
                    try {
                        var sel = LookerCharts.Utils.getCrossfilterSelection(row);
                        if (sel === 1) tr.className = 'tdx-sel';
                        else if (sel === 2) tr.className = 'tdx-dim';
                    } catch (e) { }
                    tr.style.cursor = 'pointer';
                    tr.addEventListener('click', function (evt) {
                        try { LookerCharts.Utils.toggleCrossfilter({ row: row, event: evt }); } catch (e) { }
                    });
                }

                if (showNum) {
                    var td0 = document.createElement('td');
                    td0.className = 'tdx-rownum' + (freeze ? ' tdx-freeze' : '');
                    td0.textContent = String(offset + i + 1);
                    tr.appendChild(td0);
                }

                cols.forEach(function (c, idx) {
                    var td = document.createElement('td');
                    var cls = [];
                    if (c.numeric) cls.push('tdx-num');
                    if (freeze && idx === 0 && !showNum) cls.push('tdx-freeze');
                    var cell = c.get(row);
                    if (cell) {
                        td.innerHTML = cellHtml(cell);

                        // Drill (solo si no hay crossfilter, para no chocar con el clic de fila)
                        if (!xf && cell.links && cell.links.length) {
                            cls.push('tdx-link');
                            td.addEventListener('click', function (evt) {
                                try { LookerCharts.Utils.openDrillMenu({ links: cell.links, event: evt }); } catch (e) { }
                            });
                        }

                        // Formato condicional
                        var t = fmt && fmt[c.key];
                        var v = Number(cell.value);
                        if (t && cell.value != null && !isNaN(v) && isFinite(t.min)) {
                            var range = t.max - t.min;
                            var ratio = range === 0 ? 1 : (v - t.min) / range;
                            if (cfg.formato_condicional === 'barras') {
                                var pct = Math.max(2, Math.round(ratio * 100));
                                td.style.backgroundImage = 'linear-gradient(to left,' +
                                    hexWithAlpha(cfg.color_max || '#1a73e8', 0.28) + ' ' + pct + '%, transparent ' + pct + '%)';
                            } else if (cfg.formato_condicional === 'escala') {
                                var bg = mix(cfg.color_min || '#ffffff', cfg.color_max || '#1a73e8', ratio);
                                td.style.setProperty('background', bg, 'important');
                                td.style.color = luminance(bg) < 0.55 ? '#ffffff' : '#202124';
                            }
                        }
                    }
                    td.className = cls.join(' ');
                    tr.appendChild(td);
                });
                tbody.appendChild(tr);
            });
            table.appendChild(tbody);

            // ----- TFOOT (totales de Looker) -----
            var totals = ctx.qr && ctx.qr.totals_data;
            if (cfg.mostrar_totales !== false && totals) {
                var tfoot = document.createElement('tfoot');
                var fr = document.createElement('tr');
                var labelPlaced = false;
                if (showNum) {
                    var tf0 = document.createElement('td');
                    tf0.className = 'tdx-rownum' + (freeze ? ' tdx-freeze' : '');
                    fr.appendChild(tf0);
                }
                cols.forEach(function (c, idx) {
                    var td = document.createElement('td');
                    var cls = [];
                    if (c.numeric) cls.push('tdx-num');
                    if (freeze && idx === 0 && !showNum) cls.push('tdx-freeze');
                    var tc = totals[c.field.name];
                    if (tc && c.pivotKey != null) tc = tc[c.pivotKey];
                    if (tc && 'value' in tc) {
                        td.innerHTML = cellHtml(tc);
                    } else if (!labelPlaced && !c.numeric) {
                        td.textContent = 'Total';
                        labelPlaced = true;
                    }
                    td.className = cls.join(' ');
                    fr.appendChild(td);
                });
                tfoot.appendChild(fr);
                table.appendChild(tfoot);
            }

            this._scroll.innerHTML = '';
            this._scroll.appendChild(table);

            // ----- Paginador -----
            this._pager.innerHTML = '';
            if (per > 0 && pages > 1) {
                var mk = function (txt, page, disabled) {
                    var b = document.createElement('button');
                    b.textContent = txt; b.disabled = disabled;
                    b.addEventListener('click', function () {
                        st.page = page; self._renderTable(); self._scroll.scrollTop = 0;
                    });
                    return b;
                };
                this._pager.appendChild(mk('\u00AB', 0, st.page === 0));
                this._pager.appendChild(mk('\u2039', st.page - 1, st.page === 0));
                var lbl = document.createElement('span');
                lbl.textContent = 'P\u00E1gina ' + (st.page + 1) + ' de ' + pages;
                this._pager.appendChild(lbl);
                this._pager.appendChild(mk('\u203A', st.page + 1, st.page >= pages - 1));
                this._pager.appendChild(mk('\u00BB', pages - 1, st.page >= pages - 1));
                this._pager.style.display = '';
            } else {
                this._pager.style.display = 'none';
            }
        }
    };

    looker.plugins.visualizations.add(vis);
})();

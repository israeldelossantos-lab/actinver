/**
 * Tabla Agrupada (Deacero) - Visualizacion personalizada para Looker
 *
 * Tabla con agrupacion por dimensiones (expandir / contraer) que SIEMPRE
 * muestra valores en las columnas numericas de las filas de grupo:
 *  - Grupo con 1 fila  -> muestra el valor original (mismo formato / html de LookML)
 *  - Grupo con N filas -> calcula suma / promedio / min / max segun configuracion
 *
 * Ademas: dos modos de agrupado (columnas separadas o arbol en una sola columna),
 * conteo de filas por grupo, ordenamiento, buscador, totales, encabezado fijo,
 * primera columna fija, drill, crossfilter, pivotes y negritas por texto.
 *
 * Nota: archivo en ASCII (acentos/simbolos como \uXXXX) para evitar problemas
 * de codificacion al servirse desde Looker.
 */

(function () {
    'use strict';

    var CSS = [
        '.tga-wrap{width:100%;height:100%;display:flex;flex-direction:column;font-family:Roboto,"Noto Sans",Arial,sans-serif;font-size:12px;color:#3c4043;box-sizing:border-box;}',
        '.tga-wrap *{box-sizing:border-box;}',
        '.tga-top{flex:0 0 auto;display:flex;align-items:center;gap:8px;padding:4px 4px 8px;flex-wrap:wrap;}',
        '.tga-title{font-size:14px;font-weight:500;color:#202124;margin-right:4px;}',
        '.tga-count{font-size:12px;color:#80868b;}',
        '.tga-spacer{flex:1 1 auto;}',
        '.tga-btn{height:26px;padding:0 10px;border:1px solid #dadce0;background:#fff;border-radius:13px;cursor:pointer;color:#3c4043;font-size:12px;}',
        '.tga-btn:hover{background:#f1f3f4;}',
        '.tga-search{height:26px;min-width:170px;padding:0 10px;border:1px solid #dadce0;border-radius:13px;font-size:12px;outline:none;color:#3c4043;background:#fff;}',
        '.tga-search:focus{border-color:#1a73e8;box-shadow:0 0 0 1px #1a73e8;}',
        '.tga-scroll{flex:1 1 0;min-height:0;overflow:auto;border:1px solid #e0e0e0;border-radius:10px;box-shadow:0 1px 3px rgba(60,64,67,.12);background:#fff;}',
        '.tga-scroll::-webkit-scrollbar{width:10px;height:10px;}',
        '.tga-scroll::-webkit-scrollbar-thumb{background:#c4c7cc;border-radius:10px;border:2px solid #fff;}',
        '.tga-scroll::-webkit-scrollbar-track{background:transparent;}',
        '.tga-scroll::-webkit-scrollbar-corner{background:transparent;}',
        '.tga-toggle{border-radius:50%;}',
        '.tga-labelcell:hover .tga-toggle{background:#e8eaed;}',
        '.tga-table{border-collapse:separate;border-spacing:0;min-width:100%;}',
        '.tga-table td,.tga-table th{white-space:nowrap;}',
        '.tga-table th{position:sticky;top:0;z-index:2;font-weight:500;text-align:center;cursor:pointer;user-select:none;border-bottom:1px solid #c7c7c7;}',
        '.tga-table th .tga-sort{margin-left:4px;font-size:9px;opacity:.6;}',
        '.tga-table th .tga-pivot{display:block;font-weight:400;font-size:11px;opacity:.85;}',
        '.tga-table td{background:#fff;border-bottom:1px solid #eeeeee;}',
        '.tga-vb td,.tga-vb th{border-right:1px solid #e3e3e3;}',
        '.tga-zebra tbody tr:nth-child(even) td{background:#fafafa;}',
        '.tga-table tbody tr:hover td{background:#eef3fd !important;}',
        '.tga-table tbody tr.tga-sel td{background:#d2e3fc !important;}',
        '.tga-table tbody tr.tga-dimmed td{opacity:.55;}',
        '.tga-table tfoot td{position:sticky;bottom:0;z-index:2;background:#f5f5f5;font-weight:600;border-top:1px solid #c7c7c7;}',
        '.tga-d-compacta th,.tga-d-compacta td{padding:2px 8px;}',
        '.tga-d-normal th,.tga-d-normal td{padding:5px 10px;}',
        '.tga-d-amplia th,.tga-d-amplia td{padding:9px 14px;}',
        '.tga-num{text-align:right;font-variant-numeric:tabular-nums;}',
        '.tga-freeze{position:sticky;left:0;z-index:1;}',
        '.tga-table th.tga-freeze{z-index:3;}',
        '.tga-table tfoot td.tga-freeze{z-index:3;}',
        '.tga-label{display:inline-flex;align-items:center;gap:4px;}',
        '.tga-toggle{display:inline-block;width:14px;text-align:center;font-size:9px;color:#5f6368;cursor:pointer;}',
        '.tga-cnt{color:#80868b;font-weight:400;margin-left:auto;padding-left:12px;}',
        '.tga-labelcell{cursor:pointer;}',
        '.tga-labelcell .tga-label{width:100%;}',
        '.tga-bold td{font-weight:700;}',
        '.tga-link{cursor:pointer;}',
        '.tga-link:hover{text-decoration:underline;}',
        '.tga-empty{padding:24px;text-align:center;color:#80868b;}'
    ].join('\n');

    var ARROW_RIGHT = '\u25B6', ARROW_DOWN = '\u25BC';
    var SORT_UP = '\u25B2', SORT_DOWN = '\u25BC';

    // ------------------------------------------------------------------ utilidades
    function esc(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function isNumericField(f) {
        return !!(f && (f.is_numeric || f.type === 'number' || f.type === 'count' ||
            f.type === 'sum' || f.type === 'average' || f.type === 'count_distinct'));
    }

    function isNull(cell) {
        return !cell || (cell.value == null && (cell.rendered == null || cell.rendered === '') && !cell.html);
    }

    function cellText(cell) {
        if (!cell) return '';
        if (cell.rendered != null && cell.rendered !== '') return String(cell.rendered);
        return cell.value == null ? '' : String(cell.value);
    }

    function cellHtml(cell, nullText) {
        if (isNull(cell)) return esc(nullText);
        try {
            if (typeof LookerCharts !== 'undefined' && LookerCharts.Utils && LookerCharts.Utils.htmlForCell) {
                var h = LookerCharts.Utils.htmlForCell(cell);
                if (h != null && h !== '') return h;
            }
        } catch (e) { /* fallback */ }
        return esc(cellText(cell));
    }

    function toNumber(cell) {
        if (!cell || cell.value == null || cell.value === '') return null;
        var n = Number(cell.value);
        return isFinite(n) ? n : null;
    }

    // ------------------------------------------------------------------ formato numerico
    // Deduce el formato (prefijo, sufijo, decimales, separadores, factor) a partir de
    // los valores ya formateados por Looker, para formatear igual los agregados.
    function parseRendered(rendered, value) {
        var s = String(rendered).trim();
        var first = s.search(/\d/);
        if (first < 0) return null;
        var last = first;
        for (var i = s.length - 1; i >= 0; i--) { if (/\d/.test(s[i])) { last = i; break; } }
        var prefix = s.slice(0, first).replace(/[-\u2212(]/g, '');
        var suffix = s.slice(last + 1).replace(/[)]/g, '');
        var num = s.slice(first, last + 1);

        var dots = (num.match(/\./g) || []).length;
        var commas = (num.match(/,/g) || []).length;
        var decSep = '.', grpSep = ',';
        if (dots && commas) {
            decSep = num.lastIndexOf('.') > num.lastIndexOf(',') ? '.' : ',';
            grpSep = decSep === '.' ? ',' : '.';
        } else if (dots + commas === 1) {
            var sep = dots ? '.' : ',';
            var parts = num.split(sep);
            var isDecimal = parts[1].length !== 3 || /^0+$/.test(parts[0]);
            if (isDecimal) { decSep = sep; grpSep = sep === '.' ? ',' : '.'; }
            else { grpSep = sep; decSep = sep === '.' ? ',' : '.'; }
        } else if (dots > 1) { grpSep = '.'; decSep = ','; }

        var decimals = num.indexOf(decSep) >= 0 ? num.split(decSep)[1].replace(/\D/g, '').length : 0;
        var intDigits = num.split(decSep)[0].replace(/\D/g, '').length;
        // con 4+ digitos enteros se sabe si usa separador de miles; si no, se desconoce (null)
        var grouping = num.indexOf(grpSep) >= 0 ? true : (intDigits >= 4 ? false : null);
        var parsed = Number(num.split(grpSep).join('').replace(decSep, '.'));

        var factor = 1;
        if (value && parsed && isFinite(parsed)) {
            var ratio = Math.abs(parsed / value);
            var candidates = [1, 100, 1e-3, 1e-6, 1e-9];
            var best = 1, bestDiff = Infinity;
            candidates.forEach(function (c) {
                var d = Math.abs(Math.log(ratio) - Math.log(c));
                if (d < bestDiff) { bestDiff = d; best = c; }
            });
            factor = best;
        }
        return { prefix: prefix, suffix: suffix, decimals: decimals, decSep: decSep, grpSep: grpSep, grouping: grouping, factor: factor };
    }

    function makeFormatter(col, rows) {
        var fmt = null, maxDec = 0, grouping = null;
        for (var i = 0; i < rows.length && i < 300; i++) {
            var cell = col.get(rows[i]);
            var v = toNumber(cell);
            if (v == null || !cell.rendered) continue;
            var p = parseRendered(cell.rendered, v);
            if (!p) continue;
            if (p.decimals > maxDec) maxDec = p.decimals;
            if (p.grouping != null && grouping == null) grouping = p.grouping;
            if (!fmt || (fmt.factor === 1 && v !== 0 && p.factor !== 1)) fmt = p;
        }
        if (fmt) {
            fmt.decimals = Math.max(fmt.decimals, maxDec);
            fmt.grouping = grouping == null ? true : grouping; // por defecto con separador de miles
        }

        var isPct = !!(fmt && fmt.suffix.indexOf('%') >= 0) ||
            /percent/i.test((col.field && col.field.value_format_name) || '') ||
            /%/.test((col.field && col.field.value_format) || '');

        var format = function (x) {
            if (x == null || !isFinite(x)) return null;
            if (!fmt) return x.toLocaleString('en-US', { maximumFractionDigits: 2 });
            var y = x * fmt.factor;
            var neg = y < 0;
            var str = Math.abs(y).toFixed(fmt.decimals);
            var intPart = str.split('.')[0], frac = str.split('.')[1];
            if (fmt.grouping) intPart = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, fmt.grpSep);
            var out = intPart + (frac ? fmt.decSep + frac : '');
            return (neg && Number(str) !== 0 ? '-' : '') + fmt.prefix + out + fmt.suffix;
        };
        return { format: format, isPct: isPct };
    }

    function aggregate(values, method) {
        if (!values.length || method === 'ninguna') return null;
        var i, r;
        switch (method) {
            case 'promedio':
                r = 0; for (i = 0; i < values.length; i++) r += values[i];
                return r / values.length;
            case 'min':
                return Math.min.apply(null, values);
            case 'max':
                return Math.max.apply(null, values);
            default: // suma
                r = 0; for (i = 0; i < values.length; i++) r += values[i];
                return r;
        }
    }

    // ------------------------------------------------------------------ columnas
    function buildColumns(data, qr) {
        var fields = qr.fields || {};
        var dims = fields.dimension_like || fields.dimensions || [];
        var meas = fields.measure_like || (fields.measures || []).concat(fields.table_calculations || []);
        var pivots = qr.pivots || [];
        var sample = data[0] || {};
        var cols = [];

        dims.forEach(function (f) {
            cols.push({
                key: f.name, field: f, isDim: true,
                label: f.label_short || f.label || f.name,
                numeric: false,
                get: function (row) { return row[f.name]; }
            });
        });

        meas.forEach(function (f) {
            var s = sample[f.name];
            var pivoted = pivots.length > 0 && s && !('value' in s);
            var numeric = isNumericField(f) || f.is_numeric !== false;
            if (!pivoted) {
                cols.push({
                    key: f.name, field: f, isDim: false,
                    label: f.label_short || f.label || f.name, numeric: numeric,
                    get: function (row) { return row[f.name]; }
                });
            } else {
                pivots.forEach(function (p) {
                    var pk = p.key;
                    var pLabel = pk === '$$$_row_total_$$$' ? 'Total' :
                        (p.data ? Object.keys(p.data).map(function (k) {
                            var d = p.data[k];
                            return d && typeof d === 'object' ? cellText(d) : String(d == null ? '' : d);
                        }).join(' | ') : pk);
                    cols.push({
                        key: f.name + '||' + pk, field: f, isDim: false, pivotKey: pk,
                        label: f.label_short || f.label || f.name, pivotLabel: pLabel,
                        numeric: numeric,
                        get: function (row) { return row[f.name] ? row[f.name][pk] : null; }
                    });
                });
            }
        });
        return cols;
    }

    function parseOverrides(text) {
        var map = {};
        String(text || '').split(',').forEach(function (pair) {
            var p = pair.split(':');
            if (p.length === 2 && p[0].trim()) map[p[0].trim()] = p[1].trim().toLowerCase();
        });
        return map;
    }

    // ------------------------------------------------------------------ visualizacion
    var vis = {
        id: 'deacero-tabla-agrupada',
        label: 'Tabla Agrupada (Deacero)',
        options: {
            // --- Agrupado
            niveles_agrupacion: { type: 'number', label: 'Niveles de agrupado - solo modo columnas (0 = todas)', default: 0, section: 'Agrupado', order: 1 },
            modo_agrupacion: {
                type: 'string', label: 'Modo', display: 'select', default: 'arbol', section: 'Agrupado', order: 2,
                values: [{ 'Columnas separadas': 'columnas' }, { '\u00C1rbol (una columna)': 'arbol' }]
            },
            titulo_columna_grupo: { type: 'string', label: 'T\u00EDtulo columna de grupo (modo \u00E1rbol)', default: '', section: 'Agrupado', order: 3 },
            nivel_expandido: { type: 'number', label: 'Niveles expandidos al cargar (0 = todo contra\u00EDdo)', default: 0, section: 'Agrupado', order: 4 },
            mostrar_conteo: { type: 'boolean', label: 'Mostrar conteo de filas (n)', default: true, section: 'Agrupado', order: 5 },
            // --- Calculos en grupos
            agregacion_numericos: {
                type: 'string', label: 'C\u00E1lculo para columnas num\u00E9ricas', display: 'select', default: 'suma', section: 'C\u00E1lculos', order: 1,
                values: [{ 'Suma': 'suma' }, { 'Promedio': 'promedio' }, { 'M\u00EDnimo': 'min' }, { 'M\u00E1ximo': 'max' }, { 'Ninguno (en blanco)': 'ninguna' }]
            },
            agregacion_porcentajes: {
                type: 'string', label: 'C\u00E1lculo para columnas de porcentaje', display: 'select', default: 'promedio', section: 'C\u00E1lculos', order: 2,
                values: [{ 'Promedio': 'promedio' }, { 'Suma': 'suma' }, { 'M\u00EDnimo': 'min' }, { 'M\u00E1ximo': 'max' }, { 'Ninguno (en blanco)': 'ninguna' }]
            },
            agregacion_por_columna: {
                type: 'string', label: 'Excepciones por campo (campo:suma, campo:promedio, ...)', default: '', section: 'C\u00E1lculos', order: 3
            },
            texto_nulo: { type: 'string', label: 'Texto para valores nulos', default: '\u2205', section: 'C\u00E1lculos', order: 4 },
            // --- Tabla
            titulo: { type: 'string', label: 'T\u00EDtulo', default: '', section: 'Tabla', order: 1 },
            mostrar_buscador: { type: 'boolean', label: 'Mostrar buscador', default: true, section: 'Tabla', order: 2 },
            mostrar_totales: { type: 'boolean', label: 'Mostrar totales', default: true, section: 'Tabla', order: 3 },
            fijar_primera_columna: { type: 'boolean', label: 'Fijar primera columna', default: true, section: 'Tabla', order: 4 },
            // --- Estilo
            densidad: {
                type: 'string', label: 'Densidad', display: 'select', default: 'compacta', section: 'Estilo', order: 1,
                values: [{ 'Compacta': 'compacta' }, { 'Normal': 'normal' }, { 'Amplia': 'amplia' }]
            },
            color_encabezado: { type: 'string', label: 'Color de encabezado', display: 'color', default: '#3d85c6', section: 'Estilo', order: 2 },
            color_texto_encabezado: { type: 'string', label: 'Color texto de encabezado', display: 'color', default: '#ffffff', section: 'Estilo', order: 3 },
            bordes_verticales: { type: 'boolean', label: 'Bordes verticales', default: true, section: 'Estilo', order: 4 },
            radio_bordes: { type: 'number', label: 'Redondeo de contorno (px, 0 = recto)', default: 10, section: 'Estilo', order: 8 },
            zebra: { type: 'boolean', label: 'Filas alternadas', default: false, section: 'Estilo', order: 5 },
            grupos_en_negritas: { type: 'boolean', label: 'Filas de grupo en negritas', default: false, section: 'Estilo', order: 6 },
            negritas_si_contiene: { type: 'string', label: 'Negritas si el grupo contiene (ej. TOTAL, VENTAS NETAS)', default: '', section: 'Estilo', order: 7 }
        },

        create: function (element) {
            var style = document.createElement('style');
            style.textContent = CSS;
            element.appendChild(style);
            this._wrap = document.createElement('div');
            this._wrap.className = 'tga-wrap';
            element.appendChild(this._wrap);
            this._state = { sortKey: null, asc: true, query: '', expanded: {}, expandAll: null };
        },

        updateAsync: function (data, element, config, queryResponse, details, done) {
            this.clearErrors();
            var fields = (queryResponse && queryResponse.fields) || {};
            var dims = fields.dimension_like || fields.dimensions || [];
            if (!dims.length) {
                this.addError({ title: 'Se requiere una dimensi\u00F3n', message: 'Agrega al menos una dimensi\u00F3n para agrupar.' });
                done(); return;
            }

            config = config || {};
            data = data || [];
            var cols = buildColumns(data, queryResponse);
            var dimCols = cols.filter(function (c) { return c.isDim; });

            var levels = Math.round(Number(config.niveles_agrupacion));
            // Modo arbol: SIEMPRE anida todas las dimensiones en la primera columna.
            // Modo columnas: agrupa por las primeras N (0 / vacio = todas).
            if (config.modo_agrupacion !== 'columnas' || isNaN(levels) || levels < 1 || levels > dimCols.length) {
                levels = dimCols.length;
            }

            // formateadores y metodo de calculo por columna numerica
            var overrides = parseOverrides(config.agregacion_por_columna);
            cols.forEach(function (c) {
                if (!c.numeric) return;
                var f = makeFormatter(c, data);
                c.format = f.format;
                c.isPct = f.isPct;
                c.method = overrides[c.field.name] ||
                    (f.isPct ? (config.agregacion_porcentajes || 'promedio') : (config.agregacion_numericos || 'suma'));
            });

            // si cambian los campos, reinicia orden y expansion
            var sig = cols.map(function (c) { return c.key; }).join(',') + '|' + levels + '|' + config.modo_agrupacion;
            if (sig !== this._sig) {
                this._sig = sig;
                this._state.expanded = {};
                this._state.expandAll = null;
                if (this._state.sortKey && this._state.sortKey !== '__tree__' &&
                    !cols.some(function (c) { return c.key === this._state.sortKey; }, this)) {
                    this._state.sortKey = null;
                }
            }

            this._ctx = {
                data: data, config: config, qr: queryResponse, details: details || {},
                cols: cols, groupCols: dimCols.slice(0, levels), levels: levels,
                allDimsGrouped: levels === dimCols.length,
                nullText: config.texto_nulo == null ? '\u2205' : String(config.texto_nulo),
                boldWords: String(config.negritas_si_contiene || '').split(',')
                    .map(function (s) { return s.trim().toUpperCase(); }).filter(Boolean)
            };

            this._renderShell();
            this._render();
            done();
        },

        // ---------------------------------------------------------- barra superior
        _renderShell: function () {
            var self = this, cfg = this._ctx.config, w = this._wrap;
            w.innerHTML = '';
            var top = document.createElement('div');
            top.className = 'tga-top';

            if (cfg.titulo) {
                var t = document.createElement('span');
                t.className = 'tga-title'; t.textContent = cfg.titulo;
                top.appendChild(t);
            }
            this._countEl = document.createElement('span');
            this._countEl.className = 'tga-count';
            top.appendChild(this._countEl);

            var sp = document.createElement('span'); sp.className = 'tga-spacer'; top.appendChild(sp);

            var mkBtn = function (txt, fn) {
                var b = document.createElement('button');
                b.className = 'tga-btn'; b.textContent = txt;
                b.addEventListener('click', fn);
                top.appendChild(b);
            };
            mkBtn('Expandir todo', function () { self._state.expanded = {}; self._state.expandAll = true; self._render(); });
            mkBtn('Contraer todo', function () { self._state.expanded = {}; self._state.expandAll = false; self._render(); });

            if (cfg.mostrar_buscador !== false) {
                var inp = document.createElement('input');
                inp.type = 'search'; inp.className = 'tga-search';
                inp.placeholder = 'Buscar\u2026';
                inp.value = this._state.query;
                var timer = null;
                inp.addEventListener('input', function () {
                    clearTimeout(timer);
                    timer = setTimeout(function () { self._state.query = inp.value; self._render(); }, 150);
                });
                top.appendChild(inp);
            } else {
                this._state.query = '';
            }
            w.appendChild(top);

            this._scroll = document.createElement('div');
            this._scroll.className = 'tga-scroll';
            w.appendChild(this._scroll);
        },

        // ---------------------------------------------------------- arbol de grupos
        _buildTree: function (rows, level, parentId) {
            var ctx = this._ctx;
            if (level >= ctx.levels) return null;
            var gc = ctx.groupCols[level];
            var map = {}, order = [];
            rows.forEach(function (r) {
                var cell = gc.get(r);
                var k = cell && cell.value != null ? String(cell.value) : '\u0000null';
                if (!map[k]) { map[k] = []; order.push(k); }
                map[k].push(r);
            });
            var self = this;
            return order.map(function (k) {
                var groupRows = map[k];
                var id = parentId + '\u0001' + k;
                var node = {
                    type: 'group', id: id, level: level, key: k,
                    labelCell: gc.get(groupRows[0]), rows: groupRows, agg: {}
                };
                ctx.cols.forEach(function (c) {
                    if (!c.numeric) return;
                    var vals = [];
                    groupRows.forEach(function (r) { var v = toNumber(c.get(r)); if (v != null) vals.push(v); });
                    node.agg[c.key] = groupRows.length === 1 ? (vals.length ? vals[0] : null) : aggregate(vals, c.method);
                });
                // ultimo nivel con todas las dimensiones agrupadas: el grupo es la fila final
                node.terminal = level === ctx.levels - 1 && ctx.allDimsGrouped;
                node.children = node.terminal ? null :
                    (level + 1 < ctx.levels ? self._buildTree(groupRows, level + 1, id) : groupRows.map(function (r) { return { type: 'leaf', row: r, level: level + 1 }; }));
                return node;
            });
        },

        _sortValue: function (item, col) {
            if (col === '__tree__') {
                return item.type === 'group' ? (item.labelCell ? item.labelCell.value : null) : null;
            }
            if (item.type === 'leaf') { var c = col.get(item.row); return c ? c.value : null; }
            if (col.numeric) return item.agg[col.key];
            var gcol = this._ctx.groupCols[item.level];
            if (gcol && gcol.key === col.key) return item.labelCell ? item.labelCell.value : null;
            var cell = col.get(item.rows[0]);
            return cell ? cell.value : null;
        },

        _sortTree: function (items) {
            var st = this._state, self = this;
            if (!items) return;
            if (st.sortKey) {
                var col = st.sortKey === '__tree__' ? '__tree__' :
                    this._ctx.cols.filter(function (c) { return c.key === st.sortKey; })[0];
                if (col) {
                    var dir = st.asc ? 1 : -1;
                    var numeric = col !== '__tree__' && col.numeric;
                    items.sort(function (a, b) {
                        var va = self._sortValue(a, col), vb = self._sortValue(b, col);
                        if (va == null && vb == null) return 0;
                        if (va == null) return 1;
                        if (vb == null) return -1;
                        if (numeric || (!isNaN(Number(va)) && !isNaN(Number(vb)) && va !== '' && vb !== '')) {
                            return (Number(va) - Number(vb)) * dir;
                        }
                        return String(va).localeCompare(String(vb), 'es', { numeric: true, sensitivity: 'base' }) * dir;
                    });
                }
            }
            items.forEach(function (it) { if (it.type === 'group') self._sortTree(it.children); });
        },

        _isExpanded: function (node) {
            var st = this._state;
            if (Object.prototype.hasOwnProperty.call(st.expanded, node.id)) return st.expanded[node.id];
            if (st.expandAll != null) return st.expandAll;
            var lvl = Number(this._ctx.config.nivel_expandido) || 0;
            return node.level < lvl;
        },

        // ---------------------------------------------------------- render principal
        _render: function () {
            var self = this, ctx = this._ctx, cfg = ctx.config, st = this._state;
            var xf = !!ctx.details.crossfilterEnabled;
            var arbol = cfg.modo_agrupacion !== 'columnas';

            // 1. filtrar por buscador
            var rows = ctx.data;
            var q = (st.query || '').trim().toLowerCase();
            if (q) {
                rows = rows.filter(function (r) {
                    for (var i = 0; i < ctx.cols.length; i++) {
                        if (cellText(ctx.cols[i].get(r)).toLowerCase().indexOf(q) !== -1) return true;
                    }
                    return false;
                });
            }
            this._countEl.textContent = (q ? rows.length + ' de ' + ctx.data.length : ctx.data.length) + ' registros';

            // 2. arbol + orden
            var tree = this._buildTree(rows, 0, '');
            this._sortTree(tree);

            // 3. columnas visibles
            var groupKeys = {};
            ctx.groupCols.forEach(function (g, i) { groupKeys[g.key] = i; });
            var display = [];
            if (arbol) {
                display.push({ tree: true });
                ctx.cols.forEach(function (c) { if (!(c.key in groupKeys)) display.push({ col: c }); });
            } else {
                ctx.cols.forEach(function (c) { display.push({ col: c, groupLevel: c.key in groupKeys ? groupKeys[c.key] : null }); });
            }

            var table = document.createElement('table');
            table.className = 'tga-table tga-d-' + (cfg.densidad || 'compacta') +
                (cfg.bordes_verticales !== false ? ' tga-vb' : '') +
                (cfg.zebra ? ' tga-zebra' : '');
            var freeze = cfg.fijar_primera_columna !== false;
            var hdrBg = cfg.color_encabezado || '#3d85c6';
            var hdrFg = cfg.color_texto_encabezado || '#ffffff';
            var radius = Number(cfg.radio_bordes);
            if (cfg.radio_bordes == null || cfg.radio_bordes === '' || isNaN(radius) || radius < 0) radius = 10;
            this._scroll.style.borderRadius = radius + 'px';

            // ---- encabezado
            var thead = document.createElement('thead');
            var hr = document.createElement('tr');
            display.forEach(function (d, idx) {
                var th = document.createElement('th');
                th.style.background = hdrBg; th.style.color = hdrFg;
                var key = d.tree ? '__tree__' : d.col.key;
                var cls = [];
                if (freeze && idx === 0) cls.push('tga-freeze');
                th.className = cls.join(' ');
                if (d.tree) {
                    th.appendChild(document.createTextNode(cfg.titulo_columna_grupo ||
                        ctx.groupCols.map(function (g) { return g.label; }).join(' / ')));
                } else {
                    if (d.col.field && d.col.field.description) th.title = d.col.field.description;
                    if (d.col.pivotLabel != null) {
                        var pv = document.createElement('span');
                        pv.className = 'tga-pivot'; pv.textContent = d.col.pivotLabel;
                        th.appendChild(pv);
                    }
                    th.appendChild(document.createTextNode(d.col.label));
                }
                if (st.sortKey === key) {
                    var s = document.createElement('span');
                    s.className = 'tga-sort';
                    s.textContent = st.asc ? SORT_UP : SORT_DOWN;
                    th.appendChild(s);
                }
                th.addEventListener('click', function () {
                    var initialAsc = d.tree || !d.col.numeric;
                    if (st.sortKey !== key) { st.sortKey = key; st.asc = initialAsc; }
                    else if (st.asc === initialAsc) { st.asc = !initialAsc; }
                    else { st.sortKey = null; st.asc = true; }
                    self._render();
                });
                hr.appendChild(th);
            });
            thead.appendChild(hr);
            table.appendChild(thead);

            // ---- cuerpo
            var tbody = document.createElement('tbody');
            var nullText = ctx.nullText;

            var labelContent = function (node, indentPx) {
                var wrap = document.createElement('span');
                wrap.className = 'tga-label';
                if (indentPx) wrap.style.paddingLeft = indentPx + 'px';
                var tg = document.createElement('span');
                tg.className = 'tga-toggle';
                tg.textContent = node.terminal ? '' : (self._isExpanded(node) ? ARROW_DOWN : ARROW_RIGHT);
                wrap.appendChild(tg);
                var lb = document.createElement('span');
                lb.innerHTML = cellHtml(node.labelCell, nullText);
                wrap.appendChild(lb);
                if (cfg.mostrar_conteo !== false) {
                    var cn = document.createElement('span');
                    cn.className = 'tga-cnt'; cn.textContent = '(' + node.rows.length + ')';
                    wrap.appendChild(cn);
                }
                return wrap;
            };

            var isBold = function (node) {
                if (cfg.grupos_en_negritas) return true;
                if (!ctx.boldWords.length) return false;
                var txt = cellText(node.labelCell).toUpperCase();
                return ctx.boldWords.some(function (w) { return txt.indexOf(w) !== -1; });
            };

            var attachRowEvents = function (tr, row) {
                if (!xf || typeof LookerCharts === 'undefined') return;
                try {
                    var sel = LookerCharts.Utils.getCrossfilterSelection(row);
                    if (sel === 1) tr.classList.add('tga-sel');
                    else if (sel === 2) tr.classList.add('tga-dimmed');
                } catch (e) { }
                tr.style.cursor = 'pointer';
                tr.addEventListener('click', function (evt) {
                    try { LookerCharts.Utils.toggleCrossfilter({ row: row, event: evt }); } catch (e) { }
                });
            };

            var valueCell = function (td, cell) {
                td.innerHTML = cellHtml(cell, nullText);
                if (!xf && cell && cell.links && cell.links.length) {
                    td.classList.add('tga-link');
                    td.addEventListener('click', function (evt) {
                        evt.stopPropagation();
                        try { LookerCharts.Utils.openDrillMenu({ links: cell.links, event: evt }); } catch (e) { }
                    });
                }
            };

            var renderGroup = function (node) {
                var tr = document.createElement('tr');
                if (isBold(node)) tr.className = 'tga-bold';
                var single = node.rows.length === 1;
                var toggle = function (evt) {
                    if (node.terminal) return;
                    evt.stopPropagation();
                    st.expanded[node.id] = !self._isExpanded(node);
                    self._render();
                };

                display.forEach(function (d, idx) {
                    var td = document.createElement('td');
                    if (freeze && idx === 0) td.classList.add('tga-freeze');
                    var isLabelCol = d.tree || d.groupLevel === node.level;
                    if (isLabelCol) {
                        td.appendChild(labelContent(node, d.tree ? node.level * 16 : 0));
                        if (!node.terminal) { td.classList.add('tga-labelcell'); td.addEventListener('click', toggle); }
                    } else if (d.col.numeric) {
                        td.classList.add('tga-num');
                        if (single) {
                            valueCell(td, d.col.get(node.rows[0]));
                        } else {
                            var v = node.agg[d.col.key];
                            td.textContent = v == null ? (d.col.method === 'ninguna' ? '' : nullText) : d.col.format(v);
                        }
                    } else if (d.groupLevel != null && d.groupLevel < node.level) {
                        td.textContent = '';
                    } else if (single && (d.col.isDim ? node.terminal : true)) {
                        // medida de texto en grupo de una fila, o dimension en grupo final
                        valueCell(td, d.col.get(node.rows[0]));
                    }
                    tr.appendChild(td);
                });
                if (node.terminal) attachRowEvents(tr, node.rows[0]);
                tbody.appendChild(tr);
            };

            var renderLeaf = function (leaf) {
                var tr = document.createElement('tr');
                display.forEach(function (d, idx) {
                    var td = document.createElement('td');
                    if (freeze && idx === 0) td.classList.add('tga-freeze');
                    if (d.tree) {
                        td.textContent = '';
                    } else if (d.groupLevel != null) {
                        td.textContent = '';
                    } else {
                        if (d.col.numeric) td.classList.add('tga-num');
                        valueCell(td, d.col.get(leaf.row));
                    }
                    tr.appendChild(td);
                });
                attachRowEvents(tr, leaf.row);
                tbody.appendChild(tr);
            };

            var walk = function (items) {
                (items || []).forEach(function (it) {
                    if (it.type === 'leaf') { renderLeaf(it); return; }
                    renderGroup(it);
                    if (!it.terminal && self._isExpanded(it)) walk(it.children);
                });
            };

            if (!tree || !tree.length) {
                var er = document.createElement('tr');
                var ed = document.createElement('td');
                ed.colSpan = display.length; ed.className = 'tga-empty';
                ed.textContent = q ? 'Sin coincidencias para "' + st.query + '"' : 'Sin datos para los filtros actuales';
                er.appendChild(ed); tbody.appendChild(er);
            } else {
                walk(tree);
            }
            table.appendChild(tbody);

            // ---- totales
            if (cfg.mostrar_totales !== false && rows.length) {
                var totals = (!q && ctx.qr && ctx.qr.totals_data) || null;
                var tfoot = document.createElement('tfoot');
                var fr = document.createElement('tr');
                display.forEach(function (d, idx) {
                    var td = document.createElement('td');
                    if (freeze && idx === 0) td.classList.add('tga-freeze');
                    if (idx === 0) {
                        td.textContent = 'Totales';
                    } else if (d.col && d.col.numeric) {
                        td.classList.add('tga-num');
                        var tc = totals ? totals[d.col.field.name] : null;
                        if (tc && d.col.pivotKey != null) tc = tc[d.col.pivotKey];
                        if (tc && 'value' in tc && tc.value != null) {
                            td.innerHTML = cellHtml(tc, nullText);
                        } else {
                            var vals = [];
                            rows.forEach(function (r) { var v = toNumber(d.col.get(r)); if (v != null) vals.push(v); });
                            var tv = aggregate(vals, d.col.method);
                            td.textContent = tv == null ? '' : d.col.format(tv);
                        }
                    }
                    fr.appendChild(td);
                });
                tfoot.appendChild(fr);
                table.appendChild(tfoot);
            }

            var prevTop = this._scroll.scrollTop, prevLeft = this._scroll.scrollLeft;
            this._scroll.innerHTML = '';
            this._scroll.appendChild(table);
            this._scroll.scrollTop = prevTop;
            this._scroll.scrollLeft = prevLeft;
        }
    };

    looker.plugins.visualizations.add(vis);
})();

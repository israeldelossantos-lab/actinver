- dashboard: actinver_fondos_inversiones
  title: ""
  description: "Evolución de AUM, rendimientos mensuales vs benchmark, análisis de riesgo y flujos netos por fondo de inversión."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour
  filters_location_top: true

  filters:
    - name: periodo
      title: "Periodo"
      type: field_filter
      default_value: "2025/01/01 to 2026/10/01"
      allow_multiple_values: true
      required: false
      ui_config:
        type: advanced
        display: popover
      model: demos_looker
      explore: fact_rendimiento_fondos
      listens_to_filters: []
      field: fact_rendimiento_fondos.fecha_month

    - name: fondo
      title: "Fondo"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: fact_rendimiento_fondos
      listens_to_filters: []
      field: fact_rendimiento_fondos.producto_nombre

    - name: perfil_riesgo
      title: "Perfil de riesgo"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: fact_rendimiento_fondos
      listens_to_filters: []
      field: dim_productos.perfil_riesgo

    - name: fecha_corte
      title: "Fecha de corte"
      type: field_filter
      default_value: "2026/09/01"
      allow_multiple_values: false
      required: false
      ui_config:
        type: advanced
        display: popover
      model: demos_looker
      explore: fact_rendimiento_fondos
      listens_to_filters: []
      field: fact_rendimiento_fondos.fecha_date

  elements:
    - name: header_tile
      type: text
      body_text: "<div style='background: linear-gradient(135deg, #0A0E12 0%, #1A2433 100%); border-radius: 12px; padding: 18px 26px; border-left: 6px solid #0F6FF5; overflow: hidden;'><h2 style='color: #FFFFFF; font-size: 24px; font-weight: 700; margin: 0 0 6px 0; letter-spacing: -0.02em;'>Fondos e Inversiones</h2><p style='color: #FFFFFF; font-size: 13px; margin: 0; line-height: 1.5; opacity: 0.85;'>AUM, rendimiento contra benchmark, alpha y riesgo contra rendimiento por fondo de inversión.</p></div>"
      row: 0
      col: 0
      width: 24
      height: 4

    - name: kpi_aum_total
      title_hidden: true
      show_single_value_title: true
      title: "AUM Total"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: single_value
      fields: [fact_rendimiento_fondos.total_aum_mxn]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        fecha_corte: fact_rendimiento_fondos.fecha_date
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 4
      col: 0
      width: 4
      height: 2

    - name: kpi_crecimiento_aum
      title_hidden: true
      show_single_value_title: true
      title: "Crecimiento de AUM"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: single_value
      fields: [fact_rendimiento_fondos.crecimiento_aum_pct]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 4
      col: 4
      width: 4
      height: 2

    - name: kpi_rendimiento_ponderado
      title_hidden: true
      show_single_value_title: true
      title: "Rendimiento Mensual Ponderado"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: single_value
      fields: [fact_rendimiento_fondos.rendimiento_ponderado_aum_pct]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 4
      col: 8
      width: 4
      height: 2

    - name: kpi_alpha_promedio
      title_hidden: true
      show_single_value_title: true
      title: "Alpha Promedio (pp)"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: single_value
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      fields: [fact_rendimiento_fondos.alpha_promedio_pp]
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 4
      col: 12
      width: 4
      height: 2

    - name: kpi_meses_sobre_benchmark
      title_hidden: true
      show_single_value_title: true
      title: "% Meses Sobre Benchmark"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: single_value
      fields: [fact_rendimiento_fondos.pct_meses_sobre_benchmark]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 4
      col: 16
      width: 4
      height: 2

    - name: kpi_flujo_neto_fondos
      title_hidden: true
      show_single_value_title: true
      title: "Flujo Neto a Fondos"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      fields: [fact_movimientos_inversion.captacion_neta_mxn]
      filters:
        dim_productos.categoria: "Fondos"
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_movimientos_inversion.fecha_month
        fondo: dim_productos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 4
      col: 20
      width: 4
      height: 2

    # Fila 1 Titulos
    - name: title_chart_evolucion_aum
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Evolución de AUM por Fondo<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 0
      width: 16
      height: 1

    - name: title_chart_composicion_aum
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Composición de AUM (Fecha de Corte)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 16
      width: 8
      height: 1

    - name: chart_evolucion_aum
      title_hidden: true
      title: "Evolución de AUM por Fondo"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_area
      fields: [fact_rendimiento_fondos.fecha_month, fact_rendimiento_fondos.producto_nombre, fact_rendimiento_fondos.total_aum_mxn]
      pivots: [fact_rendimiento_fondos.producto_nombre]
      sorts: [fact_rendimiento_fondos.fecha_month asc]
      stacking: normal
      series_colors:
        Fondo Liquidez Demo - fact_rendimiento_fondos.total_aum_mxn: "#0F6FF5"
        Fondo Deuda Demo - fact_rendimiento_fondos.total_aum_mxn: "#0853BB"
        Fondo Balanceado Demo - fact_rendimiento_fondos.total_aum_mxn: "#E0C792"
        Fondo Crecimiento Demo - fact_rendimiento_fondos.total_aum_mxn: "#5B6678"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 7
      col: 0
      width: 16
      height: 8

    - name: chart_composicion_aum
      title_hidden: true
      title: "Composición de AUM (Fecha de Corte)"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_pie
      fields: [fact_rendimiento_fondos.producto_nombre, fact_rendimiento_fondos.total_aum_mxn]
      sorts: [fact_rendimiento_fondos.total_aum_mxn desc]
      inner_radius: 60
      series_colors:
        Fondo Liquidez Demo: "#0F6FF5"
        Fondo Deuda Demo: "#0853BB"
        Fondo Balanceado Demo: "#E0C792"
        Fondo Crecimiento Demo: "#5B6678"
      listen:
        fecha_corte: fact_rendimiento_fondos.fecha_date
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 7
      col: 16
      width: 8
      height: 8

    # Fila 2 Titulos
    - name: title_chart_rendimiento_vs_benchmark
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Rendimiento vs Benchmark Mensual<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 0
      width: 12
      height: 1

    - name: title_chart_alpha_mensual
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Alpha Mensual (pp)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 12
      width: 12
      height: 1

    - name: chart_rendimiento_vs_benchmark
      title_hidden: true
      title: "Rendimiento vs Benchmark Mensual"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_line
      fields: [fact_rendimiento_fondos.fecha_month, fact_rendimiento_fondos.producto_nombre, fact_rendimiento_fondos.promedio_rendimiento_pct, fact_rendimiento_fondos.promedio_benchmark_pct]
      pivots: [fact_rendimiento_fondos.producto_nombre]
      sorts: [fact_rendimiento_fondos.fecha_month asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 16
      col: 0
      width: 12
      height: 8

    - name: chart_alpha_mensual
      title_hidden: true
      title: "Alpha Mensual (pp)"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_column
      fields: [fact_rendimiento_fondos.fecha_month, fact_rendimiento_fondos.alpha_promedio_pp]
      sorts: [fact_rendimiento_fondos.fecha_month asc]
      series_colors:
        fact_rendimiento_fondos.alpha_promedio_pp: "#3DBE7A"
      x_axis_gridlines: false
      y_axis_gridlines: true
      reference_lines: [{
        reference_type: line,
        line_value: 0,
        color: "#5B6678"
      }]
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 16
      col: 12
      width: 12
      height: 8

    # Fila 3 Titulos
    - name: title_chart_flujo_neto_fondo
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Flujo Neto por Fondo de Inversión<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 24
      col: 0
      width: 12
      height: 1

    - name: title_chart_riesgo_rendimiento
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Riesgo vs Rendimiento Acumulado<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 24
      col: 12
      width: 12
      height: 1

    - name: chart_flujo_neto_fondo
      title_hidden: true
      title: "Flujo Neto por Fondo de Inversión"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_bar
      fields: [dim_productos.producto_nombre, fact_movimientos_inversion.captacion_neta_mxn]
      filters:
        dim_productos.categoria: "Fondos"
      sorts: [fact_movimientos_inversion.captacion_neta_mxn desc]
      series_colors:
        fact_movimientos_inversion.captacion_neta_mxn: "#0853BB"
      x_axis_gridlines: false
      y_axis_gridlines: true
      listen:
        periodo: fact_movimientos_inversion.fecha_month
        fondo: dim_productos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 25
      col: 0
      width: 12
      height: 8

    - name: chart_riesgo_rendimiento
      title_hidden: true
      title: "Riesgo vs Rendimiento Acumulado"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_scatter
      fields: [fact_rendimiento_fondos.producto_nombre, fact_rendimiento_fondos.volatilidad_pct, fact_rendimiento_fondos.rendimiento_acumulado_pct, fact_rendimiento_fondos.aum_ultimo_corte]
      series_colors:
        Fondo Liquidez Demo: "#0F6FF5"
        Fondo Deuda Demo: "#0853BB"
        Fondo Balanceado Demo: "#E0C792"
        Fondo Crecimiento Demo: "#5B6678"
      x_axis_gridlines: true
      y_axis_gridlines: true
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 25
      col: 12
      width: 12
      height: 8

    # Fila 4 Titulo
    - name: title_grid_detalle_fondos
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Detalle Integral por Fondo de Inversión<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 33
      col: 0
      width: 24
      height: 1

    - name: grid_detalle_fondos
      title_hidden: true
      title: "Detalle Integral por Fondo de Inversión"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_grid
      fields: [
        fact_rendimiento_fondos.producto_nombre,
        dim_productos.perfil_riesgo,
        fact_rendimiento_fondos.aum_ultimo_corte,
        fact_rendimiento_fondos.crecimiento_aum_pct,
        fact_rendimiento_fondos.rendimiento_acumulado_pct,
        fact_rendimiento_fondos.promedio_rendimiento_pct,
        fact_rendimiento_fondos.promedio_benchmark_pct,
        fact_rendimiento_fondos.alpha_promedio_pp,
        fact_rendimiento_fondos.volatilidad_pct,
        fact_rendimiento_fondos.meses_sobre_benchmark
      ]
      sorts: [fact_rendimiento_fondos.aum_ultimo_corte desc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        fact_rendimiento_fondos.producto_nombre:
          is_active: false
        dim_productos.perfil_riesgo:
          is_active: false
        fact_rendimiento_fondos.aum_ultimo_corte:
          is_active: false
        fact_rendimiento_fondos.crecimiento_aum_pct:
          is_active: false
        fact_rendimiento_fondos.rendimiento_acumulado_pct:
          is_active: false
        fact_rendimiento_fondos.promedio_rendimiento_pct:
          is_active: false
        fact_rendimiento_fondos.promedio_benchmark_pct:
          is_active: false
        fact_rendimiento_fondos.alpha_promedio_pp:
          is_active: false
        fact_rendimiento_fondos.volatilidad_pct:
          is_active: false
        fact_rendimiento_fondos.meses_sobre_benchmark:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: greater than,
        value: 0,
        background_color: "#3DBE7A",
        font_color: "#FFFFFF"
      }, {
        type: less than,
        value: 0,
        background_color: "#F0645A",
        font_color: "#FFFFFF"
      }]
      listen:
        periodo: fact_rendimiento_fondos.fecha_month
        fondo: fact_rendimiento_fondos.producto_nombre
        perfil_riesgo: dim_productos.perfil_riesgo
      row: 34
      col: 0
      width: 24
      height: 8

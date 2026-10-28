- dashboard: actinver_riesgo_cumplimiento
  title: "Riesgo y Cumplimiento Avanzado"
  description: "Monitoreo avanzado de concentración de cartera, matriz de transición roll rate, idoneidad de inversiones, altas/bajas de clientes y desempeño ajustado por riesgo."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour
  filters_location_top: true

  filters:
    - name: fecha_corte
      title: "Fecha de Corte (Cartera)"
      type: field_filter
      default_value: "2026/09/01"
      allow_multiple_values: false
      required: false
      ui_config:
        type: advanced
        display: popover
      model: demos_looker
      explore: fact_cartera_credito
      listens_to_filters: []
      field: fact_cartera_credito.fecha_corte_date

    - name: periodo_movimientos
      title: "Periodo Movimientos"
      type: field_filter
      default_value: "2025/01/01 to 2026/10/01"
      allow_multiple_values: true
      required: false
      ui_config:
        type: advanced
        display: popover
      model: demos_looker
      explore: fact_movimientos_inversion
      listens_to_filters: []
      field: fact_movimientos_inversion.fecha_month

  elements:
    - name: header_tile
      type: text
      body_text: "<div style='background: linear-gradient(135deg, #0A0E12 0%, #1A2433 100%); border-radius: 12px; padding: 18px 26px; border-left: 6px solid #0F6FF5; overflow: hidden;'><h2 style='color: #FFFFFF; font-size: 24px; font-weight: 700; margin: 0 0 6px 0; letter-spacing: -0.02em;'>Riesgo y Cumplimiento Avanzado</h2><p style='color: #FFFFFF; font-size: 13px; margin: 0; line-height: 1.5; opacity: 0.85;'>Concentración de cartera, matriz de transición roll rate, idoneidad de inversiones y ratio de información.</p></div>"
      row: 0
      col: 0
      width: 24
      height: 4

# Fila 0: Disclaimer Legal

    - name: kpi_concentracion_top10
      title: "% Saldo Top 10 Empresas"
      model: demos_looker
      explore: fact_cartera_credito
      type: single_value
      custom_color_enabled: true
      fields: [fact_cartera_credito.pct_saldo_top10_empresas]
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      show_single_value_title: true
      show_comparison: false
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      note_state: collapsed
      note_display: hover
      note_text: "Concentración del saldo de las 10 empresas de mayor tamaño al corte"
      row: 4
      col: 0
      width: 5
      height: 2

    - name: kpi_indice_herfindahl
      title: "Índice Herfindahl (HHI)"
      model: demos_looker
      explore: fact_cartera_credito
      type: single_value
      custom_color_enabled: true
      fields: [fact_cartera_credito.indice_herfindahl]
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      show_single_value_title: true
      show_comparison: false
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      note_state: collapsed
      note_display: hover
      note_text: "Índice de concentración de cartera <1,500 indica baja concentración"
      row: 4
      col: 5
      width: 4
      height: 2

    - name: kpi_pct_fuera_perfil
      title: "% Fuera de Perfil"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      custom_color_enabled: true
      fields: [fact_movimientos_inversion.pct_fuera_perfil]
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      show_single_value_title: true
      show_comparison: false
      listen:
        periodo_movimientos: fact_movimientos_inversion.fecha_month
      note_state: collapsed
      note_display: hover
      note_text: "Movimientos aplicados donde el producto excede el perfil del cliente"
      row: 4
      col: 9
      width: 5
      height: 2

    - name: kpi_ratio_informacion
      title: "Ratio de Información Promedio"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: single_value
      custom_color_enabled: true
      fields: [fact_rendimiento_fondos.ratio_informacion]
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      show_single_value_title: true
      show_comparison: false
      note_state: collapsed
      note_display: hover
      note_text: "Alpha promedio dividido entre el tracking error (calidad de gestión)"
      row: 4
      col: 14
      width: 5
      height: 2

    - name: kpi_monto_pendiente
      title: "Monto Pendiente MXN"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      custom_color_enabled: true
      fields: [fact_movimientos_inversion.monto_pendiente_mxn]
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      show_single_value_title: true
      show_comparison: false
      listen:
        periodo_movimientos: fact_movimientos_inversion.fecha_month
      note_state: collapsed
      note_display: hover
      note_text: "Importe en tránsito con estatus Pendiente"
      row: 4
      col: 19
      width: 5
      height: 2

    # Fila 1 Titulo
    - name: title_chart_roll_rate_heatmap
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Matriz de Transición de Morosidad (Roll Rate %)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 0
      width: 24
      height: 1

    - name: chart_roll_rate_heatmap
      title_hidden: true
      title: "Matriz de Transición de Morosidad (Roll Rate %)"
      model: demos_looker
      explore: roll_rate_cartera
      type: looker_grid
      fields: [roll_rate_cartera.tramo_origen, roll_rate_cartera.tramo_destino, roll_rate_cartera.pct_transicion]
      pivots: [roll_rate_cartera.tramo_destino]
      sorts: [roll_rate_cartera.tramo_origen asc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        roll_rate_cartera.tramo_origen:
          is_active: false
        roll_rate_cartera.tramo_destino:
          is_active: false
        roll_rate_cartera.pct_transicion:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: along a scale...,
        value: [],
        background_color: "#0F6FF5",
        font_color: "#FFFFFF",
        palette: {
          name: "Actinver Scale",
          colors: ["#0A0E12", "#FFFFFF", "#0F6FF5", "#0F6FF5"]
        }
      }]
      row: 7
      col: 0
      width: 24
      height: 8

    # Fila 2 Titulos
    - name: title_chart_top_empresas_saldo
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Top 15 Empresas por Saldo de Capital (MXN)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 0
      width: 14
      height: 1

    - name: title_chart_top_empresas_acumulado
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Distribución y Concentración Acumulada Top Empresas<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 14
      width: 10
      height: 1

    - name: chart_top_empresas_saldo
      title_hidden: true
      title: "Top 15 Empresas por Saldo de Capital (MXN)"
      model: demos_looker
      explore: fact_cartera_credito
      type: looker_bar
      fields: [fact_cartera_credito.empresa_id, fact_cartera_credito.saldo_total_capital]
      filters:
        fact_cartera_credito.es_ultimo_corte: "Yes"
      sorts: [fact_cartera_credito.saldo_total_capital desc]
      limit: 15
      series_colors:
        fact_cartera_credito.saldo_total_capital: "#0F6FF5"
      series_labels:
        fact_cartera_credito.saldo_total_capital: "Saldo de Capital"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      row: 16
      col: 0
      width: 14
      height: 8

    - name: chart_top_empresas_acumulado
      title_hidden: true
      title: "Distribución y Concentración Acumulada Top Empresas"
      model: demos_looker
      explore: fact_cartera_credito
      type: looker_column
      fields: [fact_cartera_credito.empresa_id, fact_cartera_credito.saldo_total_capital]
      filters:
        fact_cartera_credito.es_ultimo_corte: "Yes"
      sorts: [fact_cartera_credito.saldo_total_capital desc]
      limit: 15
      series_colors:
        fact_cartera_credito.saldo_total_capital: "#E0C792"
      series_labels:
        fact_cartera_credito.saldo_total_capital: "Saldo Acumulado"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      row: 16
      col: 14
      width: 10
      height: 8

    # Fila 3 Titulo
    - name: title_chart_matriz_idoneidad
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Matriz de Idoneidad 3x3 (Perfil Cliente × Riesgo Producto)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 24
      col: 0
      width: 24
      height: 1

    - name: chart_matriz_idoneidad
      title_hidden: true
      title: "Matriz de Idoneidad 3x3 (Perfil Cliente × Riesgo Producto)"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_grid
      fields: [dim_clientes.perfil_riesgo, dim_productos.perfil_riesgo, fact_movimientos_inversion.movimientos_aplicados_count]
      pivots: [dim_productos.perfil_riesgo]
      sorts: [dim_clientes.perfil_riesgo asc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        dim_clientes.perfil_riesgo:
          is_active: false
        dim_productos.perfil_riesgo:
          is_active: false
        fact_movimientos_inversion.movimientos_aplicados_count:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: along a scale...,
        value: [],
        background_color: "#0853BB",
        font_color: "#FFFFFF",
        palette: {
          name: "Idoneidad Scale",
          colors: ["#0A0E12", "#FFFFFF", "#0F6FF5", "#0F6FF5"]
        }
      }]
      listen:
        periodo_movimientos: fact_movimientos_inversion.fecha_month
      row: 25
      col: 0
      width: 24
      height: 7

    # Fila 4 Titulos
    - name: title_chart_altas_vs_bajas
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Altas vs Bajas Mensuales de Clientes<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 32
      col: 0
      width: 14
      height: 1

    - name: title_chart_clientes_netos
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Clientes Netos por Mes (Altas - Bajas)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 32
      col: 14
      width: 10
      height: 1

    - name: chart_altas_vs_bajas
      title_hidden: true
      title: "Altas vs Bajas Mensuales de Clientes"
      model: demos_looker
      explore: dim_clientes
      type: looker_column
      fields: [dim_clientes.fecha_alta_month, dim_clientes.altas, dim_clientes.bajas_negativas]
      sorts: [dim_clientes.fecha_alta_month asc]
      series_colors:
        dim_clientes.altas: "#0F6FF5"
        dim_clientes.bajas_negativas: "#F0645A"
      series_labels:
        dim_clientes.altas: "Altas (+)"
        dim_clientes.bajas_negativas: "Bajas (-)"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      row: 33
      col: 0
      width: 14
      height: 8

    - name: chart_clientes_netos
      title_hidden: true
      title: "Clientes Netos por Mes (Altas - Bajas)"
      model: demos_looker
      explore: dim_clientes
      type: looker_line
      fields: [dim_clientes.fecha_alta_month, dim_clientes.clientes_netos]
      sorts: [dim_clientes.fecha_alta_month asc]
      series_colors:
        dim_clientes.clientes_netos: "#0853BB"
      series_labels:
        dim_clientes.clientes_netos: "Clientes Netos"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      row: 33
      col: 14
      width: 10
      height: 8

    # Fila 5 Titulos
    - name: title_chart_ratio_informacion_fondos
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Ratio de Información por Fondo de Inversión (con Línea 0)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 41
      col: 0
      width: 12
      height: 1

    - name: title_chart_monto_pendiente_antiguedad
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Monto Pendiente MXN por Tramo de Antigüedad<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 41
      col: 12
      width: 12
      height: 1

    - name: chart_ratio_informacion_fondos
      title_hidden: true
      title: "Ratio de Información por Fondo de Inversión (con Línea 0)"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_bar
      fields: [dim_productos.producto_nombre, fact_rendimiento_fondos.ratio_informacion]
      sorts: [fact_rendimiento_fondos.ratio_informacion desc]
      series_colors:
        fact_rendimiento_fondos.ratio_informacion: "#0F6FF5"
      series_labels:
        fact_rendimiento_fondos.ratio_informacion: "Ratio de Información"
      reference_lines: [{
        reference_type: line,
        line_value: 0,
        color: "#F0645A",
        label: "Umbral Cero",
        label_position: left
      }]
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      row: 42
      col: 0
      width: 12
      height: 8

    - name: chart_monto_pendiente_antiguedad
      title_hidden: true
      title: "Monto Pendiente MXN por Tramo de Antigüedad"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_column
      fields: [fact_movimientos_inversion.tramo_antiguedad_pendiente, fact_movimientos_inversion.monto_pendiente_mxn]
      filters:
        fact_movimientos_inversion.tramo_antiguedad_pendiente: "-null"
      sorts: [fact_movimientos_inversion.tramo_antiguedad_pendiente asc]
      series_colors:
        fact_movimientos_inversion.monto_pendiente_mxn: "#E0C792"
      series_labels:
        fact_movimientos_inversion.monto_pendiente_mxn: "Monto Pendiente MXN"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo_movimientos: fact_movimientos_inversion.fecha_month
      row: 42
      col: 12
      width: 12
      height: 8

    - name: chart_mapa_morosidad_sucursal
      title: "Morosidad +90 por Sucursal"
      model: demos_looker
      explore: fact_cartera_credito
      type: looker_map
      fields: [dim_sucursales.ubicacion, dim_sucursales.sucursal_nombre, fact_cartera_credito.indice_morosidad_90_pct]
      sorts: [fact_cartera_credito.indice_morosidad_90_pct desc]
      limit: 500
      map_plot_mode: points
      map_marker_type: circle
      map_marker_radius_mode: proportional_value
      map_position: fit_data
      map_tile_provider: light
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      row: 50
      col: 0
      width: 24
      height: 10

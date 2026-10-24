- dashboard: actinver_overview
  title: "Panorama Ejecutivo y Desempeño Financiero"
  description: "Monitoreo integral de captación, fondos de inversión, cartera crediticia y rentabilidad financiera."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour

  filters:
    - name: region
      title: "Región"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: checkboxes
        display: popover
      model: demos_looker
      explore: fact_movimientos_inversion
      listens_to_filters: []
      field: dim_clientes.region

    - name: segmento
      title: "Segmento de Cliente"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: fact_movimientos_inversion
      listens_to_filters: []
      field: dim_clientes.segmento

  elements:
    - name: header_tile
      type: text
      body_text: "<div style='background: linear-gradient(135deg, #0A0E12 0%, #1A2433 100%); border-radius: 12px; padding: 18px 26px; border-left: 6px solid #0F6FF5; overflow: hidden;'><h2 style='color: #FFFFFF; font-size: 24px; font-weight: 700; margin: 0 0 6px 0; letter-spacing: -0.02em;'>Panorama Ejecutivo y Desempeño Financiero</h2><p style='color: #FFFFFF; font-size: 13px; margin: 0; line-height: 1.5; opacity: 0.85;'>Captación neta, fondos de inversión, cartera crediticia y salud financiera consolidada.</p></div>"
      row: 0
      col: 0
      width: 24
      height: 4

    - name: kpi_captacion_neta
      title: "Captación Neta MXN"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      custom_color_enabled: true
      fields: [fact_movimientos_inversion.captacion_neta_mxn]
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
        region: dim_clientes.region
        segmento: dim_clientes.segmento
      row: 4
      col: 0
      width: 6
      height: 2

    - name: kpi_clientes_activos
      title: "Clientes Activos"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      custom_color_enabled: true
      fields: [dim_clientes.clientes_activos]
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
        region: dim_clientes.region
        segmento: dim_clientes.segmento
      row: 4
      col: 6
      width: 6
      height: 2

    - name: kpi_ingresos_financieros
      title: "Ingresos Totales MXN"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: single_value
      custom_color_enabled: true
      fields: [fact_finanzas_mensual.total_ingresos]
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
      row: 4
      col: 12
      width: 6
      height: 2

    - name: kpi_margen_operativo
      title: "Margen Operativo Promedio"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: single_value
      custom_color_enabled: true
      fields: [fact_finanzas_mensual.margen_operativo_pct]
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
      row: 4
      col: 18
      width: 6
      height: 2

    # Fila 1 Titulos
    - name: title_chart_captacion_tiempo
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Evolución Mensual de Captación y Retiros<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 0
      width: 12
      height: 1

    - name: title_chart_utilidad_por_area
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Utilidad Operativa e Ingresos por Área de Negocio<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 12
      width: 12
      height: 1

    # Fila 1 Graficos
    - name: chart_captacion_tiempo
      title: "Evolución Mensual de Captación y Retiros"
      title_hidden: true
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_column
      fields: [fact_movimientos_inversion.fecha_month, fact_movimientos_inversion.total_aportaciones_mxn, fact_movimientos_inversion.total_retiros_mxn, fact_movimientos_inversion.captacion_neta_mxn]
      sorts: [fact_movimientos_inversion.fecha_month asc]
      series_types:
        fact_movimientos_inversion.captacion_neta_mxn: line
      series_colors:
        fact_movimientos_inversion.total_aportaciones_mxn: "#0F6FF5"
        fact_movimientos_inversion.total_retiros_mxn: "#F0645A"
        fact_movimientos_inversion.captacion_neta_mxn: "#E0C792"
      series_labels:
        fact_movimientos_inversion.total_aportaciones_mxn: "Aportaciones (+)"
        fact_movimientos_inversion.total_retiros_mxn: "Retiros (-)"
        fact_movimientos_inversion.captacion_neta_mxn: "Captación Neta"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        region: dim_clientes.region
        segmento: dim_clientes.segmento
      row: 7
      col: 0
      width: 12
      height: 8

    - name: chart_utilidad_por_area
      title: "Utilidad Operativa e Ingresos por Área de Negocio"
      title_hidden: true
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_bar
      fields: [fact_finanzas_mensual.area_negocio, fact_finanzas_mensual.total_ingresos, fact_finanzas_mensual.total_utilidad_operativa]
      sorts: [fact_finanzas_mensual.total_utilidad_operativa desc]
      series_colors:
        fact_finanzas_mensual.total_ingresos: "#0F6FF5"
        fact_finanzas_mensual.total_utilidad_operativa: "#0853BB"
      series_labels:
        fact_finanzas_mensual.total_ingresos: "Ingresos Totales"
        fact_finanzas_mensual.total_utilidad_operativa: "Utilidad Operativa"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      row: 7
      col: 12
      width: 12
      height: 8

    # Fila 2 Titulos
    - name: title_chart_cartera_credito_mora
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Distribución de Cartera por Días de Atraso<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 0
      width: 12
      height: 1

    - name: title_chart_rendimiento_fondos
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>AUM y Rendimiento Promedio por Fondo<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 12
      width: 12
      height: 1

    # Fila 2 Graficos
    - name: chart_cartera_credito_mora
      title: "Distribución de Cartera por Días de Atraso"
      title_hidden: true
      model: demos_looker
      explore: fact_cartera_credito
      type: looker_donut_multiples
      fields: [fact_cartera_credito.bucket_mora, fact_cartera_credito.saldo_total_capital]
      sorts: [fact_cartera_credito.saldo_total_capital desc]
      colors: ["#0F6FF5", "#0F6FF5", "#FFFFFF", "#E0C792", "#F0645A"]
      series_colors:
        "Al Corriente": "#0F6FF5"
        "1 a 30 días": "#0F6FF5"
        "31 a 60 días": "#E0C792"
        "61 a 90 días": "#E3A33B"
        "90+ días (Vencida)": "#F0645A"
      row: 16
      col: 0
      width: 12
      height: 8

    - name: chart_rendimiento_fondos
      title: "AUM y Rendimiento Promedio por Fondo"
      title_hidden: true
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: looker_grid
      fields: [fact_rendimiento_fondos.producto_nombre, fact_rendimiento_fondos.total_aum_mxn, fact_rendimiento_fondos.promedio_rendimiento_pct, fact_rendimiento_fondos.promedio_benchmark_pct]
      sorts: [fact_rendimiento_fondos.total_aum_mxn desc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        fact_rendimiento_fondos.producto_nombre:
          is_active: false
        fact_rendimiento_fondos.total_aum_mxn:
          is_active: false
        fact_rendimiento_fondos.promedio_rendimiento_pct:
          is_active: false
        fact_rendimiento_fondos.promedio_benchmark_pct:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: along a scale...,
        value: [],
        background_color: "#0F6FF5"
      }]
      row: 16
      col: 12
      width: 12
      height: 8

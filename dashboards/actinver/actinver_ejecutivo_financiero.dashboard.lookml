- dashboard: actinver_ejecutivo_financiero
  title: "Ejecutivo Financiero"
  description: "Monitoreo integral de ingresos, costos, márgenes operativos y cumplimiento de metas financieras de Actinver."
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
      explore: fact_finanzas_mensual
      listens_to_filters: []
      field: fact_finanzas_mensual.mes_month

    - name: area_negocio
      title: "Área de Negocio"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: fact_finanzas_mensual
      listens_to_filters: []
      field: fact_finanzas_mensual.area_negocio

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
      body_text: "<div style='background: linear-gradient(135deg, #0A0E12 0%, #1A2433 100%); border-radius: 12px; padding: 18px 26px; border-left: 6px solid #0F6FF5; overflow: hidden;'><h2 style='color: #FFFFFF; font-size: 24px; font-weight: 700; margin: 0 0 6px 0; letter-spacing: -0.02em;'>Ejecutivo Financiero</h2><p style='color: #FFFFFF; font-size: 13px; margin: 0; line-height: 1.5; opacity: 0.85;'>Desempeño financiero, control de costos, margen operativo y cumplimiento presupuestal por unidad de negocio.</p></div>"
      row: 0
      col: 0
      width: 24
      height: 4

    - name: kpi_ingresos
      title: "Ingresos Totales"
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
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 4
      col: 0
      width: 4
      height: 2

    - name: kpi_utilidad
      title: "Utilidad Operativa"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: single_value
      custom_color_enabled: true
      fields: [fact_finanzas_mensual.total_utilidad_operativa]
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
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 4
      col: 4
      width: 4
      height: 2

    - name: kpi_margen
      title: "Margen Operativo"
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
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 4
      col: 8
      width: 4
      height: 2

    - name: kpi_cumplimiento
      title: "Cumplimiento vs Presupuesto"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: single_value
      custom_color_enabled: true
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
      fields: [fact_finanzas_mensual.cumplimiento_presupuesto_pct]
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 4
      col: 12
      width: 4
      height: 2

    - name: kpi_aum
      title: "AUM Fondos"
      model: demos_looker
      explore: fact_rendimiento_fondos
      type: single_value
      custom_color_enabled: true
      fields: [fact_rendimiento_fondos.total_aum_mxn]
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
        fecha_corte: fact_rendimiento_fondos.fecha_date
      row: 4
      col: 16
      width: 4
      height: 2

    - name: kpi_cartera
      title: "Cartera de Crédito"
      model: demos_looker
      explore: fact_cartera_credito
      type: single_value
      custom_color_enabled: true
      fields: [fact_cartera_credito.saldo_total_capital]
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
      row: 4
      col: 20
      width: 4
      height: 2

    # Fila 1 Titulos
    - name: title_chart_ingresos_vs_presupuesto
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Ingresos Reales vs Presupuesto (MXN)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 0
      width: 12
      height: 1

    - name: title_chart_margen_operativo_tendencia
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Tendencia de Margen Operativo (%)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 12
      width: 12
      height: 1

    - name: chart_ingresos_vs_presupuesto
      title_hidden: true
      title: "Ingresos Reales vs Presupuesto (MXN)"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_column
      fields: [fact_finanzas_mensual.mes_month, fact_finanzas_mensual.total_ingresos, fact_finanzas_mensual.total_presupuesto_ingresos]
      sorts: [fact_finanzas_mensual.mes_month asc]
      series_types:
        fact_finanzas_mensual.total_presupuesto_ingresos: line
      series_colors:
        fact_finanzas_mensual.total_ingresos: "#0F6FF5"
        fact_finanzas_mensual.total_presupuesto_ingresos: "#E0C792"
      series_labels:
        fact_finanzas_mensual.total_ingresos: "Ingresos Reales"
        fact_finanzas_mensual.total_presupuesto_ingresos: "Presupuesto"
      y_axes:
        - label: "Monto MXN"
          orientation: left
          showLabels: true
          showValues: true
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 7
      col: 0
      width: 12
      height: 8

    - name: chart_margen_operativo_tendencia
      title_hidden: true
      title: "Tendencia de Margen Operativo (%)"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_line
      fields: [fact_finanzas_mensual.mes_month, fact_finanzas_mensual.margen_operativo_pct]
      sorts: [fact_finanzas_mensual.mes_month asc]
      series_colors:
        fact_finanzas_mensual.margen_operativo_pct: "#0853BB"
      series_labels:
        fact_finanzas_mensual.margen_operativo_pct: "Margen Operativo"
      y_axes:
        - label: "Margen %"
          orientation: left
          showLabels: true
          showValues: true
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 7
      col: 12
      width: 12
      height: 8

    # Fila 2 Titulos
    - name: title_chart_composicion_ingreso
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Composición del Ingreso por Área (Costos vs Utilidad)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 0
      width: 12
      height: 1

    - name: title_chart_cumplimiento_heatmap
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Cumplimiento de Presupuesto por Área y Mes<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 12
      width: 12
      height: 1

    - name: chart_composicion_ingreso
      title_hidden: true
      row: 16
      title: "Composición del Ingreso por Área (Costos vs Utilidad)"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_bar
      fields: [fact_finanzas_mensual.area_negocio, fact_finanzas_mensual.total_costos, fact_finanzas_mensual.total_utilidad_operativa, fact_finanzas_mensual.total_ingresos]
      hidden_fields: [fact_finanzas_mensual.total_ingresos]
      sorts: [fact_finanzas_mensual.total_ingresos desc]
      stacking: normal
      series_colors:
        fact_finanzas_mensual.total_costos: "#5B6678"
        fact_finanzas_mensual.total_utilidad_operativa: "#0853BB"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 16
      col: 0
      width: 12
      height: 8

    - name: chart_cumplimiento_heatmap
      title_hidden: true
      title: "Cumplimiento de Presupuesto por Área y Mes"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_grid
      fields: [fact_finanzas_mensual.area_negocio, fact_finanzas_mensual.mes_month, fact_finanzas_mensual.cumplimiento_presupuesto_pct]
      pivots: [fact_finanzas_mensual.mes_month]
      sorts: [fact_finanzas_mensual.area_negocio asc, fact_finanzas_mensual.mes_month asc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        fact_finanzas_mensual.area_negocio:
          is_active: false
        fact_finanzas_mensual.mes_month:
          is_active: false
        fact_finanzas_mensual.cumplimiento_presupuesto_pct:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: along a scale...,
        value: [],
        background_color: "#3DBE7A"
      }]
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 16
      col: 12
      width: 12
      height: 8

    # Fila 3 Titulos
    - name: title_chart_desviacion_presupuesto
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Desviación vs Presupuesto por Área<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 24
      col: 0
      width: 12
      height: 1

    - name: title_chart_eficiencia_por_area
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Evolución del Índice de Eficiencia por Área<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 24
      col: 12
      width: 12
      height: 1

    - name: chart_desviacion_presupuesto
      title_hidden: true
      title: "Desviación vs Presupuesto por Área"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_column
      fields: [fact_finanzas_mensual.area_negocio, fact_finanzas_mensual.desviacion_presupuesto_mxn]
      sorts: [fact_finanzas_mensual.desviacion_presupuesto_mxn desc]
      series_colors:
        fact_finanzas_mensual.desviacion_presupuesto_mxn: "#0853BB"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 25
      col: 0
      width: 12
      height: 8

    - name: chart_eficiencia_por_area
      title_hidden: true
      title: "Evolución del Índice de Eficiencia por Área"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_line
      fields: [fact_finanzas_mensual.mes_month, fact_finanzas_mensual.area_negocio, fact_finanzas_mensual.indice_eficiencia_pct]
      pivots: [fact_finanzas_mensual.area_negocio]
      sorts: [fact_finanzas_mensual.mes_month asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      series_colors:
        Banca Corporativa - fact_finanzas_mensual.indice_eficiencia_pct: "#0F6FF5"
        Banca Privada - fact_finanzas_mensual.indice_eficiencia_pct: "#0853BB"
        Crédito - fact_finanzas_mensual.indice_eficiencia_pct: "#E0C792"
        Fondos de Inversión - fact_finanzas_mensual.indice_eficiencia_pct: "#0853BB"
        Gestión Patrimonial - fact_finanzas_mensual.indice_eficiencia_pct: "#5B6678"
        Mercado de Dinero - fact_finanzas_mensual.indice_eficiencia_pct: "#5B6678"
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 25
      col: 12
      width: 12
      height: 8

    # Fila 4 Titulo
    - name: title_grid_detalle_financiero
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Detalle Financiero por Área de Negocio<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 33
      col: 0
      width: 24
      height: 1

    - name: grid_detalle_financiero
      title_hidden: true
      title: "Detalle Financiero por Área de Negocio"
      model: demos_looker
      explore: fact_finanzas_mensual
      type: looker_grid
      fields: [
        fact_finanzas_mensual.area_negocio,
        fact_finanzas_mensual.total_ingresos,
        fact_finanzas_mensual.total_presupuesto_ingresos,
        fact_finanzas_mensual.desviacion_presupuesto_mxn,
        fact_finanzas_mensual.cumplimiento_presupuesto_pct,
        fact_finanzas_mensual.total_costos,
        fact_finanzas_mensual.total_utilidad_operativa,
        fact_finanzas_mensual.margen_operativo_pct,
        fact_finanzas_mensual.areas_mes_bajo_presupuesto
      ]
      sorts: [fact_finanzas_mensual.total_ingresos desc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        fact_finanzas_mensual.area_negocio:
          is_active: false
        fact_finanzas_mensual.total_ingresos:
          is_active: false
        fact_finanzas_mensual.total_presupuesto_ingresos:
          is_active: false
        fact_finanzas_mensual.desviacion_presupuesto_mxn:
          is_active: false
        fact_finanzas_mensual.cumplimiento_presupuesto_pct:
          is_active: false
        fact_finanzas_mensual.total_costos:
          is_active: false
        fact_finanzas_mensual.total_utilidad_operativa:
          is_active: false
        fact_finanzas_mensual.margen_operativo_pct:
          is_active: false
        fact_finanzas_mensual.areas_mes_bajo_presupuesto:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      listen:
        periodo: fact_finanzas_mensual.mes_month
        area_negocio: fact_finanzas_mensual.area_negocio
      row: 34
      col: 0
      width: 24
      height: 8

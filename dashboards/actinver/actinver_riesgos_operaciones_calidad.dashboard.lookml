- dashboard: actinver_riesgos_operaciones_calidad
  title: "Riesgos, Operaciones y Calidad de Datos"
  description: "Monitoreo integral de morosidad crediticia, eficiencia y SLAs operativos, y gobernanza de reglas de calidad de datos en Actinver."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour
  filters_location_top: true

  filters:
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
      explore: fact_cartera_credito
      listens_to_filters: []
      field: fact_cartera_credito.fecha_corte_date

    - name: periodo_cartera
      title: "Periodo de cartera"
      type: field_filter
      default_value: "2025/01/01 to 2026/10/01"
      allow_multiple_values: true
      required: false
      ui_config:
        type: advanced
        display: popover
      model: demos_looker
      explore: fact_cartera_credito
      listens_to_filters: []
      field: fact_cartera_credito.fecha_corte_month

    - name: periodo_operaciones
      title: "Periodo de operaciones"
      type: field_filter
      default_value: "2025/01/01 to 2026/10/01"
      allow_multiple_values: true
      required: false
      ui_config:
        type: advanced
        display: popover
      model: demos_looker
      explore: fact_operaciones_diarias
      listens_to_filters: []
      field: fact_operaciones_diarias.fecha_date

    - name: severidad
      title: "Severidad"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: calidad_datos
      listens_to_filters: []
      field: calidad_datos.severidad

  elements:
    - name: header_tile
      type: text
      body_text: "<div style='background: linear-gradient(135deg, #0A0E12 0%, #1A2433 100%); border-radius: 12px; padding: 18px 26px; border-left: 6px solid #0F6FF5; overflow: hidden;'><h2 style='color: #FFFFFF; font-size: 24px; font-weight: 700; margin: 0 0 6px 0; letter-spacing: -0.02em;'>Riesgos, Operaciones y Calidad de Datos</h2><p style='color: #FFFFFF; font-size: 13px; margin: 0; line-height: 1.5; opacity: 0.85;'>Morosidad crediticia, eficiencia y SLAs operativos, y gobernanza de reglas de calidad de datos.</p></div>"
      row: 0
      col: 0
      width: 24
      height: 4

# Fila 0: Header Global

    - name: header_seccion_credito
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>1. Riesgo de Crédito y Cartera<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 4
      col: 0
      width: 24
      height: 1

    - name: kpi_saldo_cartera
      title: "Saldo de Cartera"
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
      row: 5
      col: 0
      width: 6
      height: 2

    - name: kpi_morosidad_90
      title: "Morosidad +90 días"
      model: demos_looker
      explore: fact_cartera_credito
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
      fields: [fact_cartera_credito.indice_morosidad_90_pct]
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      row: 5
      col: 6
      width: 6
      height: 2

    - name: kpi_cartera_vencida
      title: "Cartera Vencida (>0 días)"
      model: demos_looker
      explore: fact_cartera_credito
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
      fields: [fact_cartera_credito.indice_cartera_vencida_pct]
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      row: 5
      col: 12
      width: 6
      height: 2

    - name: kpi_creditos_vencidos
      title: "Créditos Vencidos"
      model: demos_looker
      explore: fact_cartera_credito
      type: single_value
      custom_color_enabled: true
      fields: [fact_cartera_credito.creditos_vencidos]
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
      row: 5
      col: 18
      width: 6
      height: 2

    # Section 1 Visual Titles
    - name: title_chart_evolucion_morosidad
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Evolución de Morosidad e Índice Vencido<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 7
      col: 0
      width: 12
      height: 1

    - name: title_chart_cartera_dias_atraso
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Cartera por Tramo de Atraso (Corte)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 7
      col: 12
      width: 6
      height: 1

    - name: title_chart_saldo_tramo_tiempo
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Saldo Vencido por Tramo en el Tiempo<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 7
      col: 18
      width: 6
      height: 1

    - name: chart_evolucion_morosidad
      title_hidden: true
      title: "Evolución de Morosidad e Índice Vencido"
      model: demos_looker
      explore: fact_cartera_credito
      type: looker_line
      fields: [fact_cartera_credito.fecha_corte_month, fact_cartera_credito.indice_morosidad_90_pct, fact_cartera_credito.indice_cartera_vencida_pct]
      sorts: [fact_cartera_credito.fecha_corte_month asc]
      series_colors:
        fact_cartera_credito.indice_morosidad_90_pct: "#F0645A"
        fact_cartera_credito.indice_cartera_vencida_pct: "#E3A33B"
      reference_lines: [{
        reference_type: line,
        line_value: 0.03,
        color: "#F0645A",
        label: "Umbral 3%"
      }]
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo_cartera: fact_cartera_credito.fecha_corte_month
      row: 8
      col: 0
      width: 12
      height: 8

    - name: chart_cartera_dias_atraso
      title_hidden: true
      title: "Cartera por Tramo de Atraso (Corte)"
      model: demos_looker
      explore: fact_cartera_credito
      type: looker_pie
      fields: [fact_cartera_credito.bucket_mora, fact_cartera_credito.saldo_total_capital]
      sorts: [fact_cartera_credito.saldo_total_capital desc]
      inner_radius: 60
      series_colors:
        Al corriente: "#3DBE7A"
        1-30: "#E3A33B"
        31-60: "#E3A33B"
        61-90: "#5B6678"
        90+: "#F0645A"
      listen:
        fecha_corte: fact_cartera_credito.fecha_corte_date
      row: 8
      col: 12
      width: 6
      height: 8

    - name: chart_saldo_tramo_tiempo
      title_hidden: true
      title: "Saldo Vencido por Tramo en el Tiempo"
      model: demos_looker
      explore: fact_cartera_credito
      type: looker_column
      fields: [fact_cartera_credito.fecha_corte_month, fact_cartera_credito.bucket_mora, fact_cartera_credito.saldo_total_capital]
      pivots: [fact_cartera_credito.bucket_mora]
      filters:
        fact_cartera_credito.bucket_mora: "-Al corriente"
      sorts: [fact_cartera_credito.fecha_corte_month asc]
      stacking: normal
      series_colors:
        1-30 - fact_cartera_credito.saldo_total_capital: "#E3A33B"
        31-60 - fact_cartera_credito.saldo_total_capital: "#E3A33B"
        61-90 - fact_cartera_credito.saldo_total_capital: "#5B6678"
        90+ - fact_cartera_credito.saldo_total_capital: "#F0645A"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo_cartera: fact_cartera_credito.fecha_corte_month
      row: 8
      col: 18
      width: 6
      height: 8

    # ==============================================================================
    # SECCIÓN 2: OPERACIONES
    # ==============================================================================
    - name: header_seccion_operaciones
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>2. Operaciones y Niveles de Servicio (SLA)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 16
      col: 0
      width: 24
      height: 1

    - name: kpi_operaciones_procesadas
      title: "Operaciones Procesadas"
      model: demos_looker
      explore: fact_operaciones_diarias
      type: single_value
      custom_color_enabled: true
      fields: [fact_operaciones_diarias.total_operaciones_procesadas]
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
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 17
      col: 0
      width: 4
      height: 2

    - name: kpi_tasa_rechazo
      title: "Tasa de Rechazo"
      model: demos_looker
      explore: fact_operaciones_diarias
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
      fields: [fact_operaciones_diarias.tasa_rechazo_pct]
      listen:
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 17
      col: 4
      width: 4
      height: 2

    - name: kpi_pendientes
      title: "Operaciones Pendientes"
      model: demos_looker
      explore: fact_operaciones_diarias
      type: single_value
      custom_color_enabled: true
      fields: [fact_operaciones_diarias.total_operaciones_pendientes]
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
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 17
      col: 8
      width: 4
      height: 2

    - name: kpi_tiempo_resolucion
      title: "Tiempo Resolución Ponderado"
      model: demos_looker
      explore: fact_operaciones_diarias
      type: single_value
      custom_color_enabled: true
      fields: [fact_operaciones_diarias.tiempo_resolucion_ponderado_min]
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
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 17
      col: 12
      width: 4
      height: 2

    - name: kpi_error_ponderado
      title: "% Registros con Error"
      model: demos_looker
      explore: fact_operaciones_diarias
      type: single_value
      custom_color_enabled: true
      fields: [fact_operaciones_diarias.pct_error_ponderado]
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
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 17
      col: 16
      width: 4
      height: 2

    - name: kpi_dias_fuera_sla
      title: "Días Fuera de SLA (Tiempo)"
      model: demos_looker
      explore: fact_operaciones_diarias
      type: single_value
      custom_color_enabled: true
      fields: [fact_operaciones_diarias.dias_fuera_sla_tiempo]
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
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 17
      col: 20
      width: 4
      height: 2

    # Section 2 Visual Titles
    - name: title_chart_rechazos_errores_semana
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Tasa de Rechazo y Error Ponderado por Semana<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 19
      col: 0
      width: 16
      height: 1

    - name: title_chart_dias_fuera_sla_mes
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Días Fuera de SLA por Mes<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 19
      col: 16
      width: 8
      height: 1

    - name: chart_rechazos_errores_semana
      title_hidden: true
      title: "Tasa de Rechazo y Error Ponderado por Semana"
      model: demos_looker
      explore: fact_operaciones_diarias
      type: looker_line
      fields: [fact_operaciones_diarias.fecha_week, fact_operaciones_diarias.tasa_rechazo_pct, fact_operaciones_diarias.pct_error_ponderado]
      sorts: [fact_operaciones_diarias.fecha_week asc]
      series_colors:
        fact_operaciones_diarias.tasa_rechazo_pct: "#0F6FF5"
        fact_operaciones_diarias.pct_error_ponderado: "#5B6678"
      reference_lines: [{
        reference_type: line,
        line_value: 0.02,
        color: "#F0645A",
        label: "SLA Error 2%"
      }]
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 20
      col: 0
      width: 16
      height: 8

    - name: chart_dias_fuera_sla_mes
      title_hidden: true
      title: "Días Fuera de SLA por Mes"
      model: demos_looker
      explore: fact_operaciones_diarias
      type: looker_column
      fields: [fact_operaciones_diarias.fecha_month, fact_operaciones_diarias.dias_fuera_sla_tiempo, fact_operaciones_diarias.dias_fuera_sla_error]
      sorts: [fact_operaciones_diarias.fecha_month asc]
      series_colors:
        fact_operaciones_diarias.dias_fuera_sla_tiempo: "#F0645A"
        fact_operaciones_diarias.dias_fuera_sla_error: "#E3A33B"
      series_labels:
        fact_operaciones_diarias.dias_fuera_sla_tiempo: "Tiempo > 60 min"
        fact_operaciones_diarias.dias_fuera_sla_error: "Error > 2%"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo_operaciones: fact_operaciones_diarias.fecha_date
      row: 20
      col: 16
      width: 8
      height: 8

    # ==============================================================================
    # SECCIÓN 3: CALIDAD DE DATOS
    # ==============================================================================
    - name: header_seccion_calidad
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>3. Monitoreo y Reglas de Calidad de Datos<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 28
      col: 0
      width: 24
      height: 1

    - name: kpi_indice_calidad
      title: "Índice de Calidad Global"
      model: demos_looker
      explore: calidad_datos
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
      fields: [calidad_datos.indice_calidad_pct]
      listen:
        severidad: calidad_datos.severidad
      row: 29
      col: 0
      width: 8
      height: 2

    - name: kpi_reglas_con_falla
      title: "Reglas con Falla"
      model: demos_looker
      explore: calidad_datos
      type: single_value
      custom_color_enabled: true
      fields: [calidad_datos.reglas_con_falla]
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
        severidad: calidad_datos.severidad
      row: 29
      col: 8
      width: 8
      height: 2

    - name: kpi_registros_con_falla
      title: "Total Registros con Falla"
      model: demos_looker
      explore: calidad_datos
      type: single_value
      custom_color_enabled: true
      fields: [calidad_datos.total_registros_con_falla]
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
        severidad: calidad_datos.severidad
      row: 29
      col: 16
      width: 8
      height: 2

    # Section 3 Visual Titles
    - name: title_chart_fallas_por_regla
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Porcentaje de Falla por Regla de Negocio<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 31
      col: 0
      width: 12
      height: 1

    - name: title_grid_detalle_reglas
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Inventario de Reglas de Calidad de Datos<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 31
      col: 12
      width: 12
      height: 1

    - name: chart_fallas_por_regla
      title_hidden: true
      title: "Porcentaje de Falla por Regla de Negocio"
      model: demos_looker
      explore: calidad_datos
      type: looker_bar
      fields: [calidad_datos.regla, calidad_datos.pct_falla, calidad_datos.severidad]
      sorts: [calidad_datos.pct_falla desc]
      series_colors:
        calidad_datos.pct_falla: "#F0645A"
      x_axis_gridlines: false
      y_axis_gridlines: true
      listen:
        severidad: calidad_datos.severidad
      row: 32
      col: 0
      width: 12
      height: 8

    - name: grid_detalle_reglas
      title_hidden: true
      title: "Inventario de Reglas de Calidad de Datos"
      model: demos_looker
      explore: calidad_datos
      type: looker_grid
      fields: [
        calidad_datos.regla_id,
        calidad_datos.dominio,
        calidad_datos.regla,
        calidad_datos.severidad,
        calidad_datos.registros_evaluados,
        calidad_datos.registros_con_falla,
        calidad_datos.pct_falla,
        calidad_datos.estado_regla
      ]
      sorts: [calidad_datos.regla_id asc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        calidad_datos.regla_id:
          is_active: false
        calidad_datos.dominio:
          is_active: false
        calidad_datos.regla:
          is_active: false
        calidad_datos.severidad:
          is_active: false
        calidad_datos.registros_evaluados:
          is_active: false
        calidad_datos.registros_con_falla:
          is_active: false
        calidad_datos.pct_falla:
          is_active: false
        calidad_datos.estado_regla:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: equal to,
        value: "OK",
        background_color: "#3DBE7A",
        font_color: "#FFFFFF"
      }, {
        type: equal to,
        value: "Con falla",
        background_color: "#F0645A",
        font_color: "#FFFFFF"
      }]
      listen:
        severidad: calidad_datos.severidad
      row: 32
      col: 12
      width: 12
      height: 8

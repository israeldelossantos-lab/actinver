- dashboard: actinver_marketing_digital
  title: ""
  description: "Monitoreo del embudo de conversión publicitario, inversión multicanal y eficiencia de adquisición (CAC y CPL) en Actinver."
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
      explore: fact_marketing_campanias
      listens_to_filters: []
      field: fact_marketing_campanias.mes_month

    - name: canal
      title: "Canal"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: fact_marketing_campanias
      listens_to_filters: []
      field: fact_marketing_campanias.canal

    - name: campania
      title: "Campaña"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: fact_marketing_campanias
      listens_to_filters: []
      field: fact_marketing_campanias.campania_nombre

  elements:
    - name: header_tile
      type: text
      body_text: "<div style='background: linear-gradient(135deg, #0A0E12 0%, #1A2433 100%); border-radius: 12px; padding: 18px 26px; border-left: 6px solid #0F6FF5; overflow: hidden;'><h2 style='color: #FFFFFF; font-size: 24px; font-weight: 700; margin: 0 0 6px 0; letter-spacing: -0.02em;'>Marketing y Canales Digitales</h2><p style='color: #FFFFFF; font-size: 13px; margin: 0; line-height: 1.5; opacity: 0.85;'>Embudo de conversión digital, costo de adquisición (CAC), inversión publicitaria y ROI por canal.</p></div>"
      row: 0
      col: 0
      width: 24
      height: 4

    - name: kpi_inversion
      title_hidden: true
      show_single_value_title: true
      title: "Inversión Total"
      model: demos_looker
      explore: fact_marketing_campanias
      type: single_value
      fields: [fact_marketing_campanias.total_inversion_mxn]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 4
      col: 0
      width: 4
      height: 2

    - name: kpi_leads
      title_hidden: true
      show_single_value_title: true
      title: "Total de Leads"
      model: demos_looker
      explore: fact_marketing_campanias
      type: single_value
      fields: [fact_marketing_campanias.total_leads]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 4
      col: 4
      width: 4
      height: 2

    - name: kpi_leads_calificados
      title_hidden: true
      show_single_value_title: true
      title: "Leads Calificados"
      model: demos_looker
      explore: fact_marketing_campanias
      type: single_value
      fields: [fact_marketing_campanias.total_leads_calificados]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 4
      col: 8
      width: 4
      height: 2

    - name: kpi_conversiones
      title_hidden: true
      show_single_value_title: true
      title: "Conversiones"
      model: demos_looker
      explore: fact_marketing_campanias
      type: single_value
      fields: [fact_marketing_campanias.total_conversiones]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 4
      col: 12
      width: 4
      height: 2

    - name: kpi_cac
      title_hidden: true
      show_single_value_title: true
      title: "CAC Promedio MXN"
      model: demos_looker
      explore: fact_marketing_campanias
      type: single_value
      fields: [fact_marketing_campanias.costo_por_adquisicion_cac]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 4
      col: 16
      width: 4
      height: 2

    - name: kpi_ctr
      title_hidden: true
      show_single_value_title: true
      title: "CTR Global"
      model: demos_looker
      explore: fact_marketing_campanias
      type: single_value
      fields: [fact_marketing_campanias.ctr_pct]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 4
      col: 20
      width: 4
      height: 2

    # Fila 1 Titulos
    - name: title_chart_embudo_conversion
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Embudo de Conversión Publicitario<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 0
      width: 12
      height: 1

    - name: title_chart_cac_por_canal
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>CAC por Canal Digital (Menor = Más Eficiente)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 12
      width: 12
      height: 1

    - name: chart_embudo_conversion
      title_hidden: true
      title: "Embudo de Conversión Publicitario"
      model: demos_looker
      explore: fact_marketing_campanias
      type: looker_bar
      fields: [
        fact_marketing_campanias.total_impresiones,
        fact_marketing_campanias.total_clics,
        fact_marketing_campanias.total_leads,
        fact_marketing_campanias.total_leads_calificados,
        fact_marketing_campanias.total_conversiones
      ]
      x_axis_gridlines: false
      y_axis_gridlines: true
      series_colors:
        fact_marketing_campanias.total_impresiones: "#0F6FF5"
        fact_marketing_campanias.total_clics: "#0853BB"
        fact_marketing_campanias.total_leads: "#0853BB"
        fact_marketing_campanias.total_leads_calificados: "#0853BB"
        fact_marketing_campanias.total_conversiones: "#3DBE7A"
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 7
      col: 0
      width: 12
      height: 8

    - name: chart_cac_por_canal
      title_hidden: true
      title: "CAC por Canal Digital (Menor = Más Eficiente)"
      model: demos_looker
      explore: fact_marketing_campanias
      type: looker_bar
      fields: [fact_marketing_campanias.canal, fact_marketing_campanias.costo_por_adquisicion_cac]
      sorts: [fact_marketing_campanias.costo_por_adquisicion_cac asc]
      series_colors:
        Search: "#0F6FF5"
        Social: "#0853BB"
        Email: "#E0C792"
        Push: "#0853BB"
      reference_lines: [{
        reference_type: line,
        line_value: 6154,
        color: "#E0C792",
        label: "CAC Promedio $6,154"
      }]
      x_axis_gridlines: false
      y_axis_gridlines: true
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 7
      col: 12
      width: 12
      height: 8

    # Fila 2 Titulo
    - name: title_chart_inversion_mensual_canal
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Inversión Mensual por Canal Publicitario<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 0
      width: 24
      height: 1

    - name: chart_inversion_mensual_canal
      title_hidden: true
      title: "Inversión Mensual por Canal Publicitario"
      model: demos_looker
      explore: fact_marketing_campanias
      type: looker_column
      fields: [fact_marketing_campanias.mes_month, fact_marketing_campanias.canal, fact_marketing_campanias.total_inversion_mxn]
      pivots: [fact_marketing_campanias.canal]
      sorts: [fact_marketing_campanias.mes_month asc]
      stacking: normal
      series_colors:
        Email - fact_marketing_campanias.total_inversion_mxn: "#E0C792"
        Push - fact_marketing_campanias.total_inversion_mxn: "#0853BB"
        Search - fact_marketing_campanias.total_inversion_mxn: "#0F6FF5"
        Social - fact_marketing_campanias.total_inversion_mxn: "#0853BB"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 16
      col: 0
      width: 24
      height: 8

    # Fila 3 Titulos
    - name: title_chart_eficiencia_campania
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Eficiencia por Campaña (CAC vs Tasa de Conversión Total)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 24
      col: 0
      width: 12
      height: 1

    - name: title_chart_mix_inversion_trimestral
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Mix de Inversión por Trimestre (100% Apilado)<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 24
      col: 12
      width: 12
      height: 1

    - name: chart_eficiencia_campania
      title_hidden: true
      title: "Eficiencia por Campaña (CAC vs Tasa de Conversión Total)"
      model: demos_looker
      explore: fact_marketing_campanias
      type: looker_scatter
      fields: [fact_marketing_campanias.campania_nombre, fact_marketing_campanias.costo_por_adquisicion_cac, fact_marketing_campanias.tasa_conversion_total_pct, fact_marketing_campanias.total_inversion_mxn, fact_marketing_campanias.canal]
      series_colors:
        Search: "#0F6FF5"
        Social: "#0853BB"
        Email: "#E0C792"
        Push: "#0853BB"
      x_axis_gridlines: true
      y_axis_gridlines: true
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 25
      col: 0
      width: 12
      height: 8

    - name: chart_mix_inversion_trimestral
      title_hidden: true
      title: "Mix de Inversión por Trimestre (100% Apilado)"
      model: demos_looker
      explore: fact_marketing_campanias
      type: looker_column
      fields: [fact_marketing_campanias.mes_quarter, fact_marketing_campanias.canal, fact_marketing_campanias.total_inversion_mxn]
      pivots: [fact_marketing_campanias.canal]
      sorts: [fact_marketing_campanias.mes_quarter asc]
      stacking: percent
      series_colors:
        Email - fact_marketing_campanias.total_inversion_mxn: "#E0C792"
        Push - fact_marketing_campanias.total_inversion_mxn: "#0853BB"
        Search - fact_marketing_campanias.total_inversion_mxn: "#0F6FF5"
        Social - fact_marketing_campanias.total_inversion_mxn: "#0853BB"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 25
      col: 12
      width: 12
      height: 8

    # Fila 4 Titulo
    - name: title_grid_detalle_campanias
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Detalle de Rendimiento por Campaña<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 33
      col: 0
      width: 24
      height: 1

    - name: grid_detalle_campanias
      title_hidden: true
      title: "Detalle de Rendimiento por Campaña"
      model: demos_looker
      explore: fact_marketing_campanias
      type: looker_grid
      fields: [
        fact_marketing_campanias.campania_nombre,
        fact_marketing_campanias.canal,
        fact_marketing_campanias.total_inversion_mxn,
        fact_marketing_campanias.total_impresiones,
        fact_marketing_campanias.total_clics,
        fact_marketing_campanias.ctr_pct,
        fact_marketing_campanias.total_leads,
        fact_marketing_campanias.cpl,
        fact_marketing_campanias.total_leads_calificados,
        fact_marketing_campanias.total_conversiones,
        fact_marketing_campanias.costo_por_adquisicion_cac
      ]
      sorts: [fact_marketing_campanias.costo_por_adquisicion_cac asc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        fact_marketing_campanias.campania_nombre:
          is_active: false
        fact_marketing_campanias.canal:
          is_active: false
        fact_marketing_campanias.total_inversion_mxn:
          is_active: false
        fact_marketing_campanias.total_impresiones:
          is_active: false
        fact_marketing_campanias.total_clics:
          is_active: false
        fact_marketing_campanias.ctr_pct:
          is_active: false
        fact_marketing_campanias.total_leads:
          is_active: false
        fact_marketing_campanias.cpl:
          is_active: false
        fact_marketing_campanias.total_leads_calificados:
          is_active: false
        fact_marketing_campanias.total_conversiones:
          is_active: false
        fact_marketing_campanias.costo_por_adquisicion_cac:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: along a scale...,
        value: [],
        background_color: "#3DBE7A"
      }]
      listen:
        periodo: fact_marketing_campanias.mes_month
        canal: fact_marketing_campanias.canal
        campania: fact_marketing_campanias.campania_nombre
      row: 34
      col: 0
      width: 24
      height: 8

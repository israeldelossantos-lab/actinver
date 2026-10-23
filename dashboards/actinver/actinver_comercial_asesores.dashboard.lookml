- dashboard: actinver_comercial_asesores
  title: ""
  description: "Seguimiento al desempeño de asesores comerciales, captación por región, retención de clientes y cumplimiento de metas en Actinver."
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
      explore: fact_movimientos_inversion
      listens_to_filters: []
      field: fact_movimientos_inversion.fecha_date

    - name: region
      title: "Región"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: fact_movimientos_inversion
      listens_to_filters: []
      field: dim_asesores.region

    - name: asesor
      title: "Asesor"
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
      field: dim_asesores.asesor_nombre

    - name: segmento
      title: "Segmento"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: fact_movimientos_inversion
      listens_to_filters: []
      field: dim_clientes.segmento

    - name: producto
      title: "Producto"
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
      field: dim_productos.producto_nombre

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
      explore: fact_movimientos_inversion
      listens_to_filters: []
      field: dim_clientes.perfil_riesgo

  elements:
    - name: header_tile
      type: text
      body_text: "<div style='background: linear-gradient(135deg, #0A0E12 0%, #1A2433 100%); border-radius: 12px; padding: 18px 26px; border-left: 6px solid #0F6FF5; overflow: hidden;'><h2 style='color: #FFFFFF; font-size: 24px; font-weight: 700; margin: 0 0 6px 0; letter-spacing: -0.02em;'>Gestión Comercial y Asesores</h2><p style='color: #FFFFFF; font-size: 13px; margin: 0; line-height: 1.5; opacity: 0.85;'>Monitoreo de productividad de la fuerza comercial, captación neta, retención de clientes y cumplimiento de cuotas.</p></div>"
      row: 0
      col: 0
      width: 24
      height: 4

    - name: kpi_captacion_neta
      title_hidden: true
      show_single_value_title: true
      title: "Captación Neta"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      fields: [fact_movimientos_inversion.captacion_neta_mxn]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 4
      col: 0
      width: 4
      height: 2

    - name: kpi_aportaciones
      title_hidden: true
      show_single_value_title: true
      title: "Aportaciones"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      fields: [fact_movimientos_inversion.total_aportaciones_mxn]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 4
      col: 4
      width: 4
      height: 2

    - name: kpi_retiros
      title_hidden: true
      show_single_value_title: true
      title: "Retiros"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      fields: [fact_movimientos_inversion.total_retiros_abs_mxn]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 4
      col: 8
      width: 4
      height: 2

    - name: kpi_retencion
      title_hidden: true
      show_single_value_title: true
      title: "Tasa de Retención"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      fields: [fact_movimientos_inversion.tasa_retencion_pct]
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 4
      col: 12
      width: 4
      height: 2

    - name: kpi_clientes_movimiento
      title_hidden: true
      show_single_value_title: true
      title: "Clientes con Movimiento"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      fields: [fact_movimientos_inversion.clientes_con_movimiento]
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 4
      col: 16
      width: 4
      height: 2

    - name: kpi_asesores_meta
      title_hidden: true
      show_single_value_title: true
      title: "Asesores en Meta"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: single_value
      fields: [dim_asesores.asesor_id, fact_movimientos_inversion.cumplimiento_meta_pct]
      dynamic_fields:
        - table_calculation: asesores_cumplen
          label: "Asesores que Cumplen"
          expression: "count(if(${fact_movimientos_inversion.cumplimiento_meta_pct} >= 1.0, ${dim_asesores.asesor_id}, null))"
          value_format_name: decimal_0
      custom_color: "#FFFFFF"
      tile_background_color: "#002D6F"
      tile_text_color: "#FFFFFF"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 4
      col: 20
      width: 4
      height: 2

    # Fila 1 Titulo
    - name: title_chart_captacion_mensual
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Captación Neta Mensual<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 6
      col: 0
      width: 24
      height: 1

    - name: chart_captacion_mensual
      title_hidden: true
      title: "Captación Neta Mensual"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_column
      fields: [fact_movimientos_inversion.fecha_month, fact_movimientos_inversion.captacion_neta_mxn]
      sorts: [fact_movimientos_inversion.fecha_month asc]
      series_colors:
        fact_movimientos_inversion.captacion_neta_mxn: "#0853BB"
      x_axis_gridlines: false
      y_axis_gridlines: true
      reference_lines: [{
        reference_type: line,
        line_value: 0,
        color: "#5B6678"
      }]
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 7
      col: 0
      width: 24
      height: 8

    # Fila 2 Titulos
    - name: title_chart_ranking_asesores
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Ranking de Asesores vs Meta<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 0
      width: 16
      height: 1

    - name: title_chart_captacion_region
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Captación Neta por Región<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 15
      col: 16
      width: 8
      height: 1

    - name: chart_ranking_asesores
      title_hidden: true
      title: "Ranking de Asesores vs Meta"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_bar
      fields: [dim_asesores.asesor_nombre, fact_movimientos_inversion.cumplimiento_meta_pct, dim_asesores.region]
      sorts: [fact_movimientos_inversion.cumplimiento_meta_pct desc]
      limit: 30
      series_colors:
        fact_movimientos_inversion.cumplimiento_meta_pct: "#0F6FF5"
      x_axis_gridlines: false
      y_axis_gridlines: true
      reference_lines: [{
        reference_type: line,
        line_value: 1,
        color: "#E0C792",
        label: "Meta 100%"
      }]
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 16
      col: 0
      width: 16
      height: 9

    - name: chart_captacion_region
      title_hidden: true
      title: "Captación Neta por Región"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_pie
      fields: [dim_asesores.region, fact_movimientos_inversion.captacion_neta_mxn]
      sorts: [fact_movimientos_inversion.captacion_neta_mxn desc]
      inner_radius: 60
      series_colors:
        CDMX: "#0F6FF5"
        Norte: "#0853BB"
        Occidente: "#E0C792"
        Sur: "#0853BB"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 16
      col: 16
      width: 8
      height: 9

    # Fila 3 Titulos
    - name: title_chart_heatmap_segmento_producto
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Captación por Segmento y Producto<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 25
      col: 0
      width: 12
      height: 1

    - name: title_chart_flujos_trimestrales
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Flujos por Tipo de Movimiento<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 25
      col: 12
      width: 12
      height: 1

    - name: chart_heatmap_segmento_producto
      title_hidden: true
      title: "Captación por Segmento y Producto"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_grid
      fields: [dim_clientes.segmento, dim_productos.producto_nombre, fact_movimientos_inversion.captacion_neta_mxn]
      pivots: [dim_productos.producto_nombre]
      sorts: [dim_clientes.segmento asc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        dim_clientes.segmento:
          is_active: false
        dim_productos.producto_nombre:
          is_active: false
        fact_movimientos_inversion.captacion_neta_mxn:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: along a scale...,
        value: [],
        background_color: "#0F6FF5"
      }]
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 26
      col: 0
      width: 12
      height: 8

    - name: chart_flujos_trimestrales
      title_hidden: true
      title: "Flujos por Tipo de Movimiento"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_column
      fields: [fact_movimientos_inversion.fecha_quarter, fact_movimientos_inversion.tipo_movimiento, fact_movimientos_inversion.captacion_neta_mxn]
      pivots: [fact_movimientos_inversion.tipo_movimiento]
      filters:
        fact_movimientos_inversion.tipo_movimiento: "-Rendimiento"
      sorts: [fact_movimientos_inversion.fecha_quarter asc]
      stacking: normal
      series_colors:
        Aportación - fact_movimientos_inversion.captacion_neta_mxn: "#0853BB"
        Traspaso entrada - fact_movimientos_inversion.captacion_neta_mxn: "#0853BB"
        Retiro - fact_movimientos_inversion.captacion_neta_mxn: "#F0645A"
        Traspaso salida - fact_movimientos_inversion.captacion_neta_mxn: "#5B6678"
      x_axis_gridlines: false
      y_axis_gridlines: true
      legend_position: bottom
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 26
      col: 12
      width: 12
      height: 8

    # Fila 4 Titulos
    - name: title_chart_clientes_segmento
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Clientes por Segmento<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 34
      col: 0
      width: 8
      height: 1

    - name: title_chart_clientes_riesgo
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Clientes por Perfil de Riesgo<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 34
      col: 8
      width: 8
      height: 1

    - name: title_chart_ticket_promedio_segmento
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Ticket Promedio de Aportación por Segmento<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 34
      col: 16
      width: 8
      height: 1

    - name: chart_clientes_segmento
      title_hidden: true
      title: "Clientes por Segmento"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_pie
      fields: [dim_clientes.segmento, dim_clientes.count]
      sorts: [dim_clientes.count desc]
      inner_radius: 60
      series_colors:
        Patrimonial: "#0F6FF5"
        Empresarial: "#0853BB"
        Privada: "#E0C792"
        Preferente: "#0853BB"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 35
      col: 0
      width: 8
      height: 7

    - name: chart_clientes_riesgo
      title_hidden: true
      title: "Clientes por Perfil de Riesgo"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_pie
      fields: [dim_clientes.perfil_riesgo, dim_clientes.count]
      sorts: [dim_clientes.count desc]
      inner_radius: 60
      series_colors:
        Conservador: "#0853BB"
        Moderado: "#E0C792"
        Dinámico: "#5B6678"
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 35
      col: 8
      width: 8
      height: 7

    - name: chart_ticket_promedio_segmento
      title_hidden: true
      title: "Ticket Promedio de Aportación por Segmento"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_bar
      fields: [dim_clientes.segmento, fact_movimientos_inversion.ticket_promedio_aportacion]
      sorts: [fact_movimientos_inversion.ticket_promedio_aportacion desc]
      series_colors:
        fact_movimientos_inversion.ticket_promedio_aportacion: "#0F6FF5"
      x_axis_gridlines: false
      y_axis_gridlines: true
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 35
      col: 16
      width: 8
      height: 7

    # Fila 5 Titulo
    - name: title_grid_detalle_asesores
      type: text
      body_text: "<div style='display:flex; align-items:center; justify-content:center; font-family: Roboto, Arial, sans-serif; font-weight:400; font-size:14px; color:#002D6F; width:100%;'><div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div>Detalle de Rendimiento por Asesor<div style='flex:1; height:2px; background-color:#002D6F; margin:0 12px;'></div></div>"
      row: 42
      col: 0
      width: 24
      height: 1

    - name: grid_detalle_asesores
      title_hidden: true
      title: "Detalle de Rendimiento por Asesor"
      model: demos_looker
      explore: fact_movimientos_inversion
      type: looker_grid
      fields: [
        dim_asesores.asesor_nombre,
        dim_asesores.region,
        dim_asesores.sucursal,
        fact_movimientos_inversion.clientes_con_movimiento,
        fact_movimientos_inversion.captacion_neta_mxn,
        fact_movimientos_inversion.total_aportaciones_mxn,
        fact_movimientos_inversion.total_retiros_abs_mxn,
        fact_movimientos_inversion.meta_captacion_periodo,
        fact_movimientos_inversion.cumplimiento_meta_pct,
        fact_movimientos_inversion.movimientos_pendientes
      ]
      sorts: [fact_movimientos_inversion.cumplimiento_meta_pct desc]
      show_view_names: false
      show_row_numbers: false
      table_theme: white
      series_cell_visualizations:
        dim_asesores.asesor_nombre:
          is_active: false
        dim_asesores.region:
          is_active: false
        dim_asesores.sucursal:
          is_active: false
        fact_movimientos_inversion.clientes_con_movimiento:
          is_active: false
        fact_movimientos_inversion.captacion_neta_mxn:
          is_active: false
        fact_movimientos_inversion.total_aportaciones_mxn:
          is_active: false
        fact_movimientos_inversion.total_retiros_abs_mxn:
          is_active: false
        fact_movimientos_inversion.meta_captacion_periodo:
          is_active: false
        fact_movimientos_inversion.cumplimiento_meta_pct:
          is_active: false
        fact_movimientos_inversion.movimientos_pendientes:
          is_active: false
      header_background_color: "#1A2433"
      header_font_color: "#FFFFFF"
      conditional_formatting: [{
        type: greater than,
        value: 0.999,
        background_color: "#3DBE7A",
        font_color: "#FFFFFF"
      }, {
        type: between,
        value: [0.8, 0.999],
        background_color: "#E3A33B",
        font_color: "#FFFFFF"
      }, {
        type: less than,
        value: 0.8,
        background_color: "#F0645A",
        font_color: "#FFFFFF"
      }]
      listen:
        periodo: fact_movimientos_inversion.fecha_date
        region: dim_asesores.region
        asesor: dim_asesores.asesor_nombre
        segmento: dim_clientes.segmento
        producto: dim_productos.producto_nombre
        perfil_riesgo: dim_clientes.perfil_riesgo
      row: 43
      col: 0
      width: 24
      height: 8

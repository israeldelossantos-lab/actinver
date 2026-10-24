- dashboard: ecommerce_sales_performance
  title: "E-Commerce: Ventas, Margen y Descuentos"
  description: "Análisis comercial de ventas netas, rentabilidad por categoría, impacto de promociones y comportamiento logístico."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour

  filters:
    - name: order_date
      title: "Fecha de Orden"
      type: date_filter
      default_value: "2024/01/01 to 2026/01/31"
      allow_multiple_values: false
      required: false
      ui_config:
        type: relative_timeframes
        display: inline

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
      explore: e_commerce_orders
      listens_to_filters: []
      field: e_commerce_orders.region

    - name: category
      title: "Categoría"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: e_commerce_orders
      listens_to_filters: []
      field: e_commerce_orders.category

    - name: ship_mode
      title: "Método de Envío"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: e_commerce_orders
      listens_to_filters: []
      field: e_commerce_orders.ship_mode

  elements:
    # --- Encabezado ---
    - name: header_tile
      type: text
      title_text: "🛒 Desempeño Comercial E-Commerce"
      subtitle_text: "Monitoreo de ingresos netos, rentabilidad de productos, dispersión regional e impacto del descuento."
      body_text: ""
      row: 0
      col: 0
      width: 24
      height: 2

    # --- Fila 1: KPIs ---
    - name: kpi_venta_neta
      title: "Venta Neta"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.total_revenue_sum]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 2
      col: 0
      width: 4
      height: 2

    - name: kpi_utilidad_total
      title: "Utilidad Total"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.total_profit_sum]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 2
      col: 4
      width: 4
      height: 2

    - name: kpi_margen_pct
      title: "Margen de Utilidad %"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.profit_margin_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 2
      col: 8
      width: 4
      height: 2

    - name: kpi_ordenes
      title: "Órdenes Totales"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.count]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 2
      col: 12
      width: 4
      height: 2

    - name: kpi_aov
      title: "Ticket Promedio (AOV)"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.average_order_value]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 2
      col: 16
      width: 4
      height: 2

    - name: kpi_descuento_efectivo
      title: "Descuento Efectivo %"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.effective_discount_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 2
      col: 20
      width: 4
      height: 2

    # --- Filas 2-3: Gráficos Principales ---
    - name: chart_evolucion_venta_utilidad
      title: "Evolución Mensual: Venta Neta y Utilidad"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_area
      fields: [e_commerce_orders.order_month, e_commerce_orders.total_revenue_sum, e_commerce_orders.total_profit_sum]
      sorts: [e_commerce_orders.order_month asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Mes de Orden"
      series_colors:
        e_commerce_orders.total_revenue_sum: "#5B2A86"
        e_commerce_orders.total_profit_sum: "#1E8E3E"
      series_labels:
        e_commerce_orders.total_revenue_sum: "Venta Neta ($)"
        e_commerce_orders.total_profit_sum: "Utilidad ($)"
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 5
      col: 0
      width: 24
      height: 9

    - name: chart_venta_categoria_bar
      title: "Venta Total y Margen por Categoría"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_bar
      fields: [e_commerce_orders.category, e_commerce_orders.total_revenue_sum, e_commerce_orders.profit_margin_pct]
      sorts: [e_commerce_orders.total_revenue_sum desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: false
      series_types:
        e_commerce_orders.profit_margin_pct: line
      series_colors:
        e_commerce_orders.total_revenue_sum: "#5B2A86"
        e_commerce_orders.profit_margin_pct: "#EF6C00"
      series_labels:
        e_commerce_orders.total_revenue_sum: "Venta Neta ($)"
        e_commerce_orders.profit_margin_pct: "Margen de Utilidad (%)"
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 14
      col: 0
      width: 12
      height: 9

    - name: chart_heatmap_region_categoria
      title: "Matriz Regional: Venta Neta por Región × Categoría"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_grid
      fields: [e_commerce_orders.region, e_commerce_orders.category, e_commerce_orders.total_revenue_sum]
      pivots: [e_commerce_orders.category]
      sorts: [e_commerce_orders.total_revenue_sum desc 0]
      show_view_names: false
      show_row_numbers: false
      conditional_formatting:
        - type: low to high
          value:
          background_color:
          font_color:
          palette:
            name: purple_scale
            colors: ["#F3E5F5", "#CE93D8", "#5B2A86"]
          bold: false
          italic: false
          strikethrough: false
          fields: [e_commerce_orders.total_revenue_sum]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 14
      col: 12
      width: 12
      height: 9

    - name: chart_margen_por_descuento
      title: "Impacto del Descuento en el Margen de Utilidad (%)"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_column
      fields: [e_commerce_orders.discount_band, e_commerce_orders.profit_margin_pct]
      sorts: [e_commerce_orders.discount_band asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Rango de Descuento"
      series_colors:
        e_commerce_orders.profit_margin_pct: "#5B2A86"
      series_labels:
        e_commerce_orders.profit_margin_pct: "Margen de Utilidad (%)"
      reference_lines:
        - reference_type: line
          line_value: mean
          range_start: max
          range_end: min
          margin_top: deviation
          margin_value: mean
          margin_bottom: deviation
          label_position: right
          color: "#D93025"
          label: "Margen Promedio"
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 23
      col: 0
      width: 12
      height: 8

    - name: chart_ordenes_ship_mode_donut
      title: "Órdenes por Método de Envío"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_pie
      fields: [e_commerce_orders.ship_mode, e_commerce_orders.count]
      sorts: [e_commerce_orders.count desc]
      value_labels: legend
      label_type: labPer
      inner_radius: 55
      series_colors:
        Standard: "#9E9E9E"
        Express: "#5B2A86"
        Same Day: "#FFB300"
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 23
      col: 12
      width: 6
      height: 8

    - name: chart_aov_ship_mode
      title: "AOV por Método Envío"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_column
      fields: [e_commerce_orders.ship_mode, e_commerce_orders.average_order_value]
      sorts: [e_commerce_orders.average_order_value desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        e_commerce_orders.average_order_value: "#5B2A86"
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 23
      col: 18
      width: 6
      height: 8

    # --- Fila Final: Tabla de Detalle ---
    - name: table_top_productos
      title: "🏆 Top 20 Productos por Venta Neta y Rentabilidad"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_grid
      fields: [
        e_commerce_orders.product_name,
        e_commerce_orders.category,
        e_commerce_orders.count,
        e_commerce_orders.total_units_sold,
        e_commerce_orders.total_revenue_sum,
        e_commerce_orders.total_profit_sum,
        e_commerce_orders.profit_margin_pct
      ]
      sorts: [e_commerce_orders.total_revenue_sum desc]
      limit: 20
      show_view_names: false
      show_row_numbers: true
      table_theme: white
      conditional_formatting:
        - type: along a scale...
          value:
          background_color: "#1E8E3E"
          font_color:
          palette:
            name: profit_traffic
            colors: ["#D93025", "#F9AB00", "#1E8E3E"]
          bold: false
          italic: false
          strikethrough: false
          fields: [e_commerce_orders.profit_margin_pct]
      listen:
        order_date: e_commerce_orders.order_date
        region: e_commerce_orders.region
        category: e_commerce_orders.category
        ship_mode: e_commerce_orders.ship_mode
      row: 31
      col: 0
      width: 24
      height: 9

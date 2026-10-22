- dashboard: retail_inventory_overview
  title: "Inventario Retail: Salud de Stock y Rentabilidad"
  description: "Monitoreo integral de ventas, rotación de producto, niveles críticos de inventario y margen bruto."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour

  filters:
    - name: category
      title: "Categoría"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: checkboxes
        display: popover
      model: demos_looker
      explore: retail_inventory
      listens_to_filters: []
      field: retail_inventory.category

    - name: supplier_name
      title: "Proveedor"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: retail_inventory
      listens_to_filters: []
      field: retail_inventory.supplier_name

    - name: stock_status
      title: "Estatus de Stock"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: retail_inventory
      listens_to_filters: []
      field: retail_inventory.stock_status

  elements:
    # --- Encabezado ---
    - name: header_tile
      type: text
      title_text: "📦 Control de Inventario y Salud de Stock"
      subtitle_text: "Monitoreo en tiempo real de márgenes comerciales, rotación (sell-through) y alertas de reposición."
      body_text: ""
      row: 0
      col: 0
      width: 24
      height: 2

    # --- Fila 1: KPIs ---
    - name: kpi_venta_total
      title: "Venta Total"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.total_sales_revenue]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#0B6E4F"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 2
      col: 0
      width: 4
      height: 3

    - name: kpi_margen_bruto
      title: "Margen Bruto %"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.gross_margin_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#0B6E4F"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 2
      col: 4
      width: 4
      height: 3

    - name: kpi_sell_through
      title: "Sell-Through %"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.sell_through_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#0B6E4F"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 2
      col: 8
      width: 4
      height: 3

    - name: kpi_valor_inventario
      title: "Valor Inventario a Costo"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.total_inventory_cost_value]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#0B6E4F"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 2
      col: 12
      width: 4
      height: 3

    - name: kpi_skus_low_stock
      title: "SKUs en Bajo Stock"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.low_stock_skus]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#D93025"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 2
      col: 16
      width: 4
      height: 3

    - name: kpi_pct_low_stock
      title: "% en Bajo Stock"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.low_stock_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#D93025"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 2
      col: 20
      width: 4
      height: 3

    # --- Filas 2-3: Gráficos Principales ---
    - name: chart_venta_margen_categoria
      title: "Venta Total y Margen Bruto % por Categoría"
      model: demos_looker
      explore: retail_inventory
      type: looker_column
      fields: [retail_inventory.category, retail_inventory.total_sales_revenue, retail_inventory.gross_margin_pct]
      sorts: [retail_inventory.total_sales_revenue desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      y_axis_combined: false
      show_x_axis_label: true
      x_axis_label: "Categoría"
      series_types:
        retail_inventory.gross_margin_pct: line
      series_colors:
        retail_inventory.total_sales_revenue: "#0B6E4F"
        retail_inventory.gross_margin_pct: "#E07A5F"
      series_labels:
        retail_inventory.total_sales_revenue: "Venta Total ($)"
        retail_inventory.gross_margin_pct: "Margen Bruto (%)"
      y_axes:
        - label: "Venta Total ($)"
          orientation: left
          series:
            - id: retail_inventory.total_sales_revenue
              name: "Venta Total ($)"
        - label: "Margen Bruto (%)"
          orientation: right
          series:
            - id: retail_inventory.gross_margin_pct
              name: "Margen Bruto (%)"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 5
      col: 0
      width: 12
      height: 9

    - name: chart_proveedores_rotacion_margen
      title: "Proveedores: Rotación (Sell-Through) vs Margen Bruto"
      model: demos_looker
      explore: retail_inventory
      type: looker_scatter
      fields: [retail_inventory.supplier_name, retail_inventory.sell_through_pct, retail_inventory.gross_margin_pct, retail_inventory.total_sales_revenue]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      show_x_axis_label: true
      x_axis_label: "Sell-Through (%)"
      y_axis_label: "Margen Bruto (%)"
      series_colors:
        retail_inventory.gross_margin_pct: "#0B6E4F"
      point_style: circle
      size_by_field: retail_inventory.total_sales_revenue
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 5
      col: 12
      width: 12
      height: 9

    - name: chart_cobertura_stock_categoria
      title: "Distribución de Salud de Stock por Categoría (100% Apilado)"
      model: demos_looker
      explore: retail_inventory
      type: looker_bar
      fields: [retail_inventory.category, retail_inventory.stock_cover_bucket, retail_inventory.count]
      pivots: [retail_inventory.stock_cover_bucket]
      sorts: [retail_inventory.category asc]
      stacking: percent
      x_axis_gridlines: false
      y_axis_gridlines: false
      show_view_names: false
      show_x_axis_label: false
      show_y_axis_labels: true
      series_colors:
        Reordenar - retail_inventory.count: "#D93025"
        Vigilar - retail_inventory.count: "#F9AB00"
        Saludable - retail_inventory.count: "#1E8E3E"
      legend_position: bottom
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 14
      col: 0
      width: 16
      height: 8

    - name: chart_stock_status_donut
      title: "Estatus General de Stock"
      model: demos_looker
      explore: retail_inventory
      type: looker_pie
      fields: [retail_inventory.stock_status, retail_inventory.count]
      sorts: [retail_inventory.count desc]
      value_labels: legend
      label_type: labPer
      inner_radius: 55
      series_colors:
        In Stock: "#0B6E4F"
        Low Stock: "#D93025"
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
        stock_status: retail_inventory.stock_status
      row: 14
      col: 16
      width: 8
      height: 8

    # --- Fila Final: Tabla de Detalle ---
    - name: table_skus_reordenar
      title: "⚠️ SKUs en Bajo Stock a Reordenar Inmediatamente"
      model: demos_looker
      explore: retail_inventory
      type: looker_grid
      fields: [
        retail_inventory.product_id,
        retail_inventory.product_name,
        retail_inventory.category,
        retail_inventory.supplier_name,
        retail_inventory.closing_stock,
        retail_inventory.reorder_point,
        retail_inventory.units_below_reorder,
        retail_inventory.unit_cost
      ]
      filters:
        retail_inventory.stock_status: "Low Stock"
      sorts: [retail_inventory.units_below_reorder desc]
      limit: 50
      show_view_names: false
      show_row_numbers: true
      truncate_column_names: false
      table_theme: white
      conditional_formatting:
        - type: low to high
          value:
          background_color:
          font_color:
          palette:
            name: red_alert
            colors: ["#FFFFFF", "#FCE8E6", "#D93025"]
          bold: false
          italic: false
          strikethrough: false
          fields: [retail_inventory.units_below_reorder]
      listen:
        category: retail_inventory.category
        supplier_name: retail_inventory.supplier_name
      row: 22
      col: 0
      width: 24
      height: 9

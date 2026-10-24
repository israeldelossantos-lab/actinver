- dashboard: marketing_campaign_roi
  title: "Marketing: Inversión, Conversión y ROAS"
  description: "Monitoreo integral de retorno de inversión publicitaria (ROAS), eficiencia por canal digital y control presupuestal."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour

  filters:
    - name: start_date
      title: "Fecha de Inicio"
      type: date_filter
      default_value: "2024/01/01 to 2026/01/31"
      allow_multiple_values: false
      required: false
      ui_config:
        type: relative_timeframes
        display: inline

    - name: channel
      title: "Canal Publicitario"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: checkboxes
        display: popover
      model: demos_looker
      explore: marketing_campaigns
      listens_to_filters: []
      field: marketing_campaigns.channel

    - name: campaign_type
      title: "Tipo de Campaña"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: marketing_campaigns
      listens_to_filters: []
      field: marketing_campaigns.campaign_type

  elements:
    # --- Encabezado ---
    - name: header_tile
      type: text
      title_text: "🎯 Estrategia de Marketing Digital y Atribución de Ventas"
      subtitle_text: "Rendimiento publicitario, efectividad de embudo de conversión y comparativo multicanal de ROAS."
      body_text: ""
      row: 0
      col: 0
      width: 24
      height: 2

    # --- Fila 1: KPIs ---
    - name: kpi_inversion
      title: "Inversión Total (Gasto)"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.total_spent]
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
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 2
      col: 0
      width: 4
      height: 2

    - name: kpi_ingresos
      title: "Ingresos Atribuidos"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.total_revenue]
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
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 2
      col: 4
      width: 4
      height: 2

    - name: kpi_roas
      title: "ROAS (Retorno Inversión)"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.return_on_ad_spend]
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
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 2
      col: 8
      width: 4
      height: 2

    - name: kpi_cpa
      title: "CPA (Costo por Adquisición)"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.cost_per_acquisition]
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
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 2
      col: 12
      width: 4
      height: 2

    - name: kpi_conversion_rate
      title: "Tasa de Conversión %"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.conversion_rate_pct]
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
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 2
      col: 16
      width: 4
      height: 2

    - name: kpi_campanas_sobregiradas
      title: "Campañas Sobregiradas"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.overspent_campaigns]
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
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 2
      col: 20
      width: 4
      height: 2

    # --- Filas 2-3: Gráficos Principales ---
    - name: chart_inversion_ingresos_roas_mensual
      title: "Inversión, Ingresos Atribuidos y ROAS Mensual"
      model: demos_looker
      explore: marketing_campaigns
      type: looker_column
      fields: [
        marketing_campaigns.start_month,
        marketing_campaigns.total_spent,
        marketing_campaigns.total_revenue,
        marketing_campaigns.return_on_ad_spend
      ]
      sorts: [marketing_campaigns.start_month asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Mes de Campaña"
      series_types:
        marketing_campaigns.return_on_ad_spend: line
      series_colors:
        marketing_campaigns.total_spent: "#E8710A"
        marketing_campaigns.total_revenue: "#1E8E3E"
        marketing_campaigns.return_on_ad_spend: "#1A73E8"
      series_labels:
        marketing_campaigns.total_spent: "Inversión ($)"
        marketing_campaigns.total_revenue: "Ingresos ($)"
        marketing_campaigns.return_on_ad_spend: "ROAS (x)"
      y_axes:
        - label: "Monto Financiero ($)"
          orientation: left
          series:
            - id: marketing_campaigns.total_spent
              name: "Inversión ($)"
            - id: marketing_campaigns.total_revenue
              name: "Ingresos ($)"
        - label: "ROAS (x)"
          orientation: right
          series:
            - id: marketing_campaigns.return_on_ad_spend
              name: "ROAS (x)"
      listen:
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 5
      col: 0
      width: 24
      height: 9

    - name: chart_roas_por_canal
      title: "ROAS por Canal Publicitario (vs Punto de Equilibrio 1.0x)"
      model: demos_looker
      explore: marketing_campaigns
      type: looker_bar
      fields: [marketing_campaigns.channel, marketing_campaigns.return_on_ad_spend]
      sorts: [marketing_campaigns.return_on_ad_spend desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        marketing_campaigns.return_on_ad_spend: "#E8710A"
      series_labels:
        marketing_campaigns.return_on_ad_spend: "ROAS Promedio"
      reference_lines:
        - reference_type: line
          line_value: 1
          range_start: max
          range_end: min
          label_position: right
          color: "#D93025"
          label: "Equilibrio (1.0x)"
      listen:
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 14
      col: 0
      width: 12
      height: 9

    - name: chart_embudo_marketing
      title: "Embudo de Eficiencia: Impresiones → Clics → Conversiones"
      model: demos_looker
      explore: marketing_campaigns
      type: looker_column
      fields: [marketing_campaigns.channel, marketing_campaigns.total_impressions, marketing_campaigns.total_clicks, marketing_campaigns.total_conversions]
      sorts: [marketing_campaigns.total_impressions desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        marketing_campaigns.total_impressions: "#4285F4"
        marketing_campaigns.total_clicks: "#F9AB00"
        marketing_campaigns.total_conversions: "#1E8E3E"
      series_labels:
        marketing_campaigns.total_impressions: "Impresiones"
        marketing_campaigns.total_clicks: "Clics"
        marketing_campaigns.total_conversions: "Conversiones"
      legend_position: bottom
      listen:
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 14
      col: 12
      width: 12
      height: 9

    - name: chart_scatter_cpa_roas
      title: "Eficiencia: CPA vs ROAS por Canal y Tipo de Campaña"
      model: demos_looker
      explore: marketing_campaigns
      type: looker_scatter
      fields: [
        marketing_campaigns.channel,
        marketing_campaigns.campaign_type,
        marketing_campaigns.cost_per_acquisition,
        marketing_campaigns.return_on_ad_spend,
        marketing_campaigns.total_spent
      ]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Costo por Adquisición ($ CPA)"
      y_axis_label: "ROAS (x)"
      series_colors:
        marketing_campaigns.return_on_ad_spend: "#E8710A"
      point_style: circle
      size_by_field: marketing_campaigns.total_spent
      listen:
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 23
      col: 0
      width: 16
      height: 8

    - name: chart_spend_status_donut
      title: "Distribución de Control Presupuestal"
      model: demos_looker
      explore: marketing_campaigns
      type: looker_pie
      fields: [marketing_campaigns.spend_status, marketing_campaigns.count]
      sorts: [marketing_campaigns.count desc]
      value_labels: legend
      label_type: labPer
      inner_radius: 55
      series_colors:
        Subejercido: "#80868B"
        En plan: "#1E8E3E"
        Sobregirado: "#D93025"
      listen:
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 23
      col: 16
      width: 8
      height: 8

    # --- Fila Final: Tabla de Detalle ---
    - name: table_detalle_campanas
      title: "📋 Rendimiento por Campaña: Presupuesto, Conversiones y Retorno"
      model: demos_looker
      explore: marketing_campaigns
      type: looker_grid
      fields: [
        marketing_campaigns.campaign_id,
        marketing_campaigns.campaign_name,
        marketing_campaigns.channel,
        marketing_campaigns.start_date,
        marketing_campaigns.end_date,
        marketing_campaigns.budget_allocated,
        marketing_campaigns.amount_spent,
        marketing_campaigns.budget_utilization_pct,
        marketing_campaigns.total_conversions,
        marketing_campaigns.total_revenue,
        marketing_campaigns.return_on_ad_spend
      ]
      sorts: [marketing_campaigns.return_on_ad_spend desc]
      limit: 100
      show_view_names: false
      show_row_numbers: true
      table_theme: white
      conditional_formatting:
        - type: along a scale...
          value:
          background_color: "#1E8E3E"
          font_color:
          palette:
            name: green_roas
            colors: ["#D93025", "#F9AB00", "#1E8E3E"]
          bold: false
          italic: false
          strikethrough: false
          fields: [marketing_campaigns.return_on_ad_spend]
      listen:
        start_date: marketing_campaigns.start_date
        channel: marketing_campaigns.channel
        campaign_type: marketing_campaigns.campaign_type
      row: 31
      col: 0
      width: 24
      height: 9

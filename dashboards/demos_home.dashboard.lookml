- dashboard: demos_home
  title: "Demos Looker: Resumen Ejecutivo Multidominio"
  description: "Portal ejecutivo centralizado con indicadores de desempeño clave de los 6 dominios analíticos y accesos directos a dashboards operativos."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  refresh: 1 hour

  elements:
    # =========================================================================
    # ENCABEZADO PRINCIPAL
    # =========================================================================
    - name: home_header
      type: text
      title_text: "🌟 Suite de Demostraciones Looker: Resumen Ejecutivo"
      subtitle_text: "Tablero central unificado para la evaluación de 6 industrias y casos de uso de analítica empresarial."
      body_text: "Seleccione cualquier indicador o navegue a través de los enlaces directos a los tableros operativos de cada unidad de negocio."
      row: 0
      col: 0
      width: 24
      height: 3

    # =========================================================================
    # 1. RETAIL INVENTORY
    # =========================================================================
    - name: section_retail
      type: text
      title_text: "📦 1. Retail Inventory & Cadena de Suministro"
      subtitle_text: "[Ir al Dashboard Completo de Inventario →](/dashboards/demos_looker::retail_inventory_overview)"
      body_text: ""
      row: 3
      col: 0
      width: 8
      height: 2

    - name: kpi_retail_venta
      title: "Venta Total Retail"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.total_sales_revenue]
      custom_color: "#0B6E4F"
      custom_color_enabled: true
      row: 5
      col: 0
      width: 4
      height: 3

    - name: kpi_retail_low_stock
      title: "% en Bajo Stock"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.low_stock_pct]
      custom_color: "#D93025"
      custom_color_enabled: true
      row: 5
      col: 4
      width: 4
      height: 3

    # =========================================================================
    # 2. PROJECT MANAGEMENT
    # =========================================================================
    - name: section_pmo
      type: text
      title_text: "📊 2. Project Portfolio Management (PMO)"
      subtitle_text: "[Ir al Dashboard Completo de Proyectos →](/dashboards/demos_looker::project_portfolio_health)"
      body_text: ""
      row: 3
      col: 8
      width: 8
      height: 2

    - name: kpi_pmo_ontime
      title: "Entrega a Tiempo %"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.on_time_rate_pct]
      custom_color: "#1E8E3E"
      custom_color_enabled: true
      row: 5
      col: 8
      width: 4
      height: 3

    - name: kpi_pmo_cpi
      title: "Índice Costo (CPI)"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.cpi]
      custom_color: "#1A3A6B"
      custom_color_enabled: true
      row: 5
      col: 12
      width: 4
      height: 3

    # =========================================================================
    # 3. E-COMMERCE ORDERS
    # =========================================================================
    - name: section_ecom
      type: text
      title_text: "🛒 3. E-Commerce & Rentabilidad"
      subtitle_text: "[Ir al Dashboard Completo de E-Commerce →](/dashboards/demos_looker::ecommerce_sales_performance)"
      body_text: ""
      row: 3
      col: 16
      width: 8
      height: 2

    - name: kpi_ecom_venta
      title: "Venta Neta E-Commerce"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.total_revenue_sum]
      custom_color: "#5B2A86"
      custom_color_enabled: true
      row: 5
      col: 16
      width: 4
      height: 3

    - name: kpi_ecom_margen
      title: "Margen de Utilidad %"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.profit_margin_pct]
      custom_color: "#5B2A86"
      custom_color_enabled: true
      row: 5
      col: 20
      width: 4
      height: 3

    # =========================================================================
    # 4. HOSPITAL PATIENTS
    # =========================================================================
    - name: section_hospital
      type: text
      title_text: "🏥 4. Hospital & Operación Clínica"
      subtitle_text: "[Ir al Dashboard Completo Hospitalario →](/dashboards/demos_looker::hospital_operations_billing)"
      body_text: ""
      row: 8
      col: 0
      width: 8
      height: 2

    - name: kpi_hospital_los
      title: "Estancia Promedio (Días)"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.avg_length_of_stay]
      custom_color: "#00796B"
      custom_color_enabled: true
      row: 10
      col: 0
      width: 4
      height: 3

    - name: kpi_hospital_tasa_cobro
      title: "Tasa de Cobro %"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.collection_rate_pct]
      custom_color: "#1E8E3E"
      custom_color_enabled: true
      row: 10
      col: 4
      width: 4
      height: 3

    # =========================================================================
    # 5. SOCIAL MEDIA ANALYTICS
    # =========================================================================
    - name: section_social
      type: text
      title_text: "📱 5. Social Media Analytics"
      subtitle_text: "[Ir al Dashboard Completo de Redes →](/dashboards/demos_looker::social_media_performance)"
      body_text: ""
      row: 8
      col: 8
      width: 8
      height: 2

    - name: kpi_social_engagement
      title: "Engagement Ponderado %"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.weighted_engagement_rate]
      custom_color: "#1E8E3E"
      custom_color_enabled: true
      row: 10
      col: 8
      width: 4
      height: 3

    - name: kpi_social_reach
      title: "Alcance Acumulado"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.total_reach]
      custom_color: "#C13584"
      custom_color_enabled: true
      row: 10
      col: 12
      width: 4
      height: 3

    # =========================================================================
    # 6. MARKETING CAMPAIGNS
    # =========================================================================
    - name: section_marketing
      type: text
      title_text: "🎯 6. Marketing Digital & ROAS"
      subtitle_text: "[Ir al Dashboard Completo de Marketing →](/dashboards/demos_looker::marketing_campaign_roi)"
      body_text: ""
      row: 8
      col: 16
      width: 8
      height: 2

    - name: kpi_mkt_roas
      title: "ROAS General (Retorno)"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.return_on_ad_spend]
      custom_color: "#1E8E3E"
      custom_color_enabled: true
      row: 10
      col: 16
      width: 4
      height: 3

    - name: kpi_mkt_cpa
      title: "CPA Promedio"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.cost_per_acquisition]
      custom_color: "#E8710A"
      custom_color_enabled: true
      row: 10
      col: 20
      width: 4
      height: 3

- dashboard: seguridad_demo
  title: "Demo: ¿Qué puedo ver?"
  layout: newspaper
  preferred_viewer: dashboards-next

  elements:
    # =========================================================================
    # ENCABEZADO Y ATRIBUTOS DEL USUARIO
    # =========================================================================
    - name: header_seguridad
      type: text
      title_text: "🛡️ Seguridad por Fila y por Columna"
      subtitle_text: "Lo que ves depende de tus atributos de usuario (Gobierno de Datos & Mínimo Privilegio)"
      body_text: "Este tablero demuestra la aplicación dinámica de **access_filter** (filtro de filas) y **access_grant** (control de columnas y explores) en tiempo real según el perfil del usuario autenticado en Looker."
      row: 0
      col: 0
      width: 24
      height: 2

    - name: grid_mis_atributos
      title: "Mis atributos"
      model: demos_looker
      explore: contexto_usuario
      type: looker_grid
      fields: [
        contexto_usuario.usuario_perfil,
        contexto_usuario.usuario_region,
        contexto_usuario.usuario_linea_negocio,
        contexto_usuario.usuario_area,
        contexto_usuario.usuario_departamento,
        contexto_usuario.usuario_canal
      ]
      limit: 1
      show_view_names: false
      show_row_numbers: false
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: white
      enable_conditional_formatting: false
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      row: 2
      col: 0
      width: 24
      height: 3

    # =========================================================================
    # 1. RETAIL INVENTORY
    # =========================================================================
    - name: header_retail
      type: text
      title_text: "📦 1. Retail Inventory"
      subtitle_text: "Filtro por Línea de Negocio (demo_linea_negocio)"
      body_text: ""
      row: 5
      col: 0
      width: 24
      height: 1

    - name: kpi_retail_registros
      title: "Registros visibles"
      model: demos_looker
      explore: retail_inventory
      type: single_value
      fields: [retail_inventory.count]
      custom_color: "#0B6E4F"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      row: 6
      col: 0
      width: 6
      height: 6

    - name: grid_retail_detalle
      title: "Detalle de Retail Inventory"
      subtitle_text: "Columna unit_cost (solo perfil financiero)"
      model: demos_looker
      explore: retail_inventory
      type: looker_grid
      fields: [
        retail_inventory.product_name,
        retail_inventory.category,
        retail_inventory.linea_negocio,
        retail_inventory.closing_stock,
        retail_inventory.unit_cost
      ]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      size_to_fit: true
      table_theme: white
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      row: 6
      col: 6
      width: 18
      height: 6

    # =========================================================================
    # 2. E-COMMERCE ORDERS
    # =========================================================================
    - name: header_ecommerce
      type: text
      title_text: "🛒 2. E-Commerce Orders"
      subtitle_text: "Filtros por Región (demo_region) y Línea de Negocio (demo_linea_negocio)"
      body_text: ""
      row: 12
      col: 0
      width: 24
      height: 1

    - name: kpi_ecommerce_registros
      title: "Registros visibles"
      model: demos_looker
      explore: e_commerce_orders
      type: single_value
      fields: [e_commerce_orders.count]
      custom_color: "#0B6E4F"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      row: 13
      col: 0
      width: 6
      height: 6

    - name: grid_ecommerce_detalle
      title: "Detalle de Órdenes E-Commerce"
      subtitle_text: "profit (solo perfil financiero) | customer_name (solo perfil operaciones)"
      model: demos_looker
      explore: e_commerce_orders
      type: looker_grid
      fields: [
        e_commerce_orders.order_id,
        e_commerce_orders.region,
        e_commerce_orders.linea_negocio,
        e_commerce_orders.total_revenue,
        e_commerce_orders.profit,
        e_commerce_orders.customer_name
      ]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      size_to_fit: true
      table_theme: white
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      row: 13
      col: 6
      width: 18
      height: 6

    # =========================================================================
    # 3. PROJECT MANAGEMENT
    # =========================================================================
    - name: header_proyectos
      type: text
      title_text: "📋 3. Project Management"
      subtitle_text: "Filtro por Área de Negocio (demo_area)"
      body_text: ""
      row: 19
      col: 0
      width: 24
      height: 1

    - name: kpi_proyectos_registros
      title: "Registros visibles"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.count]
      custom_color: "#0B6E4F"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      row: 20
      col: 0
      width: 6
      height: 6

    - name: grid_proyectos_detalle
      title: "Detalle de Tareas de Proyectos"
      subtitle_text: "planned_budget y actual_cost (solo perfil financiero)"
      model: demos_looker
      explore: project_management
      type: looker_grid
      fields: [
        project_management.project_name,
        project_management.area_negocio,
        project_management.task_name,
        project_management.status,
        project_management.planned_budget,
        project_management.actual_cost
      ]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      size_to_fit: true
      table_theme: white
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      row: 20
      col: 6
      width: 18
      height: 6

    # =========================================================================
    # 4. HOSPITAL PATIENTS
    # =========================================================================
    - name: header_hospital
      type: text
      title_text: "🏥 4. Hospital Patients"
      subtitle_text: "Acceso al explore (acceso_hospital) y Filtro por Departamento (demo_departamento)"
      body_text: ""
      row: 26
      col: 0
      width: 24
      height: 1

    - name: kpi_hospital_registros
      title: "Registros visibles"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.count]
      custom_color: "#0B6E4F"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      row: 27
      col: 0
      width: 6
      height: 6

    - name: grid_hospital_detalle
      title: "Detalle de Pacientes Hospitalarios"
      subtitle_text: "patient_name y diagnosis (solo perfil clínico) | total_bill_amount (solo perfil financiero)"
      model: demos_looker
      explore: hospital_patients
      type: looker_grid
      fields: [
        hospital_patients.patient_id,
        hospital_patients.department,
        hospital_patients.payment_status,
        hospital_patients.patient_name,
        hospital_patients.diagnosis,
        hospital_patients.total_bill_amount
      ]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      size_to_fit: true
      table_theme: white
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      row: 27
      col: 6
      width: 18
      height: 6

    # =========================================================================
    # 5. MARKETING CAMPAIGNS
    # =========================================================================
    - name: header_marketing
      type: text
      title_text: "📢 5. Marketing Campaigns"
      subtitle_text: "Filtro por Canal Publicitario (demo_canal)"
      body_text: ""
      row: 33
      col: 0
      width: 24
      height: 1

    - name: kpi_marketing_registros
      title: "Registros visibles"
      model: demos_looker
      explore: marketing_campaigns
      type: single_value
      fields: [marketing_campaigns.count]
      custom_color: "#0B6E4F"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      row: 34
      col: 0
      width: 6
      height: 6

    - name: grid_marketing_detalle
      title: "Detalle de Campañas de Marketing"
      subtitle_text: "amount_spent y revenue_generated (solo perfil financiero)"
      model: demos_looker
      explore: marketing_campaigns
      type: looker_grid
      fields: [
        marketing_campaigns.campaign_name,
        marketing_campaigns.channel,
        marketing_campaigns.grupo_canal,
        marketing_campaigns.conversions,
        marketing_campaigns.amount_spent,
        marketing_campaigns.revenue_generated
      ]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      size_to_fit: true
      table_theme: white
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      row: 34
      col: 6
      width: 18
      height: 6

    # =========================================================================
    # 6. SOCIAL MEDIA ANALYTICS
    # =========================================================================
    - name: header_social
      type: text
      title_text: "📱 6. Social Media Analytics"
      subtitle_text: "Filtro por Plataforma (demo_canal)"
      body_text: ""
      row: 40
      col: 0
      width: 24
      height: 1

    - name: kpi_social_registros
      title: "Registros visibles"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.count]
      custom_color: "#0B6E4F"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      row: 41
      col: 0
      width: 6
      height: 6

    - name: grid_social_detalle
      title: "Detalle de Redes Sociales"
      subtitle_text: "Sin restricciones de columna (métricas de interacción pública)"
      model: demos_looker
      explore: social_media_analytics
      type: looker_grid
      fields: [
        social_media_analytics.post_id,
        social_media_analytics.platform,
        social_media_analytics.grupo_canal,
        social_media_analytics.reach,
        social_media_analytics.engagement_rate_pct
      ]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      size_to_fit: true
      table_theme: white
      header_text_alignment: left
      header_font_size: '12'
      rows_font_size: '12'
      row: 41
      col: 6
      width: 18
      height: 6

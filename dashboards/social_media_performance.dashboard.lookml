- dashboard: social_media_performance
  title: "Redes Sociales: Alcance y Engagement"
  description: "Análisis cross-platform de efectividad de contenido orgánico, viralidad, volumen de alcance e interacciones."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour

  filters:
    - name: post_date
      title: "Fecha de Publicación"
      type: date_filter
      default_value: "2024/01/01 to 2026/01/31"
      allow_multiple_values: false
      required: false
      ui_config:
        type: relative_timeframes
        display: inline

    - name: platform
      title: "Plataforma"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: social_media_analytics
      listens_to_filters: []
      field: social_media_analytics.platform

    - name: content_type
      title: "Tipo de Contenido"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: social_media_analytics
      listens_to_filters: []
      field: social_media_analytics.content_type

  elements:
    # --- Encabezado ---
    - name: header_tile
      type: text
      title_text: "📱 Analítica de Redes Sociales y Rendimiento Digital"
      subtitle_text: "Seguimiento unificado de alcance, crecimiento de audiencia y engagement rate ponderado en canales sociales."
      body_text: ""
      row: 0
      col: 0
      width: 24
      height: 2

    # --- Fila 1: KPIs ---
    - name: kpi_total_posts
      title: "Posts Publicados"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.count]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#C13584"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 2
      col: 0
      width: 4
      height: 3

    - name: kpi_impresiones
      title: "Impresiones Totales"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.total_impressions]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#C13584"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 2
      col: 4
      width: 4
      height: 3

    - name: kpi_alcance
      title: "Alcance Único"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.total_reach]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#C13584"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 2
      col: 8
      width: 4
      height: 3

    - name: kpi_interacciones
      title: "Interacciones (Engagements)"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.total_engagements]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#C13584"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 2
      col: 12
      width: 4
      height: 3

    - name: kpi_engagement_ponderado
      title: "Engagement Rate (Ponderado)"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.weighted_engagement_rate]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#1E8E3E"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 2
      col: 16
      width: 4
      height: 3

    - name: kpi_posts_virales
      title: "Posts Virales (>=12%)"
      model: demos_looker
      explore: social_media_analytics
      type: single_value
      fields: [social_media_analytics.viral_posts]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#C13584"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 2
      col: 20
      width: 4
      height: 3

    # --- Filas 2-3: Gráficos Principales ---
    - name: chart_impresiones_plataforma_tiempo
      title: "Tendencia de Impresiones Mensuales por Plataforma"
      model: demos_looker
      explore: social_media_analytics
      type: looker_area
      fields: [social_media_analytics.post_month, social_media_analytics.platform, social_media_analytics.total_impressions]
      pivots: [social_media_analytics.platform]
      sorts: [social_media_analytics.post_month asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Mes de Publicación"
      series_colors:
        Instagram - social_media_analytics.total_impressions: "#C13584"
        TikTok - social_media_analytics.total_impressions: "#25F4EE"
        Facebook - social_media_analytics.total_impressions: "#1877F2"
        Twitter - social_media_analytics.total_impressions: "#1DA1F2"
        LinkedIn - social_media_analytics.total_impressions: "#0A66C2"
      legend_position: bottom
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 5
      col: 0
      width: 24
      height: 9

    - name: chart_engagement_por_plataforma
      title: "Engagement Rate Ponderado por Plataforma"
      model: demos_looker
      explore: social_media_analytics
      type: looker_column
      fields: [social_media_analytics.platform, social_media_analytics.weighted_engagement_rate]
      sorts: [social_media_analytics.weighted_engagement_rate desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: false
      series_colors:
        social_media_analytics.weighted_engagement_rate: "#C13584"
      series_labels:
        social_media_analytics.weighted_engagement_rate: "Engagement Rate (%)"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 14
      col: 0
      width: 12
      height: 9

    - name: chart_heatmap_formato_plataforma
      title: "¿Qué formato funciona en cada red? (Engagement Rate Ponderado)"
      model: demos_looker
      explore: social_media_analytics
      type: looker_grid
      fields: [social_media_analytics.platform, social_media_analytics.content_type, social_media_analytics.weighted_engagement_rate]
      pivots: [social_media_analytics.content_type]
      sorts: [social_media_analytics.platform asc]
      show_view_names: false
      show_row_numbers: false
      conditional_formatting:
        - type: low to high
          value:
          background_color:
          font_color:
          palette:
            name: pink_mag
            colors: ["#FCE4EC", "#F48FB1", "#C13584"]
          bold: false
          italic: false
          strikethrough: false
          fields: [social_media_analytics.weighted_engagement_rate]
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 14
      col: 12
      width: 12
      height: 9

    - name: chart_composicion_interacciones
      title: "Composición de Interacciones por Plataforma (100% Apilado)"
      model: demos_looker
      explore: social_media_analytics
      type: looker_bar
      fields: [social_media_analytics.platform, social_media_analytics.total_likes, social_media_analytics.total_comments, social_media_analytics.total_shares]
      sorts: [social_media_analytics.platform asc]
      stacking: percent
      x_axis_gridlines: false
      y_axis_gridlines: false
      show_view_names: false
      series_colors:
        social_media_analytics.total_likes: "#E91E63"
        social_media_analytics.total_comments: "#FFB300"
        social_media_analytics.total_shares: "#00ACC1"
      series_labels:
        social_media_analytics.total_likes: "Likes"
        social_media_analytics.total_comments: "Comentarios"
        social_media_analytics.total_shares: "Shares"
      legend_position: bottom
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 23
      col: 0
      width: 12
      height: 8

    - name: chart_engagement_dia_semana
      title: "Engagement Rate por Día de la Semana"
      model: demos_looker
      explore: social_media_analytics
      type: looker_column
      fields: [social_media_analytics.post_day_of_week, social_media_analytics.weighted_engagement_rate]
      sorts: [social_media_analytics.post_day_of_week asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        social_media_analytics.weighted_engagement_rate: "#C13584"
      series_labels:
        social_media_analytics.weighted_engagement_rate: "Engagement Rate (%)"
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 23
      col: 12
      width: 12
      height: 8

    # --- Fila Final: Tabla de Detalle ---
    - name: table_top_posts
      title: "🔥 Top 25 Publicaciones con Mayor Viralidad y Engagement"
      model: demos_looker
      explore: social_media_analytics
      type: looker_grid
      fields: [
        social_media_analytics.post_id,
        social_media_analytics.platform,
        social_media_analytics.content_type,
        social_media_analytics.post_date,
        social_media_analytics.reach,
        social_media_analytics.total_engagements,
        social_media_analytics.weighted_engagement_rate,
        social_media_analytics.performance_tier
      ]
      sorts: [social_media_analytics.total_engagements desc]
      limit: 25
      show_view_names: false
      show_row_numbers: true
      table_theme: white
      conditional_formatting:
        - type: along a scale...
          value:
          background_color: "#C13584"
          font_color:
          palette:
            name: pink_bars
            colors: ["#FFFFFF", "#F8BBD0", "#C13584"]
          bold: false
          italic: false
          strikethrough: false
          fields: [social_media_analytics.weighted_engagement_rate]
      listen:
        post_date: social_media_analytics.post_date
        platform: social_media_analytics.platform
        content_type: social_media_analytics.content_type
      row: 31
      col: 0
      width: 24
      height: 9

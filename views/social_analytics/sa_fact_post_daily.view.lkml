view: sa_fact_post_daily {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.fact_post_daily` ;;

  dimension: pk {
    primary_key: yes
    type: string
    hidden: yes
    sql: CONCAT(CAST(${TABLE}.date_key AS STRING), '_', CAST(${TABLE}.post_id AS STRING)) ;;
  }

  dimension: post_id {
    type: number
    hidden: yes
    sql: ${TABLE}.post_id ;;
  }

  dimension_group: fecha {
    label: "Fecha"
    type: time
    timeframes: [raw, date, week, month, quarter, year, day_of_week]
    datatype: date
    convert_tz: no
    sql: ${TABLE}.date_key ;;
    description: "Fecha del snapshot de rendimiento del contenido"
  }

  # ============================================================================
  # MEDIDAS: Alcance e Impresiones
  # ============================================================================

  measure: impresiones {
    label: "Impresiones Orgánicas"
    type: sum
    sql: ${TABLE}.impressions ;;
    value_format_name: decimal_0
    group_label: "Alcance e Impresiones"
    description: "Impresiones totales alcanzadas por el contenido en el día"
  }

  measure: alcance {
    label: "Alcance Orgánico"
    type: sum
    sql: ${TABLE}.reach ;;
    value_format_name: decimal_0
    group_label: "Alcance e Impresiones"
    description: "Usuarios únicos impactados por el post orgánico"
  }

  # ============================================================================
  # MEDIDAS: Interacciones Orgánicas
  # ============================================================================

  measure: me_gusta {
    label: "Me Gusta (Likes)"
    type: sum
    sql: ${TABLE}.likes ;;
    value_format_name: decimal_0
    group_label: "Interacciones Orgánicas"
    description: "Cantidad de likes recibidos"
  }

  measure: comentarios {
    label: "Comentarios"
    type: sum
    sql: ${TABLE}.comments ;;
    value_format_name: decimal_0
    group_label: "Interacciones Orgánicas"
    description: "Comentarios totales acumulados"
  }

  measure: compartidos {
    label: "Compartidos (Shares)"
    type: sum
    sql: ${TABLE}.shares ;;
    value_format_name: decimal_0
    group_label: "Interacciones Orgánicas"
    description: "Veces que los usuarios compartieron el post"
  }

  measure: guardados {
    label: "Guardados (Saves)"
    type: sum
    sql: ${TABLE}.saves ;;
    value_format_name: decimal_0
    group_label: "Interacciones Orgánicas"
    description: "Veces que los usuarios guardaron la publicación"
  }

  measure: reproducciones_video {
    label: "Reproducciones de Video Orgánico"
    type: sum
    sql: ${TABLE}.video_views ;;
    value_format_name: decimal_0
    group_label: "Interacciones Orgánicas"
    description: "Visualizaciones totales acumuladas en video/reels"
  }

  measure: tiempo_medio_reproduccion {
    label: "Tiempo Medio de Reproducción (seg)"
    type: average
    sql: ${TABLE}.avg_watch_time_s ;;
    value_format_name: decimal_2
    group_label: "Interacciones Orgánicas"
    description: "Tiempo promedio de retención de video en segundos"
  }

  # ============================================================================
  # MEDIDAS CALCULADAS: Engagement
  # ============================================================================

  measure: interacciones_totales {
    label: "Interacciones Totales Orgánicas"
    type: number
    sql: ${me_gusta} + ${comentarios} + ${compartidos} + ${guardados} ;;
    value_format_name: decimal_0
    group_label: "Métricas Calculadas"
    description: "Suma de me gusta, comentarios, compartidos y guardados"
  }

  measure: engagement_rate {
    label: "Tasa de Engagement Orgánico"
    type: number
    sql: SAFE_DIVIDE(${interacciones_totales}, ${alcance}) ;;
    value_format_name: percent_2
    group_label: "Métricas Calculadas"
    description: "Interacciones totales sobre alcance: Interacciones / Alcance"
  }

  measure: count {
    label: "Cantidad de Snapshots Diarios"
    type: count
    description: "Total de registros de publicaciones diarias"
  }
}

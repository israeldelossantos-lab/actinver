view: social_media_analytics {
  sql_table_name: `claro_video.social_media_analytics` ;;

  dimension: post_id {
    primary_key: yes
    type: string
    label: "ID de Publicación"
    sql: ${TABLE}.post_id ;;
  }

  dimension: platform {
    type: string
    label: "Plataforma"
    sql: ${TABLE}.platform ;;
  }

  dimension_group: post {
    type: time
    timeframes: [raw, date, week, month, quarter, year, day_of_week]
    datatype: datetime
    label: "Fecha de Publicación"
    sql: ${TABLE}.post_date ;;
  }

  dimension: content_type {
    type: string
    label: "Tipo de Contenido"
    sql: ${TABLE}.content_type ;;
  }

  dimension: impressions {
    type: number
    label: "Impresiones"
    sql: ${TABLE}.impressions ;;
  }

  dimension: reach {
    type: number
    label: "Alcance (Personas Únicas)"
    sql: ${TABLE}.reach ;;
  }

  dimension: likes {
    type: number
    label: "Me Gusta (Likes)"
    sql: ${TABLE}.likes ;;
  }

  dimension: comments {
    type: number
    label: "Comentarios"
    sql: ${TABLE}.comments ;;
  }

  dimension: shares {
    type: number
    label: "Compartidos (Shares)"
    sql: ${TABLE}.shares ;;
  }

  dimension: engagement_rate_pct {
    type: number
    label: "Engagement Rate Nominal (%)"
    description: "Tasa de interacción nominal registrada por post"
    sql: ${TABLE}.engagement_rate_pct ;;
  }

  # --- Security dimensions ---

  dimension: grupo_canal {
    type: string
    group_label: "Seguridad"
    label: "Grupo de Canal"
    description: "Agrupación de plataformas para control y análisis"
    case: {
      when: {
        sql: ${TABLE}.platform IN ('Facebook', 'Instagram', 'LinkedIn') ;;
        label: "Social"
      }
      when: {
        sql: ${TABLE}.platform IN ('TikTok', 'Twitter') ;;
        label: "Emergente"
      }
      else: "Otros"
    }
  }

  # --- Derived dimensions ---

  dimension: performance_tier {
    type: string
    label: "Nivel de Rendimiento"
    description: "Bajo (<4%), Promedio (4-8%), Alto (8-12%), Viral (>=12%)"
    case: {
      when: {
        sql: ${engagement_rate_pct} < 4.0 ;;
        label: "Bajo (<4%)"
      }
      when: {
        sql: ${engagement_rate_pct} < 8.0 ;;
        label: "Promedio (4-8%)"
      }
      when: {
        sql: ${engagement_rate_pct} < 12.0 ;;
        label: "Alto (8-12%)"
      }
      else: "Viral (>=12%)"
    }
  }

  # --- Base measures ---

  measure: count {
    type: count
    label: "Total Publicaciones"
    drill_fields: [post_id, platform, content_type, post_date, reach, impressions]
  }

  measure: total_impressions {
    type: sum
    group_label: "KPIs"
    label: "Impresiones Totales"
    description: "Suma total de visualizaciones de publicaciones"
    sql: ${impressions} ;;
  }

  measure: total_reach {
    type: sum
    group_label: "KPIs"
    label: "Alcance Total"
    description: "Suma total de usuarios únicos alcanzados"
    sql: ${reach} ;;
  }

  measure: total_likes {
    type: sum
    group_label: "Volumen"
    label: "Total Likes"
    description: "Suma total de me gusta recibidos"
    sql: ${likes} ;;
  }

  measure: total_comments {
    type: sum
    group_label: "Volumen"
    label: "Total Comentarios"
    description: "Suma total de comentarios generados"
    sql: ${comments} ;;
  }

  measure: total_shares {
    type: sum
    group_label: "Volumen"
    label: "Total Compartidos"
    description: "Suma total de veces compartido el contenido"
    sql: ${shares} ;;
  }

  measure: avg_engagement_rate {
    type: average
    group_label: "Eficiencia"
    label: "Engagement Rate Promedio Simple (%)"
    description: "Promedio aritmético simple de las tasas de engagement registradas"
    value_format_name: percent_2
    sql: ${engagement_rate_pct} / 100.0 ;;
  }

  # --- KPI measures ---

  measure: total_engagements {
    type: sum
    group_label: "KPIs"
    label: "Interacciones Totales (Engagements)"
    description: "Suma de todos los likes, comentarios y compartidos"
    sql: ${likes} + ${comments} + ${shares} ;;
  }

  measure: weighted_engagement_rate {
    type: number
    group_label: "KPIs"
    label: "Engagement Rate (Ponderado)"
    description: "Total de interacciones dividido entre el total de alcance real acumulado"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_engagements}, ${total_reach}) ;;
  }

  measure: engagement_per_impression {
    type: number
    group_label: "Eficiencia"
    label: "Interacciones por Impresión (%)"
    description: "Tasa de interacción sobre el total de impresiones"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_engagements}, ${total_impressions}) ;;
  }

  measure: frequency {
    type: number
    group_label: "Eficiencia"
    label: "Frecuencia de Exposición"
    description: "Promedio de impresiones generadas por usuario alcanzado"
    value_format_name: decimal_2
    sql: SAFE_DIVIDE(${total_impressions}, ${total_reach}) ;;
  }

  measure: share_rate {
    type: number
    group_label: "Eficiencia"
    label: "Tasa de Viralidad (Share Rate %)"
    description: "Compartidos divididos entre usuarios alcanzados"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_shares}, ${total_reach}) ;;
  }

  measure: comment_rate {
    type: number
    group_label: "Eficiencia"
    label: "Tasa de Conversación (Comment Rate %)"
    description: "Comentarios divididos entre usuarios alcanzados"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_comments}, ${total_reach}) ;;
  }

  measure: avg_reach_per_post {
    type: number
    group_label: "Volumen"
    label: "Alcance Promedio por Post"
    description: "Alcance total dividido entre número de publicaciones"
    value_format_name: decimal_0
    sql: SAFE_DIVIDE(${total_reach}, ${count}) ;;
  }

  measure: viral_posts {
    type: count
    group_label: "KPIs"
    label: "Publicaciones Virales (>=12%)"
    description: "Número de publicaciones con engagement rate superior o igual a 12%"
    filters: [performance_tier: "Viral (>=12%)"]
  }
}

view: sa_ai_comment_analysis {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.ai_comment_analysis` ;;

  dimension: comment_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.comment_id ;;
  }

  dimension: sentimiento {
    label: "Sentimiento"
    type: string
    sql: ${TABLE}.sentiment ;;
    description: "Sentimiento clasificado por IA: positivo, neutral, negativo"
  }

  dimension: tema {
    label: "Tema"
    type: string
    sql: ${TABLE}.topic ;;
    description: "Tema o categoría principal del comentario"
  }

  dimension: intencion_compra {
    label: "Intención de Compra"
    type: yesno
    sql: ${TABLE}.is_purchase_intent ;;
    description: "Indica si el comentario expresa intención o interés de compra"
  }

  dimension: es_queja {
    label: "Es Queja / Reclamo"
    type: yesno
    sql: ${TABLE}.is_complaint ;;
    description: "Indica si el comentario contiene una queja o inconformidad"
  }

  dimension_group: analizado_el {
    label: "Análisis IA"
    type: time
    timeframes: [raw, time, date]
    datatype: timestamp
    sql: ${TABLE}.analyzed_at ;;
    description: "Momento en que se ejecutó la inferencia de IA"
  }

  # ============================================================================
  # MEDIDAS: Conteo y Distribución de Sentimiento
  # ============================================================================

  measure: total_comentarios_analizados {
    label: "Comentarios Analizados"
    type: count_distinct
    sql: ${TABLE}.comment_id ;;
    description: "Total de comentarios clasificados con modelo de lenguaje"
  }

  measure: total_positivos {
    label: "Total Positivos"
    type: count_distinct
    sql: ${TABLE}.comment_id ;;
    filters: [sentimiento: "positivo"]
    description: "Cantidad de comentarios con sentimiento positivo"
  }

  measure: total_negativos {
    label: "Total Negativos"
    type: count_distinct
    sql: ${TABLE}.comment_id ;;
    filters: [sentimiento: "negativo"]
    description: "Cantidad de comentarios con sentimiento negativo"
  }

  measure: total_neutrales {
    label: "Total Neutrales"
    type: count_distinct
    sql: ${TABLE}.comment_id ;;
    filters: [sentimiento: "neutral"]
    description: "Cantidad de comentarios con sentimiento neutral"
  }

  measure: pct_positivo {
    label: "% Comentarios Positivos"
    type: number
    sql: SAFE_DIVIDE(${total_positivos}, ${total_comentarios_analizados}) ;;
    value_format_name: percent_2
    description: "Proporción de comentarios positivos sobre el total analizado"
  }

  measure: pct_negativo {
    label: "% Comentarios Negativos"
    type: number
    sql: SAFE_DIVIDE(${total_negativos}, ${total_comentarios_analizados}) ;;
    value_format_name: percent_2
    description: "Proporción de comentarios negativos sobre el total analizado"
  }

  measure: total_quejas {
    label: "Total de Quejas"
    type: count_distinct
    sql: ${TABLE}.comment_id ;;
    filters: [es_queja: "yes"]
    description: "Cantidad total de quejas identificadas por IA"
  }

  measure: total_intencion_compra {
    label: "Total con Intención de Compra"
    type: count_distinct
    sql: ${TABLE}.comment_id ;;
    filters: [intencion_compra: "yes"]
    description: "Cantidad total de comentarios orientados a compra"
  }

  measure: pct_quejas {
    label: "% Quejas"
    type: number
    sql: SAFE_DIVIDE(${total_quejas}, ${total_comentarios_analizados}) ;;
    value_format_name: percent_2
    description: "Porcentaje de comentarios calificados como queja"
  }

  measure: pct_intencion_compra {
    label: "% Intención de Compra"
    type: number
    sql: SAFE_DIVIDE(${total_intencion_compra}, ${total_comentarios_analizados}) ;;
    value_format_name: percent_2
    description: "Porcentaje de comentarios que expresan intención de compra"
  }
}

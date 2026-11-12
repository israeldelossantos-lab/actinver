view: sa_ai_insight {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.ai_insight` ;;

  dimension: insight_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.insight_id ;;
    description: "Identificador único del insight generado por IA"
  }

  dimension: campaign_id {
    type: number
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: tipo_insight {
    label: "Tipo de Insight"
    type: string
    sql: ${TABLE}.insight_type ;;
    description: "weekly_report, anomaly, campaign_review, qa_answer"
  }

  dimension: severidad {
    label: "Severidad"
    type: string
    sql: ${TABLE}.severity ;;
    description: "Nivel de severidad: info, warning, critical"
  }

  dimension: titulo {
    label: "Título Ejecutivo"
    type: string
    sql: ${TABLE}.title ;;
    description: "Encabezado ejecutivo del hallazgo"
  }

  dimension: resumen {
    label: "Resumen Analítico"
    type: string
    sql: ${TABLE}.summary ;;
    description: "Síntesis del análisis generado por Claude"
  }

  dimension: recomendaciones_json {
    type: string
    hidden: yes
    sql: TO_JSON_STRING(${TABLE}.recommendations_json) ;;
    description: "Recomendaciones tácticas estructuradas en JSON"
  }

  dimension: plataforma_codigo {
    label: "Plataforma"
    type: string
    sql: ${TABLE}.platform_code ;;
    description: "Plataforma analizada o general"
  }

  dimension_group: periodo_inicio {
    label: "Periodo Inicio"
    type: time
    timeframes: [raw, date]
    datatype: date
    sql: ${TABLE}.period_start ;;
  }

  dimension_group: periodo_fin {
    label: "Periodo Fin"
    type: time
    timeframes: [raw, date]
    datatype: date
    sql: ${TABLE}.period_end ;;
  }

  dimension: modelo {
    label: "Modelo de IA"
    type: string
    sql: ${TABLE}.model ;;
    description: "Modelo de lenguaje utilizado (ej. claude-opus-5-5)"
  }

  dimension: costo_usd {
    label: "Costo de Inferencia (USD)"
    type: number
    sql: ${TABLE}.cost_usd ;;
    value_format_name: decimal_4
    description: "Costo en dólares de la llamada a la API"
  }

  dimension_group: creado_en {
    label: "Generado el"
    type: time
    timeframes: [raw, time, date]
    datatype: timestamp
    sql: ${TABLE}.created_at ;;
  }

  measure: count {
    label: "Cantidad de Insights"
    type: count
    description: "Total de informes y alertas de IA generadas"
  }

  measure: total_costo_usd {
    label: "Costo Total IA (USD)"
    type: sum
    sql: ${TABLE}.cost_usd ;;
    value_format_name: decimal_4
    description: "Inversión acumulada en inferencia de IA"
  }
}

view: sa_fact_ad_daily {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.fact_ad_daily` ;;

  dimension: pk {
    primary_key: yes
    type: string
    hidden: yes
    sql: CONCAT(CAST(${TABLE}.date_key AS STRING), '_', CAST(${TABLE}.ad_id AS STRING)) ;;
  }

  dimension: ad_id {
    type: number
    hidden: yes
    sql: ${TABLE}.ad_id ;;
  }

  dimension_group: fecha {
    label: "Fecha"
    type: time
    timeframes: [raw, date, week, month, quarter, year, day_of_week]
    datatype: date
    convert_tz: no
    sql: ${TABLE}.date_key ;;
    description: "Fecha de registro de la métrica publicitaria"
  }

  # ============================================================================
  # MEDIDAS: Gasto y Resultados
  # ============================================================================

  measure: gasto {
    label: "Inversión Publicitaria"
    type: sum
    sql: ${TABLE}.spend ;;
    value_format_name: decimal_2
    group_label: "Gasto y resultados"
    description: "Inversión publicitaria total en moneda local (MXN)"
  }

  measure: conversiones {
    label: "Conversiones"
    type: sum
    sql: ${TABLE}.conversions ;;
    value_format_name: decimal_2
    group_label: "Gasto y resultados"
    description: "Cantidad total de conversiones atribuidas a las campañas"
  }

  measure: valor_conversiones {
    label: "Valor de Conversiones"
    type: sum
    sql: ${TABLE}.conversion_value ;;
    value_format_name: decimal_2
    group_label: "Gasto y resultados"
    description: "Valor económico total de las conversiones generadas (MXN)"
  }

  measure: clientes_potenciales {
    label: "Clientes Potenciales (Leads)"
    type: sum
    sql: ${TABLE}.leads ;;
    value_format_name: decimal_0
    group_label: "Gasto y resultados"
    description: "Total de prospectos comerciales o leads registrados"
  }

  # ============================================================================
  # MEDIDAS: Alcance y Clics
  # ============================================================================

  measure: impresiones {
    label: "Impresiones"
    type: sum
    sql: ${TABLE}.impressions ;;
    value_format_name: decimal_0
    group_label: "Alcance y Clics"
    description: "Número total de visualizaciones de anuncios"
  }

  measure: alcance {
    label: "Alcance"
    type: sum
    sql: ${TABLE}.reach ;;
    value_format_name: decimal_0
    group_label: "Alcance y Clics"
    description: "Número de usuarios únicos impactados por la publicidad"
  }

  measure: clics {
    label: "Clics Totales"
    type: sum
    sql: ${TABLE}.clicks ;;
    value_format_name: decimal_0
    group_label: "Alcance y Clics"
    description: "Total de clics recibidos en los anuncios"
  }

  measure: clics_enlace {
    label: "Clics en el Enlace"
    type: sum
    sql: ${TABLE}.link_clicks ;;
    value_format_name: decimal_0
    group_label: "Alcance y Clics"
    description: "Clics dirigidos específicamente a la URL de destino"
  }

  measure: interacciones {
    label: "Interacciones"
    type: sum
    sql: ${TABLE}.engagements ;;
    value_format_name: decimal_0
    group_label: "Alcance y Clics"
    description: "Total de reacciones, comentarios y compartidos en anuncios"
  }

  # ============================================================================
  # MEDIDAS: Video
  # ============================================================================

  measure: reproducciones_video {
    label: "Reproducciones de Video"
    type: sum
    sql: ${TABLE}.video_views ;;
    value_format_name: decimal_0
    group_label: "Video"
    description: "Total de reproducciones de video registradas"
  }

  measure: video_25 {
    label: "Video al 25%"
    type: sum
    sql: ${TABLE}.video_p25 ;;
    value_format_name: decimal_0
    group_label: "Video"
    description: "Visualizaciones que alcanzaron el 25% de duración"
  }

  measure: video_50 {
    label: "Video al 50%"
    type: sum
    sql: ${TABLE}.video_p50 ;;
    value_format_name: decimal_0
    group_label: "Video"
    description: "Visualizaciones que alcanzaron el 50% de duración"
  }

  measure: video_100 {
    label: "Video al 100%"
    type: sum
    sql: ${TABLE}.video_p100 ;;
    value_format_name: decimal_0
    group_label: "Video"
    description: "Visualizaciones completas del video publicitario"
  }

  # ============================================================================
  # MEDIDAS CALCULADAS: Ratios y Eficiencia
  # ============================================================================

  measure: ctr {
    label: "CTR (Click-Through Rate)"
    type: number
    sql: SAFE_DIVIDE(${clics}, ${impresiones}) ;;
    value_format_name: percent_2
    group_label: "Métricas Calculadas"
    description: "Porcentaje de clics sobre impresiones: Clics / Impresiones"
  }

  measure: cpc {
    label: "CPC (Costo por Clic)"
    type: number
    sql: SAFE_DIVIDE(${gasto}, ${clics}) ;;
    value_format_name: decimal_2
    group_label: "Métricas Calculadas"
    description: "Costo unitario por cada clic obtenido: Gasto / Clics (MXN)"
  }

  measure: cpm {
    label: "CPM (Costo por Mil Impresiones)"
    type: number
    sql: SAFE_DIVIDE(${gasto}, ${impresiones}) * 1000 ;;
    value_format_name: decimal_2
    group_label: "Métricas Calculadas"
    description: "Costo por cada 1,000 impresiones: (Gasto / Impresiones) * 1000 (MXN)"
  }

  measure: cpa {
    label: "CPA (Costo por Adquisición)"
    type: number
    sql: SAFE_DIVIDE(${gasto}, ${conversiones}) ;;
    value_format_name: decimal_2
    group_label: "Métricas Calculadas"
    description: "Costo unitario por cada conversión: Gasto / Conversiones (MXN)"
  }

  measure: roas {
    label: "ROAS (Retorno de Inversión)"
    type: number
    sql: SAFE_DIVIDE(${valor_conversiones}, ${gasto}) ;;
    value_format_name: decimal_2
    group_label: "Métricas Calculadas"
    description: "Retorno sobre la inversión publicitaria: Valor Conversiones / Gasto"
  }

  measure: tasa_conversion {
    label: "Tasa de Conversión"
    type: number
    sql: SAFE_DIVIDE(${conversiones}, ${clics}) ;;
    value_format_name: percent_2
    group_label: "Métricas Calculadas"
    description: "Porcentaje de clics que generaron conversión: Conversiones / Clics"
  }

  measure: retencion_video {
    label: "Tasa de Retención de Video (100%)"
    type: number
    sql: SAFE_DIVIDE(${video_100}, ${reproducciones_video}) ;;
    value_format_name: percent_2
    group_label: "Métricas Calculadas"
    description: "Porcentaje de videos vistos en su totalidad: Video 100% / Reproducciones"
  }

  measure: count {
    label: "Cantidad de Registros Diarios"
    type: count
    description: "Total de filas diarias de métricas registradas"
  }
}

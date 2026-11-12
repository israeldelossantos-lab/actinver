view: sa_decision_impact {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.vw_decision_impact` ;;

  dimension: decision_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.decision_id ;;
    description: "Identificador de la decisión evaluada"
  }

  dimension_group: fecha_decision {
    label: "Fecha de Decisión"
    type: time
    timeframes: [raw, date, week, month, year]
    datatype: date
    sql: ${TABLE}.fecha_decision ;;
    description: "Fecha en que se tomó la decisión"
  }

  dimension: plataforma {
    label: "Plataforma"
    type: string
    sql: ${TABLE}.plataforma ;;
  }

  dimension: campana_nombre {
    label: "Campaña Afectada"
    type: string
    sql: ${TABLE}.campana_nombre ;;
    description: "Campaña específica evaluada o 'Plataforma completa'"
  }

  dimension: tipo_decision {
    label: "Tipo de Decisión"
    type: string
    sql: ${TABLE}.tipo_decision ;;
  }

  dimension: kpi_objetivo {
    label: "KPI Evaluado"
    type: string
    sql: ${TABLE}.kpi_objetivo ;;
  }

  dimension: cambio_esperado_pct {
    label: "Cambio Esperado (%)"
    type: number
    sql: ${TABLE}.cambio_esperado_pct ;;
    value_format_name: decimal_2
    description: "Meta porcentual de variación esperada"
  }

  dimension: valor_antes {
    label: "Valor KPI Antes"
    type: number
    sql: ${TABLE}.valor_antes ;;
    value_format_name: decimal_2
    description: "Valor promedio del KPI en la ventana anterior"
  }

  dimension: valor_despues {
    label: "Valor KPI Después"
    type: number
    sql: ${TABLE}.valor_despues ;;
    value_format_name: decimal_2
    description: "Valor promedio del KPI en la ventana posterior"
  }

  dimension: cambio_real_pct {
    label: "Cambio Real Obtenido (%)"
    type: number
    sql: ${TABLE}.cambio_real_pct ;;
    value_format_name: decimal_2
    description: "Variación porcentual real calculada en los datos"
  }

  dimension: se_cumplio {
    label: "¿Se Cumplió la Meta?"
    type: yesno
    sql: ${TABLE}.se_cumplio ;;
    description: "Verdadero si el cambio real satisfizo la meta esperada"
  }

  dimension: estado_cumplimiento {
    label: "Estado de Cumplimiento"
    type: string
    sql: CASE
      WHEN ${TABLE}.se_cumplio IS TRUE THEN 'Cumplida'
      WHEN ${TABLE}.se_cumplio IS FALSE THEN 'No cumplida'
      ELSE 'En medición'
    END ;;
    description: "Resultado de la evaluación: Cumplida, No cumplida o En medición"
  }

  # ============================================================================
  # MEDIDAS: Análisis de Cumplimiento de Hipótesis
  # ============================================================================

  measure: count {
    label: "Total Evaluaciones de Impacto"
    type: count
    description: "Cantidad de decisiones analizadas por la vista"
  }

  measure: count_cumplidas {
    label: "Decisiones con Meta Cumplida"
    type: count
    filters: [estado_cumplimiento: "Cumplida"]
    description: "Decisiones cuya variación real superó o igualó la meta"
  }

  measure: count_no_cumplidas {
    label: "Decisiones con Meta No Cumplida"
    type: count
    filters: [estado_cumplimiento: "No cumplida"]
    description: "Decisiones cuya variación real no alcanzó la meta"
  }

  measure: count_en_medicion {
    label: "Decisiones en Curso / Nulas"
    type: count
    filters: [estado_cumplimiento: "En medición"]
    description: "Decisiones recientes dentro de la ventana de medición"
  }

  measure: pct_exito_real {
    label: "Tasa de Éxito Real"
    type: number
    sql: SAFE_DIVIDE(${count_cumplidas}, NULLIF(${count_cumplidas} + ${count_no_cumplidas}, 0)) ;;
    value_format_name: percent_2
    description: "Porcentaje de decisiones con éxito sobre decisiones concluidas"
  }
}

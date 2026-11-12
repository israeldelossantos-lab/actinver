view: sa_decision_log {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.decision_log` ;;

  dimension: decision_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.decision_id ;;
    description: "Identificador único de la decisión de marketing"
  }

  dimension: campaign_id {
    type: number
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension_group: fecha_decision {
    label: "Fecha de Decisión"
    type: time
    timeframes: [raw, date, week, month, year]
    datatype: date
    sql: ${TABLE}.fecha_decision ;;
    description: "Fecha en que se formalizó la decisión"
  }

  dimension: junta {
    label: "Junta / Comité"
    type: string
    sql: ${TABLE}.junta ;;
    description: "Comité o contexto directivo de la decisión"
  }

  dimension: plataforma_codigo {
    label: "Código Plataforma"
    type: string
    sql: ${TABLE}.plataforma_codigo ;;
    description: "Plataforma impactada o todas"
  }

  dimension: tipo_decision {
    label: "Tipo de Decisión"
    type: string
    sql: ${TABLE}.tipo_decision ;;
    description: "Tipo de acción: subir_presupuesto, bajar_presupuesto, pausar, cambiar_creativo, etc."
  }

  dimension: descripcion {
    label: "Descripción de la Decisión"
    type: string
    sql: ${TABLE}.descripcion ;;
    description: "Detalle textual de la resolución tomada"
  }

  dimension: hipotesis {
    label: "Hipótesis de Negocio"
    type: string
    sql: ${TABLE}.hipotesis ;;
    description: "Resultado esperado y razonamiento de negocio"
  }

  dimension: kpi_objetivo {
    label: "KPI Objetivo"
    type: string
    sql: ${TABLE}.kpi_objetivo ;;
    description: "Métrica sobre la que se fijó el objetivo (cpa, roas, ctr, conversiones, etc.)"
  }

  dimension: cambio_esperado_pct {
    label: "Cambio Esperado (%)"
    type: number
    sql: ${TABLE}.cambio_esperado_pct ;;
    value_format_name: decimal_2
    description: "Variación porcentual esperada del KPI"
  }

  dimension: dias_medicion {
    label: "Ventana de Medición (Días)"
    type: number
    sql: ${TABLE}.dias_medicion ;;
    description: "Días de análisis antes y después de la fecha"
  }

  dimension: responsable {
    label: "Rol Responsable"
    type: string
    sql: ${TABLE}.responsable ;;
    description: "Rol asignado a la ejecución de la decisión"
  }

  dimension: estado {
    label: "Estado Declarado"
    type: string
    sql: ${TABLE}.estado ;;
    description: "Estado administrativo: cumplida, no_cumplida, pendiente"
  }

  dimension_group: creado_en {
    label: "Registro Decisión"
    type: time
    timeframes: [raw, time, date]
    datatype: timestamp
    sql: ${TABLE}.creado_en ;;
  }

  measure: count {
    label: "Total de Decisiones"
    type: count
    description: "Cantidad de decisiones registradas"
  }

  measure: total_cumplidas {
    label: "Decisiones Declaradas Cumplidas"
    type: count
    filters: [estado: "cumplida"]
    description: "Cantidad de decisiones marcadas como cumplidas en bitácora"
  }

  measure: pct_cumplidas {
    label: "% Decisiones Cumplidas (Declaradas)"
    type: number
    sql: SAFE_DIVIDE(${total_cumplidas}, ${count}) ;;
    value_format_name: percent_2
    description: "Proporción de decisiones marcadas como cumplidas"
  }
}

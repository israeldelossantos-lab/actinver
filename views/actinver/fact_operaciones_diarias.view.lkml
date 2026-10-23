view: fact_operaciones_diarias {
  sql_table_name: `vertex-ia-503623.actinver.fact_operaciones_diarias` ;;

  dimension: pk {
    primary_key: yes
    type: string
    sql: CAST(${TABLE}.fecha AS STRING) ;;
  }

  dimension_group: fecha {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Fecha"
    sql: ${TABLE}.fecha ;;
  }

  dimension: operaciones_procesadas {
    type: number
    label: "Operaciones Procesadas"
    sql: ${TABLE}.operaciones_procesadas ;;
  }

  dimension: operaciones_rechazadas {
    type: number
    label: "Operaciones Rechazadas"
    sql: ${TABLE}.operaciones_rechazadas ;;
  }

  dimension: operaciones_pendientes {
    type: number
    label: "Operaciones Pendientes"
    sql: ${TABLE}.operaciones_pendientes ;;
  }

  dimension: tiempo_promedio_resolucion_min {
    type: number
    label: "Tiempo Promedio de Resolución (min)"
    sql: ${TABLE}.tiempo_promedio_resolucion_min ;;
  }

  dimension: porcentaje_registros_con_error {
    type: number
    label: "Porcentaje de Registros con Error"
    value_format_name: percent_2
    sql: ${TABLE}.porcentaje_registros_con_error / 100.0 ;;
  }

  # ==============================================================================
  # MEDIDAS
  # ==============================================================================

  measure: count {
    type: count
    label: "Días Operativos"
    drill_fields: [fecha_date, operaciones_procesadas, operaciones_rechazadas]
  }

  measure: total_operaciones_procesadas {
    type: sum
    group_label: "Volumen Operativo"
    label: "Total de Operaciones Procesadas"
    value_format_name: decimal_0
    sql: ${operaciones_procesadas} ;;
  }

  measure: total_operaciones_rechazadas {
    type: sum
    group_label: "Volumen Operativo"
    label: "Total de Operaciones Rechazadas"
    value_format_name: decimal_0
    sql: ${operaciones_rechazadas} ;;
  }

  measure: total_operaciones_pendientes {
    type: sum
    group_label: "Volumen Operativo"
    label: "Total de Operaciones Pendientes"
    value_format_name: decimal_0
    sql: ${operaciones_pendientes} ;;
  }

  measure: tasa_rechazo_pct {
    type: number
    group_label: "Calidad y SLA"
    label: "Tasa de Rechazo"
    description: "Rechazadas / Procesadas"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_operaciones_rechazadas}, ${total_operaciones_procesadas}) ;;
  }

  measure: tasa_pendientes_pct {
    type: number
    group_label: "Calidad y SLA"
    label: "Tasa de Pendientes"
    description: "Pendientes / Procesadas"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_operaciones_pendientes}, ${total_operaciones_procesadas}) ;;
  }

  measure: tiempo_resolucion_ponderado_min {
    type: number
    group_label: "Calidad y SLA"
    label: "Tiempo de Resolución Ponderado (min)"
    description: "SUM(Tiempo * Procesadas) / SUM(Procesadas)"
    value_format: "0.0 \"min\""
    sql: SAFE_DIVIDE(SUM(${tiempo_promedio_resolucion_min} * ${operaciones_procesadas}), ${total_operaciones_procesadas}) ;;
  }

  measure: pct_error_ponderado {
    type: number
    group_label: "Calidad y SLA"
    label: "Porcentaje de Error Ponderado"
    description: "SUM(Error * Procesadas) / SUM(Procesadas)"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(SUM((${TABLE}.porcentaje_registros_con_error / 100.0) * ${operaciones_procesadas}), ${total_operaciones_procesadas}) ;;
  }

  measure: dias_fuera_sla_tiempo {
    type: count
    group_label: "Incidencias SLA"
    label: "Días Fuera de SLA (Tiempo > 60 min)"
    description: "Días con tiempo promedio de resolución mayor a 60 minutos"
    filters: [tiempo_promedio_resolucion_min: ">60"]
  }

  measure: dias_fuera_sla_error {
    type: count
    group_label: "Incidencias SLA"
    label: "Días Fuera de SLA (Error > 2%)"
    description: "Días con tasa de error de registros mayor a 2%"
    filters: [porcentaje_registros_con_error: ">0.02"]
  }
}

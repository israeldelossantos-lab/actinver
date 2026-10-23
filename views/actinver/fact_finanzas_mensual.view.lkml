view: fact_finanzas_mensual {
  sql_table_name: `vertex-ia-503623.actinver.fact_finanzas_mensual` ;;

  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.mes AS STRING), '_', ${TABLE}.area_negocio) ;;
  }

  dimension_group: mes {
    type: time
    timeframes: [raw, date, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Mes"
    sql: ${TABLE}.mes ;;
  }

  dimension: area_negocio {
    type: string
    label: "Área de Negocio"
    sql: ${TABLE}.area_negocio ;;
  }

  dimension: ingresos_mxn {
    type: number
    label: "Ingresos MXN"
    value_format_name: mxn_m
    sql: ${TABLE}.ingresos_mxn ;;
  }

  dimension: costos_mxn {
    type: number
    label: "Costos MXN"
    value_format_name: mxn_m
    sql: ${TABLE}.costos_mxn ;;
  }

  dimension: utilidad_operativa_mxn {
    type: number
    label: "Utilidad Operativa MXN"
    value_format_name: mxn_m
    sql: ${TABLE}.utilidad_operativa_mxn ;;
  }

  dimension: presupuesto_ingresos_mxn {
    type: number
    label: "Presupuesto de Ingresos MXN"
    value_format_name: mxn_m
    sql: ${TABLE}.presupuesto_ingresos_mxn ;;
  }

  dimension: bajo_presupuesto {
    type: yesno
    label: "Bajo Presupuesto"
    description: "Ingresos reales menores al presupuesto"
    sql: ${ingresos_mxn} < ${presupuesto_ingresos_mxn} ;;
  }

  # ==============================================================================
  # MEDIDAS
  # ==============================================================================

  measure: count {
    type: count
    label: "Total Registros"
    drill_fields: [mes_month, area_negocio, ingresos_mxn, utilidad_operativa_mxn]
  }

  measure: total_ingresos {
    type: sum
    group_label: "Finanzas"
    label: "Ingresos Totales MXN"
    value_format_name: mxn_m
    sql: ${ingresos_mxn} ;;
  }

  measure: total_costos {
    type: sum
    group_label: "Finanzas"
    label: "Costos Totales MXN"
    value_format_name: mxn_m
    sql: ${costos_mxn} ;;
  }

  measure: total_utilidad_operativa {
    type: sum
    group_label: "Finanzas"
    label: "Utilidad Operativa Total MXN"
    value_format_name: mxn_m
    sql: ${utilidad_operativa_mxn} ;;
  }

  measure: total_presupuesto_ingresos {
    type: sum
    group_label: "Presupuesto"
    label: "Presupuesto Total de Ingresos MXN"
    value_format_name: mxn_m
    sql: ${presupuesto_ingresos_mxn} ;;
  }

  measure: desviacion_presupuesto_mxn {
    type: number
    group_label: "Presupuesto"
    label: "Desviación vs Presupuesto MXN"
    description: "Ingresos Totales - Presupuesto Total"
    value_format_name: mxn_m
    sql: ${total_ingresos} - ${total_presupuesto_ingresos} ;;
  }

  measure: margen_operativo_pct {
    type: number
    group_label: "Ratios"
    label: "Margen Operativo"
    description: "Utilidad Operativa / Ingresos"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_utilidad_operativa}, ${total_ingresos}) ;;
  }

  measure: cumplimiento_presupuesto_pct {
    type: number
    group_label: "Presupuesto"
    label: "Cumplimiento de Presupuesto"
    description: "Ingresos / Presupuesto"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${total_ingresos}, ${total_presupuesto_ingresos}) ;;
  }

  measure: indice_eficiencia_pct {
    type: number
    group_label: "Ratios"
    label: "Índice de Eficiencia"
    description: "Costos / Ingresos (menor es mejor)"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${total_costos}, ${total_ingresos}) ;;
  }

  measure: areas_mes_bajo_presupuesto {
    type: count
    group_label: "Presupuesto"
    label: "Meses-Área Bajo Presupuesto"
    description: "Conteo de meses donde el área no alcanzó el presupuesto"
    filters: [bajo_presupuesto: "yes"]
  }
}

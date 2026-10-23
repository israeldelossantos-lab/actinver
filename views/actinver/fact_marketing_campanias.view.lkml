view: fact_marketing_campanias {
  sql_table_name: `vertex-ia-503623.actinver.fact_marketing_campanias` ;;

  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.mes AS STRING), '_', ${TABLE}.campania_id) ;;
  }

  dimension_group: mes {
    type: time
    timeframes: [raw, date, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Mes"
    sql: ${TABLE}.mes ;;
  }

  dimension: campania_id {
    type: string
    label: "ID de Campaña"
    sql: ${TABLE}.campania_id ;;
  }

  dimension: campania_nombre {
    type: string
    label: "Nombre de Campaña"
    sql: ${TABLE}.campania_nombre ;;
  }

  dimension: canal {
    type: string
    label: "Canal Digital"
    sql: ${TABLE}.canal ;;
  }

  dimension: inversion_mxn {
    type: number
    label: "Inversión MXN"
    value_format_name: mxn_m
    sql: ${TABLE}.inversion_mxn ;;
  }

  dimension: impresiones {
    type: number
    label: "Impresiones"
    sql: ${TABLE}.impresiones ;;
  }

  dimension: clics {
    type: number
    label: "Clics"
    sql: ${TABLE}.clics ;;
  }

  dimension: leads {
    type: number
    label: "Leads"
    sql: ${TABLE}.leads ;;
  }

  dimension: leads_calificados {
    type: number
    label: "Leads Calificados"
    sql: ${TABLE}.leads_calificados ;;
  }

  dimension: conversiones {
    type: number
    label: "Conversiones"
    sql: ${TABLE}.conversiones ;;
  }

  # ==============================================================================
  # MEDIDAS
  # ==============================================================================

  measure: count {
    type: count
    label: "Total Registros"
    drill_fields: [campania_id, campania_nombre, canal, inversion_mxn]
  }

  measure: total_inversion_mxn {
    type: sum
    group_label: "Inversión"
    label: "Inversión Total MXN"
    value_format_name: mxn_m
    sql: ${inversion_mxn} ;;
  }

  measure: total_impresiones {
    type: sum
    group_label: "Volumen"
    label: "Total de Impresiones"
    value_format_name: decimal_0
    sql: ${impresiones} ;;
  }

  measure: total_clics {
    type: sum
    group_label: "Volumen"
    label: "Total de Clics"
    value_format_name: decimal_0
    sql: ${clics} ;;
  }

  measure: total_leads {
    type: sum
    group_label: "Volumen"
    label: "Total de Leads"
    value_format_name: decimal_0
    sql: ${leads} ;;
  }

  measure: total_leads_calificados {
    type: sum
    group_label: "Volumen"
    label: "Total de Leads Calificados"
    value_format_name: decimal_0
    sql: ${leads_calificados} ;;
  }

  measure: total_conversiones {
    type: sum
    group_label: "Volumen"
    label: "Total de Conversiones"
    value_format_name: decimal_0
    sql: ${conversiones} ;;
  }

  measure: ctr_pct {
    type: number
    group_label: "Eficiencia de Embudo"
    label: "CTR (Click Through Rate)"
    description: "Clics / Impresiones"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_clics}, ${total_impresiones}) ;;
  }

  measure: tasa_lead_pct {
    type: number
    group_label: "Eficiencia de Embudo"
    label: "Tasa de Lead (Lead Rate)"
    description: "Leads / Clics"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_leads}, ${total_clics}) ;;
  }

  measure: tasa_calificacion_pct {
    type: number
    group_label: "Eficiencia de Embudo"
    label: "Tasa de Calificación de Leads"
    description: "Leads Calificados / Leads"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_leads_calificados}, ${total_leads}) ;;
  }

  measure: tasa_cierre_pct {
    type: number
    group_label: "Eficiencia de Embudo"
    label: "Tasa de Cierre de Leads Calificados"
    description: "Conversiones / Leads Calificados"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_conversiones}, ${total_leads_calificados}) ;;
  }

  measure: tasa_conversion_total_pct {
    type: number
    group_label: "Eficiencia de Embudo"
    label: "Tasa de Conversión Total"
    description: "Conversiones / Leads"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_conversiones}, ${total_leads}) ;;
  }

  measure: cpm {
    type: number
    group_label: "Costos Unitarios"
    label: "CPM MXN (Costo por Mil)"
    description: "(Inversión / Impresiones) * 1000"
    value_format_name: usd_0
    sql: SAFE_DIVIDE(${total_inversion_mxn}, ${total_impresiones}) * 1000.0 ;;
  }

  measure: cpc {
    type: number
    group_label: "Costos Unitarios"
    label: "CPC MXN (Costo por Clic)"
    description: "Inversión / Clics"
    value_format_name: usd_0
    sql: SAFE_DIVIDE(${total_inversion_mxn}, ${total_clics}) ;;
  }

  measure: cpl {
    type: number
    group_label: "Costos Unitarios"
    label: "CPL MXN (Costo por Lead)"
    description: "Inversión / Leads"
    value_format_name: usd_0
    sql: SAFE_DIVIDE(${total_inversion_mxn}, ${total_leads}) ;;
  }

  measure: costo_lead_calificado {
    type: number
    group_label: "Costos Unitarios"
    label: "Costo por Lead Calificado MXN"
    description: "Inversión / Leads Calificados"
    value_format_name: usd_0
    sql: SAFE_DIVIDE(${total_inversion_mxn}, ${total_leads_calificados}) ;;
  }

  measure: costo_por_adquisicion_cac {
    type: number
    group_label: "Costos Unitarios"
    label: "CAC MXN (Costo de Adquisición)"
    description: "Inversión / Conversiones"
    value_format_name: usd_0
    sql: SAFE_DIVIDE(${total_inversion_mxn}, ${total_conversiones}) ;;
  }
}

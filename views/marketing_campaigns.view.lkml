view: marketing_campaigns {
  sql_table_name: `claro_video.marketing_campaigns` ;;

  dimension: campaign_id {
    primary_key: yes
    type: string
    label: "ID de Campaña"
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    type: string
    label: "Nombre de Campaña"
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: channel {
    type: string
    label: "Canal Publicitario"
    sql: ${TABLE}.channel ;;
  }

  dimension_group: start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha de Inicio"
    sql: ${TABLE}.start_date ;;
  }

  dimension_group: end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha de Fin"
    sql: ${TABLE}.end_date ;;
  }

  dimension: budget_allocated {
    type: number
    label: "Presupuesto Asignado"
    value_format_name: usd_0
    sql: ${TABLE}.budget_allocated ;;
    required_access_grants: [ver_financiero]
  }

  dimension: amount_spent {
    type: number
    label: "Gasto Real"
    value_format_name: usd_0
    sql: ${TABLE}.amount_spent ;;
    required_access_grants: [ver_financiero]
  }

  dimension: impressions {
    type: number
    label: "Impresiones"
    sql: ${TABLE}.impressions ;;
  }

  dimension: clicks {
    type: number
    label: "Clics"
    sql: ${TABLE}.clicks ;;
  }

  dimension: conversions {
    type: number
    label: "Conversiones"
    sql: ${TABLE}.conversions ;;
  }

  dimension: revenue_generated {
    type: number
    label: "Ingresos Generados"
    value_format_name: usd_0
    sql: ${TABLE}.revenue_generated ;;
    required_access_grants: [ver_financiero]
  }

  # --- Security dimensions ---

  dimension: grupo_canal {
    type: string
    group_label: "Seguridad"
    label: "Grupo de Canal"
    description: "Agrupación de canales para control y análisis"
    case: {
      when: {
        sql: ${TABLE}.channel IN ('Facebook', 'Instagram', 'LinkedIn') ;;
        label: "Social"
      }
      when: {
        sql: ${TABLE}.channel = 'Google Ads' ;;
        label: "Performance"
      }
      when: {
        sql: ${TABLE}.channel = 'Email' ;;
        label: "Owned"
      }
      else: "Otros"
    }
  }

  # --- Derived dimensions ---

  dimension: campaign_type {
    type: string
    label: "Tipo de Campaña"
    description: "Categoría de campaña extraída antes del guion (e.g. Back to School, Summer Sale)"
    sql: TRIM(SPLIT(${TABLE}.campaign_name, ' - ')[SAFE_OFFSET(0)]) ;;
  }

  dimension: campaign_duration_days {
    type: number
    label: "Duración de Campaña (Días)"
    description: "Días entre la fecha de inicio y de fin"
    sql: DATE_DIFF(DATE(${TABLE}.end_date), DATE(${TABLE}.start_date), DAY) ;;
  }

  dimension: spend_status {
    type: string
    label: "Estatus de Presupuesto"
    description: "Subejercido (<=90%), En plan (90-100%), Sobregirado (>100%)"
    required_access_grants: [ver_financiero]
    case: {
      when: {
        sql: SAFE_DIVIDE(${amount_spent}, ${budget_allocated}) <= 0.90 ;;
        label: "Subejercido"
      }
      when: {
        sql: SAFE_DIVIDE(${amount_spent}, ${budget_allocated}) <= 1.00 ;;
        label: "En plan"
      }
      else: "Sobregirado"
    }
  }

  dimension: campaign_roas_value {
    type: number
    hidden: yes
    sql: SAFE_DIVIDE(${revenue_generated}, ${amount_spent}) ;;
    required_access_grants: [ver_financiero]
  }

  dimension: roas_tier {
    type: string
    label: "Nivel de ROAS"
    description: "Bajo (<2x), Medio (2-5x), Alto (>5x)"
    required_access_grants: [ver_financiero]
    case: {
      when: {
        sql: ${campaign_roas_value} < 2.0 ;;
        label: "Bajo (<2x)"
      }
      when: {
        sql: ${campaign_roas_value} <= 5.0 ;;
        label: "Medio (2-5x)"
      }
      else: "Alto (>5x)"
    }
  }

  # --- Base measures ---

  measure: count {
    type: count
    label: "Total Campañas"
    drill_fields: [campaign_id, campaign_name, channel, start_date, end_date]
  }

  measure: total_budget {
    type: sum
    group_label: "KPIs"
    label: "Presupuesto Asignado Total"
    description: "Suma del presupuesto aprobado para todas las campañas"
    value_format_name: usd_0
    sql: ${budget_allocated} ;;
    required_access_grants: [ver_financiero]
  }

  measure: total_spent {
    type: sum
    group_label: "KPIs"
    label: "Inversión Total (Gasto)"
    description: "Monto total ejercido en inversión publicitaria"
    value_format_name: usd_0
    sql: ${amount_spent} ;;
    required_access_grants: [ver_financiero]
  }

  measure: total_revenue {
    type: sum
    group_label: "KPIs"
    label: "Ingresos Generados Totales"
    description: "Ingresos comerciales atribuidos a las campañas de marketing"
    value_format_name: usd_0
    sql: ${revenue_generated} ;;
    required_access_grants: [ver_financiero]
  }

  measure: total_impressions {
    type: sum
    group_label: "Volumen"
    label: "Total Impresiones"
    description: "Suma de impactos o impresiones de anuncios"
    sql: ${impressions} ;;
  }

  measure: total_clicks {
    type: sum
    group_label: "Volumen"
    label: "Total Clics"
    description: "Suma de clics recibidos en los anuncios"
    sql: ${clicks} ;;
  }

  measure: total_conversions {
    type: sum
    group_label: "Volumen"
    label: "Total Conversiones"
    description: "Suma de conversiones y objetivos logrados"
    sql: ${conversions} ;;
  }

  measure: return_on_ad_spend {
    type: number
    group_label: "KPIs"
    label: "ROAS (Retorno sobre Gasto Publicitario)"
    description: "Ingresos generados divididos entre inversión total"
    value_format_name: decimal_2
    sql: SAFE_DIVIDE(${total_revenue}, ${total_spent}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: cost_per_click {
    type: number
    group_label: "Eficiencia"
    label: "Costo por Clic (CPC Promedio)"
    description: "Inversión total dividida entre el total de clics"
    value_format_name: usd
    sql: SAFE_DIVIDE(${total_spent}, ${total_clicks}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: conversion_rate_pct {
    type: number
    group_label: "Eficiencia"
    label: "Tasa de Conversión (%)"
    description: "Conversiones divididas entre el número de clics"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_conversions}, ${total_clicks}) ;;
  }

  # --- KPI measures ---

  measure: ctr_pct {
    type: number
    group_label: "Eficiencia"
    label: "Click-Through Rate (CTR %)"
    description: "Porcentaje de impresiones que resultaron en clics"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${total_clicks}, ${total_impressions}) ;;
  }

  measure: cpm {
    type: number
    group_label: "Eficiencia"
    label: "Costo por Mil Impresiones (CPM)"
    description: "Costo por cada mil impresiones publicitarias servidas"
    value_format_name: usd
    sql: SAFE_DIVIDE(${total_spent}, ${total_impressions}) * 1000.0 ;;
    required_access_grants: [ver_financiero]
  }

  measure: cost_per_acquisition {
    type: number
    group_label: "KPIs"
    label: "Costo por Adquisición (CPA)"
    description: "Inversión publicitaria total dividida entre conversiones totales"
    value_format_name: usd
    sql: SAFE_DIVIDE(${total_spent}, ${total_conversions}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: revenue_per_conversion {
    type: number
    group_label: "Eficiencia"
    label: "Ingreso Promedio por Conversión"
    description: "Ingresos totales divididos entre conversiones logradas"
    value_format_name: usd
    sql: SAFE_DIVIDE(${total_revenue}, ${total_conversions}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: roi_pct {
    type: number
    group_label: "KPIs"
    label: "ROI Neto (%)"
    description: "Utilidad neta de campaña sobre inversión publicitaria"
    value_format_name: percent_0
    sql: SAFE_DIVIDE(${total_revenue} - ${total_spent}, ${total_spent}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: budget_utilization_pct {
    type: number
    group_label: "Eficiencia"
    label: "Utilización de Presupuesto (%)"
    description: "Porcentaje del presupuesto asignado efectivamente ejercido"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${total_spent}, ${total_budget}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: overspent_campaigns {
    type: count
    group_label: "Riesgo"
    label: "Campañas Sobregiradas"
    description: "Número de campañas cuyo gasto superó el presupuesto asignado"
    filters: [spend_status: "Sobregirado"]
    required_access_grants: [ver_financiero]
  }

  measure: net_profit {
    type: number
    group_label: "KPIs"
    label: "Ganancia Neta ($)"
    description: "Ingresos generados menos inversión publicitaria total"
    value_format_name: usd_0
    sql: ${total_revenue} - ${total_spent} ;;
    required_access_grants: [ver_financiero]
  }
}

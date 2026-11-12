view: sa_fact_account_daily {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.fact_account_daily` ;;

  dimension: pk {
    primary_key: yes
    type: string
    hidden: yes
    sql: CONCAT(CAST(${TABLE}.date_key AS STRING), '_', CAST(${TABLE}.account_id AS STRING)) ;;
  }

  dimension: account_id {
    type: number
    hidden: yes
    sql: ${TABLE}.account_id ;;
  }

  dimension_group: fecha {
    label: "Fecha"
    type: time
    timeframes: [raw, date, week, month, quarter, year, day_of_week]
    datatype: date
    convert_tz: no
    sql: ${TABLE}.date_key ;;
    description: "Fecha de la métrica diaria de cuenta"
  }

  dimension: seguidores_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.followers ;;
  }

  # ============================================================================
  # MEDIDAS: Seguidores y Crecimiento
  # ============================================================================

  measure: seguidores {
    label: "Seguidores al Corte"
    type: max
    sql: ${TABLE}.followers ;;
    value_format_name: decimal_0
    group_label: "Seguidores y Crecimiento"
    description: "Cifra de seguidores al último corte o máximo del rango seleccionado"
  }

  measure: nuevos_seguidores {
    label: "Nuevos Seguidores Netos"
    type: sum
    sql: ${TABLE}.followers_delta ;;
    value_format_name: decimal_0
    group_label: "Seguidores y Crecimiento"
    description: "Variación neta acumulada de seguidores (followers_delta)"
  }

  # ============================================================================
  # MEDIDAS: Actividad de la Cuenta
  # ============================================================================

  measure: vistas_perfil {
    label: "Vistas del Perfil"
    type: sum
    sql: ${TABLE}.profile_views ;;
    value_format_name: decimal_0
    group_label: "Actividad de Cuenta"
    description: "Visualizaciones del perfil de la marca"
  }

  measure: impresiones_cuenta {
    label: "Impresiones de Cuenta"
    type: sum
    sql: ${TABLE}.impressions ;;
    value_format_name: decimal_0
    group_label: "Actividad de Cuenta"
    description: "Impresiones totales registradas a nivel cuenta"
  }

  measure: alcance_cuenta {
    label: "Alcance de Cuenta"
    type: sum
    sql: ${TABLE}.reach ;;
    value_format_name: decimal_0
    group_label: "Actividad de Cuenta"
    description: "Alcance de usuarios únicos a nivel cuenta"
  }

  measure: count {
    label: "Cantidad de Registros Diarios"
    type: count
    description: "Total de snapshots diarios de cuenta"
  }
}

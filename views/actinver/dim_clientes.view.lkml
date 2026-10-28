view: dim_clientes {
  sql_table_name: `vertex-ia-503623.actinver.dim_clientes` ;;

  dimension: cliente_id {
    primary_key: yes
    type: string
    label: "ID de Cliente"
    sql: ${TABLE}.cliente_id ;;
  }

  dimension: sucursal {
    type: string
    label: "Sucursal"
    sql: ${TABLE}.sucursal ;;
  }

  dimension: segmento {
    type: string
    label: "Segmento"
    sql: ${TABLE}.segmento ;;
  }

  dimension: region {
    type: string
    label: "Región"
    sql: ${TABLE}.region ;;
  }

  dimension_group: fecha_alta {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Alta"
    sql: ${TABLE}.fecha_alta ;;
  }

  dimension_group: fecha_baja {
    type: time
    timeframes: [raw, date, month, year]
    convert_tz: no
    datatype: date
    label: "Baja"
    sql: ${TABLE}.fecha_baja ;;
  }

  dimension: asesor_id {
    type: string
    label: "ID de Asesor"
    sql: ${TABLE}.asesor_id ;;
  }

  dimension: estatus_cliente {
    type: string
    label: "Estatus de Cliente"
    sql: ${TABLE}.estatus_cliente ;;
  }

  dimension: perfil_riesgo {
    type: string
    label: "Perfil de Riesgo"
    sql: ${TABLE}.perfil_riesgo ;;
  }

  dimension: nivel_riesgo {
    type: number
    label: "Nivel de Riesgo (1-3)"
    description: "Nivel numérico: Conservador 1, Moderado 2, Dinámico 3"
    sql: CASE ${perfil_riesgo}
      WHEN 'Conservador' THEN 1
      WHEN 'Moderado' THEN 2
      WHEN 'Dinámico' THEN 3
      ELSE 1
    END ;;
  }

  dimension: moneda_preferida {
    type: string
    label: "Moneda Preferida"
    sql: ${TABLE}.moneda_preferida ;;
  }

  dimension: antiguedad_anios {
    type: number
    label: "Antigüedad en Años"
    description: "Años transcurridos desde el alta hasta la baja o fecha actual"
    sql: DATE_DIFF(COALESCE(${TABLE}.fecha_baja, CURRENT_DATE()), ${TABLE}.fecha_alta, YEAR) ;;
  }

  dimension: tier_antiguedad {
    type: string
    label: "Tier de Antigüedad"
    description: "Clasificación de antigüedad del cliente"
    sql: CASE
      WHEN ${antiguedad_anios} < 1 THEN '<1 año'
      WHEN ${antiguedad_anios} BETWEEN 1 AND 2 THEN '1-3 años'
      WHEN ${antiguedad_anios} BETWEEN 3 AND 4 THEN '3-5 años'
      ELSE '5+ años'
    END ;;
  }

  measure: count {
    type: count
    label: "Total de Clientes"
    drill_fields: [cliente_id, segmento, region, estatus_cliente, perfil_riesgo]
  }

  measure: clientes_activos {
    type: count
    label: "Clientes Activos"
    description: "Clientes con estatus Activo"
    filters: [estatus_cliente: "Activo"]
  }

  measure: clientes_inactivos {
    type: count
    label: "Clientes Inactivos"
    description: "Clientes con estatus Inactivo"
    filters: [estatus_cliente: "Inactivo"]
  }

  # --- Hoja de ruta analítica ---
  measure: altas {
    type: count
    group_label: "Hoja de ruta"
    label: "Altas de Clientes"
    description: "Conteo de clientes dados de alta en el periodo"
    filters: [fecha_alta_date: "-null"]
  }

  measure: bajas {
    type: count
    group_label: "Hoja de ruta"
    label: "Bajas de Clientes"
    description: "Conteo de bajas expresado en negativo para barras comparativas"
    filters: [fecha_baja_date: "-null"]
  }

  measure: bajas_negativas {
    type: number
    group_label: "Hoja de ruta"
    label: "Bajas de Clientes (Gráfica)"
    description: "Conteo de bajas expresado en negativo para barras comparativas"
    sql: -1 * ${bajas} ;;
  }

  measure: clientes_netos {
    type: number
    group_label: "Hoja de ruta"
    label: "Clientes Netos"
    description: "Altas de clientes menos bajas de clientes"
    sql: ${altas} - ${bajas} ;;
  }

  measure: tasa_bajas_pct {
    type: number
    group_label: "Hoja de ruta"
    label: "Tasa de Bajas (%)"
    description: "Bajas divididas entre total de clientes activos"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${bajas}, ${clientes_activos}) ;;
  }
}

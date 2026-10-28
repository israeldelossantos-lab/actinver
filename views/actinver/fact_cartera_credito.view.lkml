view: fact_cartera_credito {
  sql_table_name: `vertex-ia-503623.actinver.fact_cartera_credito` ;;

  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.fecha_corte AS STRING), '_', ${TABLE}.credito_id) ;;
  }

  dimension_group: fecha_corte {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Fecha de Corte"
    sql: ${TABLE}.fecha_corte ;;
  }

  dimension: credito_id {
    type: string
    label: "ID de Crédito"
    sql: ${TABLE}.credito_id ;;
  }

  dimension: cliente_id {
    type: string
    label: "ID de Cliente"
    sql: ${TABLE}.cliente_id ;;
  }

  dimension: empresa_id {
    type: string
    label: "ID de Empresa"
    sql: ${TABLE}.empresa_id ;;
  }

  dimension: sucursal {
    type: string
    label: "Sucursal"
    sql: ${TABLE}.sucursal ;;
  }

  dimension: saldo_capital_mxn {
    type: number
    label: "Saldo Capital MXN"
    value_format_name: mxn_m
    sql: ${TABLE}.saldo_capital_mxn ;;
  }

  dimension: dias_atraso {
    type: number
    label: "Días de Atraso"
    sql: ${TABLE}.dias_atraso ;;
  }

  dimension: estatus_credito {
    type: string
    label: "Estatus del Crédito"
    sql: ${TABLE}.estatus_credito ;;
  }

  dimension: bucket_orden {
    type: number
    hidden: yes
    sql: CASE
      WHEN ${dias_atraso} = 0 THEN 0
      WHEN ${dias_atraso} BETWEEN 1 AND 30 THEN 1
      WHEN ${dias_atraso} BETWEEN 31 AND 60 THEN 2
      WHEN ${dias_atraso} BETWEEN 61 AND 90 THEN 3
      ELSE 4
    END ;;
  }

  dimension: bucket_mora {
    type: string
    label: "Tramo de Mora"
    order_by_field: bucket_orden
    sql: CASE
      WHEN ${dias_atraso} = 0 THEN 'Al corriente'
      WHEN ${dias_atraso} BETWEEN 1 AND 30 THEN '1-30'
      WHEN ${dias_atraso} BETWEEN 31 AND 60 THEN '31-60'
      WHEN ${dias_atraso} BETWEEN 61 AND 90 THEN '61-90'
      ELSE '90+'
    END ;;
  }

  dimension: es_ultimo_corte {
    type: yesno
    label: "Es Último Corte"
    description: "Indica si el registro pertenece a la fecha de corte más reciente"
    sql: ${TABLE}.fecha_corte = (SELECT MAX(fecha_corte) FROM `vertex-ia-503623.actinver.fact_cartera_credito`) ;;
  }

  # ==============================================================================
  # MEDIDAS
  # ==============================================================================

  measure: count {
    type: count
    label: "Registros de Cartera"
    drill_fields: [credito_id, cliente_id, fecha_corte_date, saldo_capital_mxn, estatus_credito]
  }

  measure: saldo_total_capital {
    type: sum
    group_label: "Saldos"
    label: "Saldo Total Capital MXN"
    description: "Usar con un solo corte. Suma de saldo capital"
    value_format_name: mxn_m
    sql: ${saldo_capital_mxn} ;;
  }

  measure: saldo_ultimo_corte {
    type: sum
    group_label: "Saldos"
    label: "Saldo de Cartera Último Corte MXN"
    description: "Saldo de capital filtrado automáticamente al corte más reciente"
    value_format_name: mxn_m
    sql: ${saldo_capital_mxn} ;;
    filters: [es_ultimo_corte: "yes"]
  }

  measure: saldo_vencido_total {
    type: sum
    group_label: "Saldos"
    label: "Saldo Vencido Total MXN (>0 días)"
    description: "Saldo capital con días de atraso mayor a 0"
    value_format_name: mxn_m
    sql: ${saldo_capital_mxn} ;;
    filters: [dias_atraso: ">0"]
  }

  measure: saldo_cartera_vencida {
    type: sum
    group_label: "Saldos"
    label: "Saldo vencido +90 días"
    description: "Saldo capital con mora mayor a 89 días"
    value_format_name: mxn_m
    sql: ${saldo_capital_mxn} ;;
    filters: [dias_atraso: ">89"]
  }

  measure: indice_morosidad_90_pct {
    type: number
    group_label: "Ratios"
    label: "Índice de Morosidad (+90 días)"
    description: "Saldo vencido +90 días / Saldo total"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${saldo_cartera_vencida}, ${saldo_total_capital}) ;;
  }

  measure: indice_cartera_vencida_pct {
    type: number
    group_label: "Ratios"
    label: "Índice de Cartera Vencida Total"
    description: "Saldo vencido total (>0 días) / Saldo total"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${saldo_vencido_total}, ${saldo_total_capital}) ;;
  }

  measure: creditos_vencidos {
    type: count_distinct
    group_label: "Conteos"
    label: "Créditos Vencidos"
    description: "Número de créditos con estatus Vencido"
    sql: ${credito_id} ;;
    filters: [estatus_credito: "Vencido"]
  }

  measure: creditos_90_mas {
    type: count_distinct
    group_label: "Conteos"
    label: "Créditos con Mora +90 días"
    description: "Número de créditos con más de 89 días de atraso"
    sql: ${credito_id} ;;
    filters: [dias_atraso: ">89"]
  }

  measure: promedio_dias_atraso {
    type: average
    group_label: "Promedios"
    label: "Promedio de Días de Atraso"
    value_format_name: decimal_1
    sql: ${dias_atraso} ;;
  }

  # --- Hoja de ruta analítica ---
  # Concentración al último corte: se calcula sobre el saldo agregado por empresa.
  # type: max envuelve la subconsulta escalar para que el resultado sea un solo valor por fila de la consulta.
  measure: pct_saldo_top10_empresas {
    type: max
    group_label: "Hoja de ruta"
    label: "Concentración Top 10 Empresas (%)"
    description: "Participación del saldo de las 10 mayores empresas al último corte"
    value_format_name: percent_1
    sql: (
      SELECT SUM(participacion) FROM (
        SELECT SAFE_DIVIDE(SUM(saldo_capital_mxn), SUM(SUM(saldo_capital_mxn)) OVER ()) AS participacion
        FROM `vertex-ia-503623.actinver.fact_cartera_credito`
        WHERE fecha_corte = (SELECT MAX(fecha_corte) FROM `vertex-ia-503623.actinver.fact_cartera_credito`)
        GROUP BY empresa_id
        ORDER BY participacion DESC
        LIMIT 10
      )
    ) ;;
  }

  measure: indice_herfindahl {
    type: max
    group_label: "Hoja de ruta"
    label: "Índice Herfindahl-Hirschman (HHI)"
    description: "Suma de participaciones al cuadrado por empresa al último corte, escala 0-10,000"
    value_format: "0"
    sql: (
      SELECT SUM(POWER(participacion * 100, 2)) FROM (
        SELECT SAFE_DIVIDE(SUM(saldo_capital_mxn), SUM(SUM(saldo_capital_mxn)) OVER ()) AS participacion
        FROM `vertex-ia-503623.actinver.fact_cartera_credito`
        WHERE fecha_corte = (SELECT MAX(fecha_corte) FROM `vertex-ia-503623.actinver.fact_cartera_credito`)
        GROUP BY empresa_id
      )
    ) ;;
  }
}

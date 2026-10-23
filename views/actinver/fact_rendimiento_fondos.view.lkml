view: fact_rendimiento_fondos {
  sql_table_name: `vertex-ia-503623.actinver.fact_rendimiento_fondos` ;;

  dimension: pk {
    primary_key: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.fecha AS STRING), '_', ${TABLE}.producto_id) ;;
  }

  dimension_group: fecha {
    type: time
    timeframes: [raw, date, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Fecha"
    sql: ${TABLE}.fecha ;;
  }

  dimension: producto_id {
    type: string
    label: "ID de Producto"
    sql: ${TABLE}.producto_id ;;
  }

  dimension: producto_nombre {
    type: string
    label: "Nombre de Fondo"
    sql: ${TABLE}.producto_nombre ;;
  }

  dimension: aum_mxn {
    type: number
    label: "AUM MXN"
    value_format_name: mxn_m
    sql: ${TABLE}.aum_mxn ;;
  }

  dimension: rendimiento_periodo_pct {
    type: number
    label: "Rendimiento del Periodo"
    value_format_name: percent_2
    sql: ${TABLE}.rendimiento_periodo_pct / 100.0 ;;
  }

  dimension: benchmark_periodo_pct {
    type: number
    label: "Benchmark del Periodo"
    value_format_name: percent_2
    sql: ${TABLE}.benchmark_periodo_pct / 100.0 ;;
  }

  dimension: alpha_pp {
    type: number
    label: "Alpha (pp)"
    description: "Exceso de rendimiento sobre benchmark en puntos porcentuales"
    value_format: "0.00 \"pp\""
    sql: (${rendimiento_periodo_pct} - ${benchmark_periodo_pct}) * 100.0 ;;
  }

  dimension: es_ultimo_corte {
    type: yesno
    label: "Es Último Corte"
    description: "Indica si el registro corresponde al mes más reciente"
    sql: ${TABLE}.fecha = (SELECT MAX(fecha) FROM `vertex-ia-503623.actinver.fact_rendimiento_fondos`) ;;
  }

  dimension: es_primer_corte {
    type: yesno
    label: "Es Primer Corte"
    description: "Indica si el registro corresponde al mes más antiguo"
    sql: ${TABLE}.fecha = (SELECT MIN(fecha) FROM `vertex-ia-503623.actinver.fact_rendimiento_fondos`) ;;
  }

  # ==============================================================================
  # MEDIDAS
  # ==============================================================================

  measure: count {
    type: count
    label: "Total Registros"
    drill_fields: [fecha_month, producto_id, producto_nombre, aum_mxn]
  }

  measure: total_aum_mxn {
    type: sum
    group_label: "AUM"
    label: "AUM Total MXN"
    description: "Usar con un solo corte. Suma de AUM"
    value_format_name: mxn_m
    sql: ${aum_mxn} ;;
  }

  measure: aum_ultimo_corte {
    type: sum
    group_label: "AUM"
    label: "AUM Último Corte MXN"
    description: "AUM del corte más reciente"
    value_format_name: mxn_m
    sql: ${aum_mxn} ;;
    filters: [es_ultimo_corte: "yes"]
  }

  measure: aum_primer_corte {
    type: sum
    group_label: "AUM"
    label: "AUM Primer Corte MXN"
    description: "AUM del primer corte disponible"
    value_format_name: mxn_m
    sql: ${aum_mxn} ;;
    filters: [es_primer_corte: "yes"]
  }

  measure: crecimiento_aum_pct {
    type: number
    group_label: "AUM"
    label: "Crecimiento de AUM"
    description: "(AUM Último / AUM Primer) - 1"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${aum_ultimo_corte}, ${aum_primer_corte}) - 1.0 ;;
  }

  measure: promedio_rendimiento_pct {
    type: average
    group_label: "Rendimientos"
    label: "Rendimiento Promedio Mensual"
    value_format_name: percent_2
    sql: ${rendimiento_periodo_pct} ;;
  }

  measure: promedio_benchmark_pct {
    type: average
    group_label: "Rendimientos"
    label: "Benchmark Promedio Mensual"
    value_format_name: percent_2
    sql: ${benchmark_periodo_pct} ;;
  }

  measure: alpha_promedio_pp {
    type: average
    group_label: "Rendimientos"
    label: "Alpha Promedio (pp)"
    description: "Promedio mensual de exceso sobre el benchmark en pp"
    value_format: "0.00 \"pp\""
    sql: ${alpha_pp} ;;
  }

  measure: meses_sobre_benchmark {
    type: count
    group_label: "Rendimientos"
    label: "Meses Sobre Benchmark"
    description: "Meses con Alpha positivo"
    filters: [alpha_pp: ">0"]
  }

  measure: pct_meses_sobre_benchmark {
    type: number
    group_label: "Rendimientos"
    label: "Porcentaje de Meses Sobre Benchmark"
    description: "Meses sobre benchmark / Total de meses evaluados"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${meses_sobre_benchmark}, ${count}) ;;
  }

  measure: volatilidad_pct {
    type: number
    group_label: "Riesgo"
    label: "Volatilidad del Fondo"
    description: "Desviación estándar muestral de rendimientos mensuales"
    value_format_name: percent_2
    sql: STDDEV_SAMP(${rendimiento_periodo_pct}) ;;
  }

  measure: rendimiento_ponderado_aum_pct {
    type: number
    group_label: "Rendimientos"
    label: "Rendimiento Ponderado por AUM"
    description: "Suma(AUM * Rendimiento) / Suma(AUM)"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(SUM(${aum_mxn} * ${rendimiento_periodo_pct}), SUM(${aum_mxn})) ;;
  }

  measure: rendimiento_acumulado_pct {
    type: number
    group_label: "Rendimientos"
    label: "Rendimiento Acumulado"
    description: "EXP(SUM(LN(1 + rendimiento))) - 1"
    value_format_name: percent_1
    sql: EXP(SUM(LN(1.0 + ${rendimiento_periodo_pct}))) - 1.0 ;;
  }

  # --- Hoja de ruta analítica ---
  measure: tracking_error_pp {
    type: number
    group_label: "Hoja de ruta"
    label: "Tracking Error (pp)"
    description: "Desviación estándar muestral del exceso de rendimiento (alpha) en pp"
    value_format: "0.00 \"pp\""
    sql: STDDEV_SAMP(${alpha_pp}) ;;
  }

  measure: ratio_informacion {
    type: number
    group_label: "Hoja de ruta"
    label: "Ratio de Información"
    description: "Alpha promedio dividido entre el tracking error (calidad de gestión activa)"
    value_format: "0.00"
    sql: SAFE_DIVIDE(${alpha_promedio_pp}, ${tracking_error_pp}) ;;
  }
}

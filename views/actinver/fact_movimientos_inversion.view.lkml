view: fact_movimientos_inversion {
  sql_table_name: `vertex-ia-503623.actinver.fact_movimientos_inversion` ;;

  dimension: movimiento_id {
    primary_key: yes
    type: string
    label: "ID de Movimiento"
    sql: ${TABLE}.movimiento_id ;;
  }

  dimension_group: fecha {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    label: "Fecha"
    sql: ${TABLE}.fecha ;;
  }

  dimension: cliente_id {
    type: string
    label: "ID de Cliente"
    sql: ${TABLE}.cliente_id ;;
  }

  dimension: asesor_id {
    type: string
    label: "ID de Asesor"
    sql: ${TABLE}.asesor_id ;;
  }

  dimension: producto_id {
    type: string
    label: "ID de Producto"
    sql: ${TABLE}.producto_id ;;
  }

  dimension: sucursal {
    type: string
    label: "Sucursal"
    sql: ${TABLE}.sucursal ;;
  }

  dimension: tipo_movimiento {
    type: string
    label: "Tipo de Movimiento"
    sql: ${TABLE}.tipo_movimiento ;;
  }

  dimension: monto_original {
    type: number
    label: "Monto Original"
    sql: ${TABLE}.monto_original ;;
  }

  dimension: moneda {
    type: string
    label: "Moneda"
    sql: ${TABLE}.moneda ;;
  }

  dimension: tipo_cambio_mxn {
    type: number
    label: "Tipo de Cambio a MXN"
    sql: ${TABLE}.tipo_cambio_mxn ;;
  }

  dimension: monto_equivalente_mxn {
    type: number
    value_format_name: mxn_m
    label: "Monto Equivalente MXN"
    sql: ${TABLE}.monto_equivalente_mxn ;;
  }

  dimension: estatus {
    type: string
    label: "Estatus"
    sql: ${TABLE}.estatus ;;
  }

  dimension: es_aplicado {
    type: yesno
    label: "Es Aplicado"
    description: "Indica si el movimiento tiene estatus Aplicado"
    sql: ${estatus} = 'Aplicado' ;;
  }

  dimension: es_captacion {
    type: yesno
    label: "Es Captación"
    description: "Movimientos aplicados de captación (excluye Rendimiento)"
    sql: ${es_aplicado} AND ${tipo_movimiento} != 'Rendimiento' ;;
  }

  dimension: sentido_flujo {
    type: string
    label: "Sentido del Flujo"
    description: "Entrada (>0) o Salida (<0)"
    sql: CASE WHEN ${monto_equivalente_mxn} >= 0 THEN 'Entrada' ELSE 'Salida' END ;;
  }

  dimension: excepcion_idoneidad {
    type: yesno
    label: "Excepción de Idoneidad"
    description: "Nivel de riesgo del producto superior al perfil de riesgo del cliente"
    sql: ${dim_productos.nivel_riesgo} > ${dim_clientes.nivel_riesgo} ;;
  }

  dimension: dias_pendiente {
    type: number
    group_label: "Hoja de ruta"
    label: "Días Pendiente"
    description: "Días transcurridos para movimientos pendientes calculados al corte"
    sql: CASE WHEN ${estatus} = 'Pendiente' THEN DATE_DIFF(DATE '2026-09-30', ${fecha_date}, DAY) ELSE NULL END ;;
  }

  dimension: tramo_antiguedad_pendiente {
    type: string
    group_label: "Hoja de ruta"
    label: "Tramo Antigüedad Pendiente"
    description: "Segmento de días de atraso en resolución de movimientos pendientes"
    sql: CASE
      WHEN ${dias_pendiente} IS NULL THEN NULL
      WHEN ${dias_pendiente} <= 2 THEN '0-2 días'
      WHEN ${dias_pendiente} <= 7 THEN '3-7 días'
      WHEN ${dias_pendiente} <= 15 THEN '8-15 días'
      ELSE '+15 días'
    END ;;
  }

  # ==============================================================================
  # MEDIDAS
  # ==============================================================================

  measure: count {
    type: count
    label: "Total de Movimientos"
    drill_fields: [movimiento_id, fecha_date, tipo_movimiento, monto_equivalente_mxn, estatus]
  }

  measure: captacion_neta_mxn {
    type: sum
    group_label: "Captación"
    label: "Captación Neta MXN"
    description: "Flujos netos aplicados excluyendo Rendimiento"
    value_format_name: mxn_m
    sql: ${monto_equivalente_mxn} ;;
    filters: [estatus: "Aplicado", tipo_movimiento: "-Rendimiento"]
  }

  measure: total_aportaciones_mxn {
    type: sum
    group_label: "Captación"
    label: "Total de Aportaciones MXN"
    description: "Suma de aportaciones aplicadas"
    value_format_name: mxn_m
    sql: ${monto_equivalente_mxn} ;;
    filters: [estatus: "Aplicado", tipo_movimiento: "Aportación"]
  }

  measure: total_retiros_mxn {
    type: sum
    group_label: "Captación"
    label: "Total de Retiros MXN (Negativo)"
    description: "Suma de retiros aplicados con signo negativo"
    value_format_name: mxn_m
    sql: ${monto_equivalente_mxn} ;;
    filters: [estatus: "Aplicado", tipo_movimiento: "Retiro"]
  }

  measure: total_retiros_abs_mxn {
    type: number
    group_label: "Captación"
    label: "Total de Retiros Absoluto MXN"
    description: "Valor absoluto de los retiros aplicados"
    value_format_name: mxn_m
    sql: -1.0 * ${total_retiros_mxn} ;;
  }

  measure: traspasos_netos_mxn {
    type: sum
    group_label: "Captación"
    label: "Traspasos Netos MXN"
    description: "Neto de traspasos de entrada y salida aplicados"
    value_format_name: mxn_m
    sql: ${monto_equivalente_mxn} ;;
    filters: [estatus: "Aplicado", tipo_movimiento: "Traspaso entrada,Traspaso salida"]
  }

  measure: rendimientos_pagados_mxn {
    type: sum
    group_label: "Rendimientos"
    label: "Rendimientos Pagados MXN"
    description: "Monto aplicado correspondiente a Rendimiento"
    value_format_name: mxn_m
    sql: ${monto_equivalente_mxn} ;;
    filters: [estatus: "Aplicado", tipo_movimiento: "Rendimiento"]
  }

  measure: tasa_retencion_pct {
    type: number
    group_label: "Captación"
    label: "Tasa de Retención"
    description: "1 - (Retiros Abs / Aportaciones)"
    value_format_name: percent_1
    sql: 1.0 - SAFE_DIVIDE(${total_retiros_abs_mxn}, ${total_aportaciones_mxn}) ;;
  }

  measure: movimientos_aplicados_count {
    type: count
    group_label: "Operaciones"
    label: "Movimientos Aplicados"
    filters: [estatus: "Aplicado"]
  }

  measure: clientes_con_movimiento {
    type: count_distinct
    group_label: "Clientes"
    label: "Clientes con Movimiento"
    description: "Clientes únicos con movimientos aplicados"
    sql: ${cliente_id} ;;
    filters: [estatus: "Aplicado"]
  }

  measure: num_aportaciones {
    type: count
    group_label: "Captación"
    label: "Número de Aportaciones"
    filters: [estatus: "Aplicado", tipo_movimiento: "Aportación"]
  }

  measure: ticket_promedio_aportacion {
    type: number
    group_label: "Captación"
    label: "Ticket Promedio de Aportación MXN"
    description: "Monto promedio por aportación aplicada"
    value_format_name: usd_0
    sql: SAFE_DIVIDE(${total_aportaciones_mxn}, ${num_aportaciones}) ;;
  }

  measure: movimientos_pendientes {
    type: count
    group_label: "Operaciones"
    label: "Movimientos Pendientes"
    filters: [estatus: "Pendiente"]
  }

  measure: movimientos_cancelados {
    type: count
    group_label: "Operaciones"
    label: "Movimientos Cancelados"
    filters: [estatus: "Cancelado"]
  }

  measure: monto_pendiente_mxn {
    type: sum
    group_label: "Operaciones"
    label: "Monto Pendiente MXN"
    description: "Suma de montos absolutos en estatus Pendiente"
    value_format_name: mxn_m
    sql: ABS(${monto_equivalente_mxn}) ;;
    filters: [estatus: "Pendiente"]
  }

  measure: meses_en_periodo {
    type: count_distinct
    group_label: "Metas"
    label: "Meses en Periodo"
    sql: ${fecha_month} ;;
  }

  measure: meta_captacion_periodo {
    type: number
    group_label: "Metas"
    label: "Meta de Captación del Periodo MXN"
    description: "Meta mensual agregada por el número de meses analizados"
    value_format_name: mxn_m
    sql: ${dim_asesores.total_meta_captacion} * ${meses_en_periodo} ;;
  }

  measure: cumplimiento_meta_pct {
    type: number
    group_label: "Metas"
    label: "Cumplimiento de Meta de Captación"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${captacion_neta_mxn}, ${meta_captacion_periodo}) ;;
  }

  measure: movimientos_fuera_perfil {
    type: count
    group_label: "Idoneidad"
    label: "Movimientos Fuera de Perfil"
    description: "Movimientos aplicados donde el producto excede el riesgo del cliente"
    filters: [estatus: "Aplicado", excepcion_idoneidad: "yes"]
  }

  measure: pct_fuera_perfil {
    type: number
    group_label: "Idoneidad"
    label: "Porcentaje Fuera de Perfil"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${movimientos_fuera_perfil}, ${movimientos_aplicados_count}) ;;
  }

  # --- Hoja de ruta analítica ---
  measure: captacion_por_cliente {
    type: number
    group_label: "Hoja de ruta"
    label: "Captación Neta por Cliente"
    description: "Captación neta promedio por cliente con movimiento en el periodo"
    value_format_name: mxn_m
    sql: SAFE_DIVIDE(${captacion_neta_mxn}, ${clientes_con_movimiento}) ;;
  }

  measure: clientes_por_asesor {
    type: number
    group_label: "Hoja de ruta"
    label: "Clientes por Asesor"
    description: "Promedio de clientes atendidos por asesor activo"
    value_format_name: decimal_1
    sql: SAFE_DIVIDE(${clientes_con_movimiento}, NULLIF(COUNT(DISTINCT ${asesor_id}), 0)) ;;
  }

  measure: pct_clientes_activos_90d {
    type: number
    group_label: "Hoja de ruta"
    label: "Clientes Activos Recientes (90d)"
    description: "Porcentaje de clientes con movimiento aplicado en los últimos 90 días"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(COUNT(DISTINCT CASE WHEN ${fecha_date} >= DATE '2026-07-01' AND ${estatus} = 'Aplicado' THEN ${cliente_id} END), ${clientes_con_movimiento}) ;;
  }

  measure: captacion_usd_mxn {
    type: sum
    group_label: "Hoja de ruta"
    label: "Captación USD (en MXN)"
    description: "Flujos netos en moneda USD convertidos a MXN"
    value_format_name: mxn_m
    sql: ${monto_equivalente_mxn} ;;
    filters: [estatus: "Aplicado", tipo_movimiento: "-Rendimiento", moneda: "USD"]
  }

  measure: pct_captacion_usd {
    type: number
    group_label: "Hoja de ruta"
    label: "Participación Captación USD (%)"
    description: "Captación neta en USD convertida a MXN dividida entre la captación neta total"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${captacion_usd_mxn}, ${captacion_neta_mxn}) ;;
  }
}

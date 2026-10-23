view: calidad_datos {
  derived_table: {
    sql:
      WITH reglas AS (
        SELECT 'R1' as regla_id, 'Cartera' as dominio, 'Crédito con >1 cliente_id o empresa_id entre cortes' as regla, 'Alta' as severidad,
          COUNT(DISTINCT credito_id) as registros_evaluados,
          COUNT(DISTINCT CASE WHEN clientes > 1 OR empresas > 1 THEN credito_id END) as registros_con_falla
        FROM (
          SELECT credito_id, COUNT(DISTINCT cliente_id) as clientes, COUNT(DISTINCT empresa_id) as empresas
          FROM `vertex-ia-503623.actinver.fact_cartera_credito`
          GROUP BY credito_id
        )
        UNION ALL
        SELECT 'R2', 'Movimientos', 'Fecha < fecha_alta del cliente', 'Alta',
          COUNT(*),
          COUNTIF(m.fecha < c.fecha_alta)
        FROM `vertex-ia-503623.actinver.fact_movimientos_inversion` m
        JOIN `vertex-ia-503623.actinver.dim_clientes` c ON m.cliente_id = c.cliente_id
        UNION ALL
        SELECT 'R3', 'Movimientos', 'Fecha > fecha_baja del cliente', 'Media',
          COUNTIF(c.fecha_baja IS NOT NULL),
          COUNTIF(c.fecha_baja IS NOT NULL AND m.fecha > c.fecha_baja)
        FROM `vertex-ia-503623.actinver.fact_movimientos_inversion` m
        JOIN `vertex-ia-503623.actinver.dim_clientes` c ON m.cliente_id = c.cliente_id
        UNION ALL
        SELECT 'R4', 'Idoneidad', 'Movimiento aplicado con producto de mayor riesgo que el perfil del cliente', 'Alta',
          COUNTIF(m.estatus = 'Aplicado'),
          COUNTIF(m.estatus = 'Aplicado' AND (
            CASE p.perfil_riesgo WHEN 'Conservador' THEN 1 WHEN 'Moderado' THEN 2 WHEN 'Dinámico' THEN 3 END >
            CASE c.perfil_riesgo WHEN 'Conservador' THEN 1 WHEN 'Moderado' THEN 2 WHEN 'Dinámico' THEN 3 END
          ))
        FROM `vertex-ia-503623.actinver.fact_movimientos_inversion` m
        JOIN `vertex-ia-503623.actinver.dim_clientes` c ON m.cliente_id = c.cliente_id
        JOIN `vertex-ia-503623.actinver.dim_productos` p ON m.producto_id = p.producto_id
        UNION ALL
        SELECT 'R5', 'Movimientos', 'Estatus Pendiente', 'Media',
          COUNT(*),
          COUNTIF(estatus = 'Pendiente')
        FROM `vertex-ia-503623.actinver.fact_movimientos_inversion`
        UNION ALL
        SELECT 'R6', 'Movimientos', 'Estatus Cancelado', 'Baja',
          COUNT(*),
          COUNTIF(estatus = 'Cancelado')
        FROM `vertex-ia-503623.actinver.fact_movimientos_inversion`
        UNION ALL
        SELECT 'R7', 'Movimientos', 'Cliente/asesor/producto inexistente', 'Alta',
          COUNT(*),
          COUNTIF(c.cliente_id IS NULL OR a.asesor_id IS NULL OR p.producto_id IS NULL)
        FROM `vertex-ia-503623.actinver.fact_movimientos_inversion` m
        LEFT JOIN `vertex-ia-503623.actinver.dim_clientes` c ON m.cliente_id = c.cliente_id
        LEFT JOIN `vertex-ia-503623.actinver.dim_asesores` a ON m.asesor_id = a.asesor_id
        LEFT JOIN `vertex-ia-503623.actinver.dim_productos` p ON m.producto_id = p.producto_id
        UNION ALL
        SELECT 'R8', 'Finanzas', '|Utilidad − (ingresos − costos)| > 1', 'Alta',
          COUNT(*),
          COUNTIF(ABS(utilidad_operativa_mxn - (ingresos_mxn - costos_mxn)) > 1)
        FROM `vertex-ia-503623.actinver.fact_finanzas_mensual`
        UNION ALL
        SELECT 'R9', 'Marketing', 'Embudo incoherente', 'Media',
          COUNT(*),
          COUNTIF(clics > impresiones OR leads > clics OR leads_calificados > leads OR conversiones > leads_calificados)
        FROM `vertex-ia-503623.actinver.fact_marketing_campanias`
        UNION ALL
        SELECT 'R10', 'Operaciones', 'Días faltantes en el calendario', 'Media',
          DATE_DIFF(DATE '2026-09-30', DATE '2025-01-01', DAY) + 1,
          (DATE_DIFF(DATE '2026-09-30', DATE '2025-01-01', DAY) + 1) - COUNT(DISTINCT fecha)
        FROM `vertex-ia-503623.actinver.fact_operaciones_diarias`
      )
      SELECT * FROM reglas
    ;;
  }

  dimension: regla_id {
    primary_key: yes
    type: string
    label: "ID de Regla"
    sql: ${TABLE}.regla_id ;;
  }

  dimension: dominio {
    type: string
    label: "Dominio"
    sql: ${TABLE}.dominio ;;
  }

  dimension: regla {
    type: string
    label: "Regla de Negocio"
    sql: ${TABLE}.regla ;;
  }

  dimension: severidad {
    type: string
    label: "Severidad"
    sql: ${TABLE}.severidad ;;
  }

  dimension: registros_evaluados {
    type: number
    label: "Registros Evaluados"
    sql: ${TABLE}.registros_evaluados ;;
  }

  dimension: registros_con_falla {
    type: number
    label: "Registros con Falla"
    sql: ${TABLE}.registros_con_falla ;;
  }

  dimension: estado_regla {
    type: string
    label: "Estado de la Regla"
    sql: CASE WHEN ${registros_con_falla} > 0 THEN 'Con falla' ELSE 'OK' END ;;
  }

  dimension: pct_falla {
    type: number
    label: "Porcentaje de Falla"
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${registros_con_falla}, ${registros_evaluados}) ;;
  }

  # ==============================================================================
  # MEDIDAS
  # ==============================================================================

  measure: total_reglas {
    type: count
    label: "Total de Reglas Evaluadas"
  }

  measure: reglas_con_falla {
    type: count
    label: "Reglas con Falla"
    filters: [registros_con_falla: ">0"]
  }

  measure: total_registros_evaluados {
    type: sum
    label: "Total Registros Evaluados"
    sql: ${registros_evaluados} ;;
  }

  measure: total_registros_con_falla {
    type: sum
    label: "Total Registros con Falla"
    sql: ${registros_con_falla} ;;
  }

  measure: indice_calidad_pct {
    type: number
    label: "Índice de Calidad Global"
    description: "1 - (Total con Falla / Total Evaluados)"
    value_format_name: percent_2
    sql: 1.0 - SAFE_DIVIDE(${total_registros_con_falla}, ${total_registros_evaluados}) ;;
  }
}

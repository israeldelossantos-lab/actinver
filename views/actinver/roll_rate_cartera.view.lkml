view: roll_rate_cartera {
  derived_table: {
    sql: WITH base AS (
        SELECT
          credito_id,
          fecha_corte,
          saldo_capital_mxn AS saldo,
          CASE
            WHEN dias_atraso = 0 THEN 'Al corriente'
            WHEN dias_atraso <= 30 THEN '1-30'
            WHEN dias_atraso <= 60 THEN '31-60'
            WHEN dias_atraso <= 90 THEN '61-90'
            ELSE '90+'
          END AS tramo_destino,
          CASE
            WHEN dias_atraso = 0 THEN 1
            WHEN dias_atraso <= 30 THEN 2
            WHEN dias_atraso <= 60 THEN 3
            WHEN dias_atraso <= 90 THEN 4
            ELSE 5
          END AS orden_destino,
          LAG(
            CASE
              WHEN dias_atraso = 0 THEN 'Al corriente'
              WHEN dias_atraso <= 30 THEN '1-30'
              WHEN dias_atraso <= 60 THEN '31-60'
              WHEN dias_atraso <= 90 THEN '61-90'
              ELSE '90+'
            END
          ) OVER (PARTITION BY credito_id ORDER BY fecha_corte) AS tramo_origen,
          LAG(
            CASE
              WHEN dias_atraso = 0 THEN 1
              WHEN dias_atraso <= 30 THEN 2
              WHEN dias_atraso <= 60 THEN 3
              WHEN dias_atraso <= 90 THEN 4
              ELSE 5
            END
          ) OVER (PARTITION BY credito_id ORDER BY fecha_corte) AS orden_origen
        FROM `vertex-ia-503623.actinver.fact_cartera_credito`
      ),
      trans AS (
        SELECT
          tramo_origen,
          tramo_destino,
          orden_origen,
          orden_destino,
          COUNT(*) AS creditos,  -- transiciones crédito-mes (antes COUNT(DISTINCT credito_id) contaba créditos)
          SUM(saldo) AS saldo
        FROM base
        WHERE tramo_origen IS NOT NULL
        GROUP BY 1, 2, 3, 4
      )
      SELECT
        CONCAT(tramo_origen, '_', tramo_destino) AS pk,
        tramo_origen,
        tramo_destino,
        orden_origen,
        orden_destino,
        creditos,
        saldo,
        SAFE_DIVIDE(creditos, SUM(creditos) OVER (PARTITION BY tramo_origen)) AS pct_transicion_raw
      FROM trans ;;
  }

  dimension: pk {
    primary_key: yes
    type: string
    hidden: yes
    sql: ${TABLE}.pk ;;
  }

  dimension: tramo_origen {
    type: string
    label: "Tramo Origen"
    order_by_field: orden_origen
    sql: ${TABLE}.tramo_origen ;;
  }

  dimension: orden_origen {
    type: number
    hidden: yes
    sql: ${TABLE}.orden_origen ;;
  }

  dimension: tramo_destino {
    type: string
    label: "Tramo Destino"
    order_by_field: orden_destino
    sql: ${TABLE}.tramo_destino ;;
  }

  dimension: orden_destino {
    type: number
    hidden: yes
    sql: ${TABLE}.orden_destino ;;
  }

  measure: creditos {
    type: sum
    group_label: "Hoja de ruta"
    label: "Transiciones"
    description: "Número de transiciones crédito-mes del tramo origen al tramo destino"
    sql: ${TABLE}.creditos ;;
  }

  measure: total_saldo_transicion {
    type: sum
    group_label: "Hoja de ruta"
    label: "Saldo en Transición MXN"
    description: "Suma de saldo involucrado en la transición"
    value_format_name: mxn_m
    sql: ${TABLE}.saldo ;;
  }

  measure: pct_transicion {
    type: max
    group_label: "Hoja de ruta"
    label: "Porcentaje de Transición (%)"
    description: "Proporción de créditos en destino vs créditos del tramo origen"
    value_format_name: percent_1
    sql: ${TABLE}.pct_transicion_raw ;;
  }
}

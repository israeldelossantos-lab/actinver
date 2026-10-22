view: e_commerce_orders {
  sql_table_name: `claro_video.e_commerce_orders` ;;

  dimension: order_id {
    primary_key: yes
    type: string
    label: "ID de Orden"
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: order {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha de Orden"
    sql: ${TABLE}.order_date ;;
  }

  dimension: customer_name {
    type: string
    label: "Cliente"
    tags: ["pii"]
    sql: ${TABLE}.customer_name ;;
    required_access_grants: [ver_pii_clientes]
  }

  dimension: region {
    type: string
    label: "Región"
    sql: ${TABLE}.region ;;
  }

  dimension: product_name {
    type: string
    label: "Producto"
    sql: ${TABLE}.product_name ;;
  }

  dimension: category {
    type: string
    label: "Categoría"
    sql: ${TABLE}.category ;;
  }

  dimension: quantity {
    type: number
    label: "Cantidad"
    sql: ${TABLE}.quantity ;;
  }

  dimension: unit_price {
    type: number
    label: "Precio Unitario"
    value_format_name: usd
    sql: ${TABLE}.unit_price ;;
  }

  dimension: discount_pct {
    type: number
    label: "Descuento Nominal (%)"
    description: "Porcentaje de descuento otorgado (0-25)"
    sql: ${TABLE}.discount_pct ;;
  }

  dimension: total_revenue {
    type: number
    label: "Ingreso Neto"
    value_format_name: usd
    sql: ${TABLE}.total_revenue ;;
  }

  dimension: profit {
    type: number
    label: "Utilidad Neta"
    value_format_name: usd
    sql: ${TABLE}.profit ;;
    required_access_grants: [ver_financiero]
  }

  dimension: ship_mode {
    type: string
    label: "Método de Envío"
    sql: ${TABLE}.ship_mode ;;
  }

  # --- Security dimensions ---

  dimension: linea_negocio {
    type: string
    group_label: "Seguridad"
    label: "Línea de Negocio"
    description: "Línea de negocio normalizada para control de acceso"
    case: {
      when: {
        sql: ${TABLE}.category = 'Electronics' ;;
        label: "Tecnologia"
      }
      when: {
        sql: ${TABLE}.category = 'Beauty' ;;
        label: "Cuidado Personal"
      }
      when: {
        sql: ${TABLE}.category = 'Sports' ;;
        label: "Deportes"
      }
      when: {
        sql: ${TABLE}.category = 'Home' ;;
        label: "Hogar"
      }
      when: {
        sql: ${TABLE}.category = 'Clothing' ;;
        label: "Moda"
      }
      else: "Otros"
    }
  }

  # --- Derived dimensions ---

  dimension: discount_band {
    type: string
    label: "Rango de Descuento"
    description: "Clasificación de descuento: Sin descuento (0), Bajo (5-10), Medio (15-20), Alto (25)"
    case: {
      when: {
        sql: ${discount_pct} = 0 ;;
        label: "Sin descuento"
      }
      when: {
        sql: ${discount_pct} <= 10 ;;
        label: "Bajo (5-10%)"
      }
      when: {
        sql: ${discount_pct} <= 20 ;;
        label: "Medio (15-20%)"
      }
      else: "Alto (25%)"
    }
  }

  dimension: order_size {
    type: string
    label: "Tamaño de Orden"
    description: "Unitaria (1), Media (2-3), Grande (4-5)"
    case: {
      when: {
        sql: ${quantity} = 1 ;;
        label: "Unitaria (1)"
      }
      when: {
        sql: ${quantity} <= 3 ;;
        label: "Media (2-3)"
      }
      else: "Grande (4-5)"
    }
  }

  # --- Base measures ---

  measure: count {
    type: count
    label: "Total Órdenes"
    drill_fields: [order_id, region, category, product_name, total_revenue_sum]
  }

  measure: total_revenue_sum {
    type: sum
    group_label: "KPIs"
    label: "Venta Total Neta"
    description: "Suma de los ingresos netos de todas las órdenes"
    value_format_name: usd_0
    sql: ${total_revenue} ;;
  }

  measure: total_profit_sum {
    type: sum
    group_label: "KPIs"
    label: "Utilidad Total"
    description: "Suma de la utilidad generada en todas las órdenes"
    value_format_name: usd_0
    sql: ${profit} ;;
    required_access_grants: [ver_financiero]
  }

  measure: total_units_sold {
    type: sum
    group_label: "Volumen"
    label: "Unidades Vendidas"
    description: "Suma total de piezas vendidas"
    sql: ${quantity} ;;
  }

  measure: profit_margin_pct {
    type: number
    group_label: "Eficiencia"
    label: "Margen de Utilidad (%)"
    description: "Porcentaje de utilidad sobre la venta neta"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${total_profit_sum}, ${total_revenue_sum}) ;;
    required_access_grants: [ver_financiero]
  }

  # --- KPI measures ---

  measure: average_order_value {
    type: number
    group_label: "KPIs"
    label: "Ticket Promedio (AOV)"
    description: "Venta total neta dividida entre el número de órdenes"
    value_format_name: usd
    sql: SAFE_DIVIDE(${total_revenue_sum}, ${count}) ;;
  }

  measure: unique_customers {
    type: count_distinct
    group_label: "Volumen"
    label: "Clientes Únicos"
    description: "Conteo único de clientes compradores"
    sql: ${customer_name} ;;
    required_access_grants: [ver_pii_clientes]
  }

  measure: orders_per_customer {
    type: number
    group_label: "Eficiencia"
    label: "Órdenes por Cliente"
    description: "Promedio de compras realizadas por cliente único"
    value_format_name: decimal_2
    sql: SAFE_DIVIDE(${count}, ${unique_customers}) ;;
    required_access_grants: [ver_pii_clientes]
  }

  measure: gross_sales_before_discount {
    type: sum
    group_label: "KPIs"
    label: "Venta Bruta (Antes de Descuento)"
    description: "Suma de cantidad vendida multiplicada por precio de lista"
    value_format_name: usd_0
    sql: ${quantity} * ${unit_price} ;;
  }

  measure: discount_amount {
    type: number
    group_label: "KPIs"
    label: "Monto Total de Descuento ($)"
    description: "Diferencia entre venta bruta y venta neta efectivamente cobrada"
    value_format_name: usd_0
    sql: ${gross_sales_before_discount} - ${total_revenue_sum} ;;
  }

  measure: effective_discount_pct {
    type: number
    group_label: "Eficiencia"
    label: "Descuento Efectivo (%)"
    description: "Monto de descuento dividido entre la venta bruta"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${discount_amount}, ${gross_sales_before_discount}) ;;
  }

  measure: profit_per_order {
    type: number
    group_label: "Eficiencia"
    label: "Utilidad Promedio por Orden"
    description: "Utilidad total dividida entre número de órdenes"
    value_format_name: usd
    sql: SAFE_DIVIDE(${total_profit_sum}, ${count}) ;;
    required_access_grants: [ver_financiero]
  }
}

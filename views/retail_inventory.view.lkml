view: retail_inventory {
  sql_table_name: `claro_video.retail_inventory` ;;

  dimension: product_id {
    primary_key: yes
    type: string
    label: "ID de Producto"
    sql: ${TABLE}.product_id ;;
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

  dimension: supplier_name {
    type: string
    label: "Proveedor"
    sql: ${TABLE}.supplier_name ;;
  }

  dimension: unit_cost {
    type: number
    label: "Costo Unitario"
    value_format_name: usd
    sql: ${TABLE}.unit_cost ;;
    required_access_grants: [ver_financiero]
  }

  dimension: retail_price {
    type: number
    label: "Precio de Venta"
    value_format_name: usd
    sql: ${TABLE}.retail_price ;;
  }

  dimension: opening_stock {
    type: number
    label: "Stock Inicial"
    sql: ${TABLE}.opening_stock ;;
  }

  dimension: units_sold {
    type: number
    label: "Unidades Vendidas"
    sql: ${TABLE}.units_sold ;;
  }

  dimension: closing_stock {
    type: number
    label: "Stock Final"
    sql: ${TABLE}.closing_stock ;;
  }

  dimension: reorder_point {
    type: number
    label: "Punto de Reorden"
    sql: ${TABLE}.reorder_point ;;
  }

  dimension: stock_status {
    type: string
    label: "Estatus de Stock"
    sql: ${TABLE}.stock_status ;;
  }

  # --- Security dimensions ---

  dimension: linea_negocio {
    type: string
    group_label: "Seguridad"
    label: "Línea de Negocio"
    description: "Línea de negocio normalizada para control de acceso"
    case: {
      when: {
        sql: ${TABLE}.category IN ('Electronics', 'Office Supplies') ;;
        label: "Tecnologia"
      }
      when: {
        sql: ${TABLE}.category = 'Beauty' ;;
        label: "Cuidado Personal"
      }
      when: {
        sql: ${TABLE}.category = 'Sports & Outdoors' ;;
        label: "Deportes"
      }
      when: {
        sql: ${TABLE}.category = 'Home & Kitchen' ;;
        label: "Hogar"
      }
      when: {
        sql: ${TABLE}.category = 'Clothing' ;;
        label: "Moda"
      }
      when: {
        sql: ${TABLE}.category IN ('Grocery', 'Toys & Games') ;;
        label: "Consumo"
      }
      else: "Otros"
    }
  }

  # --- Derived dimensions ---

  dimension: unit_margin_pct {
    type: number
    label: "Margen Unitario %"
    description: "Margen de ganancia porcentual por unidad"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${retail_price} - ${unit_cost}, ${retail_price}) ;;
    required_access_grants: [ver_financiero]
  }

  dimension: margin_tier {
    type: string
    label: "Nivel de Margen"
    description: "Clasificación de margen: Bajo (<30%), Medio (30-50%), Alto (>50%)"
    required_access_grants: [ver_financiero]
    case: {
      when: {
        sql: ${unit_margin_pct} < 0.30 ;;
        label: "Bajo"
      }
      when: {
        sql: ${unit_margin_pct} <= 0.50 ;;
        label: "Medio"
      }
      else: "Alto"
    }
  }

  dimension: stock_cover_ratio {
    type: number
    label: "Ratio de Cobertura de Stock"
    description: "Proporción de stock final vs punto de reorden"
    value_format_name: decimal_2
    sql: SAFE_DIVIDE(${closing_stock}, ${reorder_point}) ;;
  }

  dimension: stock_cover_bucket {
    type: string
    label: "Semáforo de Cobertura"
    description: "Estado de inventario: Reordenar (<=1), Vigilar (1-2), Saludable (>2)"
    case: {
      when: {
        sql: ${stock_cover_ratio} <= 1.0 ;;
        label: "Reordenar"
      }
      when: {
        sql: ${stock_cover_ratio} <= 2.0 ;;
        label: "Vigilar"
      }
      else: "Saludable"
    }
  }

  # --- Base measures ---

  measure: count {
    type: count
    label: "Total SKUs"
    drill_fields: [product_id, product_name, category, supplier_name]
  }

  measure: total_units_sold {
    type: sum
    group_label: "Volumen"
    label: "Total Unidades Vendidas"
    description: "Suma de unidades vendidas de todos los SKUs"
    sql: ${units_sold} ;;
  }

  measure: total_opening_stock {
    type: sum
    group_label: "Volumen"
    label: "Total Stock Inicial"
    description: "Suma de stock inicial"
    sql: ${opening_stock} ;;
  }

  measure: total_closing_stock {
    type: sum
    group_label: "Volumen"
    label: "Total Stock Final"
    description: "Suma de stock final disponible"
    sql: ${closing_stock} ;;
  }

  measure: total_sales_revenue {
    type: sum
    group_label: "KPIs"
    label: "Venta Total"
    description: "Ingresos totales por venta de unidades a precio retail"
    value_format_name: usd_0
    sql: ${units_sold} * ${retail_price} ;;
  }

  measure: total_inventory_cost_value {
    type: sum
    group_label: "KPIs"
    label: "Valor Inventario a Costo"
    description: "Valorización del stock final al costo unitario"
    value_format_name: usd_0
    sql: ${closing_stock} * ${unit_cost} ;;
    required_access_grants: [ver_financiero]
  }

  # --- KPI measures ---

  measure: total_cost_of_goods_sold {
    type: sum
    group_label: "KPIs"
    label: "Costo Total de Ventas (COGS)"
    description: "Costo total de las unidades vendidas"
    value_format_name: usd_0
    sql: ${units_sold} * ${unit_cost} ;;
    required_access_grants: [ver_financiero]
  }

  measure: gross_profit {
    type: number
    group_label: "KPIs"
    label: "Margen Bruto ($)"
    description: "Venta total menos costo total de los bienes vendidos"
    value_format_name: usd_0
    sql: ${total_sales_revenue} - ${total_cost_of_goods_sold} ;;
    required_access_grants: [ver_financiero]
  }

  measure: gross_margin_pct {
    type: number
    group_label: "Eficiencia"
    label: "Margen Bruto (%)"
    description: "Porcentaje de utilidad bruta sobre la venta total"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${gross_profit}, ${total_sales_revenue}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: sell_through_pct {
    type: number
    group_label: "Eficiencia"
    label: "Sell-Through (%)"
    description: "Porcentaje de stock vendido respecto al stock inicial"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${total_units_sold}, ${total_opening_stock}) ;;
  }

  measure: inventory_retail_value {
    type: sum
    group_label: "Volumen"
    label: "Valor Inventario a Precio Venta"
    description: "Valorización del stock final a precio minorista"
    value_format_name: usd_0
    sql: ${closing_stock} * ${retail_price} ;;
  }

  measure: low_stock_skus {
    type: count
    group_label: "Riesgo"
    label: "SKUs en Bajo Stock"
    description: "Cantidad de productos con estatus Low Stock"
    filters: [stock_status: "Low Stock"]
  }

  measure: low_stock_pct {
    type: number
    group_label: "Riesgo"
    label: "% SKUs en Bajo Stock"
    description: "Porcentaje de productos en bajo stock respecto al total"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${low_stock_skus}, ${count}) ;;
  }

  measure: avg_markup_pct {
    type: average
    group_label: "Eficiencia"
    label: "Markup Promedio (%)"
    description: "Porcentaje promedio de incremento de precio sobre costo"
    value_format_name: percent_0
    sql: SAFE_DIVIDE(${retail_price} - ${unit_cost}, ${unit_cost}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: units_below_reorder {
    type: sum
    group_label: "Riesgo"
    label: "Unidades Faltantes para Reorden"
    description: "Cantidad de unidades requeridas para alcanzar el punto de reorden"
    sql: GREATEST(${reorder_point} - ${closing_stock}, 0) ;;
  }
}

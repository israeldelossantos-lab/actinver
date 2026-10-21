view: retail_inventory {
  sql_table_name: `claro_video.retail_inventory` ;;

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: closing_stock {
    type: number
    sql: ${TABLE}.closing_stock ;;
  }
  dimension: opening_stock {
    type: number
    sql: ${TABLE}.opening_stock ;;
  }
  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }
  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }
  dimension: reorder_point {
    type: number
    sql: ${TABLE}.reorder_point ;;
  }
  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }
  dimension: stock_status {
    type: string
    sql: ${TABLE}.stock_status ;;
  }
  dimension: supplier_name {
    type: string
    sql: ${TABLE}.supplier_name ;;
  }
  dimension: unit_cost {
    type: number
    sql: ${TABLE}.unit_cost ;;
  }
  dimension: units_sold {
    type: number
    sql: ${TABLE}.units_sold ;;
  }
  measure: count {
    type: count
    drill_fields: [supplier_name, product_name]
  }
}

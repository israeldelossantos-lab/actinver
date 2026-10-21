view: e_commerce_orders {
  sql_table_name: `claro_video.e_commerce_orders` ;;

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: customer_name {
    type: string
    sql: ${TABLE}.customer_name ;;
  }
  dimension: discount_pct {
    type: number
    sql: ${TABLE}.discount_pct ;;
  }
  dimension_group: order {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.order_date ;;
  }
  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }
  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }
  dimension: profit {
    type: number
    sql: ${TABLE}.profit ;;
  }
  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }
  dimension: ship_mode {
    type: string
    sql: ${TABLE}.ship_mode ;;
  }
  dimension: total_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
  }
  dimension: unit_price {
    type: number
    sql: ${TABLE}.unit_price ;;
  }
  measure: count {
    type: count
    drill_fields: [customer_name, product_name]
  }
}

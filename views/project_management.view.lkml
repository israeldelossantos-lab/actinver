view: project_management {
  sql_table_name: `claro_video.project_management` ;;

  dimension: actual_cost {
    type: number
    sql: ${TABLE}.actual_cost ;;
  }
  dimension_group: actual_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.actual_end_date ;;
  }
  dimension: assigned_to {
    type: string
    sql: ${TABLE}.assigned_to ;;
  }
  dimension: pct_complete {
    type: number
    sql: ${TABLE}.pct_complete ;;
  }
  dimension: planned_budget {
    type: number
    sql: ${TABLE}.planned_budget ;;
  }
  dimension_group: planned_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.planned_end_date ;;
  }
  dimension_group: planned_start {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.planned_start_date ;;
  }
  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
  }
  dimension: project_name {
    type: string
    sql: ${TABLE}.project_name ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: task_name {
    type: string
    sql: ${TABLE}.task_name ;;
  }
  measure: count {
    type: count
    drill_fields: [task_name, project_name]
  }
}

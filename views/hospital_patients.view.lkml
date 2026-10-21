view: hospital_patients {
  sql_table_name: `claro_video.hospital_patients` ;;

  dimension_group: admission {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.admission_date ;;
  }
  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: diagnosis {
    type: string
    sql: ${TABLE}.diagnosis ;;
  }
  dimension_group: discharge {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.discharge_date ;;
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
  dimension: insurance_coverage_pct {
    type: number
    sql: ${TABLE}.insurance_coverage_pct ;;
  }
  dimension: patient_id {
    type: string
    sql: ${TABLE}.patient_id ;;
  }
  dimension: patient_name {
    type: string
    sql: ${TABLE}.patient_name ;;
  }
  dimension: payment_status {
    type: string
    sql: ${TABLE}.payment_status ;;
  }
  dimension: total_bill_amount {
    type: number
    sql: ${TABLE}.total_bill_amount ;;
  }
  measure: count {
    type: count
    drill_fields: [patient_name]
  }
}

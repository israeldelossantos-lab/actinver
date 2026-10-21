view: social_media_analytics {
  sql_table_name: `claro_video.social_media_analytics` ;;

  dimension: comments {
    type: number
    sql: ${TABLE}.comments ;;
  }
  dimension: content_type {
    type: string
    sql: ${TABLE}.content_type ;;
  }
  dimension: engagement_rate_pct {
    type: number
    sql: ${TABLE}.engagement_rate_pct ;;
  }
  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }
  dimension: likes {
    type: number
    sql: ${TABLE}.likes ;;
  }
  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension_group: post {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.post_date ;;
  }
  dimension: post_id {
    type: string
    sql: ${TABLE}.post_id ;;
  }
  dimension: reach {
    type: number
    sql: ${TABLE}.reach ;;
  }
  dimension: shares {
    type: number
    sql: ${TABLE}.shares ;;
  }
  measure: count {
    type: count
  }
}

view: dim_asesores {
  sql_table_name: `vertex-ia-503623.actinver.dim_asesores` ;;

  dimension: asesor_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.asesor_id ;;
  }

  dimension: asesor_nombre {
    type: string
    sql: ${TABLE}.asesor_nombre ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: sucursal {
    type: string
    sql: ${TABLE}.sucursal ;;
  }

  dimension: meta_captacion_mensual_mxn {
    type: number
    value_format_name: usd_0
    sql: ${TABLE}.meta_captacion_mensual_mxn ;;
  }

  measure: count {
    type: count
    drill_fields: [asesor_id, asesor_nombre, region, sucursal]
  }

  measure: total_meta_captacion {
    type: sum
    value_format_name: usd_0
    sql: ${meta_captacion_mensual_mxn} ;;
  }
}

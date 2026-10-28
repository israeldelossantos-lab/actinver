view: dim_sucursales {
  sql_table_name: `vertex-ia-503623.actinver.dim_sucursales` ;;

  dimension: sucursal {
    primary_key: yes
    type: string
    label: "Sucursal"
    sql: ${TABLE}.sucursal ;;
  }
  dimension: sucursal_nombre {
    type: string
    label: "Nombre de Sucursal"
    sql: ${TABLE}.sucursal_nombre ;;
  }
  dimension: ciudad {
    type: string
    sql: ${TABLE}.ciudad ;;
  }
  dimension: estado {
    type: string
    label: "Estado"
    sql: ${TABLE}.estado ;;
  }
  dimension: estado_codigo {
    type: string
    label: "Código de Estado (ISO)"
    sql: ${TABLE}.estado_codigo ;;
  }
  dimension: region {
    type: string
    label: "Región (Sucursal)"
    sql: ${TABLE}.region ;;
  }
  dimension: latitud {
    type: number
    hidden: yes
    sql: ${TABLE}.latitud ;;
  }
  dimension: longitud {
    type: number
    hidden: yes
    sql: ${TABLE}.longitud ;;
  }
  dimension: ubicacion {
    type: location
    label: "Ubicación"
    sql_latitude: ${latitud} ;;
    sql_longitude: ${longitud} ;;
  }
  measure: count {
    type: count
    label: "Número de Sucursales"
    drill_fields: [sucursal, sucursal_nombre, ciudad, estado, region]
  }
}

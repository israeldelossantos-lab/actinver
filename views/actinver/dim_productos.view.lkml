view: dim_productos {
  sql_table_name: `vertex-ia-503623.actinver.dim_productos` ;;

  dimension: producto_id {
    primary_key: yes
    type: string
    label: "ID de Producto"
    sql: ${TABLE}.producto_id ;;
  }

  dimension: producto_nombre {
    type: string
    label: "Nombre de Producto"
    sql: ${TABLE}.producto_nombre ;;
  }

  dimension: categoria {
    type: string
    label: "Categoría"
    sql: ${TABLE}.categoria ;;
  }

  dimension: perfil_riesgo {
    type: string
    label: "Perfil de Riesgo"
    sql: ${TABLE}.perfil_riesgo ;;
  }

  dimension: nivel_riesgo {
    type: number
    label: "Nivel de Riesgo (1-3)"
    description: "Nivel numérico: Conservador 1, Moderado 2, Dinámico 3"
    sql: CASE ${perfil_riesgo}
      WHEN 'Conservador' THEN 1
      WHEN 'Moderado' THEN 2
      WHEN 'Dinámico' THEN 3
      ELSE 1
    END ;;
  }

  dimension: moneda {
    type: string
    label: "Moneda"
    sql: ${TABLE}.moneda ;;
  }

  measure: count {
    type: count
    label: "Total de Productos"
    drill_fields: [producto_id, producto_nombre, categoria, perfil_riesgo, moneda]
  }
}

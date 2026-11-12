view: sa_dim_comment {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.dim_comment` ;;

  dimension: comment_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.comment_id ;;
  }

  dimension: post_id {
    type: number
    hidden: yes
    sql: ${TABLE}.post_id ;;
  }

  dimension: comentario_id_externo {
    label: "ID Externo Comentario"
    type: string
    sql: ${TABLE}.external_id ;;
    description: "Identificador del comentario en la plataforma"
  }

  dimension: comentario {
    label: "Texto del Comentario"
    type: string
    sql: ${TABLE}.text ;;
    description: "Texto anónimo del comentario dejado por el usuario"
  }

  dimension_group: fecha_comentario {
    label: "Comentario"
    type: time
    timeframes: [raw, time, date, week, month, year]
    datatype: datetime
    sql: ${TABLE}.created_at ;;
    description: "Fecha y hora en que se emitió el comentario"
  }

  dimension: me_gusta_comentario {
    label: "Likes en Comentario"
    type: number
    sql: ${TABLE}.like_count ;;
    description: "Cantidad de likes recibidos en el comentario"
  }

  measure: count {
    label: "Cantidad de Comentarios"
    type: count
    description: "Total de comentarios registrados"
  }

  measure: total_likes_comentarios {
    label: "Total Likes en Comentarios"
    type: sum
    sql: ${TABLE}.like_count ;;
    value_format_name: decimal_0
    description: "Suma total de likes recibidos en todos los comentarios"
  }
}

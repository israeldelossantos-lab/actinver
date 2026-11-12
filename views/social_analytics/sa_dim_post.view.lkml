view: sa_dim_post {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.dim_post` ;;

  dimension: post_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.post_id ;;
  }

  dimension: account_id {
    type: number
    hidden: yes
    sql: ${TABLE}.account_id ;;
  }

  dimension: publicacion_id_externo {
    label: "ID Externo Publicación"
    type: string
    sql: ${TABLE}.external_id ;;
    description: "Identificador del post en la red social"
  }

  dimension: publicacion {
    label: "Publicación"
    type: string
    sql: ${TABLE}.external_id ;;
    description: "Identificador del post para agrupación"
  }

  dimension: tipo_publicacion {
    label: "Tipo de Publicación"
    type: string
    sql: ${TABLE}.post_type ;;
    description: "Tipo de contenido: IMAGE, VIDEO, REEL, CAROUSEL, LINK"
  }

  dimension_group: fecha_publicacion {
    label: "Publicación"
    type: time
    timeframes: [raw, time, date, week, month, year, hour_of_day]
    datatype: datetime
    sql: ${TABLE}.published_at ;;
    description: "Momento exacto en que se publicó el contenido"
  }

  dimension: texto {
    label: "Texto / Copy"
    type: string
    sql: ${TABLE}.caption ;;
    description: "Texto o copy descriptivo de la publicación orgánica"
  }

  dimension: enlace {
    label: "Enlace Permanente"
    type: string
    sql: ${TABLE}.permalink ;;
    html: <a href="{{ value }}" target="_blank" rel="noopener noreferrer">{{ value }}</a> ;;
    description: "URL hacia la publicación original"
  }

  dimension: etiqueta_campana {
    label: "Etiqueta de Campaña"
    type: string
    sql: ${TABLE}.campaign_tag ;;
    description: "Hashtag o etiqueta de campaña orgánica"
  }

  measure: count {
    label: "Cantidad de Publicaciones"
    type: count
    description: "Total de publicaciones orgánicas únicas"
  }
}

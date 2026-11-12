view: sa_dim_ad {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.dim_ad` ;;

  dimension: ad_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.ad_id ;;
  }

  dimension: adset_id {
    type: number
    hidden: yes
    sql: ${TABLE}.adset_id ;;
  }

  dimension: anuncio_id_externo {
    label: "ID Externo Anuncio"
    type: string
    sql: ${TABLE}.external_id ;;
    description: "Identificador del anuncio en la plataforma"
  }

  dimension: anuncio {
    label: "Anuncio"
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre descriptivo del anuncio publicitario"
  }

  dimension: estado_anuncio {
    label: "Estado del Anuncio"
    type: string
    sql: ${TABLE}.status ;;
    description: "Estado del anuncio publicitario"
  }

  dimension: tipo_creativo {
    label: "Tipo de Creativo"
    type: string
    sql: ${TABLE}.creative_type ;;
    description: "Formato del creativo publicitario (IMAGE, VIDEO, CAROUSEL, TEXT)"
  }

  dimension: titular {
    label: "Titular / Headline"
    type: string
    sql: ${TABLE}.headline ;;
    description: "Titular o copy principal del creativo"
  }

  dimension: texto_principal {
    label: "Texto Principal"
    type: string
    sql: ${TABLE}.body_text ;;
    description: "Texto descriptivo secundario del anuncio"
  }

  dimension: url_creativo {
    label: "URL Creativo"
    type: string
    sql: ${TABLE}.creative_url ;;
    html: <a href="{{ value }}" target="_blank" rel="noopener noreferrer">{{ value }}</a> ;;
    description: "Enlace web hacia el recurso multimedia alojado"
  }

  measure: count {
    label: "Cantidad de Anuncios"
    type: count
    description: "Total de creativos publicitarios registrados"
  }
}

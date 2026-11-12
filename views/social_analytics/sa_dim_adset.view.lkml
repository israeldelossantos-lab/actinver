view: sa_dim_adset {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.dim_adset` ;;

  dimension: adset_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.adset_id ;;
  }

  dimension: campaign_id {
    type: number
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: adset_id_externo {
    label: "ID Externo Ad Set"
    type: string
    sql: ${TABLE}.external_id ;;
    description: "Identificador externo del conjunto de anuncios"
  }

  dimension: conjunto_anuncios {
    label: "Conjunto de Anuncios"
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre del conjunto de anuncios o ad group"
  }

  dimension: estado {
    label: "Estado Ad Set"
    type: string
    sql: ${TABLE}.status ;;
    description: "Estado del conjunto de anuncios"
  }

  dimension: segmentacion_json {
    type: string
    hidden: yes
    sql: TO_JSON_STRING(${TABLE}.targeting_json) ;;
    description: "Configuración de segmentación en formato JSON"
  }

  measure: count {
    label: "Cantidad de Conjuntos de Anuncios"
    type: count
    description: "Total de conjuntos de anuncios registrados"
  }
}

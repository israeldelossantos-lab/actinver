view: sa_dim_campaign {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.dim_campaign` ;;

  dimension: campaign_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: account_id {
    type: number
    hidden: yes
    sql: ${TABLE}.account_id ;;
  }

  dimension: campana_id_externo {
    label: "ID Externo de Campaña"
    type: string
    sql: ${TABLE}.external_id ;;
    group_label: "Atributos de campaña"
    description: "Identificador externo de la campaña en la plataforma"
  }

  dimension: campana {
    label: "Campaña"
    type: string
    sql: ${TABLE}.name ;;
    group_label: "Atributos de campaña"
    description: "Nombre completo de la campaña"
  }

  dimension: objetivo {
    label: "Objetivo"
    type: string
    sql: ${TABLE}.objective ;;
    group_label: "Atributos de campaña"
    description: "Objetivo publicitario declarado (VENTAS, ALCANCE, etc.)"
  }

  dimension: estado {
    label: "Estado de Campaña"
    type: string
    sql: ${TABLE}.status ;;
    group_label: "Atributos de campaña"
    description: "Estado actual de la campaña (ACTIVE, PAUSED, ENABLED, COMPLETED)"
  }

  dimension: tipo_canal {
    label: "Tipo de Canal"
    type: string
    sql: ${TABLE}.channel_type ;;
    group_label: "Atributos de campaña"
    description: "Canal en Google Ads (SEARCH, VIDEO, PMAX, DISPLAY)"
  }

  dimension: marca {
    label: "Marca"
    type: string
    sql: ${TABLE}.brand ;;
    group_label: "Atributos de campaña"
    description: "Marca asignada según taxonomía"
  }

  dimension: linea_producto {
    label: "Línea de Producto"
    type: string
    sql: ${TABLE}.product_line ;;
    group_label: "Atributos de campaña"
    description: "Línea de producto asociada"
  }

  dimension: region {
    label: "Región"
    type: string
    sql: ${TABLE}.region ;;
    group_label: "Atributos de campaña"
    description: "Región geográfica objetivo"
  }

  dimension_group: fecha_inicio {
    label: "Inicio de Campaña"
    type: time
    timeframes: [raw, date, week, month, year]
    datatype: date
    sql: ${TABLE}.start_date ;;
    group_label: "Atributos de campaña"
  }

  dimension_group: fecha_fin {
    label: "Fin de Campaña"
    type: time
    timeframes: [raw, date, week, month, year]
    datatype: date
    sql: ${TABLE}.end_date ;;
    group_label: "Atributos de campaña"
  }

  dimension: presupuesto {
    label: "Presupuesto Asignado"
    type: number
    sql: ${TABLE}.budget ;;
    value_format_name: decimal_2
    group_label: "Atributos de campaña"
    description: "Presupuesto diario o total asignado a la campaña"
  }

  dimension: es_demo {
    label: "Es Campaña DEMO"
    type: yesno
    sql: STARTS_WITH(${TABLE}.external_id, 'DEMO-') ;;
    group_label: "Atributos de campaña"
    description: "Identifica si la campaña pertenece al set sintético DEMO"
  }

  measure: count {
    label: "Cantidad de Campañas"
    type: count
    description: "Total de campañas publicitarias únicas"
  }
}

view: sa_dim_account {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.dim_account` ;;

  dimension: account_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.account_id ;;
  }

  dimension: platform_id {
    type: number
    hidden: yes
    sql: ${TABLE}.platform_id ;;
  }

  dimension: cuenta_id_externo {
    label: "ID Externo de Cuenta"
    type: string
    sql: ${TABLE}.external_id ;;
    description: "Identificador externo de la cuenta en la API"
  }

  dimension: cuenta {
    label: "Cuenta"
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre descriptivo de la cuenta publicitaria o perfil"
  }

  dimension: tipo_cuenta {
    label: "Tipo de Cuenta"
    type: string
    sql: ${TABLE}.account_type ;;
    description: "Clasificación de la cuenta: organic o ads"
  }

  dimension: moneda {
    label: "Moneda"
    type: string
    sql: ${TABLE}.currency ;;
    description: "Moneda de facturación configurada (MXN)"
  }

  dimension: zona_horaria {
    label: "Zona Horaria"
    type: string
    sql: ${TABLE}.timezone ;;
    description: "Zona horaria configurada en la cuenta"
  }

  dimension_group: inicio_historia {
    label: "Inicio de Historia"
    type: time
    timeframes: [raw, date, week, month, year]
    datatype: date
    sql: ${TABLE}.history_start_date ;;
    description: "Fecha más antigua disponible devuelta por la API"
  }

  dimension: es_activa {
    label: "Cuenta Activa"
    type: yesno
    sql: ${TABLE}.is_active ;;
    description: "Indica si la cuenta está activa para el pipeline ETL"
  }
}

view: contexto_usuario {
  derived_table: {
    sql: SELECT 1 AS id ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: usuario_perfil {
    type: string
    label: "Perfil de Usuario"
    sql: {{ _user_attributes['demo_perfil'] | sql_quote }} ;;
  }

  dimension: usuario_region {
    type: string
    label: "Región Asignada"
    sql: {{ _user_attributes['demo_region'] | sql_quote }} ;;
  }

  dimension: usuario_linea_negocio {
    type: string
    label: "Línea de Negocio Asignada"
    sql: {{ _user_attributes['demo_linea_negocio'] | sql_quote }} ;;
  }

  dimension: usuario_area {
    type: string
    label: "Área Asignada"
    sql: {{ _user_attributes['demo_area'] | sql_quote }} ;;
  }

  dimension: usuario_departamento {
    type: string
    label: "Departamento Asignado"
    sql: {{ _user_attributes['demo_departamento'] | sql_quote }} ;;
  }

  dimension: usuario_canal {
    type: string
    label: "Canal Asignado"
    sql: {{ _user_attributes['demo_canal'] | sql_quote }} ;;
  }
}

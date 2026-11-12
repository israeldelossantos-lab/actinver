view: sa_dim_platform {
  sql_table_name: `vertex-ia-503623.social_analytics_demo.dim_platform` ;;

  dimension: platform_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.platform_id ;;
  }

  dimension: plataforma {
    label: "Plataforma"
    type: string
    sql: ${TABLE}.code ;;
    description: "Código identificador de la plataforma (facebook, instagram, tiktok, google_ads, youtube)"
  }

  dimension: plataforma_nombre {
    label: "Nombre de Plataforma"
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre comercial de la plataforma publicitaria"
  }
}

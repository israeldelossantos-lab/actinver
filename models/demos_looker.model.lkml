connection: "claro_video_bigquery"

include: "/views/**/*.view.lkml"
include: "/dashboards/**/*.dashboard.lookml"

named_value_format: mxn_m {
  value_format: "[>=1000000]$#,##0.0,\"M\";$#,##0"
}

# ==============================================================================
# ACCESS GRANTS: Control de Acceso por Columna y Explore
# ==============================================================================

access_grant: ver_financiero {
  user_attribute: demo_perfil
  allowed_values: ["directivo", "finanzas"]
}

access_grant: ver_datos_clinicos {
  user_attribute: demo_perfil
  allowed_values: ["clinico"]
}

access_grant: ver_pii_clientes {
  user_attribute: demo_perfil
  allowed_values: ["operaciones"]
}

access_grant: acceso_hospital {
  user_attribute: demo_perfil
  allowed_values: ["directivo", "finanzas", "clinico"]
}

# ==============================================================================
# EXPLORES: Demos Looker con Seguridad por Fila (access_filter)
# ==============================================================================

explore: retail_inventory {
  label: "Retail Inventory"
  description: "Inventario de productos, niveles de stock, costos y rotación"
  access_filter: {
    field: retail_inventory.linea_negocio
    user_attribute: demo_linea_negocio
  }
}

explore: project_management {
  label: "Project Management"
  description: "Gestión de proyectos, tareas, presupuestos y estatus de ejecución"
  access_filter: {
    field: project_management.area_negocio
    user_attribute: demo_area
  }
}

explore: e_commerce_orders {
  label: "E-Commerce Orders"
  description: "Órdenes de comercio electrónico, ingresos, márgenes y clientes"
  access_filter: {
    field: e_commerce_orders.region
    user_attribute: demo_region
  }
  access_filter: {
    field: e_commerce_orders.linea_negocio
    user_attribute: demo_linea_negocio
  }
}

explore: hospital_patients {
  label: "Hospital Patients"
  description: "Registro de pacientes hospitalarios, diagnósticos y facturación"
  required_access_grants: [acceso_hospital]
  access_filter: {
    field: hospital_patients.department
    user_attribute: demo_departamento
  }
}

explore: social_media_analytics {
  label: "Social Media Analytics"
  description: "Métricas de redes sociales: impresiones, alcance, engagement e interacción"
  access_filter: {
    field: social_media_analytics.platform
    user_attribute: demo_canal
  }
}

explore: marketing_campaigns {
  label: "Marketing Campaigns"
  description: "Rendimiento de campañas de marketing, canales, conversiones y ROI"
  access_filter: {
    field: marketing_campaigns.channel
    user_attribute: demo_canal
  }
}

explore: contexto_usuario {
  label: "Contexto de Usuario Actual"
  description: "Devuelve los atributos de seguridad del usuario de la sesión actual"
  hidden: yes
}

# ==============================================================================
# EXPLORES: Actinver (Banca Privada, Inversiones, Crédito y Operaciones)
# ==============================================================================

explore: fact_movimientos_inversion {
  label: "Actinver - Movimientos e Inversiones"
  description: "Movimientos transaccionales de inversión de clientes, fondos y asesores"

  join: dim_clientes {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_movimientos_inversion.cliente_id} = ${dim_clientes.cliente_id} ;;
  }

  join: dim_asesores {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_movimientos_inversion.asesor_id} = ${dim_asesores.asesor_id} ;;
  }

  join: dim_productos {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_movimientos_inversion.producto_id} = ${dim_productos.producto_id} ;;
  }

  join: dim_sucursales {
    type: left_outer
    sql_on: ${fact_movimientos_inversion.sucursal} = ${dim_sucursales.sucursal} ;;
    relationship: many_to_one
  }
}

explore: fact_cartera_credito {
  label: "Actinver - Cartera de Crédito"
  description: "Cortes mensuales de saldos de capital, días de atraso y morosidad de créditos"

  join: dim_clientes {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_cartera_credito.cliente_id} = ${dim_clientes.cliente_id} ;;
  }

  join: dim_sucursales {
    type: left_outer
    sql_on: ${fact_cartera_credito.sucursal} = ${dim_sucursales.sucursal} ;;
    relationship: many_to_one
  }
}

explore: fact_finanzas_mensual {
  label: "Actinver - Finanzas Mensuales"
  description: "Ingresos, costos, utilidad operativa y presupuesto por unidad de negocio"
}

explore: fact_rendimiento_fondos {
  label: "Actinver - Rendimiento de Fondos"
  description: "AUM mensual y rendimientos comparados contra el benchmark de mercado"

  join: dim_productos {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_rendimiento_fondos.producto_id} = ${dim_productos.producto_id} ;;
  }
}

explore: fact_marketing_campanias {
  label: "Actinver - Marketing y Campañas"
  description: "Inversión publicitaria, impresiones, clics, leads y conversiones por canal"
}

explore: fact_operaciones_diarias {
  label: "Actinver - Operaciones Diarias"
  description: "Métricas diarias de calidad de servicio, tasas de rechazo y tiempos de resolución"
}

explore: calidad_datos {
  label: "Actinver - Calidad de Datos"
  description: "Monitoreo automatizado de reglas de negocio y calidad de datos"
}

explore: roll_rate_cartera {
  label: "Actinver - Roll Rate de Cartera"
  description: "Matriz de transición y migración de morosidad entre cortes mensuales"
}

explore: dim_clientes {
  label: "Actinver - Clientes y Crecimiento"
  description: "Altas, bajas, clientes netos y base total de clientes de Actinver"

  join: dim_asesores {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_clientes.asesor_id} = ${dim_asesores.asesor_id} ;;
  }
}

# ==============================================================================
# === SOCIAL ANALYTICS (Centro de Decisiones de Campañas) ===
# ==============================================================================

# TODO: access_filter por marca cuando haya datos reales

explore: sa_campanas {
  label: "Campañas Pagadas"
  description: "Desempeño diario de campañas, conjuntos y anuncios en Meta, TikTok y Google Ads"
  group_label: "Social Analytics"
  view_name: sa_fact_ad_daily

  join: sa_dim_ad {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_fact_ad_daily.ad_id} = ${sa_dim_ad.ad_id} ;;
  }

  join: sa_dim_adset {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_ad.adset_id} = ${sa_dim_adset.adset_id} ;;
  }

  join: sa_dim_campaign {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_adset.campaign_id} = ${sa_dim_campaign.campaign_id} ;;
  }

  join: sa_dim_account {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_campaign.account_id} = ${sa_dim_account.account_id} ;;
  }

  join: sa_dim_platform {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_account.platform_id} = ${sa_dim_platform.platform_id} ;;
  }
}

explore: sa_organico {
  label: "Contenido Orgánico"
  description: "Rendimiento y engagement de posts, videos y reels en Facebook, Instagram y TikTok"
  group_label: "Social Analytics"
  view_name: sa_fact_post_daily

  join: sa_dim_post {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_fact_post_daily.post_id} = ${sa_dim_post.post_id} ;;
  }

  join: sa_dim_account {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_post.account_id} = ${sa_dim_account.account_id} ;;
  }

  join: sa_dim_platform {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_account.platform_id} = ${sa_dim_platform.platform_id} ;;
  }
}

explore: sa_seguidores {
  label: "Crecimiento de Cuentas"
  description: "Evolución histórica de seguidores y visualizaciones de perfil de las cuentas"
  group_label: "Social Analytics"
  view_name: sa_fact_account_daily

  join: sa_dim_account {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_fact_account_daily.account_id} = ${sa_dim_account.account_id} ;;
  }

  join: sa_dim_platform {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_account.platform_id} = ${sa_dim_platform.platform_id} ;;
  }
}

explore: sa_comentarios {
  label: "Comentarios y Sentimiento"
  description: "Análisis cualitativo y clasificación de sentimiento por IA de comentarios"
  group_label: "Social Analytics"
  view_name: sa_dim_comment

  join: sa_ai_comment_analysis {
    type: left_outer
    relationship: one_to_one
    sql_on: ${sa_dim_comment.comment_id} = ${sa_ai_comment_analysis.comment_id} ;;
  }

  join: sa_dim_post {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_comment.post_id} = ${sa_dim_post.post_id} ;;
  }

  join: sa_dim_account {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_post.account_id} = ${sa_dim_account.account_id} ;;
  }

  join: sa_dim_platform {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_account.platform_id} = ${sa_dim_platform.platform_id} ;;
  }
}

explore: sa_decisiones {
  label: "Bitácora de Decisiones"
  description: "Registro de decisiones tácticas y evaluación de su impacto real vs esperado"
  group_label: "Social Analytics"
  view_name: sa_decision_log

  join: sa_decision_impact {
    type: left_outer
    relationship: one_to_one
    sql_on: ${sa_decision_log.decision_id} = ${sa_decision_impact.decision_id} ;;
  }

  join: sa_dim_campaign {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_decision_log.campaign_id} = ${sa_dim_campaign.campaign_id} ;;
  }

  join: sa_dim_account {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_campaign.account_id} = ${sa_dim_account.account_id} ;;
  }

  join: sa_dim_platform {
    type: left_outer
    relationship: many_to_one
    sql_on: ${sa_dim_account.platform_id} = ${sa_dim_platform.platform_id} ;;
  }
}

explore: sa_ia_insights {
  label: "Insights de IA"
  description: "Auditorías automáticas, detección de anomalías y reportes ejecutivos generados por Claude"
  group_label: "Social Analytics"
  view_name: sa_ai_insight
}

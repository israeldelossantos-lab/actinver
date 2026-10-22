connection: "claro_video_bigquery"

include: "/views/**/*.view.lkml"
include: "/dashboards/**/*.dashboard.lookml"

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

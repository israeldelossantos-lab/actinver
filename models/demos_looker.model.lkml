connection: "claro_video_bigquery"

include: "/views/**/*.view.lkml"

# ==============================================================================
# EXPLORES: Demos Looker
# ==============================================================================

explore: retail_inventory {
  label: "Retail Inventory"
  description: "Inventario de productos, niveles de stock, costos y rotación"
}

explore: project_management {
  label: "Project Management"
  description: "Gestión de proyectos, tareas, presupuestos y estatus de ejecución"
}

explore: e_commerce_orders {
  label: "E-Commerce Orders"
  description: "Órdenes de comercio electrónico, ingresos, márgenes y clientes"
}

explore: hospital_patients {
  label: "Hospital Patients"
  description: "Registro de pacientes hospitalarios, diagnósticos y facturación"
}

explore: social_media_analytics {
  label: "Social Media Analytics"
  description: "Métricas de redes sociales: impresiones, alcance, engagement e interacción"
}

explore: marketing_campaigns {
  label: "Marketing Campaigns"
  description: "Rendimiento de campañas de marketing, canales, conversiones y ROI"
}

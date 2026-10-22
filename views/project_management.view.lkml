view: project_management {
  sql_table_name: `claro_video.project_management` ;;

  dimension: task_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.project_name, '|', ${TABLE}.task_name, '|', ${TABLE}.assigned_to, '|', CAST(${TABLE}.planned_start_date AS STRING)) ;;
  }

  dimension: project_name {
    type: string
    label: "Proyecto"
    sql: ${TABLE}.project_name ;;
  }

  dimension: task_name {
    type: string
    label: "Tarea"
    sql: ${TABLE}.task_name ;;
  }

  dimension: assigned_to {
    type: string
    label: "Responsable"
    sql: ${TABLE}.assigned_to ;;
  }

  dimension: priority {
    type: string
    label: "Prioridad"
    sql: ${TABLE}.priority ;;
  }

  dimension_group: planned_start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha Inicio Planeada"
    sql: ${TABLE}.planned_start_date ;;
  }

  dimension_group: planned_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha Fin Planeada"
    sql: ${TABLE}.planned_end_date ;;
  }

  dimension_group: actual_end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha Fin Real"
    sql: ${TABLE}.actual_end_date ;;
  }

  dimension: pct_complete {
    type: number
    label: "% de Avance"
    value_format_name: percent_1
    sql: ${TABLE}.pct_complete ;;
  }

  dimension: planned_budget {
    type: number
    label: "Presupuesto Planeado"
    value_format_name: usd_0
    sql: ${TABLE}.planned_budget ;;
    required_access_grants: [ver_financiero]
  }

  dimension: actual_cost {
    type: number
    label: "Costo Real"
    value_format_name: usd_0
    sql: ${TABLE}.actual_cost ;;
    required_access_grants: [ver_financiero]
  }

  dimension: status {
    type: string
    label: "Estatus"
    sql: ${TABLE}.status ;;
  }

  # --- Security dimensions ---

  dimension: area_negocio {
    type: string
    group_label: "Seguridad"
    label: "Área de Negocio"
    description: "Área de negocio asignada al proyecto para control de acceso"
    case: {
      when: {
        sql: ${TABLE}.project_name IN ('API Gateway', 'Cloud Infrastructure', 'Data Warehouse Build', 'DevOps Pipeline', 'Security Audit', 'Email Platform Migration') ;;
        label: "Tecnologia"
      }
      when: {
        sql: ${TABLE}.project_name IN ('Annual Report', 'Budget Planning Tool', 'ERP Implementation', 'Payment Integration', 'Compliance Overhaul') ;;
        label: "Finanzas"
      }
      when: {
        sql: ${TABLE}.project_name IN ('HR System Upgrade', 'Onboarding Automation', 'Performance Review System', 'Training Platform', 'Office Relocation') ;;
        label: "Recursos Humanos"
      }
      when: {
        sql: ${TABLE}.project_name IN ('Brand Refresh', 'Marketing Automation', 'Social Media Revamp', 'Website Redesign', 'Product Launch Q1', 'Product Launch Q2') ;;
        label: "Marketing"
      }
      when: {
        sql: ${TABLE}.project_name IN ('Inventory System', 'Supply Chain Optimization', 'Vendor Portal', 'Analytics Dashboard') ;;
        label: "Operaciones"
      }
      when: {
        sql: ${TABLE}.project_name IN ('CRM Migration', 'Customer Portal', 'Chatbot Development', 'Mobile App Launch') ;;
        label: "Comercial"
      }
      else: "Sin asignar"
    }
  }

  # --- Derived dimensions ---

  dimension: is_completed_on_time {
    type: yesno
    hidden: yes
    sql: ${status} = 'Completed' AND ${actual_end_date} <= ${planned_end_date} ;;
  }

  dimension: is_late {
    type: yesno
    label: "¿Tiene Retraso?"
    description: "Tarea completada fuera de plazo o tarea abierta con fecha límite superada"
    sql: (${status} = 'Completed' AND ${actual_end_date} > ${planned_end_date})
      OR (${status} NOT IN ('Completed', 'Cancelled') AND CURRENT_DATE() > DATE(${planned_end_date})) ;;
  }

  dimension: delay_days_completed {
    type: number
    hidden: yes
    sql: CASE WHEN ${status} = 'Completed' AND ${actual_end_date} > ${planned_end_date}
              THEN DATE_DIFF(DATE(${actual_end_date}), DATE(${planned_end_date}), DAY)
              ELSE NULL END ;;
  }

  dimension: planned_duration_days {
    type: number
    label: "Duración Planeada (Días)"
    description: "Días entre la fecha planeada de inicio y de fin"
    sql: DATE_DIFF(DATE(${planned_end_date}), DATE(${planned_start_date}), DAY) ;;
  }

  dimension: budget_health {
    type: string
    label: "Salud Presupuestal"
    description: "Evaluación: En presupuesto (<=90%), En riesgo (90-110%), Excedido (>110%)"
    required_access_grants: [ver_financiero]
    case: {
      when: {
        sql: ${actual_cost} <= 0.90 * ${planned_budget} ;;
        label: "En presupuesto"
      }
      when: {
        sql: ${actual_cost} <= 1.10 * ${planned_budget} ;;
        label: "En riesgo"
      }
      else: "Excedido"
    }
  }

  # --- Base measures ---

  measure: count {
    type: count
    label: "Total Tareas"
    drill_fields: [project_name, task_name, assigned_to, status]
  }

  measure: total_planned_budget {
    type: sum
    group_label: "KPIs"
    label: "Presupuesto Planeado Total"
    description: "Suma de los presupuestos planeados de todas las tareas"
    value_format_name: usd_0
    sql: ${planned_budget} ;;
    required_access_grants: [ver_financiero]
  }

  measure: total_actual_cost {
    type: sum
    group_label: "KPIs"
    label: "Costo Real Total"
    description: "Suma de los costos reales ejecutados"
    value_format_name: usd_0
    sql: ${actual_cost} ;;
    required_access_grants: [ver_financiero]
  }

  measure: budget_variance {
    type: number
    group_label: "KPIs"
    label: "Variación Presupuestal ($)"
    description: "Presupuesto planeado menos costo real ejecutado"
    value_format_name: usd_0
    sql: ${total_planned_budget} - ${total_actual_cost} ;;
    required_access_grants: [ver_financiero]
  }

  measure: avg_completion_pct {
    type: average
    group_label: "KPIs"
    label: "% de Avance Promedio"
    description: "Promedio del porcentaje de avance de las tareas"
    value_format_name: percent_1
    sql: ${pct_complete} ;;
  }

  # --- KPI measures ---

  measure: tasks_completed {
    type: count
    group_label: "Volumen"
    label: "Tareas Completadas"
    description: "Número de tareas finalizadas (Completed)"
    filters: [status: "Completed"]
  }

  measure: tasks_delayed {
    type: count
    group_label: "Riesgo"
    label: "Tareas Retrasadas"
    description: "Tareas con estatus oficial Delayed"
    filters: [status: "Delayed"]
  }

  measure: tasks_open {
    type: count
    group_label: "Volumen"
    label: "Tareas Abiertas"
    description: "Tareas en curso, no iniciadas, en pausa o con retraso"
    filters: [status: "In Progress, Not Started, On Hold, Delayed"]
  }

  measure: tasks_cancelled {
    type: count
    hidden: yes
    filters: [status: "Cancelled"]
  }

  measure: completion_rate_pct {
    type: number
    group_label: "Eficiencia"
    label: "Tasa de Completado (%)"
    description: "Porcentaje de tareas completadas sobre tareas activas"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${tasks_completed}, ${count} - ${tasks_cancelled}) ;;
  }

  measure: tasks_on_time {
    type: count
    hidden: yes
    filters: [is_completed_on_time: "yes"]
  }

  measure: on_time_rate_pct {
    type: number
    group_label: "Eficiencia"
    label: "Entrega a Tiempo (%)"
    description: "Porcentaje de tareas completadas dentro de la fecha límite planeada"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${tasks_on_time}, ${tasks_completed}) ;;
  }

  measure: avg_delay_days {
    type: average
    group_label: "Riesgo"
    label: "Días Promedio de Retraso"
    description: "Promedio de días de desfase en tareas completadas con retraso"
    value_format_name: decimal_1
    sql: ${delay_days_completed} ;;
  }

  measure: cost_variance_pct {
    type: number
    group_label: "Eficiencia"
    label: "Desviación de Costo (%)"
    description: "Desviación porcentual del costo real respecto al presupuesto planeado"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${total_actual_cost} - ${total_planned_budget}, ${total_planned_budget}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: tasks_over_budget {
    type: count
    group_label: "Riesgo"
    label: "Tareas Excedidas de Presupuesto"
    description: "Cantidad de tareas donde el costo real supera el presupuesto"
    filters: [budget_health: "Excedido"]
    required_access_grants: [ver_financiero]
  }

  measure: budget_burn_pct {
    type: number
    group_label: "Eficiencia"
    label: "Presupuesto vs Real (%)"
    description: "Costo real dividido entre presupuesto planeado"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${total_actual_cost}, ${total_planned_budget}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: earned_value {
    type: sum
    group_label: "KPIs"
    label: "Valor Ganado (Earned Value)"
    description: "Presupuesto planeado ponderado por el avance de cada tarea"
    value_format_name: usd_0
    sql: ${planned_budget} * ${pct_complete} ;;
    required_access_grants: [ver_financiero]
  }

  measure: cpi {
    type: number
    group_label: "Eficiencia"
    label: "Índice de Rendimiento de Costo (CPI)"
    description: "Cost Performance Index: Valor Ganado / Costo Real (>1 eficiente, <1 deficiente)"
    value_format_name: decimal_2
    sql: SAFE_DIVIDE(${earned_value}, ${total_actual_cost}) ;;
    required_access_grants: [ver_financiero]
  }
}

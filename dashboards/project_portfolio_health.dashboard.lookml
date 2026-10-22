- dashboard: project_portfolio_health
  title: "Portafolio de Proyectos: Avance, Plazo y Costo"
  description: "Monitoreo PMO integral de ejecución de tareas, apego a cronograma y control presupuestal."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour

  filters:
    - name: project_name
      title: "Proyecto"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: project_management
      listens_to_filters: []
      field: project_management.project_name

    - name: assigned_to
      title: "Responsable"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: project_management
      listens_to_filters: []
      field: project_management.assigned_to

    - name: priority
      title: "Prioridad"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: project_management
      listens_to_filters: []
      field: project_management.priority

    - name: status
      title: "Estatus"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: checkboxes
        display: popover
      model: demos_looker
      explore: project_management
      listens_to_filters: []
      field: project_management.status

    - name: planned_start_date
      title: "Fecha Inicio Planeada"
      type: date_filter
      default_value: "2024/01/01 to 2026/01/31"
      allow_multiple_values: false
      required: false
      ui_config:
        type: relative_timeframes
        display: inline

  elements:
    # --- Encabezado ---
    - name: header_tile
      type: text
      title_text: "📊 Portafolio de Proyectos: Avance, Plazo y Costo"
      subtitle_text: "Monitoreo ejecutivo de cumplimiento de cronogramas, desviación de costos y productividad del equipo."
      body_text: ""
      row: 0
      col: 0
      width: 24
      height: 2

    # --- Fila 1: KPIs ---
    - name: kpi_tareas_totales
      title: "Tareas Totales"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.count]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#1A3A6B"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 2
      col: 0
      width: 4
      height: 3

    - name: kpi_pct_completado
      title: "% Avance Promedio"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.avg_completion_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#1A3A6B"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 2
      col: 4
      width: 4
      height: 3

    - name: kpi_on_time_rate
      title: "Entrega a Tiempo %"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.on_time_rate_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#1E8E3E"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 2
      col: 8
      width: 4
      height: 3

    - name: kpi_tareas_retrasadas
      title: "Tareas Retrasadas"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.tasks_delayed]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#D93025"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 2
      col: 12
      width: 4
      height: 3

    - name: kpi_budget_burn
      title: "Presupuesto vs Real (%)"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.budget_burn_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#1A3A6B"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 2
      col: 16
      width: 4
      height: 3

    - name: kpi_cpi
      title: "Índice Costo (CPI)"
      model: demos_looker
      explore: project_management
      type: single_value
      fields: [project_management.cpi]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#1E8E3E"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 2
      col: 20
      width: 4
      height: 3

    # --- Filas 2-3: Gráficos Principales ---
    - name: chart_tareas_proyecto_status
      title: "Top 15 Proyectos por Volumen y Estatus de Ejecución"
      model: demos_looker
      explore: project_management
      type: looker_bar
      fields: [project_management.project_name, project_management.status, project_management.count]
      pivots: [project_management.status]
      sorts: [project_management.count desc 0]
      limit: 15
      stacking: normal
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: false
      show_y_axis_labels: true
      series_colors:
        Completed - project_management.count: "#1E8E3E"
        In Progress - project_management.count: "#1A73E8"
        Not Started - project_management.count: "#9AA0A6"
        On Hold - project_management.count: "#F9AB00"
        Delayed - project_management.count: "#D93025"
        Cancelled - project_management.count: "#5F6368"
      legend_position: bottom
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 5
      col: 0
      width: 16
      height: 9

    - name: chart_tareas_prioridad_donut
      title: "Distribución por Prioridad"
      model: demos_looker
      explore: project_management
      type: looker_pie
      fields: [project_management.priority, project_management.count]
      sorts: [project_management.count desc]
      value_labels: legend
      label_type: labPer
      inner_radius: 55
      series_colors:
        Critical: "#B31412"
        High: "#E8710A"
        Medium: "#F9AB00"
        Low: "#81C995"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 5
      col: 16
      width: 8
      height: 9

    - name: chart_presupuesto_real_mensual
      title: "Evolución Presupuestal Mensual vs Desviación (%)"
      model: demos_looker
      explore: project_management
      type: looker_column
      fields: [
        project_management.planned_start_month,
        project_management.total_planned_budget,
        project_management.total_actual_cost,
        project_management.cost_variance_pct
      ]
      sorts: [project_management.planned_start_month asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Mes de Inicio Planeado"
      series_types:
        project_management.cost_variance_pct: line
      series_colors:
        project_management.total_planned_budget: "#1A3A6B"
        project_management.total_actual_cost: "#E8710A"
        project_management.cost_variance_pct: "#D93025"
      series_labels:
        project_management.total_planned_budget: "Presupuesto Planeado ($)"
        project_management.total_actual_cost: "Costo Real ($)"
        project_management.cost_variance_pct: "Desviación de Costo (%)"
      y_axes:
        - label: "Monto Presupuestal ($)"
          orientation: left
          series:
            - id: project_management.total_planned_budget
              name: "Presupuesto Planeado ($)"
            - id: project_management.total_actual_cost
              name: "Costo Real ($)"
        - label: "Desviación (%)"
          orientation: right
          series:
            - id: project_management.cost_variance_pct
              name: "Desviación de Costo (%)"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 14
      col: 0
      width: 24
      height: 9

    - name: chart_carga_retrasos_responsable
      title: "Top 15 Responsables: Tareas Retrasadas y Días de Desfase"
      model: demos_looker
      explore: project_management
      type: looker_bar
      fields: [project_management.assigned_to, project_management.tasks_delayed, project_management.avg_delay_days]
      sorts: [project_management.tasks_delayed desc]
      limit: 15
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        project_management.tasks_delayed: "#D93025"
        project_management.avg_delay_days: "#F9AB00"
      series_labels:
        project_management.tasks_delayed: "Tareas Retrasadas"
        project_management.avg_delay_days: "Días Promedio Retraso"
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 23
      col: 0
      width: 12
      height: 9

    - name: chart_heatmap_riesgo_proyecto
      title: "Matriz de Riesgo: Proyecto × Prioridad (Tareas Retrasadas)"
      model: demos_looker
      explore: project_management
      type: looker_grid
      fields: [project_management.project_name, project_management.priority, project_management.tasks_delayed]
      pivots: [project_management.priority]
      sorts: [project_management.tasks_delayed desc 0]
      limit: 20
      show_view_names: false
      show_row_numbers: false
      conditional_formatting:
        - type: low to high
          value:
          background_color:
          font_color:
          palette:
            name: heat_risk
            colors: ["#FFFFFF", "#FCE8E6", "#D93025"]
          bold: false
          italic: false
          strikethrough: false
          fields: [project_management.tasks_delayed]
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
        planned_start_date: project_management.planned_start_date
      row: 23
      col: 12
      width: 12
      height: 9

    # --- Fila Final: Tabla de Detalle ---
    - name: table_tareas_en_riesgo
      title: "🚨 Tareas Críticas con Retraso Activo o Fuera de Plazo"
      model: demos_looker
      explore: project_management
      type: looker_grid
      fields: [
        project_management.project_name,
        project_management.task_name,
        project_management.assigned_to,
        project_management.priority,
        project_management.planned_end_date,
        project_management.pct_complete,
        project_management.planned_budget,
        project_management.actual_cost,
        project_management.budget_health
      ]
      filters:
        project_management.is_late: "yes"
        project_management.status: "-Completed,-Cancelled"
      sorts: [project_management.priority desc, project_management.planned_end_date asc]
      limit: 50
      show_view_names: false
      show_row_numbers: true
      table_theme: white
      conditional_formatting:
        - type: along a scale...
          value:
          background_color: "#1E8E3E"
          font_color:
          palette:
            name: progress_bar
            colors: ["#FFFFFF", "#E6F4EA", "#1E8E3E"]
          bold: false
          italic: false
          strikethrough: false
          fields: [project_management.pct_complete]
      listen:
        project_name: project_management.project_name
        assigned_to: project_management.assigned_to
        priority: project_management.priority
        status: project_management.status
      row: 32
      col: 0
      width: 24
      height: 9

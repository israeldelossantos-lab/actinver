- dashboard: hospital_operations_billing
  title: "Hospital: Admisiones, Estancia y Cobranza"
  description: "Monitoreo clínico y administrativo de capacidad hospitalaria, días de estancia (LOS) y efectividad en cobranza médica."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  refresh: 1 hour

  filters:
    - name: admission_date
      title: "Fecha de Admisión"
      type: date_filter
      default_value: "2024/01/01 to 2026/01/31"
      allow_multiple_values: false
      required: false
      ui_config:
        type: relative_timeframes
        display: inline

    - name: department
      title: "Departamento"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: checkboxes
        display: popover
      model: demos_looker
      explore: hospital_patients
      listens_to_filters: []
      field: hospital_patients.department

    - name: payment_status
      title: "Estatus de Pago"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: button_group
        display: inline
      model: demos_looker
      explore: hospital_patients
      listens_to_filters: []
      field: hospital_patients.payment_status

    - name: age_group
      title: "Grupo de Edad"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      ui_config:
        type: tag_list
        display: popover
      model: demos_looker
      explore: hospital_patients
      listens_to_filters: []
      field: hospital_patients.age_group

  elements:
    # --- Encabezado ---
    - name: header_tile
      type: text
      title_text: "🏥 Operación Hospitalaria y Gestión Financiera"
      subtitle_text: "Control clínico de admisiones, estancia promedio de pacientes y monitoreo de cuentas por cobrar."
      body_text: ""
      row: 0
      col: 0
      width: 24
      height: 2

    # --- Fila 1: KPIs ---
    - name: kpi_admisiones
      title: "Admisiones Totales"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.count]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 2
      col: 0
      width: 4
      height: 2

    - name: kpi_los_promedio
      title: "Estancia Promedio (Días)"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.avg_length_of_stay]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 2
      col: 4
      width: 4
      height: 2

    - name: kpi_facturacion_total
      title: "Facturación Total"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.total_billed]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 2
      col: 8
      width: 4
      height: 2

    - name: kpi_cobertura_promedio
      title: "Cobertura Seguro Promedio"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.avg_insurance_coverage]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 2
      col: 12
      width: 4
      height: 2

    - name: kpi_monto_pendiente
      title: "Monto Pendiente"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.pending_amount]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 2
      col: 16
      width: 4
      height: 2

    - name: kpi_tasa_cobro
      title: "Tasa de Cobro %"
      model: demos_looker
      explore: hospital_patients
      type: single_value
      fields: [hospital_patients.collection_rate_pct]
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      custom_color: "#FFFFFF"
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting: [{
        type: not null,
        value: [],
        background_color: "#002D6F",
        font_color: "#FFFFFF"
      }]
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 2
      col: 20
      width: 4
      height: 2

    # --- Filas 2-3: Gráficos Principales ---
    - name: chart_admisiones_tiempo_departamento
      title: "Tendencia de Admisiones Mensuales por Departamento"
      model: demos_looker
      explore: hospital_patients
      type: looker_line
      fields: [hospital_patients.admission_month, hospital_patients.department, hospital_patients.count]
      pivots: [hospital_patients.department]
      sorts: [hospital_patients.admission_month asc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Mes de Admisión"
      series_colors:
        General - hospital_patients.count: "#00796B"
        Emergency - hospital_patients.count: "#D84315"
        Orthopedics - hospital_patients.count: "#5E35B1"
        Pediatrics - hospital_patients.count: "#039BE5"
        Cardiology - hospital_patients.count: "#C62828"
        Neurology - hospital_patients.count: "#6D4C41"
      legend_position: bottom
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 5
      col: 0
      width: 16
      height: 9

    - name: chart_payment_status_donut
      title: "Distribución de Estatus de Cobranza"
      model: demos_looker
      explore: hospital_patients
      type: looker_pie
      fields: [hospital_patients.payment_status, hospital_patients.count]
      sorts: [hospital_patients.count desc]
      value_labels: legend
      label_type: labPer
      inner_radius: 55
      series_colors:
        Paid: "#1E8E3E"
        Partially Paid: "#F9AB00"
        Pending: "#D93025"
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 5
      col: 16
      width: 8
      height: 9

    - name: chart_facturacion_estancia_depto
      title: "Facturación Promedio ($) y Estancia Promedio (Días) por Departamento"
      model: demos_looker
      explore: hospital_patients
      type: looker_column
      fields: [hospital_patients.department, hospital_patients.avg_bill_amount, hospital_patients.avg_length_of_stay]
      sorts: [hospital_patients.avg_bill_amount desc]
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_types:
        hospital_patients.avg_length_of_stay: line
      series_colors:
        hospital_patients.avg_bill_amount: "#00796B"
        hospital_patients.avg_length_of_stay: "#D84315"
      series_labels:
        hospital_patients.avg_bill_amount: "Facturación Promedio ($)"
        hospital_patients.avg_length_of_stay: "Estancia Promedio (Días)"
      y_axes:
        - label: "Facturación Promedio ($)"
          orientation: left
          series:
            - id: hospital_patients.avg_bill_amount
              name: "Facturación Promedio ($)"
        - label: "Estancia Promedio (Días)"
          orientation: right
          series:
            - id: hospital_patients.avg_length_of_stay
              name: "Estancia Promedio (Días)"
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 14
      col: 0
      width: 12
      height: 9

    - name: chart_demografia_edad_genero
      title: "Demografía: Admisiones por Grupo de Edad y Género"
      model: demos_looker
      explore: hospital_patients
      type: looker_column
      fields: [hospital_patients.age_group, hospital_patients.gender, hospital_patients.count]
      pivots: [hospital_patients.gender]
      sorts: [hospital_patients.age_group asc]
      stacking: normal
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        Female - hospital_patients.count: "#8E24AA"
        Male - hospital_patients.count: "#1E88E5"
      legend_position: bottom
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 14
      col: 12
      width: 12
      height: 9

    - name: chart_top_diagnosticos_bar
      title: "Top 10 Diagnósticos Médicos por Volumen y Facturación Promedio"
      model: demos_looker
      explore: hospital_patients
      type: looker_bar
      fields: [hospital_patients.diagnosis, hospital_patients.count, hospital_patients.avg_bill_amount]
      sorts: [hospital_patients.count desc]
      limit: 10
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        hospital_patients.count: "#00796B"
      series_labels:
        hospital_patients.count: "Total Admisiones"
        hospital_patients.avg_bill_amount: "Facturación Promedio ($)"
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 23
      col: 0
      width: 12
      height: 9

    - name: chart_cobertura_distribucion_monto
      title: "Composición de Pago: Aseguradora vs Gasto de Bolsillo"
      model: demos_looker
      explore: hospital_patients
      type: looker_column
      fields: [hospital_patients.coverage_band, hospital_patients.insurance_covered_amount, hospital_patients.patient_out_of_pocket]
      sorts: [hospital_patients.coverage_band asc]
      stacking: normal
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      series_colors:
        hospital_patients.insurance_covered_amount: "#00796B"
        hospital_patients.patient_out_of_pocket: "#F9AB00"
      series_labels:
        hospital_patients.insurance_covered_amount: "Cubierto por Aseguradora ($)"
        hospital_patients.patient_out_of_pocket: "Gasto de Bolsillo ($)"
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        payment_status: hospital_patients.payment_status
        age_group: hospital_patients.age_group
      row: 23
      col: 12
      width: 12
      height: 9

    # --- Fila Final: Tabla de Detalle ---
    - name: table_cuentas_por_cobrar
      title: "📑 Cartera Vencida y Cuentas Médicas por Cobrar (Pendiente o Parcial)"
      model: demos_looker
      explore: hospital_patients
      type: looker_grid
      fields: [
        hospital_patients.patient_id,
        hospital_patients.department,
        hospital_patients.diagnosis,
        hospital_patients.admission_date,
        hospital_patients.discharge_date,
        hospital_patients.length_of_stay_days,
        hospital_patients.total_bill_amount,
        hospital_patients.insurance_coverage_pct,
        hospital_patients.payment_status
      ]
      filters:
        hospital_patients.payment_status: "Pending,Partially Paid"
      sorts: [hospital_patients.total_bill_amount desc]
      limit: 50
      show_view_names: false
      show_row_numbers: true
      table_theme: white
      conditional_formatting:
        - type: along a scale...
          value:
          background_color:
          font_color:
          palette:
            name: alert_red_scale
            colors: ["#FFFFFF", "#FCE8E6", "#D93025"]
          bold: false
          italic: false
          strikethrough: false
          fields: [hospital_patients.total_bill_amount]
      listen:
        admission_date: hospital_patients.admission_date
        department: hospital_patients.department
        age_group: hospital_patients.age_group
      row: 32
      col: 0
      width: 24
      height: 9

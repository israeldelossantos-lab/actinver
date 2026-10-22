view: hospital_patients {
  sql_table_name: `claro_video.hospital_patients` ;;

  dimension: patient_id {
    primary_key: yes
    type: string
    label: "ID de Paciente"
    sql: ${TABLE}.patient_id ;;
  }

  dimension: patient_name {
    type: string
    label: "Nombre de Paciente"
    tags: ["pii", "phi"]
    sql: ${TABLE}.patient_name ;;
    required_access_grants: [ver_datos_clinicos]
  }

  dimension: age {
    type: number
    label: "Edad"
    sql: ${TABLE}.age ;;
    required_access_grants: [ver_datos_clinicos]
  }

  dimension: gender {
    type: string
    label: "Género"
    sql: ${TABLE}.gender ;;
  }

  dimension_group: admission {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha de Admisión"
    sql: ${TABLE}.admission_date ;;
  }

  dimension_group: discharge {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    datatype: datetime
    label: "Fecha de Alta"
    sql: ${TABLE}.discharge_date ;;
  }

  dimension: department {
    type: string
    label: "Departamento"
    sql: ${TABLE}.department ;;
  }

  dimension: diagnosis {
    type: string
    label: "Diagnóstico"
    sql: ${TABLE}.diagnosis ;;
    required_access_grants: [ver_datos_clinicos]
  }

  dimension: total_bill_amount {
    type: number
    label: "Monto Facturado"
    value_format_name: usd
    sql: ${TABLE}.total_bill_amount ;;
    required_access_grants: [ver_financiero]
  }

  dimension: insurance_coverage_pct {
    type: number
    label: "Cobertura de Seguro (%)"
    description: "Porcentaje cubierto por póliza de seguro (0-100)"
    sql: ${TABLE}.insurance_coverage_pct ;;
    required_access_grants: [ver_financiero]
  }

  dimension: payment_status {
    type: string
    label: "Estatus de Pago"
    sql: ${TABLE}.payment_status ;;
  }

  # --- Derived dimensions ---

  dimension: length_of_stay_days {
    type: number
    label: "Días de Estancia (LOS)"
    description: "Días transcurridos entre la admisión y el alta"
    sql: DATE_DIFF(DATE(${TABLE}.discharge_date), DATE(${TABLE}.admission_date), DAY) ;;
  }

  dimension: age_group {
    type: string
    label: "Grupo de Edad"
    description: "Pediátrico (0-17), Adulto joven (18-39), Adulto (40-64), Adulto mayor (65+)"
    required_access_grants: [ver_datos_clinicos]
    case: {
      when: {
        sql: ${age} < 18 ;;
        label: "Pediátrico"
      }
      when: {
        sql: ${age} < 40 ;;
        label: "Adulto joven"
      }
      when: {
        sql: ${age} < 65 ;;
        label: "Adulto"
      }
      else: "Adulto mayor"
    }
  }

  dimension: los_bucket {
    type: string
    label: "Rango de Estancia"
    description: "Corta (1-2d), Media (3-5d), Larga (6-9d), Prolongada (10+d)"
    case: {
      when: {
        sql: ${length_of_stay_days} <= 2 ;;
        label: "Corta (1-2d)"
      }
      when: {
        sql: ${length_of_stay_days} <= 5 ;;
        label: "Media (3-5d)"
      }
      when: {
        sql: ${length_of_stay_days} <= 9 ;;
        label: "Larga (6-9d)"
      }
      else: "Prolongada (10+d)"
    }
  }

  dimension: coverage_band {
    type: string
    label: "Nivel de Cobertura de Seguro"
    description: "Sin seguro (0), Parcial (1-49), Mayoritaria (50-99), Total (100)"
    required_access_grants: [ver_financiero]
    case: {
      when: {
        sql: ${insurance_coverage_pct} = 0 ;;
        label: "Sin seguro"
      }
      when: {
        sql: ${insurance_coverage_pct} < 50 ;;
        label: "Parcial (1-49%)"
      }
      when: {
        sql: ${insurance_coverage_pct} < 100 ;;
        label: "Mayoritaria (50-99%)"
      }
      else: "Total (100%)"
    }
  }

  # --- Base measures ---

  measure: count {
    type: count
    label: "Total Admisiones"
    drill_fields: [patient_id, department, admission_date, discharge_date]
  }

  measure: total_billed {
    type: sum
    group_label: "KPIs"
    label: "Facturación Total"
    description: "Suma del monto total facturado por servicios hospitalarios"
    value_format_name: usd_0
    sql: ${total_bill_amount} ;;
    required_access_grants: [ver_financiero]
  }

  measure: avg_bill_amount {
    type: average
    group_label: "KPIs"
    label: "Facturación Promedio por Admisión"
    description: "Monto facturado promedio por paciente admitido"
    value_format_name: usd_0
    sql: ${total_bill_amount} ;;
    required_access_grants: [ver_financiero]
  }

  measure: avg_patient_age {
    type: average
    group_label: "Volumen"
    label: "Edad Promedio de Pacientes"
    description: "Promedio de edad de los pacientes atendidos"
    value_format_name: decimal_1
    sql: ${age} ;;
    required_access_grants: [ver_datos_clinicos]
  }

  # --- KPI measures ---

  measure: avg_length_of_stay {
    type: average
    group_label: "KPIs"
    label: "Estancia Promedio (Días)"
    description: "Promedio de días de estancia hospitalaria"
    value_format_name: decimal_1
    sql: ${length_of_stay_days} ;;
  }

  measure: total_patient_days {
    type: sum
    group_label: "Volumen"
    label: "Total Días Paciente"
    description: "Suma de todos los días de hospitalización acumulados"
    sql: ${length_of_stay_days} ;;
  }

  measure: insurance_covered_amount {
    type: sum
    group_label: "KPIs"
    label: "Monto Cubierto por Aseguradora"
    description: "Porción de la factura liquidada o cubierta por seguro"
    value_format_name: usd_0
    sql: ${total_bill_amount} * (${insurance_coverage_pct} / 100.0) ;;
    required_access_grants: [ver_financiero]
  }

  measure: patient_out_of_pocket {
    type: number
    group_label: "KPIs"
    label: "Gasto de Bolsillo Paciente"
    description: "Monto neto a cargo directo del paciente"
    value_format_name: usd_0
    sql: ${total_billed} - ${insurance_covered_amount} ;;
    required_access_grants: [ver_financiero]
  }

  measure: avg_insurance_coverage {
    type: average
    group_label: "Eficiencia"
    label: "Cobertura Promedio de Seguro (%)"
    description: "Porcentaje promedio de cobertura asegurada"
    value_format_name: percent_0
    sql: ${insurance_coverage_pct} / 100.0 ;;
    required_access_grants: [ver_financiero]
  }

  measure: pending_amount {
    type: sum
    group_label: "Riesgo"
    label: "Monto Pendiente de Cobro"
    description: "Monto facturado con pago pendiente o parcial"
    value_format_name: usd_0
    sql: ${total_bill_amount} ;;
    filters: [payment_status: "Pending,Partially Paid"]
    required_access_grants: [ver_financiero]
  }

  measure: paid_amount {
    type: sum
    hidden: yes
    sql: ${total_bill_amount} ;;
    filters: [payment_status: "Paid"]
    required_access_grants: [ver_financiero]
  }

  measure: collection_rate_pct {
    type: number
    group_label: "Eficiencia"
    label: "Tasa de Cobro (%)"
    description: "Porcentaje del monto facturado efectivamente cobrado (Paid)"
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${paid_amount}, ${total_billed}) ;;
    required_access_grants: [ver_financiero]
  }

  measure: revenue_per_patient_day {
    type: number
    group_label: "Eficiencia"
    label: "Ingreso por Día Paciente"
    description: "Facturación total dividida entre el total de días paciente"
    value_format_name: usd_0
    sql: SAFE_DIVIDE(${total_billed}, ${total_patient_days}) ;;
    required_access_grants: [ver_financiero]
  }
}

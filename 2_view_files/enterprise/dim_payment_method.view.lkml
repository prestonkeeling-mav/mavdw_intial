# Purpose: Exposes MAVDW payment method reference values for payment reporting and joins from transaction facts.
# Source: MAVDW enterprise.Dim_Payment_Method
# Grain: One row per Dim_Payment_Method_Key.
# Primary Key: dim_payment_method_key
# Refresh: Follows the MAVDW enterprise.Dim_Payment_Method refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal, no known PII.
# Known Limitations: Payment method code and description definitions should be validated with the data owner before production release.

view: dim_payment_method {
  sql_table_name: enterprise.Dim_Payment_Method ;;
  view_label: "Payment Method"

  set: payment_method_detail {
    fields: [dim_payment_method_key, payment_method_code, payment_method_description]
  }

  dimension: dim_payment_method_key {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    label: "Payment Method Key"
    group_label: "Keys & IDs"
    description: "Surrogate key for one payment method dimension row from enterprise.Dim_Payment_Method."
    sql: ${TABLE}.[Dim_Payment_Method_Key] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this payment method row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension: payment_method_code {
    type: string
    label: "Payment Method Code"
    group_label: "Payment Method"
    description: "Source payment method code used to classify the tender or payment method."
    sql: ${TABLE}.[Payment_Method_Code] ;;
  }

  dimension: payment_method_description {
    type: string
    label: "Payment Method Description"
    group_label: "Payment Method"
    description: "Business-readable description of the payment method code."
    sql: ${TABLE}.[Payment_Method_Description] ;;
  }

  measure: count {
    type: count
    label: "Payment Method Count"
    group_label: "Measures"
    description: "Count of payment method dimension rows."
    drill_fields: [payment_method_detail*]
    value_format: "#,##0"
  }
}

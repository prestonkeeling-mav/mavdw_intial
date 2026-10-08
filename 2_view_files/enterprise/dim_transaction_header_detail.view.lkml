# Purpose: Exposes MAVDW transaction header detail attributes for transaction status, channel, correction type, made-to-order, and fuel prepay reporting.
# Source: MAVDW enterprise.Dim_Transaction_Header_Detail
# Grain: One row per Dim_Transaction_Header_Detail_Key.
# Primary Key: dim_transaction_header_detail_key
# Refresh: Follows the MAVDW enterprise.Dim_Transaction_Header_Detail refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal, no known PII.
# Known Limitations: Transaction status, correction type, and indicator definitions should be validated with the data owner before production release.

view: dim_transaction_header_detail {
  sql_table_name: enterprise.Dim_Transaction_Header_Detail ;;
  view_label: "Transaction Header Detail"

  set: transaction_header_detail {
    fields: [dim_transaction_header_detail_key, transaction_status_group, transaction_status_code, transaction_status_description, transaction_channel]
  }

  dimension: dim_transaction_header_detail_key {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    label: "Transaction Header Detail Key"
    group_label: "Keys & IDs"
    description: "Surrogate key for one transaction header detail dimension row."
    sql: ${TABLE}.[Dim_Transaction_Header_Detail_Key] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this transaction header detail row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension: transaction_status_group {
    type: string
    label: "Transaction Status Group"
    group_label: "Transaction Status"
    description: "High-level transaction status group assigned to the transaction header."
    sql: ${TABLE}.[Transaction_Status_Group] ;;
  }

  dimension: transaction_status_code {
    type: string
    label: "Transaction Status Code"
    group_label: "Transaction Status"
    description: "Source transaction status code assigned to the transaction header."
    sql: ${TABLE}.[Transaction_Status_Code] ;;
  }

  dimension: transaction_status_description {
    type: string
    label: "Transaction Status Description"
    group_label: "Transaction Status"
    description: "Business-readable transaction status description assigned to the transaction header."
    sql: ${TABLE}.[Transaction_Status_Description] ;;
  }

  dimension: made_to_order_indicator {
    type: string
    label: "Made To Order Indicator"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the transaction header is associated with made-to-order activity. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Made_To_Order_Indicator] ;;
  }

  dimension: corrected_transaction_type_code {
    type: string
    label: "Corrected Transaction Type Code"
    group_label: "Correction Attributes"
    description: "Source corrected transaction type code assigned to the transaction header."
    sql: ${TABLE}.[Corrected_Transaction_Type_Code] ;;
  }

  dimension: corrected_transaction_type_description {
    type: string
    label: "Corrected Transaction Type Description"
    group_label: "Correction Attributes"
    description: "Business-readable corrected transaction type description assigned to the transaction header."
    sql: ${TABLE}.[Corrected_Transaction_Type_Description] ;;
  }

  dimension: transaction_channel {
    type: string
    label: "Transaction Channel"
    group_label: "Transaction Attributes"
    description: "Channel through which the transaction was processed."
    sql: ${TABLE}.[Transaction_Channel] ;;
  }

  dimension: fuel_prepay_indicator {
    type: string
    label: "Fuel Prepay Indicator"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the transaction header is associated with fuel prepay activity. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Fuel_Prepay_Indicator] ;;
  }

  measure: count {
    type: count
    label: "Transaction Header Detail Count"
    group_label: "Measures"
    description: "Count of transaction header detail dimension rows."
    drill_fields: [transaction_header_detail*]
    value_format: "#,##0"
  }
}

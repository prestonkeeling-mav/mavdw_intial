# Purpose: Exposes MAVDW transaction line detail attributes for line status, void, price override, correction type, channel, and fuel prepay reporting.
# Source: MAVDW enterprise.Dim_Transaction_Line_Detail
# Grain: One row per Dim_Transaction_Line_Detail_Key.
# Primary Key: dim_transaction_line_detail_key
# Refresh: Follows the MAVDW enterprise.Dim_Transaction_Line_Detail refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal, no known PII.
# Known Limitations: Void, price override, correction type, and indicator definitions should be validated with the data owner before production release.

view: dim_transaction_line_detail {
  sql_table_name: enterprise.Dim_Transaction_Line_Detail ;;
  view_label: "Transaction Line Detail"

  set: transaction_line_detail {
    fields: [dim_transaction_line_detail_key, transaction_status_group, transaction_status_code, transaction_status_description, transaction_channel, price_override_reason]
  }

  dimension: dim_transaction_line_detail_key {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    label: "Transaction Line Detail Key"
    group_label: "Keys & IDs"
    description: "Surrogate key for one transaction line detail dimension row."
    sql: ${TABLE}.[Dim_Transaction_Line_Detail_Key] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this transaction line detail row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension: transaction_status_group {
    type: string
    label: "Transaction Status Group"
    group_label: "Transaction Status"
    description: "High-level transaction status group assigned to the transaction line."
    sql: ${TABLE}.[Transaction_Status_Group] ;;
  }

  dimension: transaction_status_code {
    type: string
    label: "Transaction Status Code"
    group_label: "Transaction Status"
    description: "Source transaction status code assigned to the transaction line."
    sql: ${TABLE}.[Transaction_Status_Code] ;;
  }

  dimension: transaction_status_description {
    type: string
    label: "Transaction Status Description"
    group_label: "Transaction Status"
    description: "Business-readable transaction status description assigned to the transaction line."
    sql: ${TABLE}.[Transaction_Status_Description] ;;
  }

  dimension: is_void {
    type: string
    label: "Void"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the transaction line is void. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Void] ;;
  }

  dimension: was_voided {
    type: string
    label: "Was Voided"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the transaction line was voided. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Was_Voided] ;;
  }

  dimension: price_override_code {
    type: number
    value_format_name: id
    label: "Price Override Code"
    group_label: "Price Override"
    description: "Source price override code assigned to the transaction line, when available."
    sql: ${TABLE}.[Price_Override_Code] ;;
  }

  dimension: price_override_reason {
    type: string
    label: "Price Override Reason"
    group_label: "Price Override"
    description: "Business-readable reason for the price override on the transaction line."
    sql: ${TABLE}.[Price_Override_Reason] ;;
  }

  dimension: is_price_override {
    type: string
    label: "Price Override"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the transaction line had a price override. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Price_Override] ;;
  }

  dimension: corrected_transaction_type_code {
    type: string
    label: "Corrected Transaction Type Code"
    group_label: "Correction Attributes"
    description: "Source corrected transaction type code assigned to the transaction line."
    sql: ${TABLE}.[Corrected_Transaction_Type_Code] ;;
  }

  dimension: corrected_transaction_type_description {
    type: string
    label: "Corrected Transaction Type Description"
    group_label: "Correction Attributes"
    description: "Business-readable corrected transaction type description assigned to the transaction line."
    sql: ${TABLE}.[Corrected_Transaction_Type_Description] ;;
  }

  dimension: transaction_channel {
    type: string
    label: "Transaction Channel"
    group_label: "Transaction Attributes"
    description: "Channel through which the transaction line was processed."
    sql: ${TABLE}.[Transaction_Channel] ;;
  }

  dimension: fuel_prepay_indicator {
    type: string
    label: "Fuel Prepay Indicator"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the transaction line is associated with fuel prepay activity. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Fuel_Prepay_Indicator] ;;
  }

  measure: count {
    type: count
    label: "Transaction Line Detail Count"
    group_label: "Measures"
    description: "Count of transaction line detail dimension rows."
    drill_fields: [transaction_line_detail*]
    value_format: "#,##0"
  }
}

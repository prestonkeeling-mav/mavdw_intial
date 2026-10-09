# Purpose: Exposes MAVDW LZ transaction header fact rows for transaction-level sales totals, tax totals, duration, and dimensional joins.
# Source: MAVDW enterprise.Fact_LZ_Transaction_Header
# Grain: One row per transaction number and site ID in the LZ transaction header source.
# Primary Key: transaction_header_key
# Refresh: Follows the MAVDW enterprise.Fact_LZ_Transaction_Header refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal; no known direct PII in the provided metadata.
# Known Limitations: The source metadata does not provide a single physical primary key. This view defines a composite LookML primary key from Transaction_Number and Site_Id; validate uniqueness before production release.

view: fact_lz_transaction_header {
  sql_table_name: MAVDW.enterprise.Fact_LZ_Transaction_Header ;;
  view_label: "LZ Transaction Header"

  set: transaction_header_detail {
    fields: [
      transaction_number,
      site_id,
      transaction_date_date,
      business_date_date,
      transaction_time_key,
      terminal_id,
      transaction_total_amount,
      sales_tax_total_amount,
      transaction_duration
    ]
  }

  dimension: transaction_header_key {
    primary_key: yes
    hidden: yes
    type: string
    label: "Transaction Header Key"
    group_label: "Keys & IDs"
    description: "Composite LookML key created from Transaction Number and Site ID because the source metadata does not include a single transaction header surrogate key. Validate uniqueness before production use."
    sql: CONCAT(CAST(${TABLE}.[Transaction_Number] AS varchar(32)), '|', CAST(${TABLE}.[Site_Id] AS varchar(16))) ;;
  }

  dimension: transaction_number {
    type: number
    value_format_name: id
    label: "Transaction Number"
    group_label: "Keys & IDs"
    description: "Transaction number from the LZ transaction header fact."
    sql: ${TABLE}.[Transaction_Number] ;;
  }

  dimension: site_id {
    type: number
    value_format_name: id
    label: "Site ID"
    group_label: "Keys & IDs"
    description: "Site identifier associated with the transaction header."
    sql: ${TABLE}.[Site_Id] ;;
  }

  dimension: dim_organization_key {
    type: number
    value_format_name: id
    label: "Organization Dimension Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the organization dimension row associated with the transaction header."
    sql: ${TABLE}.[Dim_Organization_Key] ;;
  }

  dimension: dim_transaction_header_detail_key {
    type: number
    value_format_name: id
    label: "Transaction Header Detail Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the transaction header detail dimension row."
    sql: ${TABLE}.[Dim_Transaction_Header_Detail_Key] ;;
  }

  dimension: terminal_id {
    type: number
    value_format_name: id
    label: "Terminal ID"
    group_label: "Keys & IDs"
    description: "Terminal identifier associated with the transaction header, when available."
    sql: ${TABLE}.[Terminal_Id] ;;
  }

  dimension_group: transaction_date {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Transaction Date"
    group_label: "Transaction Dates"
    description: "Calendar date when the transaction occurred."
    sql: ${TABLE}.[Transaction_Date_Key] ;;
  }

  dimension_group: business_date {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Business Date"
    group_label: "Transaction Dates"
    description: "Business date associated with the transaction header, when available."
    sql: ${TABLE}.[Business_Date_Key] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this transaction header row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension: transaction_time_key {
    type: string
    label: "Transaction Time Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the time dimension value associated with the transaction header, modeled as a string to preserve time-key behavior."
    sql: CAST(${TABLE}.[Transaction_Time_Key] AS varchar(16)) ;;
  }

  dimension: transaction_total_amount {
    type: number
    value_format_name: usd
    label: "Transaction Total Amount"
    group_label: "Amounts"
    description: "Transaction total amount recorded on the header row."
    sql: ${TABLE}.[Transaction_Total_Amount] ;;
  }

  dimension: sales_tax_total_amount {
    type: number
    value_format_name: usd
    label: "Sales Tax Total Amount"
    group_label: "Amounts"
    description: "Sales tax total amount recorded on the transaction header row."
    sql: ${TABLE}.[Sales_Tax_Total_Amount] ;;
  }

  dimension: transaction_duration {
    type: number
    label: "Transaction Duration"
    group_label: "Transaction Attributes"
    description: "Duration recorded for the transaction header. Confirm the unit of measure before production use."
    sql: ${TABLE}.[Transaction_Duration] ;;
  }

  measure: count {
    type: count
    label: "Transaction Header Row Count"
    group_label: "Measures"
    description: "Count of LZ transaction header fact rows."
    drill_fields: [transaction_header_detail*]
    value_format: "#,##0"
  }

  measure: count_distinct_transactions {
    type: count_distinct
    sql: ${transaction_header_key} ;;
    label: "Distinct Transaction Count"
    group_label: "Measures"
    description: "Distinct count of transaction headers based on the composite transaction header key."
    drill_fields: [transaction_header_detail*]
    value_format: "#,##0"
  }

  measure: total_transaction_amount {
    type: sum
    sql: ${transaction_total_amount} ;;
    label: "Total Transaction Amount"
    group_label: "Measures"
    description: "Total transaction amount summed across transaction header rows."
    value_format_name: usd
  }

  measure: total_sales_tax_amount {
    type: sum
    sql: ${sales_tax_total_amount} ;;
    label: "Total Sales Tax Amount"
    group_label: "Measures"
    description: "Total sales tax amount summed across transaction header rows."
    value_format_name: usd
  }
}

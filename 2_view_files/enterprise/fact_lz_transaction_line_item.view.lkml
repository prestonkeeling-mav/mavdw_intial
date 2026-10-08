# Purpose: Exposes MAVDW LZ transaction line item fact rows for item-level sales quantity, extended retail price, and dimensional joins.
# Source: MAVDW enterprise.Fact_LZ_Transaction_Line_Item
# Grain: One row per transaction number, site ID, and transaction line number in the LZ transaction line item source.
# Primary Key: transaction_line_item_key
# Refresh: Follows the MAVDW enterprise.Fact_LZ_Transaction_Line_Item refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal; no known direct PII in the provided metadata.
# Known Limitations: The source metadata does not provide a single physical primary key. This view defines a composite LookML primary key from Transaction_Number, Site_Id, and Transaction_Line_Number; validate uniqueness before production release.

view: fact_lz_transaction_line_item {
  sql_table_name: enterprise.Fact_LZ_Transaction_Line_Item ;;
  view_label: "LZ Transaction Line Item"

  set: transaction_line_item_detail {
    fields: [
      transaction_number,
      site_id,
      transaction_line_number,
      transaction_date_date,
      business_date_date,
      transaction_time_key,
      dim_product_key,
      dim_product_upc_key,
      sales_quantity,
      extended_retail_price
    ]
  }

  dimension: transaction_line_item_key {
    primary_key: yes
    hidden: yes
    type: string
    label: "Transaction Line Item Key"
    group_label: "Keys & IDs"
    description: "Composite LookML key created from Transaction Number, Site ID, and Transaction Line Number because the source metadata does not include a single transaction line surrogate key. Validate uniqueness before production use."
    sql: CONCAT(CAST(${TABLE}.[Transaction_Number] AS varchar(32)), '|', CAST(${TABLE}.[Site_Id] AS varchar(16)), '|', CAST(${TABLE}.[Transaction_Line_Number] AS varchar(16))) ;;
  }

  dimension: transaction_number {
    type: number
    value_format_name: id
    label: "Transaction Number"
    group_label: "Keys & IDs"
    description: "Transaction number from the LZ transaction line item fact."
    sql: ${TABLE}.[Transaction_Number] ;;
  }

  dimension: site_id {
    type: number
    value_format_name: id
    label: "Site ID"
    group_label: "Keys & IDs"
    description: "Site identifier associated with the transaction line item."
    sql: ${TABLE}.[Site_Id] ;;
  }

  dimension: transaction_line_number {
    type: number
    value_format_name: id
    label: "Transaction Line Number"
    group_label: "Keys & IDs"
    description: "Line number within the transaction."
    sql: ${TABLE}.[Transaction_Line_Number] ;;
  }

  dimension: dim_organization_key {
    type: number
    value_format_name: id
    label: "Organization Dimension Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the organization dimension row associated with the transaction line item."
    sql: ${TABLE}.[Dim_Organization_Key] ;;
  }

  dimension: dim_product_key {
    type: number
    value_format_name: id
    label: "Product Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the product dimension row associated with the transaction line item."
    sql: ${TABLE}.[Dim_Product_Key] ;;
  }

  dimension: dim_product_upc_key {
    type: number
    value_format_name: id
    label: "Product UPC Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the product UPC dimension row associated with the transaction line item."
    sql: ${TABLE}.[Dim_Product_UPC_Key] ;;
  }

  dimension: dim_transaction_line_detail_key {
    type: number
    value_format_name: id
    label: "Transaction Line Detail Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the transaction line detail dimension row."
    sql: ${TABLE}.[Dim_Transaction_Line_Detail_Key] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this transaction line item row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension_group: transaction_date {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Transaction Date"
    group_label: "Transaction Dates"
    description: "Calendar date when the transaction line item occurred."
    sql: ${TABLE}.[Transaction_Date_Key] ;;
  }

  dimension_group: business_date {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Business Date"
    group_label: "Transaction Dates"
    description: "Business date associated with the transaction line item, when available."
    sql: ${TABLE}.[Business_Date_Key] ;;
  }

  dimension: transaction_time_key {
    type: string
    label: "Transaction Time Key"
    group_label: "Keys & IDs"
    description: "Foreign key to the time dimension value associated with the transaction line item, modeled as a string to preserve time-key behavior."
    sql: CAST(${TABLE}.[Transaction_Time_Key] AS varchar(16)) ;;
  }

  dimension: sales_quantity {
    type: number
    label: "Sales Quantity"
    group_label: "Sales"
    description: "Sales quantity recorded on the transaction line item."
    sql: ${TABLE}.[Sales_Quantity] ;;
  }

  dimension: extended_retail_price {
    type: number
    value_format_name: usd
    label: "Extended Retail Price"
    group_label: "Sales"
    description: "Extended retail price recorded on the transaction line item."
    sql: ${TABLE}.[Extended_Retail_Price] ;;
  }

  measure: count {
    type: count
    label: "Transaction Line Item Row Count"
    group_label: "Measures"
    description: "Count of LZ transaction line item fact rows."
    drill_fields: [transaction_line_item_detail*]
    value_format: "#,##0"
  }

  measure: count_distinct_transaction_line_items {
    type: count_distinct
    sql: ${transaction_line_item_key} ;;
    label: "Distinct Transaction Line Item Count"
    group_label: "Measures"
    description: "Distinct count of transaction line items based on the composite transaction line item key."
    drill_fields: [transaction_line_item_detail*]
    value_format: "#,##0"
  }

  measure: total_sales_quantity {
    type: sum
    sql: ${sales_quantity} ;;
    label: "Total Sales Quantity"
    group_label: "Measures"
    description: "Total sales quantity summed across transaction line item rows."
    value_format: "#,##0"
  }

  measure: total_extended_retail_price {
    type: sum
    sql: ${extended_retail_price} ;;
    label: "Total Extended Retail Price"
    group_label: "Measures"
    description: "Total extended retail price summed across transaction line item rows."
    value_format_name: usd
  }
}

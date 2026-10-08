# Purpose: Exposes MAVDW product UPC attributes for product barcode reporting and joins from transaction line facts.
# Source: MAVDW enterprise.Dim_Product_UPC
# Grain: One row per Dim_Product_UPC_Key.
# Primary Key: dim_product_upc_key
# Refresh: Follows the MAVDW enterprise.Dim_Product_UPC refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal, no known PII.
# Known Limitations: UPC status flags and barcode formats should be validated with the data owner before production release.

view: dim_product_upc {
  sql_table_name: enterprise.Dim_Product_UPC ;;
  view_label: "Product UPC"

  set: product_upc_detail {
    fields: [dim_product_upc_key, item_upc_key, ent_product_id, item_number, item_upc_normalized, item_upc_gtin_14]
  }

  dimension: dim_product_upc_key {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    label: "Product UPC Key"
    group_label: "Keys & IDs"
    description: "Surrogate key for one product UPC dimension row from enterprise.Dim_Product_UPC."
    sql: ${TABLE}.[Dim_Product_UPC_Key] ;;
  }

  dimension: item_upc_key {
    type: number
    value_format_name: id
    label: "Item UPC Key"
    group_label: "Keys & IDs"
    description: "Source item UPC key associated with the product UPC."
    sql: ${TABLE}.[Item_UPC_Key] ;;
  }

  dimension: ent_product_upc_id {
    type: number
    value_format_name: id
    label: "Enterprise Product UPC ID"
    group_label: "Keys & IDs"
    description: "Enterprise product UPC identifier."
    sql: ${TABLE}.[Ent_Product_UPC_Id] ;;
  }

  dimension: ent_product_id {
    type: number
    value_format_name: id
    label: "Enterprise Product ID"
    group_label: "Keys & IDs"
    description: "Enterprise product identifier associated with the UPC."
    sql: ${TABLE}.[Ent_Product_Id] ;;
  }

  dimension: item_number {
    type: string
    label: "Item Number"
    group_label: "Keys & IDs"
    description: "Business item number associated with the UPC."
    sql: ${TABLE}.[Item_Number] ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Updated"
    group_label: "Audit & Metadata"
    description: "Timestamp when this product UPC row was last updated in MAVDW."
    sql: ${TABLE}.[Updated_Datetime] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this product UPC row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension: retail_package_code {
    type: string
    label: "Retail Package Code"
    group_label: "UPC Attributes"
    description: "Retail package code associated with the item UPC."
    sql: ${TABLE}.[RtlPkg_Code] ;;
  }

  dimension: item_upc_number {
    type: string
    label: "Item UPC Number"
    group_label: "UPC Attributes"
    description: "Numeric UPC value associated with the item, modeled as a string to preserve identifier behavior."
    sql: CAST(${TABLE}.[Item_UPC_Number] AS varchar(32)) ;;
  }

  dimension: item_upc_normalized {
    type: string
    label: "Normalized Item UPC"
    group_label: "UPC Attributes"
    description: "Normalized UPC value associated with the item."
    sql: ${TABLE}.[Item_UPC_Normalized] ;;
  }

  dimension: item_upc_without_check_digit {
    type: string
    label: "Item UPC Without Check Digit"
    group_label: "UPC Attributes"
    description: "UPC value without the check digit."
    sql: ${TABLE}.[Item_UPC_Without_Check_Digit] ;;
  }

  dimension: item_upc_check_digit {
    type: string
    label: "Item UPC Check Digit"
    group_label: "UPC Attributes"
    description: "Check digit for the item UPC."
    sql: ${TABLE}.[Item_UPC_Check_Digit] ;;
  }

  dimension: item_upc_gtin_14 {
    type: string
    label: "Item UPC GTIN 14"
    group_label: "UPC Attributes"
    description: "GTIN-14 formatted UPC value associated with the item."
    sql: ${TABLE}.[Item_UPC_GTIN_14] ;;
  }

  dimension: item_upc_scan_modifier {
    type: number
    label: "Item UPC Scan Modifier"
    group_label: "UPC Attributes"
    description: "Scan modifier associated with the item UPC, when available."
    sql: ${TABLE}.[Item_UPC_Scan_Modifier] ;;
  }

  dimension_group: item_upc_discontinue {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Item UPC Discontinue"
    group_label: "UPC Dates"
    description: "Date the UPC was discontinued, when available."
    sql: ${TABLE}.[Item_UPC_Discontinue_Date] ;;
  }

  dimension: item_upc_ultralong_desc {
    type: string
    label: "Item UPC Long Description"
    group_label: "UPC Attributes"
    description: "Long description associated with the item UPC."
    sql: ${TABLE}.[Item_UPC_UltraLong_Desc] ;;
  }

  dimension: is_primary_upc {
    type: string
    label: "Primary UPC"
    group_label: "Flags & Filters"
    description: "Source indicator for whether this UPC is the primary UPC for the item. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Primary_UPC] ;;
  }

  dimension: is_discontinued_upc {
    type: string
    label: "Discontinued UPC"
    group_label: "Flags & Filters"
    description: "Source indicator for whether this UPC is discontinued. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Discontinued_UPC] ;;
  }

  dimension: is_active_upc_last_12_months {
    type: string
    label: "Active UPC Last 12 Months"
    group_label: "Flags & Filters"
    description: "Source indicator for whether this UPC was active in the last 12 months. Confirm values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Active_UPC_Last_12_Months] ;;
  }

  measure: count {
    type: count
    label: "Product UPC Count"
    group_label: "Measures"
    description: "Count of product UPC dimension rows."
    drill_fields: [product_upc_detail*]
    value_format: "#,##0"
  }
}

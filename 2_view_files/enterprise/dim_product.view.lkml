# Purpose: Exposes MAVDW product dimension attributes for item, package, department, category, brand, manufacturer, and product status reporting.
# Source: MAVDW enterprise.Dim_Product
# Grain: One row per Dim_Product_Key.
# Primary Key: dim_product_key
# Refresh: Follows the MAVDW enterprise.Dim_Product refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal, no known PII.
# Known Limitations: Product hierarchy definitions and text flag values should be validated with the data owner before production release.

view: dim_product {
  sql_table_name: enterprise.Dim_Product ;;
  view_label: "Product"

  set: product_detail {
    fields: [
      dim_product_key,
      ent_product_id,
      item_number,
      item_description,
      department_description,
      category_description,
      sub_category_description,
      item_brand_description,
      item_manufacturer_description
    ]
  }

  dimension: dim_product_key {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    label: "Product Key"
    group_label: "Keys & IDs"
    description: "Surrogate key for one product dimension row from enterprise.Dim_Product."
    sql: ${TABLE}.[Dim_Product_Key] ;;
  }

  dimension: ent_product_id {
    type: number
    value_format_name: id
    label: "Enterprise Product ID"
    group_label: "Keys & IDs"
    description: "Enterprise product identifier associated with the item."
    sql: ${TABLE}.[Ent_Product_Id] ;;
  }

  dimension: item_number {
    type: string
    label: "Item Number"
    group_label: "Keys & IDs"
    description: "Business item number used to identify the product."
    sql: ${TABLE}.[Item_Number] ;;
  }

  dimension: department_id {
    type: number
    value_format_name: id
    label: "Department ID"
    group_label: "Keys & IDs"
    description: "Department identifier assigned to the product."
    sql: ${TABLE}.[Department_Id] ;;
  }

  dimension: category_id {
    type: number
    value_format_name: id
    label: "Category ID"
    group_label: "Keys & IDs"
    description: "Category identifier assigned to the product."
    sql: ${TABLE}.[Category_Id] ;;
  }

  dimension: sub_category_id {
    type: number
    value_format_name: id
    label: "Subcategory ID"
    group_label: "Keys & IDs"
    description: "Subcategory identifier assigned to the product."
    sql: ${TABLE}.[Sub_Category_Id] ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Updated"
    group_label: "Audit & Metadata"
    description: "Timestamp when this product row was last updated in MAVDW."
    sql: ${TABLE}.[Updated_Datetime] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this product row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension: retail_package_code {
    type: string
    label: "Retail Package Code"
    group_label: "Product Attributes"
    description: "Retail package code associated with the item."
    sql: ${TABLE}.[Retail_Package_Code] ;;
  }

  dimension: item_description {
    type: string
    label: "Item Description"
    group_label: "Product Attributes"
    description: "Business-readable product or item description."
    sql: ${TABLE}.[Item_Description] ;;
  }

  dimension: retail_package_quantity {
    type: number
    label: "Retail Package Quantity"
    group_label: "Product Attributes"
    description: "Quantity associated with the retail package for the item."
    sql: ${TABLE}.[Retail_Package_Quantity] ;;
  }

  dimension: item_size_description {
    type: string
    label: "Item Size Description"
    group_label: "Product Attributes"
    description: "Business-readable size description for the item."
    sql: ${TABLE}.[Item_Size_Description] ;;
  }

  dimension: department_description {
    type: string
    label: "Department Description"
    group_label: "Product Hierarchy"
    description: "Business-readable department description assigned to the product."
    sql: ${TABLE}.[Department_Description] ;;
  }

  dimension: category_description {
    type: string
    label: "Category Description"
    group_label: "Product Hierarchy"
    description: "Business-readable category description assigned to the product."
    sql: ${TABLE}.[Category_Description] ;;
  }

  dimension: sub_category_description {
    type: string
    label: "Subcategory Description"
    group_label: "Product Hierarchy"
    description: "Business-readable subcategory description assigned to the product."
    sql: ${TABLE}.[Sub_Category_Description] ;;
  }

  dimension: item_brand_description {
    type: string
    label: "Item Brand Description"
    group_label: "Product Hierarchy"
    description: "Brand description assigned to the item."
    sql: ${TABLE}.[Item_Brand_Description] ;;
  }

  dimension: item_manufacturer_description {
    type: string
    label: "Item Manufacturer Description"
    group_label: "Product Hierarchy"
    description: "Manufacturer description assigned to the item."
    sql: ${TABLE}.[Item_Manufacturer_Description] ;;
  }

  dimension_group: item_created {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Item Created"
    group_label: "Product Dates"
    description: "Date the item was created, when available."
    sql: ${TABLE}.[Item_Created_Date] ;;
  }

  dimension_group: item_inactive {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Item Inactive"
    group_label: "Product Dates"
    description: "Date the item became inactive, when available."
    sql: ${TABLE}.[Item_Inactive_Date] ;;
  }

  dimension: is_active_product {
    type: string
    label: "Active Product"
    group_label: "Flags & Filters"
    description: "Source product active-status value. Confirm the expected values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Active_Product] ;;
  }

  dimension: is_sellable_package {
    type: string
    label: "Sellable Package"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the product package is sellable. Confirm the expected values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Sellable_Package] ;;
  }

  dimension: is_purchasable {
    type: string
    label: "Purchasable"
    group_label: "Flags & Filters"
    description: "Source indicator for whether the product is purchasable. Confirm the expected values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Purchasable] ;;
  }

  dimension: is_discontinued_item {
    type: string
    label: "Discontinued Item"
    group_label: "Flags & Filters"
    description: "Source discontinued-item indicator. Confirm the expected values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Discontinued_Item] ;;
  }

  dimension: is_coupon {
    type: string
    label: "Coupon"
    group_label: "Flags & Filters"
    description: "Source coupon indicator for the product. Confirm the expected values before converting to a yes/no dimension."
    sql: ${TABLE}.[Is_Coupon] ;;
  }

  measure: count {
    type: count
    label: "Product Count"
    group_label: "Measures"
    description: "Count of product dimension rows."
    drill_fields: [product_detail*]
    value_format: "#,##0"
  }
}

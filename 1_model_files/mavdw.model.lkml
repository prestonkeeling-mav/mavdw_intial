connection: "mavdw"


include: "/2_view_files/**/*.view.lkml"
#include: "/2_view_files/enterprise/fact_lz_transaction_header.view.lkml"
#include: "/2_view_files/enterprise/fact_lz_transaction_line_item.view.lkml"
week_start_day: friday
datagroup: no_caching_datagroup {
  max_cache_age: "0 seconds"
  sql_trigger: Select cast(getdate() as date) ;;
}
datagroup: daily_metrics_default_datagroup {
  max_cache_age: "24 hours"
  sql_trigger:  Select cast(dateadd(hour,+5,getdate()) as date) ;;
}
datagroup: daily {
  max_cache_age: "20 hours"
  sql_trigger:  select  cast(dateadd(hour,+5,getdate())+1 as date) ;;
}
access_grant: developer_access {
  user_attribute: readiness_status #This is for views/explores that we are not ready to move to reporting or ETL yet.
  allowed_values: [ "in development"]
}

named_value_format: cpg {
  value_format: "0.000 \" cpg\""
  strict_value_format: yes
}
named_value_format: hours {
  value_format:  "#,##0\" Hours\""
  strict_value_format: yes
}
named_value_format: accounting {
  value_format: "$#,###;($#,###)"
  strict_value_format: yes
}
named_value_format: millions {
  value_format: "0,,\" M\""
  strict_value_format: yes
}

# Purpose: Explore LZ transaction header activity with calendar, business date, transaction time, organization, and transaction header detail context.
# Base View: fact_lz_transaction_header.
# Base Grain: One row per transaction_header_key, a composite key built from transaction_number and site_id.
# Join Summary:
# - transaction_date: left_outer many_to_one to dim_date using transaction_date_date.
# - business_date: left_outer many_to_one to dim_date using business_date_date.
# - dim_time: left_outer many_to_one using transaction_time_key.
# - dim_organization: left_outer many_to_one using dim_organization_key.
# - dim_transaction_header_detail: left_outer many_to_one using dim_transaction_header_detail_key.
# Known Limitations:
# - New Explores require BI Manager approval under the workspace Explore standard.
# - Composite key uniqueness for fact_lz_transaction_header.transaction_header_key must be validated before production release.
# - Join cardinality, row counts, transaction amount totals, sales tax totals, LookML validation, SQL validation, and performance must be validated before production release.
# - Date joins use role-specific aliases of dim_date so users can distinguish transaction date from business date.

explore: fact_lz_transaction_header {
  label: "LZ Transaction Header"
  group_label: "Landing Zone"
  view_label: "LZ Transaction Header"
  description: "Analyze transaction-level LZ header activity, including transaction totals, sales tax totals, duration, terminal, organization, transaction date, business date, transaction time, status, channel, correction type, and fuel prepay context."
  fields: [ALL_FIELDS*]

  join: transaction_date {
    from: dim_date
    type: inner
    relationship: many_to_one
    view_label: "Transaction Date"
    sql_on: ${fact_lz_transaction_header.transaction_date_raw} = ${transaction_date.date_key} ;;
  }


  join: dim_time {
    type: inner
    relationship: many_to_one
    view_label: "Transaction Time"
    sql_on: ${fact_lz_transaction_header.transaction_time_key} = ${dim_time.time_key} ;;
  }

  join: dim_organization {
    type: inner
    relationship: many_to_one
    view_label: "Organization"
    sql_on: ${fact_lz_transaction_header.dim_organization_key} = ${dim_organization.dim_organization_key} ;;
  }
}

# Purpose: Explore LZ transaction line item activity with product, UPC, organization, date, time, line detail, and optional transaction header context.
# Base View: fact_lz_transaction_line_item.
# Base Grain: One row per transaction_line_item_key, a composite key built from transaction_number, site_id, and transaction_line_number.
# Join Summary:
# - transaction_date: left_outer many_to_one to dim_date using transaction_date_date.
# - business_date: left_outer many_to_one to dim_date using business_date_date.
# - dim_time: left_outer many_to_one using transaction_time_key.
# - dim_organization: left_outer many_to_one using dim_organization_key.
# - dim_product: left_outer many_to_one using dim_product_key.
# - dim_product_upc: left_outer many_to_one using dim_product_upc_key.
# - dim_transaction_line_detail: left_outer many_to_one using dim_transaction_line_detail_key.
# - transaction_header: left_outer many_to_one to fact_lz_transaction_header using transaction_number and site_id for header-level context.
# Known Limitations:
# - New Explores require BI Manager approval under the workspace Explore standard.
# - Composite key uniqueness for fact_lz_transaction_line_item.transaction_line_item_key must be validated before production release.
# - The transaction_header join depends on transaction_number and site_id being unique in fact_lz_transaction_header; validate cardinality before production release.
# - Join cardinality, row counts, sales quantity totals, extended retail price totals, LookML validation, SQL validation, and performance must be validated before production release.
# - Date joins use role-specific aliases of dim_date so users can distinguish transaction date from business date.

explore: fact_lz_transaction_line_item {
  label: "LZ Transaction Line Item"
  group_label: "Landing Zone"
  view_label: "LZ Transaction Line Item"
  description: "Analyze item-level LZ transaction line activity, including sales quantity, extended retail price, product, UPC, organization, transaction date, business date, transaction time, line status, void, price override, correction type, channel, fuel prepay, and optional transaction header context."
  fields: [ALL_FIELDS*]

  join: transaction_date {
    from: dim_date
    type: inner
    relationship: many_to_one
    view_label: "Transaction Date"
    sql_on: ${fact_lz_transaction_line_item.transaction_date_date} = ${transaction_date.date_key} ;;
  }

  join: business_date {
    from: dim_date
    type: inner
    relationship: many_to_one
    view_label: "Business Date"
    sql_on: ${fact_lz_transaction_line_item.business_date_date} = ${business_date.date_key} ;;
  }

  join: dim_time {
    type: inner
    relationship: many_to_one
    view_label: "Transaction Time"
    sql_on: ${fact_lz_transaction_line_item.transaction_time_key} = ${dim_time.time_key} ;;
  }

  join: dim_organization {
    type: inner
    relationship: many_to_one
    view_label: "Organization"
    sql_on: ${fact_lz_transaction_line_item.dim_organization_key} = ${dim_organization.dim_organization_key} ;;
  }

  join: dim_product {
    type: inner
    relationship: many_to_one
    view_label: "Product"
    sql_on: ${fact_lz_transaction_line_item.dim_product_key} = ${dim_product.dim_product_key} ;;
  }

  join: dim_product_upc {
    type: inner
    relationship: many_to_one
    view_label: "Product UPC"
    sql_on: ${fact_lz_transaction_line_item.dim_product_upc_key} = ${dim_product_upc.dim_product_upc_key} ;;
  }

  join: dim_transaction_line_detail {
    type: inner
    relationship: many_to_one
    view_label: "Transaction Line Detail"
    sql_on: ${fact_lz_transaction_line_item.dim_transaction_line_detail_key} = ${dim_transaction_line_detail.dim_transaction_line_detail_key} ;;
  }

  join: transaction_header {
    from: fact_lz_transaction_header
    type: inner
    relationship: many_to_one
    view_label: "Transaction Header"
    sql_on:
      ${fact_lz_transaction_line_item.transaction_number} = ${transaction_header.transaction_number}
      AND ${fact_lz_transaction_line_item.site_id} = ${transaction_header.site_id} ;;
  }
}

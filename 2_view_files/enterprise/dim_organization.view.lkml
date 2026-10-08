# Purpose: Exposes MAVDW organization dimension attributes for site, hierarchy, location, store attribute, pricing, food service, and business entity reporting.
# Source: MAVDW enterprise.dim_organization
# Grain: One row per Dim_Organization_Key, representing one effective-dated organization dimension version.
# Primary Key: dim_organization_key
# Refresh: Follows the MAVDW enterprise.dim_organization refresh cadence; confirm the production cadence with the data owner.
# Data Owner: TBD
# Security Classification: Internal; includes site address and phone attributes but no known direct personal PII. Confirm classification before production release.
# Known Limitations: This view includes historical and current dimension versions. Use is_current_record or effective date fields when an analysis requires current-state organization attributes.

view: dim_organization {
  sql_table_name: enterprise.dim_organization ;;
  view_label: "Organization"

  set: organization_detail {
    fields: [
      dim_organization_key,
      site_id,
      site_description,
      site_type,
      operating_status,
      effective_start_date,
      effective_end_date,
      is_current_record,
      assigned_region_name,
      assigned_district_name,
      city,
      state,
      business_entity_name
    ]
  }

  dimension: dim_organization_key {
    primary_key: yes
    hidden: yes
    type: number
    value_format_name: id
    label: "Organization Dimension Key"
    group_label: "Keys & IDs"
    description: "Surrogate key for one effective-dated organization dimension row from enterprise.dim_organization. This is the primary key for this LookML view and should be unique and non-null at the documented grain."
    sql: ${TABLE}.[Dim_Organization_Key] ;;
  }

  dimension: site_id {
    type: number
    value_format_name: id
    label: "Site ID"
    group_label: "Keys & IDs"
    description: "Numeric site identifier for the organization. A site can have multiple organization dimension rows over time when effective-dated attributes change."
    sql: ${TABLE}.[Site_Id] ;;
  }

  dimension: trade_partner_id {
    type: number
    value_format_name: id
    label: "Trade Partner ID"
    group_label: "Keys & IDs"
    description: "Identifier for the trade partner associated with the organization, when one is assigned."
    sql: ${TABLE}.[Trade_Partner_Id] ;;
  }

  dimension: assigned_region_id {
    type: string
    label: "Assigned Region ID"
    group_label: "Keys & IDs"
    description: "Identifier for the currently assigned region hierarchy value on this organization dimension version."
    sql: ${TABLE}.[Assigned_Region_Id] ;;
  }

  dimension: assigned_district_id {
    type: string
    label: "Assigned District ID"
    group_label: "Keys & IDs"
    description: "Identifier for the currently assigned district hierarchy value on this organization dimension version."
    sql: ${TABLE}.[Assigned_District_Id] ;;
  }

  dimension: assigned_functional_id {
    type: string
    label: "Assigned Functional ID"
    group_label: "Keys & IDs"
    description: "Identifier for the currently assigned functional hierarchy value on this organization dimension version."
    sql: ${TABLE}.[Assigned_Functional_Id] ;;
  }

  dimension: region_id {
    type: string
    label: "Region ID"
    group_label: "Keys & IDs"
    description: "Region identifier associated with the organization dimension row. Use Region Description for the business-readable region name."
    sql: ${TABLE}.[Region_Id] ;;
  }

  dimension: district_id {
    type: string
    label: "District ID"
    group_label: "Keys & IDs"
    description: "District identifier associated with the organization dimension row. Use District Description for the business-readable district name."
    sql: ${TABLE}.[District_Id] ;;
  }

  dimension: layout_id {
    type: string
    label: "Layout ID"
    group_label: "Keys & IDs"
    description: "Identifier for the store layout assigned to the site for this organization dimension version."
    sql: ${TABLE}.[Layout_Id] ;;
  }

  dimension: distribution_id {
    type: string
    label: "Distribution ID"
    group_label: "Keys & IDs"
    description: "Planning and budgeting distribution identifier assigned to the site."
    sql: ${TABLE}.[Distribution_Id] ;;
  }

  dimension: food_service_program_id {
    type: string
    label: "Food Service Program ID"
    group_label: "Keys & IDs"
    description: "Identifier for the food service program assigned to the site."
    sql: ${TABLE}.[Food_Service_Program_Id] ;;
  }

  dimension: food_service_kps_id {
    type: string
    label: "Food Service KPS ID"
    group_label: "Keys & IDs"
    description: "Planning and budgeting food service KPS identifier assigned to the site."
    sql: ${TABLE}.[Food_Service_KPS_Id] ;;
  }

  dimension: price_zone_id {
    type: string
    label: "Price Zone ID"
    group_label: "Keys & IDs"
    description: "Identifier for the general price zone assigned to the site."
    sql: ${TABLE}.[Price_Zone_Id] ;;
  }

  dimension: cigarette_price_zone_id {
    type: string
    label: "Cigarette Price Zone ID"
    group_label: "Keys & IDs"
    description: "Identifier for the cigarette price zone assigned to the site."
    sql: ${TABLE}.[Cigarette_Price_Zone_Id] ;;
  }

  dimension: city_sales_tax_id {
    type: string
    label: "City Sales Tax ID"
    group_label: "Keys & IDs"
    description: "Planning and budgeting identifier for the site's city sales tax assignment."
    sql: ${TABLE}.[City_Sales_Tax_Id] ;;
  }

  dimension: business_entity_id {
    type: string
    label: "Business Entity ID"
    group_label: "Keys & IDs"
    description: "Identifier for the legal or operating business entity associated with the site."
    sql: ${TABLE}.[Business_Entity_Id] ;;
  }

  dimension: site_description {
    type: string
    label: "Site Description"
    group_label: "Organization Details"
    description: "Business-readable name or description of the site."
    sql: ${TABLE}.[Site_Description] ;;
  }

  dimension: site_type {
    type: string
    label: "Site Type"
    group_label: "Organization Details"
    description: "Business classification of the site, such as Retail, Wholesale, or Unknown in the provided sample data."
    sql: ${TABLE}.[Site_Type] ;;
  }

  dimension: operating_status {
    type: string
    label: "Operating Status"
    group_label: "Organization Details"
    description: "Operating status assigned to the site, such as Open, Closed, Admin, Truck and Trailer, or Unknown in the provided sample data."
    sql: ${TABLE}.[Operating_Status] ;;
  }

  dimension: comparable_store_type {
    type: string
    label: "Comparable Store Type"
    group_label: "Organization Details"
    description: "Comparable-store classification used for reporting comparisons, such as Same, Closed, Other Retail, PY Rebuild, CY Rebuild, Wholesale, or Unknown in the provided sample data."
    sql: ${TABLE}.[Comparable_Store_Type] ;;
  }

  dimension: retail_site_status {
    type: string
    label: "Retail Site Status"
    group_label: "Organization Details"
    description: "Retail site status value for the organization dimension row. The provided sample data only contained null values, so confirm expected production values before relying on this field."
    sql: ${TABLE}.[Retail_Site_Status] ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Updated"
    group_label: "Audit & Metadata"
    description: "Timestamp when this organization dimension row was last updated in MAVDW."
    sql: ${TABLE}.[Updated_Datetime] ;;
  }

  dimension_group: loaded {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    label: "Loaded"
    group_label: "Audit & Metadata"
    description: "Timestamp when this organization dimension row was loaded into MAVDW."
    sql: ${TABLE}.[Load_Datetime] ;;
  }

  dimension_group: effective_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Effective Start"
    group_label: "Dimension History"
    description: "Date this effective-dated organization dimension version became active."
    sql: ${TABLE}.[Effective_Start_Date] ;;
  }

  dimension_group: effective_end {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Effective End"
    group_label: "Dimension History"
    description: "Date this effective-dated organization dimension version stopped being active. This is null for current rows in the provided sample data."
    sql: ${TABLE}.[Effective_End_Date] ;;
  }

  dimension_group: open {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Open"
    group_label: "Operating Dates"
    description: "Date the site opened for business, when available."
    sql: ${TABLE}.[Open_Date] ;;
  }

  dimension_group: closing {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Closing"
    group_label: "Operating Dates"
    description: "Recorded closing date for the site, when available."
    sql: ${TABLE}.[Closing_Date] ;;
  }

  dimension_group: store_closed_to_public {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Store Closed To Public"
    group_label: "Operating Dates"
    description: "Date the store closed to the public, when available."
    sql: ${TABLE}.[Store_Closed_To_Public_Date] ;;
  }

  dimension_group: rebrand_open {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Rebrand Open"
    group_label: "Operating Dates"
    description: "Date the site opened under its current brand following a rebrand, when available."
    sql: ${TABLE}.[Rebrand_Open_Date] ;;
  }

  dimension_group: cp_project_end {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Capital Project End"
    group_label: "Capital Projects"
    description: "End date of the capital project associated with the site, when available."
    sql: ${TABLE}.[CP_Project_End_Date] ;;
  }

  dimension: cp_last_major_project {
    type: string
    label: "Last Major Capital Project"
    group_label: "Capital Projects"
    description: "Description or classification of the site's most recent major capital project."
    sql: ${TABLE}.[CP_Last_Major_Project] ;;
  }

  dimension: is_current_record {
    type: yesno
    label: "Current Record"
    group_label: "Flags & Filters"
    description: "Indicates whether this row is the current effective-dated organization dimension version. It is true when Current_Record_Flag equals 1."
    sql: ${TABLE}.[Current_Record_Flag] = 1 ;;
  }

  dimension: assigned_region_name {
    type: string
    label: "Assigned Region Name"
    group_label: "Assigned Organization Hierarchy"
    description: "Name of the region currently assigned to the site for this organization dimension version."
    sql: ${TABLE}.[Assigned_Region_Name] ;;
  }

  dimension: assigned_district_name {
    type: string
    label: "Assigned District Name"
    group_label: "Assigned Organization Hierarchy"
    description: "Name of the district currently assigned to the site for this organization dimension version."
    sql: ${TABLE}.[Assigned_District_Name] ;;
  }

  dimension: assigned_functional_name {
    type: string
    label: "Assigned Functional Name"
    group_label: "Assigned Organization Hierarchy"
    description: "Name of the functional organization currently assigned to the site for this organization dimension version."
    sql: ${TABLE}.[Assigned_Functional_Name] ;;
  }

  dimension: region_description {
    type: string
    label: "Region Description"
    group_label: "Organization Hierarchy"
    description: "Name or description of the region associated with the organization dimension row."
    sql: ${TABLE}.[Region_Description] ;;
  }

  dimension: district_description {
    type: string
    label: "District Description"
    group_label: "Organization Hierarchy"
    description: "Name or description of the district associated with the organization dimension row."
    sql: ${TABLE}.[District_Description] ;;
  }

  dimension: address_line_1 {
    type: string
    label: "Address Line 1"
    group_label: "Location & Contact"
    description: "Primary street address line recorded for the site."
    sql: ${TABLE}.[Address_Line_1] ;;
  }

  dimension: address_line_2 {
    type: string
    label: "Address Line 2"
    group_label: "Location & Contact"
    description: "Secondary street address line recorded for the site."
    sql: ${TABLE}.[Address_Line_2] ;;
  }

  dimension: city {
    type: string
    label: "City"
    group_label: "Location & Contact"
    description: "City recorded for the site address."
    sql: ${TABLE}.[City] ;;
  }

  dimension: state {
    type: string
    label: "State"
    group_label: "Location & Contact"
    description: "State or province recorded for the site address."
    sql: ${TABLE}.[State] ;;
  }

  dimension: postal_code {
    type: zipcode
    label: "Postal Code"
    group_label: "Location & Contact"
    description: "Postal code recorded for the site address."
    sql: ${TABLE}.[Postal_Code] ;;
  }

  dimension: county {
    type: string
    label: "County"
    group_label: "Location & Contact"
    description: "County in which the site is located."
    sql: ${TABLE}.[County] ;;
  }

  dimension: latitude {
    type: number
    label: "Latitude"
    group_label: "Location & Contact"
    description: "Latitude coordinate recorded for the site."
    sql: ${TABLE}.[Latitude] ;;
  }

  dimension: longitude {
    type: number
    label: "Longitude"
    group_label: "Location & Contact"
    description: "Longitude coordinate recorded for the site."
    sql: ${TABLE}.[Longitude] ;;
  }

  dimension: phone_number {
    type: string
    label: "Phone Number"
    group_label: "Location & Contact"
    description: "Telephone number recorded for the site. Treat as site contact information and confirm security classification before production release."
    sql: ${TABLE}.[Phone_Number] ;;
  }

  dimension: time_zone_id {
    type: string
    label: "Time Zone ID"
    group_label: "Location & Contact"
    description: "Time zone identifier assigned to the site."
    sql: ${TABLE}.[Time_Zone_Id] ;;
  }

  dimension: locale {
    type: string
    label: "Locale"
    group_label: "Location & Contact"
    description: "Locale classification assigned to the site."
    sql: ${TABLE}.[Locale] ;;
  }

  dimension: store_style_description {
    type: string
    label: "Store Style Description"
    group_label: "Store Attributes"
    description: "Description of the site's store style."
    sql: ${TABLE}.[Store_Style_Description] ;;
  }

  dimension: velocity_group_description {
    type: string
    label: "Velocity Group Description"
    group_label: "Store Attributes"
    description: "Description of the sales or operating velocity group assigned to the site."
    sql: ${TABLE}.[Velocity_Group_Description] ;;
  }

  dimension: square_footage {
    type: string
    label: "Square Footage"
    group_label: "Store Attributes"
    description: "Recorded square footage value or classification for the site. The source metadata defines this as varchar, so it is modeled as a string rather than a numeric measure."
    sql: ${TABLE}.[Square_Footage] ;;
  }

  dimension: square_footage_description {
    type: string
    label: "Square Footage Description"
    group_label: "Store Attributes"
    description: "Descriptive square-footage classification assigned to the site."
    sql: ${TABLE}.[Square_Footage_Description] ;;
  }

  dimension: brand_profile {
    type: string
    label: "Brand Profile"
    group_label: "Store Attributes"
    description: "Brand profile assigned to the site."
    sql: ${TABLE}.[Brand_Profile] ;;
  }

  dimension: is_high_flow {
    type: string
    label: "High Flow"
    group_label: "Store Attributes"
    description: "High-flow fueling designation for the site. The provided sample data includes values such as No, Not Provided, and Unknown, so this is modeled as a descriptive string rather than a yes/no field."
    sql: ${TABLE}.[Is_High_Flow] ;;
  }

  dimension: alcohol_sales_type {
    type: string
    label: "Alcohol Sales Type"
    group_label: "Store Attributes"
    description: "Alcohol sales designation for the site, such as Beer, Beer Wine, Beer Wine Liquor, N A, or Unknown in the provided sample data."
    sql: ${TABLE}.[Alcohol_Sales_Type] ;;
  }

  dimension: layout_description {
    type: string
    label: "Layout Description"
    group_label: "Store Attributes"
    description: "Description of the layout assigned to the site."
    sql: ${TABLE}.[Layout_Description] ;;
  }

  dimension: distribution_description {
    type: string
    label: "Distribution Description"
    group_label: "Planning & Budget Attributes"
    description: "Planning and budgeting description of the site's distribution assignment."
    sql: ${TABLE}.[Distribution_Description] ;;
  }

  dimension: city_sales_tax_description {
    type: string
    label: "City Sales Tax Description"
    group_label: "Planning & Budget Attributes"
    description: "Planning and budgeting description of the site's city sales tax assignment."
    sql: ${TABLE}.[City_Sales_Tax_Description] ;;
  }

  dimension: food_service_program_description {
    type: string
    label: "Food Service Program Description"
    group_label: "Food Service"
    description: "Description of the food service program assigned to the site."
    sql: ${TABLE}.[Food_Service_Program_Description] ;;
  }

  dimension: food_service_kps_description {
    type: string
    label: "Food Service KPS Description"
    group_label: "Food Service"
    description: "Planning and budgeting description of the site's food service KPS assignment."
    sql: ${TABLE}.[Food_Service_KPS_Description] ;;
  }

  dimension: price_zone_description {
    type: string
    label: "Price Zone Description"
    group_label: "Pricing"
    description: "Description of the general price zone assigned to the site."
    sql: ${TABLE}.[Price_Zone_Description] ;;
  }

  dimension: cigarette_price_zone_description {
    type: string
    label: "Cigarette Price Zone Description"
    group_label: "Pricing"
    description: "Description of the cigarette price zone assigned to the site."
    sql: ${TABLE}.[Cigarette_Price_Zone_Description] ;;
  }

  dimension: real_estate_land_code {
    type: string
    label: "Real Estate Land Code"
    group_label: "Business & Brand"
    description: "Real-estate land code associated with the site."
    sql: ${TABLE}.[Real_Estate_Land_Code] ;;
  }

  dimension: business_entity_name {
    type: string
    label: "Business Entity Name"
    group_label: "Business & Brand"
    description: "Name of the legal or operating business entity associated with the site."
    sql: ${TABLE}.[Business_Entity_Name] ;;
  }

  measure: count {
    type: count
    label: "Organization Dimension Row Count"
    group_label: "Measures"
    description: "Count of organization dimension rows at the selected query grain. Because the source is effective-dated, this counts dimension versions rather than distinct sites."
    drill_fields: [organization_detail*]
    value_format: "#,##0"
  }

  measure: count_distinct_sites {
    type: count_distinct
    sql: ${site_id} ;;
    label: "Distinct Site Count"
    group_label: "Measures"
    description: "Distinct count of site identifiers in the query result. Use this when counting unique sites across effective-dated organization dimension rows."
    drill_fields: [organization_detail*]
    value_format: "#,##0"
  }
}

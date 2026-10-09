# Purpose: Exposes MAVDW calendar and fiscal date attributes for reporting, filtering, period comparisons, business-day logic, and joins from fact tables.
# Source: MAVDW enterprise.Dim_Date
# Grain: One row per Date_Key calendar date.
# Primary Key: date_key
# Refresh: Follows the MAVDW enterprise.Dim_Date refresh cadence; confirm the production cadence with the data owner.
# Data Owner: TBD
# Security Classification: Internal, no known PII.
# Known Limitations: Fiscal calendar definitions, relative-period offsets, and business-day flags should be validated with the data owner before production release.

view: dim_date {
  sql_table_name: MAVDW.enterprise.Dim_Date ;;
  view_label: "Date"

  set: date_detail {
    fields: [
      date_key,
      calendar_date_date,
      year_number,
      quarter_name,
      month_name,
      week_number,
      day_name,
      fiscal_year,
      fiscal_period_desc,
      fiscal_week_date,
      is_business_day,
      is_holiday
    ]
  }

  dimension: date_key {
    primary_key: yes
    type: date_raw
    label: "Date Key"
    group_label: "Keys & IDs"
    description: "Calendar date that uniquely identifies one row in enterprise.Dim_Date. This field is the primary key for this LookML view and is commonly used to join fact-table date columns to the date dimension."
    sql: ${TABLE}.[Date_Key] ;;
  }

  dimension: dim_date_id {
    type: number
    value_format_name: id
    label: "Date ID"
    group_label: "Keys & IDs"
    description: "Integer identifier assigned to the date row. Date Key remains the documented primary key for this view because the table grain is one row per calendar date."
    sql: ${TABLE}.[Dim_Date_Id] ;;
  }

  dimension_group: calendar_date {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Date"
    group_label: "Calendar Dates"
    description: "Calendar date represented by this date-dimension row."
    sql: ${TABLE}.[Date_Key] ;;
  }

  dimension: year_number {
    type: number
    label: "Calendar Year"
    group_label: "Calendar Attributes"
    description: "Calendar year number for the date."
    sql: ${TABLE}.[Year_Number] ;;
  }

  dimension: quarter_name {
    type: string
    label: "Calendar Quarter"
    group_label: "Calendar Attributes"
    description: "Business-readable calendar quarter label for the date."
    sql: ${TABLE}.[Quarter_Name] ;;
  }

  dimension: month_number {
    type: number
    label: "Calendar Month Number"
    group_label: "Calendar Attributes"
    description: "Month number within the calendar year, where January is expected to be 1 and December is expected to be 12."
    sql: ${TABLE}.[Month_Number] ;;
  }

  dimension: month_name {
    type: string
    label: "Calendar Month Name"
    group_label: "Calendar Attributes"
    description: "Full calendar month name for the date."
    sql: ${TABLE}.[Month_Name] ;;
  }

  dimension: month_name_3 {
    type: string
    label: "Calendar Month Abbreviation"
    group_label: "Calendar Attributes"
    description: "Three-character calendar month abbreviation for the date."
    sql: ${TABLE}.[Month_Name_3] ;;
  }

  dimension: year_month {
    type: string
    label: "Calendar Year Month"
    group_label: "Calendar Attributes"
    description: "Calendar year-month label for grouping dates by month across years."
    sql: ${TABLE}.[Year_Month] ;;
  }

  dimension: week_number {
    type: number
    label: "Calendar Week Number"
    group_label: "Calendar Attributes"
    description: "Calendar week number associated with the date."
    sql: ${TABLE}.[Week_Number] ;;
  }

  dimension: day_of_year {
    type: number
    label: "Day Of Calendar Year"
    group_label: "Calendar Attributes"
    description: "Sequential day number within the calendar year."
    sql: ${TABLE}.[Day_Of_Year] ;;
  }

  dimension: day_of_quarter {
    type: number
    label: "Day Of Calendar Quarter"
    group_label: "Calendar Attributes"
    description: "Sequential day number within the calendar quarter."
    sql: ${TABLE}.[Day_Of_Quarter] ;;
  }

  dimension: day_of_month {
    type: number
    label: "Day Of Calendar Month"
    group_label: "Calendar Attributes"
    description: "Sequential day number within the calendar month."
    sql: ${TABLE}.[Day_Of_Month] ;;
  }

  dimension: day_of_week {
    type: number
    label: "Day Of Week Number"
    group_label: "Calendar Attributes"
    description: "Numeric day-of-week value for the date. Confirm the first-day-of-week convention with the data owner before using this field for custom logic."
    sql: ${TABLE}.[Day_Of_Week] ;;
  }

  dimension: day_name {
    type: string
    label: "Day Name"
    group_label: "Calendar Attributes"
    description: "Full day name for the date."
    sql: ${TABLE}.[Day_Name] ;;
  }

  dimension: day_name_3 {
    type: string
    label: "Day Abbreviation"
    group_label: "Calendar Attributes"
    description: "Three-character day name abbreviation for the date."
    sql: ${TABLE}.[Day_Name_3] ;;
  }

  dimension: fiscal_year {
    type: number
    label: "Fiscal Year"
    group_label: "Fiscal Attributes"
    description: "Fiscal year assigned to the date."
    sql: ${TABLE}.[Fiscal_Year] ;;
  }

  dimension: fiscal_quarter {
    type: number
    label: "Fiscal Quarter"
    group_label: "Fiscal Attributes"
    description: "Fiscal quarter number assigned to the date."
    sql: ${TABLE}.[Fiscal_Quarter] ;;
  }

  dimension: fiscal_period_no {
    type: number
    label: "Fiscal Period No"
    group_label: "Fiscal Attributes"
    description: "Fiscal period sequence value assigned to the date. Confirm whether this differs from Fiscal Period Number before production use."
    sql: ${TABLE}.[Fiscal_Period_No] ;;
  }

  dimension: fiscal_period_number {
    type: number
    label: "Fiscal Period Number"
    group_label: "Fiscal Attributes"
    description: "Fiscal period number assigned to the date within the fiscal year."
    sql: ${TABLE}.[Fiscal_Period_Number] ;;
  }

  dimension: fiscal_period_desc {
    type: string
    label: "Fiscal Period Description"
    group_label: "Fiscal Attributes"
    description: "Business-readable fiscal period description assigned to the date."
    sql: ${TABLE}.[Fiscal_Period_Desc] ;;
  }

  dimension: fiscal_week_number {
    type: number
    label: "Fiscal Week Number"
    group_label: "Fiscal Attributes"
    description: "Fiscal week number assigned to the date."
    sql: ${TABLE}.[Fiscal_Week_Number] ;;
  }

  dimension_group: fiscal_week {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Fiscal Week"
    group_label: "Fiscal Dates"
    description: "Date value representing the fiscal week associated with the date. Confirm whether this is the fiscal week start date before production use."
    sql: ${TABLE}.[Fiscal_Week] ;;
  }

  dimension: fiscal_day_of_period {
    type: number
    label: "Fiscal Day Of Period"
    group_label: "Fiscal Attributes"
    description: "Sequential day number within the fiscal period."
    sql: ${TABLE}.[Fiscal_Day_Of_Period] ;;
  }

  dimension_group: year_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Year Start"
    group_label: "Period Boundary Dates"
    description: "Start date of the calendar year containing the date."
    sql: ${TABLE}.[Year_Start] ;;
  }

  dimension_group: year_end {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Year End"
    group_label: "Period Boundary Dates"
    description: "End date of the calendar year containing the date."
    sql: ${TABLE}.[Year_End] ;;
  }

  dimension_group: quarter_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Quarter Start"
    group_label: "Period Boundary Dates"
    description: "Start date of the calendar quarter containing the date."
    sql: ${TABLE}.[Quarter_Start] ;;
  }

  dimension_group: quarter_end {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Quarter End"
    group_label: "Period Boundary Dates"
    description: "End date of the calendar quarter containing the date."
    sql: ${TABLE}.[Quarter_End] ;;
  }

  dimension_group: month_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Month Start"
    group_label: "Period Boundary Dates"
    description: "Start date of the calendar month containing the date."
    sql: ${TABLE}.[Month_Start] ;;
  }

  dimension_group: month_end {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Month End"
    group_label: "Period Boundary Dates"
    description: "End date of the calendar month containing the date."
    sql: ${TABLE}.[Month_End] ;;
  }

  dimension_group: week_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Week Start"
    group_label: "Period Boundary Dates"
    description: "Start date of the calendar week containing the date."
    sql: ${TABLE}.[Week_Start] ;;
  }

  dimension_group: week_end {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Calendar Week End"
    group_label: "Period Boundary Dates"
    description: "End date of the calendar week containing the date."
    sql: ${TABLE}.[Week_End] ;;
  }

  dimension_group: previous_business {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Previous Business Date"
    group_label: "Business Dates"
    description: "Previous business date relative to this date, based on the business-day calendar in enterprise.Dim_Date."
    sql: ${TABLE}.[Previous_Business_Date] ;;
  }

  dimension_group: next_business {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "Next Business Date"
    group_label: "Business Dates"
    description: "Next business date relative to this date, based on the business-day calendar in enterprise.Dim_Date."
    sql: ${TABLE}.[Next_Business_Date] ;;
  }

  dimension_group: ytd_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "YTD Start"
    group_label: "Relative Period Dates"
    description: "Year-to-date anchor date associated with this date. Confirm the precise business definition with the data owner before production use."
    sql: ${TABLE}.[YTD] ;;
  }

  dimension_group: qtd_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "QTD Start"
    group_label: "Relative Period Dates"
    description: "Quarter-to-date anchor date associated with this date. Confirm the precise business definition with the data owner before production use."
    sql: ${TABLE}.[QTD] ;;
  }

  dimension_group: mtd_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "MTD Start"
    group_label: "Relative Period Dates"
    description: "Month-to-date anchor date associated with this date. Confirm the precise business definition with the data owner before production use."
    sql: ${TABLE}.[MTD] ;;
  }

  dimension_group: wtd_start {
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    label: "WTD Start"
    group_label: "Relative Period Dates"
    description: "Week-to-date anchor date associated with this date. Confirm the precise business definition with the data owner before production use."
    sql: ${TABLE}.[WTD] ;;
  }

  dimension: business_days_ytd {
    type: number
    label: "Business Days YTD"
    group_label: "Business Day Counts"
    description: "Number of business days elapsed year-to-date as of this date."
    sql: ${TABLE}.[Business_Days_YTD] ;;
  }

  dimension: business_days_remaining_ytd {
    type: number
    label: "Business Days Remaining YTD"
    group_label: "Business Day Counts"
    description: "Number of business days remaining in the calendar year after this date, based on the business-day calendar in enterprise.Dim_Date."
    sql: ${TABLE}.[Business_Days_Remaining_YTD] ;;
  }

  dimension: business_days_qtd {
    type: number
    label: "Business Days QTD"
    group_label: "Business Day Counts"
    description: "Number of business days elapsed quarter-to-date as of this date."
    sql: ${TABLE}.[Business_Days_QTD] ;;
  }

  dimension: business_days_remaining_qtd {
    type: number
    label: "Business Days Remaining QTD"
    group_label: "Business Day Counts"
    description: "Number of business days remaining in the calendar quarter after this date, based on the business-day calendar in enterprise.Dim_Date."
    sql: ${TABLE}.[Business_Days_Remaining_QTD] ;;
  }

  dimension: business_days_mtd {
    type: number
    label: "Business Days MTD"
    group_label: "Business Day Counts"
    description: "Number of business days elapsed month-to-date as of this date."
    sql: ${TABLE}.[Business_Days_MTD] ;;
  }

  dimension: business_days_remaining_mtd {
    type: number
    label: "Business Days Remaining MTD"
    group_label: "Business Day Counts"
    description: "Number of business days remaining in the calendar month after this date, based on the business-day calendar in enterprise.Dim_Date."
    sql: ${TABLE}.[Business_Days_Remaining_MTD] ;;
  }

  dimension: relative_year {
    type: number
    label: "Relative Year"
    group_label: "Relative Offsets"
    description: "Relative year offset for the date. Confirm the anchor date used for this offset before production use."
    sql: ${TABLE}.[Relative_Year] ;;
  }

  dimension: relative_quarter {
    type: number
    label: "Relative Quarter"
    group_label: "Relative Offsets"
    description: "Relative quarter offset for the date. Confirm the anchor date used for this offset before production use."
    sql: ${TABLE}.[Relative_Quarter] ;;
  }

  dimension: relative_month {
    type: number
    label: "Relative Month"
    group_label: "Relative Offsets"
    description: "Relative month offset for the date. Confirm the anchor date used for this offset before production use."
    sql: ${TABLE}.[Relative_Month] ;;
  }

  dimension: relative_week {
    type: number
    label: "Relative Week"
    group_label: "Relative Offsets"
    description: "Relative week offset for the date. Confirm the anchor date used for this offset before production use."
    sql: ${TABLE}.[Relative_Week] ;;
  }

  dimension: relative_week_day {
    type: number
    label: "Relative Week Day"
    group_label: "Relative Offsets"
    description: "Relative weekday offset for the date. Confirm the anchor date and weekday convention used for this offset before production use."
    sql: ${TABLE}.[Relative_Week_Day] ;;
  }

  dimension: relative_calendar_day {
    type: number
    label: "Relative Calendar Day"
    group_label: "Relative Offsets"
    description: "Relative calendar-day offset for the date. Confirm the anchor date used for this offset before production use."
    sql: ${TABLE}.[Relative_Calendar_Day] ;;
  }

  dimension: relative_business_day {
    type: number
    label: "Relative Business Day"
    group_label: "Relative Offsets"
    description: "Relative business-day offset for the date. Confirm the anchor date and business-day calendar used for this offset before production use."
    sql: ${TABLE}.[Relative_Business_Day] ;;
  }

  dimension: week_day_flag {
    hidden: yes
    type: number
    label: "Weekday Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric weekday indicator from the source table. Hidden because the business-friendly Current Weekday yes/no field should be used for reporting."
    sql: ${TABLE}.[Week_Day_Flag] ;;
  }

  dimension: is_week_day {
    type: yesno
    label: "Weekday"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is a weekday according to the source calendar. This uses Week_Day_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[Week_Day_Flag] = 1 ;;
  }

  dimension: holiday_flag {
    hidden: yes
    type: number
    label: "Holiday Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric holiday indicator from the source table. Hidden because the business-friendly Holiday yes/no field should be used for reporting."
    sql: ${TABLE}.[Holiday_Flag] ;;
  }

  dimension: is_holiday {
    type: yesno
    label: "Holiday"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is a holiday according to the source calendar. This uses Holiday_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[Holiday_Flag] = 1 ;;
  }

  dimension: business_day_flag {
    hidden: yes
    type: number
    label: "Business Day Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric business-day indicator from the source table. Hidden because the business-friendly Business Day yes/no field should be used for reporting."
    sql: ${TABLE}.[Business_Day_Flag] ;;
  }

  dimension: is_business_day {
    type: yesno
    label: "Business Day"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is a business day according to the source calendar. This uses Business_Day_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[Business_Day_Flag] = 1 ;;
  }

  dimension: month_end_flag {
    hidden: yes
    type: number
    label: "Month End Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric month-end indicator from the source table. Hidden because the business-friendly Month End yes/no field should be used for reporting."
    sql: ${TABLE}.[Month_End_Flag] ;;
  }

  dimension: is_month_end {
    type: yesno
    label: "Month End"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is the last date of the calendar month according to the source calendar. This uses Month_End_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[Month_End_Flag] = 1 ;;
  }

  dimension: ytd_flag {
    hidden: yes
    type: number
    label: "YTD Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric year-to-date indicator from the source table. Hidden because the business-friendly YTD yes/no field should be used for reporting."
    sql: ${TABLE}.[YTD_Flag] ;;
  }

  dimension: is_ytd {
    type: yesno
    label: "YTD"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is in the current year-to-date reporting window according to the source calendar. This uses YTD_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[YTD_Flag] = 1 ;;
  }

  dimension: qtd_flag {
    hidden: yes
    type: number
    label: "QTD Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric quarter-to-date indicator from the source table. Hidden because the business-friendly QTD yes/no field should be used for reporting."
    sql: ${TABLE}.[QTD_Flag] ;;
  }

  dimension: is_qtd {
    type: yesno
    label: "QTD"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is in the current quarter-to-date reporting window according to the source calendar. This uses QTD_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[QTD_Flag] = 1 ;;
  }

  dimension: mtd_flag {
    hidden: yes
    type: number
    label: "MTD Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric month-to-date indicator from the source table. Hidden because the business-friendly MTD yes/no field should be used for reporting."
    sql: ${TABLE}.[MTD_Flag] ;;
  }

  dimension: is_mtd {
    type: yesno
    label: "MTD"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is in the current month-to-date reporting window according to the source calendar. This uses MTD_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[MTD_Flag] = 1 ;;
  }

  dimension: wtd_flag {
    hidden: yes
    type: number
    label: "WTD Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric week-to-date indicator from the source table. Hidden because the business-friendly WTD yes/no field should be used for reporting."
    sql: ${TABLE}.[WTD_Flag] ;;
  }

  dimension: is_wtd {
    type: yesno
    label: "WTD"
    group_label: "Flags & Filters"
    description: "Indicates whether the date is in the current week-to-date reporting window according to the source calendar. This uses WTD_Flag equals 1 rather than the duplicate source text field."
    sql: ${TABLE}.[WTD_Flag] = 1 ;;
  }

  dimension: dst_in_effect_flag {
    hidden: yes
    type: number
    label: "DST In Effect Flag"
    group_label: "Flags & Filters"
    description: "Technical numeric daylight-saving-time indicator from the source table. Hidden because the business-friendly Daylight Saving Time In Effect yes/no field should be used for reporting."
    sql: ${TABLE}.[DST_In_Effect_Flag] ;;
  }

  dimension: is_dst_in_effect {
    type: yesno
    label: "Daylight Saving Time In Effect"
    group_label: "Flags & Filters"
    description: "Indicates whether daylight saving time is in effect for the date according to the source calendar."
    sql: ${TABLE}.[DST_In_Effect_Flag] = 1 ;;
  }

  dimension: source_is_week_day {
    hidden: yes
    type: string
    label: "Source Is Weekday"
    group_label: "Source Flag Text"
    description: "Source text version of the weekday indicator. Hidden because it duplicates the Weekday yes/no field."
    sql: ${TABLE}.[Is_Week_Day] ;;
  }

  dimension: source_is_holiday {
    hidden: yes
    type: string
    label: "Source Is Holiday"
    group_label: "Source Flag Text"
    description: "Source text version of the holiday indicator. Hidden because it duplicates the Holiday yes/no field."
    sql: ${TABLE}.[Is_Holiday] ;;
  }

  dimension: source_is_business_day {
    hidden: yes
    type: string
    label: "Source Is Business Day"
    group_label: "Source Flag Text"
    description: "Source text version of the business-day indicator. Hidden because it duplicates the Business Day yes/no field."
    sql: ${TABLE}.[Is_Business_Day] ;;
  }

  dimension: source_is_month_end {
    hidden: yes
    type: string
    label: "Source Is Month End"
    group_label: "Source Flag Text"
    description: "Source text version of the month-end indicator. Hidden because it duplicates the Month End yes/no field."
    sql: ${TABLE}.[Is_Month_End] ;;
  }

  dimension: source_is_ytd {
    hidden: yes
    type: string
    label: "Source Is YTD"
    group_label: "Source Flag Text"
    description: "Source text version of the year-to-date indicator. Hidden because it duplicates the YTD yes/no field."
    sql: ${TABLE}.[Is_YTD] ;;
  }

  dimension: source_is_qtd {
    hidden: yes
    type: string
    label: "Source Is QTD"
    group_label: "Source Flag Text"
    description: "Source text version of the quarter-to-date indicator. Hidden because it duplicates the QTD yes/no field."
    sql: ${TABLE}.[Is_QTD] ;;
  }

  dimension: source_is_mtd {
    hidden: yes
    type: string
    label: "Source Is MTD"
    group_label: "Source Flag Text"
    description: "Source text version of the month-to-date indicator. Hidden because it duplicates the MTD yes/no field."
    sql: ${TABLE}.[Is_MTD] ;;
  }

  dimension: source_is_wtd {
    hidden: yes
    type: string
    label: "Source Is WTD"
    group_label: "Source Flag Text"
    description: "Source text version of the week-to-date indicator. Hidden because it duplicates the WTD yes/no field."
    sql: ${TABLE}.[Is_WTD] ;;
  }

  dimension: utc_offset {
    type: number
    label: "UTC Offset"
    group_label: "Time Zone"
    description: "UTC offset value associated with the date. Confirm the unit and applicable time zone context before production use."
    sql: ${TABLE}.[UTC_Offset] ;;
  }

  measure: count {
    type: count
    label: "Date Count"
    group_label: "Measures"
    description: "Count of date dimension rows at the selected query grain. Because the source grain is one row per Date Key, this is usually equivalent to the number of dates returned."
    drill_fields: [date_detail*]
    value_format: "#,##0"
  }
}

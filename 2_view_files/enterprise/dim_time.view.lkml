# Purpose: Exposes MAVDW time-of-day attributes for reporting and joins from transaction facts.
# Source: MAVDW enterprise.Dim_Time
# Grain: One row per Time_Key.
# Primary Key: time_key
# Refresh: Follows the MAVDW enterprise.Dim_Time refresh cadence; confirm with the data owner.
# Data Owner: TBD
# Security Classification: Internal, no known PII.
# Known Limitations: Day-part definitions and time key formatting should be validated with the data owner before production release.

view: dim_time {
  sql_table_name: enterprise.Dim_Time ;;
  view_label: "Time"

  set: time_detail {
    fields: [time_key, time_hh_mm, time_hh_mm_ss, hour_24, minute, second, day_part]
  }

  dimension: time_key {
    primary_key: yes
    type: string
    label: "Time Key"
    group_label: "Keys & IDs"
    description: "Time-of-day key that uniquely identifies one row in enterprise.Dim_Time. Modeled as a string to keep time values stable as identifiers in Looker joins and drills."
    sql: CAST(${TABLE}.[Time_Key] AS varchar(16)) ;;
  }

  dimension: hour_24 {
    type: number
    label: "Hour 24"
    group_label: "Time Attributes"
    description: "Hour of day using a 24-hour clock."
    sql: ${TABLE}.[Hour_24] ;;
  }

  dimension: hour_12 {
    type: number
    label: "Hour 12"
    group_label: "Time Attributes"
    description: "Hour of day using a 12-hour clock."
    sql: ${TABLE}.[Hour_12] ;;
  }

  dimension: minute {
    type: number
    label: "Minute"
    group_label: "Time Attributes"
    description: "Minute within the hour."
    sql: ${TABLE}.[Minute] ;;
  }

  dimension: second {
    type: number
    label: "Second"
    group_label: "Time Attributes"
    description: "Second within the minute."
    sql: ${TABLE}.[Second] ;;
  }

  dimension: time_hh_mm {
    type: string
    label: "Time HH:MM"
    group_label: "Time Attributes"
    description: "Time formatted at hour-and-minute precision."
    sql: ${TABLE}.[Time_HH_MM] ;;
  }

  dimension: time_hh_mm_ss {
    type: string
    label: "Time HH:MM:SS"
    group_label: "Time Attributes"
    description: "Time formatted at hour-minute-second precision."
    sql: ${TABLE}.[Time_HH_MM_SS] ;;
  }

  dimension: am_pm {
    type: string
    label: "AM/PM"
    group_label: "Time Attributes"
    description: "AM or PM period for the time."
    sql: ${TABLE}.[Am_Pm] ;;
  }

  dimension: day_part {
    type: string
    label: "Day Part"
    group_label: "Time Attributes"
    description: "Business-defined day-part classification for the time."
    sql: ${TABLE}.[Day_Part] ;;
  }

  dimension: minute_of_day {
    type: number
    label: "Minute Of Day"
    group_label: "Time Attributes"
    description: "Sequential minute number within the day."
    sql: ${TABLE}.[Minute_Of_Day] ;;
  }

  dimension: second_of_day {
    type: number
    label: "Second Of Day"
    group_label: "Time Attributes"
    description: "Sequential second number within the day."
    sql: ${TABLE}.[Second_Of_Day] ;;
  }

  dimension: quarter_hour_number {
    type: number
    label: "Quarter Hour Number"
    group_label: "Time Attributes"
    description: "Sequential quarter-hour bucket number within the day."
    sql: ${TABLE}.[Quarter_Hour_Number] ;;
  }

  dimension: half_hour_number {
    type: number
    label: "Half Hour Number"
    group_label: "Time Attributes"
    description: "Sequential half-hour bucket number within the day."
    sql: ${TABLE}.[Half_Hour_Number] ;;
  }

  measure: count {
    type: count
    label: "Time Count"
    group_label: "Measures"
    description: "Count of time dimension rows."
    drill_fields: [time_detail*]
    value_format: "#,##0"
  }
}

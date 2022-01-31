view: dialogflow_cleaned_logs {
  sql_table_name: `looker_training.dialogflow_cleaned_logs`;;

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension_group: date {
    type: time
    sql: date_timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: intent_detection_confidence {
    type: number
    sql: ${TABLE}.intent_detection_confidence ;;
  }

  dimension: intent_triggered {
    type: string
    sql: ${TABLE}.intent_triggered ;;
  }

  dimension: is_fallback {
    type: yesno
    sql: ${TABLE}.isFallback ;;
  }

  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
  }

  dimension: magnitude {
    type: number
    sql: ${TABLE}.magnitude ;;
  }

  dimension: month_number {
    type: number
    sql: ${TABLE}.month_number ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: query_text {
    type: string
    sql: ${TABLE}.query_text ;;
  }

  dimension: query_text_redacted {
    type: string
    sql: ${TABLE}.query_text_redacted ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}.response_ID ;;
    primary_key: yes

  }

  dimension: sendate_timent_score {
    type: number
    sql: ${TABLE}.sendate_timent_score ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_ID ;;
  }
  measure: Total_Sessions{
    type: count_distinct
    sql: ${session_id} ;;
  }
  measure: Date_count {
    type: count_distinct
    sql: ${date_date} ;;
  }
  measure: Avg_sessions_day {
    type: number
    sql: ${Total_Sessions}/${Date_count} ;;
    value_format: "0"
  }
  measure: Total_Queries {
    type: count_distinct
    sql: ${response_id} ;;
  }
  measure: Avg_Queries_session {
    type: number
    sql: ${Total_Queries}/${Total_Sessions} ;;
    value_format: "0"
  }
  measure: Handled_queries{
    type: count_distinct
    sql: case when ${is_fallback}= True then ${response_id} end ;;

  }
  measure: Unhandled_queries{
    type: count_distinct
    sql: case when ${is_fallback}= False then ${response_id} end ;;

  }

  dimension_group: date_time {
    type: time
    sql: date_timeframes: [
      raw,
      date_time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date_time ;;
  }

  dimension_group: date_time_stamp {
    type: time
    sql: date_timeframes: [
      raw,
      date_time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date_time_stamp ;;
  }
  dimension: Busiest_hours {
    type: date
    sql: case when extract(hour from ${date_time}) in (00,01) then "12am-2am"
       when extract(hour from ${date_time}) in (02,03) then "2am-4am"
       when extract(hour from ${date_time}) in (04,05) then "4am-6am"
       when extract(hour from ${date_time}) in (06,07) then "6am-8am"
       when extract(hour from ${date_time}) in (08,09) then "8am-10am"
       when extract(hour from ${date_time}) in (10,11) then "10am-12pm"
       when extract(hour from ${date_time}) in (12,13) then "12pm-2pm"
       when extract(hour from ${date_time}) in (14,15) then "2pm-4pm"
       when extract(hour from ${date_time}) in (16,17) then "4pm-6pm"
       when extract(hour from ${date_time}) in (18,19) then "6pm-8pm"
       when extract(hour from ${date_time}) in (20,21) then "8pm-10pm"
       when extract(hour from ${date_time}) in (22,23) then "10pm-12am" end ;;

    }

  dimension: week_number {
    type: number
    sql: ${TABLE}.week_number ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

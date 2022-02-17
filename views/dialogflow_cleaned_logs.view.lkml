view: dialogflow_cleaned_logs {
  sql_table_name: `looker_training.dialogflow_cleaned_logs`;;

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension_group: date {
    type: time
    sql: timeframes: [
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

  dimension: sentiment_score {
    type: number
    sql: ${TABLE}.sentiment_score ;;
  }
  dimension: sentiment_bucket {
    type: string
    sql: CASE WHEN magnitude > 3 and sentiment_score between 0.25 and 1 THEN '1. Positive'
          WHEN magnitude <= 3 and sentiment_score between 0.25 and 1 THEN '2. Partially Positive'
          WHEN magnitude <= 3 and sentiment_score between -1 and -0.25 THEN '4. Partially Negative'
          WHEN magnitude > 3 and sentiment_score between -1 and -0.25 THEN '5. Negative'
          ELSE "3. Neutral" END ;;
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
    sql: ${time_stamp_date} ;;
  }
  measure: Avg_sessions_day {
    type: number
    sql: if(${Date_count} > 0, ${Total_Sessions}/${Date_count}, 0) ;;
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
    sql: case when ${is_fallback}= False then ${response_id} end ;;

  }
  measure: Unhandled_queries{
    type: count_distinct
    sql: case when ${is_fallback}= True then ${response_id} end ;;

  }
  measure: success_rate {
    type: number
    sql: if(${count} > 0, sum(if(${is_fallback},0,1))/${count}, 0);;
    value_format: "#%;(#%)"
  }
  measure: average_sentiment_score {
    type: average
    sql: ${sentiment_score};;
    value_format: "#.000;(#.000)"
  }
  measure: average_intent_detection_confidence {
    type: average
    sql: ${intent_detection_confidence};;
  }


  dimension_group: time {
    type: time
     timeframes : [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time ;;
  }

  dimension_group: time_stamp {
    type: time
    timeframes : [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time_stamp ;;
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

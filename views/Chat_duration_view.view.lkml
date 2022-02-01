view: Chat_duration_view  {
  derived_table: {
    sql:
    WITH entry_intent AS (
    SELECT session_ID, intent_triggered AS entry_intent FROM
    (SELECT session_ID, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_ID  ORDER BY time_stamp  ASC) AS entry_rn
    FROM `qp-qai-training-1-2021-05.looker_training.dialogflow_cleaned_logs`)
    WHERE entry_rn =1
    ),
    exit_intent AS (
      SELECT session_ID, intent_triggered AS exit_intent FROM
      (SELECT session_ID, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_ID  ORDER BY time_stamp  DESC) AS exit_rn
      FROM `qp-qai-training-1-2021-05.looker_training.dialogflow_cleaned_logs`)
      WHERE exit_rn=1
    ),
    conv_length AS(
      Select session_ID, DATETIME_DIFF(end_time, start_time, second) as conversation_length_in_seconds, count_of_msg, session_date_time, date, platform, avg_sentiment_score
      from
      (SELECT session_ID, min( time_stamp ) as start_time, max( time_stamp ) as end_time, count(distinct response_ID) as count_of_msg, MIN( time_stamp ) as session_date_time, MIN( date ) AS date, MIN( platform ) as platform, avg(sentiment_score) as avg_sentiment_score,
        FROM `qp-qai-training-1-2021-05.looker_training.dialogflow_cleaned_logs`
      group by session_ID)
    )
    SELECT entry_intent.*, exit_intent.exit_intent,
    conv_length.conversation_length_in_seconds as conversation_length_in_seconds, count_of_msg, session_date_time, date, platform,
    avg_sentiment_score,
    from entry_intent
    LEFT JOIN exit_intent
    on entry_intent.session_ID=exit_intent.session_ID
    LEFT JOIN conv_length
    ON entry_intent.session_ID=conv_length.session_ID
    ;;
  }
  dimension: response_id {
    type: string
    sql: ${TABLE}.response_ID ;;
    primary_key: yes

  }
 dimension: session_ID {
    description: "Session ID"
    type: string
    sql: ${TABLE}.session_ID ;;
  }
  dimension: entry_intent {
    description: "Entry Intent"
    type: string
    sql: ${TABLE}.entry_intent ;;
  }
  dimension: exit_intent {
    description: "Exit Intent"
    type: string
    sql: ${TABLE}.exit_intent ;;
  }
  dimension: conversation_length_in_seconds {
    description: "Conversation length in Seconds"
    type: number
    sql: ${TABLE}.conversation_length_in_seconds ;;
  }
  dimension: count_of_msg {
    description: "Number of message"
    type: number
    sql: ${TABLE}.count_of_msg ;;
  }
  dimension: session_date_time {
    description: "Session datetime"
    type: date_time
    sql: ${TABLE}.session_date_time ;;
  }
  dimension: date {
    description: "Date"
    type: date
    sql: ${TABLE}.date ;;
  }
  dimension: platform {
    description: "Platform"
    type: string
    sql: ${TABLE}.platform ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
  measure: sessioncount {
    type: count_distinct
    sql:  ${session_ID} ;;
  }
  measure : sumduration {
    type: sum
    sql:  ${conversation_length_in_seconds} ;;
  }
  measure: avgduration {
    type:  number
    sql: (${sumduration}/${sessioncount}) ;;
    value_format: "mm:ss"
  }}

view: exit_intent {
  derived_table: {
    sql:
      SELECT session_id, intent_triggered AS exit_intent FROM
      (SELECT session_id, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_id  ORDER BY time_stamp  DESC) AS exit_rn
      FROM dialogflow_cleaned_logs )
      WHERE exit_rn =1
      ;;
  }

  dimension: session_id {
    type: string
    primary_key: yes
  }

  dimension: exit_intent {
    type: string
  }
  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: intent_triggered {
    type: string
    sql: ${TABLE}.intent_triggered ;;
  }
}

view: session_level {
  derived_table: {
    sql:
      SELECT session_id, intent_triggered AS entry_intent FROM
      (SELECT session_id, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_id  ORDER BY time_stamp  ASC) AS entry_rn
      FROM dialogflow_cleaned_logs )
      WHERE entry_rn =1
      ;;
  }
  dimension: session_id {
    type: string
    primary_key: yes
  }

  dimension: entry_intent {
    type: string
  }

  measure: total_sessions {
    type: count
    drill_fields: []
  }
}

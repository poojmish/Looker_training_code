view: intent_correlation {
  derived_table: {
    sql:
    SELECT A.response_id, A.session_id, A.intent_triggered, B.intent_triggered as intent_list FROM (
SELECT response_id,session_id,intent_triggered  FROM dialogflow_cleaned_logs) A
INNER JOIN (
SELECT session_id,intent_triggered  FROM dialogflow_cleaned_logs) B
using (session_id)
where A.intent_triggered != B.intent_triggered
    ;;
  }

  dimension: response_id {
    type:  string
  }

  dimension: session_id {
    type:  string
  }

  dimension: intent_triggered {
    type:  string
  }

  dimension: intent_list {
    type:  string
  }

  measure: count {
    type: count_distinct
    sql: ${session_id} ;;
  }

}

connection: "qai_de_looker_training_q03374_pooja_mishra"

# include all the views
include: "/views/**/*.view"

datagroup: qai_de_looker_training_q03374_pooja_mishra_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: qai_de_looker_training_q03374_pooja_mishra_default_datagroup

explore: dialogflow_cleaned_logs {

  join: Conversation_duration_view {
    type: full_outer
    relationship: one_to_many
    sql_on: dialogflow_cleaned_logs.session_id = conversation_length.session_id ;;
    fields: [call_duration_bucket, session_id]
  }
}

explore: session_level {
  join: exit_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = exit_intent.session_id ;;
    # fields: [exit_intent]
  }
  join: second_last_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = second_last_intent.session_id ;;
    # fields: [second_last_intent]
  }
  join: Conversation_duration_view {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = conversation_length.session_id ;;
    # fields: []
  }
  }

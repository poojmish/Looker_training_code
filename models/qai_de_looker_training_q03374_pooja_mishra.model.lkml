connection: "qai_de_looker_training_q03374_pooja_mishra"

# include all the views
include: "/views/**/dialogflow_cleaned_logs.view"
include: "/views/**/session_level.view"
include: "/views/**/exit_intent.view"
include: "/views/**/second_last_intent.view"
include: "/views/**/Conversation_duration.view"
include: "/views/**/Deflection_logic.view"
include: "/views/**/intent_correlation.view"

datagroup: qai_de_looker_training_q03374_pooja_mishra_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: qai_de_looker_training_q03374_pooja_mishra_default_datagroup

explore: dialogflow_cleaned_logs {

  join: Conversation_duration {
    type: full_outer
    relationship: one_to_many
    sql_on: dialogflow_cleaned_logs.session_id = Conversation_duration.session_id ;;
    fields: [call_duration_bucket, session_id]
  }
  join: intent_correlation {
    type: left_outer
    relationship: one_to_many
    sql_on: dialogflow_cleaned_logs.response_id = intent_correlation.response_id ;;
  }
}


explore: session_level {
  join: exit_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = exit_intent.session_id ;;
    fields: [exit_intent]
  }
  join: second_last_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = second_last_intent.session_id ;;
    fields: [second_last_intent]
  }
  join: Conversation_duration {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = Conversation_duration.session_id ;;
    fields: [avg_session_duration,hour_frame]
  }
  join: Deflection_logic {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = Deflection_logic.session_id ;;
    fields: [Deflection,Deflection_rate]
  }
  }

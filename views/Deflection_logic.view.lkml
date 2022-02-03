view: Deflection_logic {
  derived_table: {
    sql: select dialogflow_cleaned_logs.session_id,
          sum(case when dialogflow_cleaned_logs.isFallback is true then 1
          else 0 end) as fallback_case,
          sum(case when dialogflow_cleaned_logs.intent_triggered = "LiveAgentTransfer" then 1
          else 0 end) as agent_case,

          from dialogflow_cleaned_logs
          group by session_id
          ;;
  }

  dimension: session_id {
    type: string
    primary_key: yes
  }

  dimension:  fallback_case {
    type: number
  }

  dimension:  agent_case {
    type: number
  }

  dimension: Deflection {
    case: {
      when: {
        sql: ${fallback_case} = 0 and ${agent_case} = 0 ;;
        label: "Sessions successfully handled by Bot"
      }
      when: {
        sql: ${fallback_case} > 0 and ${agent_case} = 0 ;;
        label:  "Sessions partially handled by the bot but not transferred to live agent"
      }
      when: {
        sql: ${fallback_case} > 0 and ${agent_case} > 0 ;;
        label: "Sessions partially handled by the bot but transferred to live agent"

      }
      when: {
        sql: ${fallback_case} = 0 and ${agent_case} > 0 ;;
        label: "Sessions transferred to Live Agent as per the flow"
      }
    }
  }

  dimension: Deflection_rate {
    case: {
      when: {
        sql: ${Deflection} = "Sessions successfully handled by Bot" or ${Deflection} = "Sessions partially handled by the bot but not transferred to live agent";;
        label: "Fully Deflected"
      }
      when: {
        sql: ${Deflection} = "Sessions partially handled by the bot but transferred to live agent";;
        label: "Partially Deflected"
      }
      when: {
        sql: ${Deflection} = "Sessions transferred to Live Agent as per the flow" ;;
        label: "Not Deflected"
      }
    }
  }
}

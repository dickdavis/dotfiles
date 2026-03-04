#!/bin/bash
# log-session-activity.sh
# Append session activity to a per-session audit log.

INPUT=$(cat)
LOG_DIR="$HOME/.claude/logs"

mkdir -p "$LOG_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S")
DATE_PREFIX=$(date -u +"%Y%m%d")
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
LOG_FILE="$LOG_DIR/${DATE_PREFIX}_${SESSION_ID}.log"

case "$EVENT" in
  SessionStart)
    SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')
    MODEL=$(echo "$INPUT" | jq -r '.model // "unknown"')
    DETAIL="source=$SOURCE model=$MODEL"
    ;;
  SessionEnd)
    REASON=$(echo "$INPUT" | jq -r '.reason // "unknown"')
    DETAIL="reason=$REASON"
    ;;
  UserPromptSubmit)
    DETAIL=$(echo "$INPUT" | jq -r '.user_prompt // empty' | head -c 200)
    ;;
  PostToolUse|PostToolUseFailure)
    TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
    case "$TOOL_NAME" in
      Bash)
        TOOL_DETAIL=$(echo "$INPUT" | jq -r '.tool_input.command // empty' | head -c 200)
        ;;
      Edit|Write|Read)
        TOOL_DETAIL=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
        ;;
      Glob|Grep)
        TOOL_DETAIL=$(echo "$INPUT" | jq -r '.tool_input.pattern // empty')
        ;;
      *)
        TOOL_DETAIL=""
        ;;
    esac
    DETAIL="$TOOL_NAME | $TOOL_DETAIL"
    ;;
  SubagentStart)
    AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
    AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // empty')
    DETAIL="$AGENT_TYPE | $AGENT_ID"
    ;;
  SubagentStop)
    AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
    DETAIL="$AGENT_TYPE"
    ;;
  Stop)
    DETAIL=""
    ;;
  *)
    DETAIL=""
    ;;
esac

echo "$TIMESTAMP | $EVENT | $DETAIL" >> "$LOG_FILE"

exit 0

#!/bin/bash
# log-tool-usage.sh
# Append tool usage to an audit log.

INPUT=$(cat)
LOG_DIR="$HOME/.claude/logs"
LOG_FILE="$LOG_DIR/tool-usage.log"

mkdir -p "$LOG_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S")
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')

case "$TOOL_NAME" in
  Bash)
    DETAIL=$(echo "$INPUT" | jq -r '.tool_input.command // empty' | head -c 200)
    ;;
  Edit|Write|Read)
    DETAIL=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
    ;;
  Glob)
    DETAIL=$(echo "$INPUT" | jq -r '.tool_input.pattern // empty')
    ;;
  Grep)
    DETAIL=$(echo "$INPUT" | jq -r '.tool_input.pattern // empty')
    ;;
  *)
    DETAIL=""
    ;;
esac

echo "$TIMESTAMP | $SESSION_ID | $TOOL_NAME | $DETAIL" >> "$LOG_FILE"

exit 0

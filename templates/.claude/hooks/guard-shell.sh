#!/bin/bash
# guard-shell.sh
# Escalate destructive or network-reaching bash commands to require user confirmation.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

DANGEROUS_PATTERNS=(
  "rm -rf"
  "rm -fr"
  "git push --force"
  "git push -f"
  "git reset --hard"
  "git checkout -- ."
  "git clean -fd"
  "DROP TABLE"
  "DROP DATABASE"
  "TRUNCATE"
  "chmod -R 777"
  "mkfs"
  "> /dev/"
  "dd if="
)

NETWORK_PATTERNS=(
  "curl "
  "wget "
  "ssh "
  "scp "
  "sftp "
  "nc "
  "ncat "
  "netcat "
  "rsync "
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    jq -n \
      --arg reason "Destructive command detected: $pattern" \
      '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "ask",
          permissionDecisionReason: $reason
        }
      }'
    exit 0
  fi
done

for pattern in "${NETWORK_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    jq -n \
      --arg reason "Network command detected: $pattern— verify the target" \
      '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "ask",
          permissionDecisionReason: $reason
        }
      }'
    exit 0
  fi
done

exit 0

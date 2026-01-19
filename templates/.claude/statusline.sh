#!/bin/bash
# Claude Code statusline with Dracula theme colors

input=$(cat)

# Dracula theme colors (true color)
PURPLE='\033[38;2;189;147;249m'   # #bd93f9 - model
PINK='\033[38;2;255;121;198m'     # #ff79c6 - accents
CYAN='\033[38;2;139;233;253m'     # #8be9fd - git branch
GREEN='\033[38;2;80;250;123m'     # #50fa7b - good/added
YELLOW='\033[38;2;241;250;140m'   # #f1fa8c - warning
ORANGE='\033[38;2;255;184;108m'   # #ffb86c - cost
RED='\033[38;2;255;85;85m'        # #ff5555 - danger/removed
COMMENT='\033[38;2;98;114;164m'   # #6272a4 - dim text
FG='\033[38;2;248;248;242m'       # #f8f8f2 - foreground
RESET='\033[0m'

# Parse JSON input
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
CWD=$(echo "$input" | jq -r '.workspace.current_dir // "."')
DIR=$(basename "$CWD")
CTX_PERCENT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d'.' -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
LINES_ADD=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_DEL=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Format cost (show 2 decimal places, or 4 if very small)
if (( $(echo "$COST < 0.01" | bc -l) )); then
    COST_FMT=$(printf "%.4f" "$COST")
else
    COST_FMT=$(printf "%.2f" "$COST")
fi

# Context color based on usage
if [ "$CTX_PERCENT" -lt 50 ]; then
    CTX_COLOR="$GREEN"
elif [ "$CTX_PERCENT" -lt 75 ]; then
    CTX_COLOR="$YELLOW"
elif [ "$CTX_PERCENT" -lt 90 ]; then
    CTX_COLOR="$ORANGE"
else
    CTX_COLOR="$RED"
fi

# Git status
GIT_INFO=""
if git -C "$CWD" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git -C "$CWD" symbolic-ref --quiet --short HEAD 2>/dev/null || git -C "$CWD" rev-parse --short HEAD 2>/dev/null)
    if git -C "$CWD" --no-optional-locks diff-index --quiet HEAD -- 2>/dev/null; then
        GIT_INFO=" ${CYAN}${BRANCH}${RESET}"
    else
        GIT_INFO=" ${CYAN}${BRANCH}${YELLOW}*${RESET}"
    fi
fi

# Build status line
printf "${PURPLE}${MODEL}${RESET} "
printf "${COMMENT}| ctx: ${RESET}${CTX_COLOR}${CTX_PERCENT}%%${RESET} "
printf "${COMMENT}| cost: ${RESET}${ORANGE}\$${COST_FMT}${RESET} "
printf "${COMMENT}| lines: ${RESET}${GREEN}+${LINES_ADD}${RESET}${COMMENT}/${RESET}${RED}-${LINES_DEL}${RESET} "
printf "${COMMENT}| ${RESET}${PINK}${DIR}${RESET}"
printf "${GIT_INFO}"
printf "\n"

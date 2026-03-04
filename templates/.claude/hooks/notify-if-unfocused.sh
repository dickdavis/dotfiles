#!/bin/bash
# notify-if-unfocused.sh
# Only fire a notification if the user is not focused on the Claude Code pane.

FRONTMOST=$(lsappinfo info -only name $(lsappinfo front) | awk -F'"' '{print $4}')

if [[ "$FRONTMOST" == "Alacritty" ]]; then
  # Terminal is focused — check if the active tmux pane is Claude's pane
  if [[ -n "$TMUX_PANE" ]]; then
    ACTIVE_PANE=$(tmux display-message -p '#{pane_id}')
    if [[ "$TMUX_PANE" == "$ACTIVE_PANE" ]]; then
      exit 0
    fi
  else
    exit 0
  fi
fi

osascript -e 'display notification "Claude Code needs your attention" with title "Claude Code"'

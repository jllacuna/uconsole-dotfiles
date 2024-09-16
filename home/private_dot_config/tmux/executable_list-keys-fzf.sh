#!/usr/bin/env sh

# List tmux key bindings with notes and filter through fzf
# Allow multi-selection and bind F1 to toggle all
keys=$(tmux list-keys -N | fzf --multi --bind "f1:toggle-all")

# If keys were selected
if [ -n "$keys" ]; then
  # Get the count of selected keys
  count=$(echo "$keys" | wc -l)

  # Print keys to an empty tmux pane
  # -I to pipe the keys into an empty pane
  # -l to size the pane according to the number of keys selected
  # -f to span the window instead of spanning the width of the current pane
  echo -n "$keys" | tmux split-window -l $count -fI
fi

SESSION_NAME=$1

tmux set-option -t "$SESSION_NAME" @session_total_time 0
tmux set-option -t "$SESSION_NAME" @session_start_time ""
CURRENT_TIME=$(date +%s)
tmux set-option -t "$SESSION_NAME" @session_start_time "$CURRENT_TIME"

tmux display-message "Theuragia"

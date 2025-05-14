SESSION_NAME=$1
ACTION=$2

case $ACTION in
    start)
        # echo "start" >> ~/debug_logs/theurgia.log
        tmux set-option -t "$SESSION_NAME" @session_start_time "$(date +%s)"
        START_TIME=$(tmux show-option -qv -t "$SESSION_NAME" @session_start_time)
        echo "start: $START_TIME" >> ~/debug_logs/theurgia.log
        ;;
    stop)
        # echo "stop" >> ~/debug_logs/theurgia.log
        START_TIME=$(tmux show-option -qv -t "$SESSION_NAME" @session_start_time)
        if [ -n "$START_TIME" ]; then
            CURRENT_TIME=$(date +%s)
            ELAPSED_TIME=$(($CURRENT_TIME - $START_TIME))
            TOTAL_TIME=$(tmux show-option -qv -t "$SESSION_NAME" @session_total_time)
            TOTAL_TIME=$(( ${TOTAL_TIME:-0} + $ELAPSED_TIME ))
            tmux set-option -t "$SESSION_NAME" @session_total_time "$TOTAL_TIME"
            tmux set-option -t "$SESSION_NAME" @session_start_time ""
        fi
        echo "saved: $TOTAL_TIME" >>~/debug_logs/theurgia.log
        ;;
    show)
        # echo "show" >> ~/debug_logs/theurgia.log
        TOTAL_TIME=$(tmux show-option -qv -t "$SESSION_NAME" @session_total_time)
        START_TIME=$(tmux show-option -qv -t "$SESSION_NAME" @session_start_time)
        # echo "Session start time: $START_TIME" >> ~/debug_logs/theurgia.log
        if [ -n "$START_TIME" ]; then
            CURRENT_TIME=$(date +%s)
            ELAPSED_TIME=$(($CURRENT_TIME - $START_TIME))
            TOTAL_TIME=$(( ${TOTAL_TIME:-0} + $ELAPSED_TIME))
        fi

        ELAPSED_HOURS=$(($TOTAL_TIME / 3600))
        ELAPSED_MINUTES=$((($TOTAL_TIME % 3600) / 60))
        ELAPSED_SECONDS=$(($TOTAL_TIME % 60))
        MAX_HOURS=3
        GAUGE_WIDTH=10
        PROGRESS=$(($TOTAL_TIME * 100/ ($MAX_HOURS * 3600)))
        FILLED_WIDTH=$(($GAUGE_WIDTH * $PROGRESS / 100))

        if [ "$FILLED_WIDTH" -gt "$GAUGE_WIDTH" ]; then
            FILLED_WIDTH=$GAUGE_WIDTH
        fi

        if [ "$FILLED_WIDTH" -eq "$GAUGE_WIDTH" ]; then
            COLOR="#[fg=red]"
        elif [ "$FILLED_WIDTH" -ge $(($GAUGE_WIDTH * 75 / 100)) ]; then
            COLOR="#[fg=colour208]"
        elif [ "$FILLED_WIDTH" -ge $(($GAUGE_WIDTH * 50 / 100)) ]; then
            COLOR="#[fg=colour47]"
        else
            COLOR="#[fg=colour87]"
        fi
        

        #echo "TOTAL_TIME: $TOTAL_TIME" >> ~/debug_logs/theurgia.log
        #echo "elapsed_time: $ELAPSED_TIME" >>~/debug_logs/theurgia.log
        #echo "filled_width: $FILLED_WIDTH" >>~/debug_logs/theurgia.log
        if [ "$FILLED_WIDTH" -gt 0 ]; then
            FILLED_PART=$(printf '█%.0s' $(seq 1 $FILLED_WIDTH))
        else
            FILLED_PART=""
        fi
        REMAINDER=$(( ($GAUGE_WIDTH * $PROGRESS) % 100 / 12 ))
        # echo "remainder_char: $REMAINDER" >> ~/debug_logs/theurgia.log
        REMAINDER_CHAR=""
        case $REMAINDER in
        1) REMAINDER_CHAR="▏" ;;
        2) REMAINDER_CHAR="▎" ;;
        3) REMAINDER_CHAR="▍" ;;
        4) REMAINDER_CHAR="▌" ;;
        5) REMAINDER_CHAR="▋" ;;
        6) REMAINDER_CHAR="▊" ;;
        7) REMAINDER_CHAR="▉" ;;
        esac
        EMPTY_WIDTH=$(($GAUGE_WIDTH - $FILLED_WIDTH))

        if [ "$EMPTY_WIDTH" -gt 0 ]; then
            EMPTY_PART=$(printf ' %.0s' $(seq 1 $EMPTY_WIDTH))
        else
            EMPTY_PART=""
        fi 
        GAUGE="$FILLED_PART$REMAINDER_CHAR$EMPTY_PART"
        TIME_DISPLAY="${ELAPSED_HOURS}h ${ELAPSED_MINUTES}m ${ELAPSED_SECONDS}s"

        echo "$COLOR 󰳳TURGIA $GAUGE"

        ;;
esac


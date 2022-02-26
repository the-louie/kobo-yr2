#
# This script runs in the background and send signals to the main script when you press
# the button on the front of the Kobo
#
DOWN_TIME=0
while true; do
        DATA=$(hexdump -n 13 /dev/input/event0 2>&1)

        # this is not bash but ash so =~ doen't exist
        if echo "$DATA" | grep "66 0001"; then
                echo "DOWN"
                DOWN_TIME=$(date +"%s")
        elif echo "$DATA" | grep "66 0000"; then
                DELTA_TIME=$(($(date +"%s") - $DOWN_TIME))
                echo "UP $DELTA_TIME"
                if [ "0$DELTA_TIME" -lt 4 -a -f /tmp/lo_main.pid ]; then
                        kill -5 $(cat /tmp/lo_main.pid)
                elif [ "0$DELTA_TIME" -lt 10 -a -f /tmp/lo_main.pid ]; then
                        kill -6 $(cat /tmp/lo_main.pid)
                elif [ "0$DELTA_TIME" -gt 10 -a -f /tmp/lo_main.pid ]; then
                        kill -6 $(cat /tmp/lo_main.pid)
                        exit 0
                fi
        fi
done

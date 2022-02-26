#! /bin/sh

#
# This is the main script that reloads and redraws the images every 5 minutes
#

F_TRAP=0
MODE=0
MAXMODE=4 # Number of weather[n].raw images, plus 1
N=0

ssleep() {
        A=$1
        echo "Sleeping for $A s"
        while [ "0$A" -gt 0 ]; do
                A=$(($A - 1))
                sleep 1
                if [ $F_TRAP -eq 5 ]; then A=0; F_TRAP=0; fi # exit sleep by trap POLL
                date > /tmp/keepalive 2>&1
        done
}

load_image() {
        echo "LOADING...."
        RELOAD='1'
        if [ $N -eq 10 ]; then
          RELOAD=''
          N=0
        fi
        N=$(($N + 1))
        wget -q -T 10 -O - "http://docker.i.louie.se:21800/kobo/weather$MODE.raw" | /usr/local/Kobo/pickel showpic $RELOAD
        echo "DONE"
}

sig_poll() {
        MODE=$(($(($MODE + 1)) % $MAXMODE))
        echo "SIGPOLL new mode: $MODE"
        F_TRAP=5
}
trap sig_poll 5 # SIGPOLL

sig_abort() {
        echo "SIGABRT"
        exit 0
}
trap sig_abort 6 # SIGABRT


while true; do
        # store pid
        echo $$ > /tmp/lo_main.pid_
        mv /tmp/lo_main.pid_ /tmp/lo_main.pid

        load_image
        ssleep 300
done

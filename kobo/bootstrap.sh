#! /bin/sh

#
# This is the startup script that should be added to /etc/init.d/rcS towards the end.
#
# Like:
# /bin/sh /mnt/onboard/bootstrap.sh >> /mnt/onboard/logs/run.log 2>&1 &
#
# It shutsdown the default applications (nickel and hindenburg) and tries to download
# the script main.sh into ./scripts. If that fails it exists and restarts nickel and
# the Kobo should be stock again.
#
# If it can download main.sh it first starts the helper-script `button.sh` that watches
# for button-presses and sends singals to `main.sh`.
#

HOST="static-www:21800"

date
echo "run.sh started "$(date | tr -d '\n')
echo "sleeping for 60s"
usleep 55000

pkill nickel; sleep 1; pkill -9 nickel; sleep 1; pkill -9 nickel; sleep 1
pkill hindenburg; sleep 1; pkill -9 hindenburg; sleep 1; pkill -9 hindenburg; sleep 1

cat /mnt/onboard/images/start0.raw | /usr/local/Kobo/pickel showpic 1

# clear old scripts
echo "clearing old scripts"
rm -rf /mnt/onboard/scripts
mkdir -p /mnt/onboard/scripts

# enable networking
cat /mnt/onboard/images/network0.raw | /usr/local/Kobo/pickel showpic 1
echo "enable networking"
/bin/sh /mnt/onboard/wifiup.sh

echo "wait a while..."
usleep 500000 # sleep for 5 seconds

# try to download script to run
echo "fetching main.sh"
ERRCOUNT=0
cat /mnt/onboard/images/mainsh0.raw | /usr/local/Kobo/pickel showpic 1
while ! wget -T 10 -O /mnt/onboard/scripts/main.sh -q http://$HOST/kobo/main.sh; do
        echo " * fail"
        usleep 100000 # sleep for 10 seconds
        ERRCOUNT=$(($ERRCOUNT + 1))

        if [ "0$ERRCOUNT" -gt 10 ]; then
                # can't reach server
                /bin/sh /mnt/onboard/restart_nickle.sh
                exit 1
        fi
done

# run script
echo "button.sh"
nohup /bin/sh /mnt/onboard/button.sh &
echo "running main.sh"
cd /mnt/onboard/scripts
while /bin/sh /mnt/onboard/scripts/main.sh; do
        echo "main.sh exit 0"
        echo "fetching main.sh"
        ERRCOUNT=0
        cat /mnt/onboard/images/mainsh0.raw | /usr/local/Kobo/pickel showpic
        while ! wget -T 10 -O /mnt/onboard/scripts/main.sh -q http://$HOST/kobo/main.sh; do
                echo " * fail"
                usleep 100000 # sleep for 10 seconds
                ERRCOUNT=$(($ERRCOUNT + 1))

                if [ "0$ERRCOUNT" -gt 10 ]; then
                        # can't reach server
                        /bin/sh /mnt/onboard/restart_nickle.sh
                        exit 1
                fi
        done
        sleep 1
done

/mnt/onboard/restart_nickle.sh

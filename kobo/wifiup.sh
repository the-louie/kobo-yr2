#!/bin/sh
# echo `date +"%d-%m-%y %T"` "starting Wifi"
# ifconfig eth0 up
# wlarm_le -i eth0 up
# wpa_supplicant -s -i eth0 -c /etc/wpa_supplicant/wpa_supplicant.conf -C /var/run/wpa_supplicant -B
# sleep 2
# udhcpc -S -i eth0 -s /etc/udhcpc.d/default.script -t15 -T10 -A3 -f -q
exit 0
if /sbin/iwgetid >/dev/null |grep "gripenberg"; then
        echo "Network already up, exiting"
        exit 0
fi

mkdir -p /mnt/onboard/logs

echo "---------------------------------------"
echo "wifiup.sh started "$(date|tr -d '\n')
echo ""

echo "updating graphics"
cat /mnt/onboard/output.raw | /usr/local/Kobo/pickel showpic

echo "inmod sdio_wifi_pwr"
insmod /drivers/ntx508/wifi/sdio_wifi_pwr.ko
echo "insmod dhd"
insmod /drivers/ntx508/wifi/dhd.ko
echo "sleeping 2s"
usleep 2000000

echo "ifconfig eth0 up"
ifconfig eth0 up

echo "wlarm_le"
wlarm_le -i eth0 up

echo "wpa_supplicant"
wpa_supplicant -s -i eth0 -c /etc/wpa_supplicant/wpa_supplicant.conf -C /var/run/wpa_supplicant -B

echo "udhcpc"
udhcpc -S -i eth0 -s /etc/udhcpc.d/default.script -t15 -T10 -A3 -f -q

echo "wifiup.sh ended "$(date|tr -d '\n')
echo "---------------------------------------"
echo ""

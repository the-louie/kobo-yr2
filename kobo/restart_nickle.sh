#! /bin/sh

# restart nickel to enable 'normal' mode again

PRODUCT=`/bin/kobo_config.sh`
CPU=`ntx_hwconfig -s -p /dev/mmcblk0 CPU`
PLATFORM=$CPU-ntx
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/lib:
runlevel=S
prevlevel=N
export PATH runlevel prevlevel

export UBOOT_MMC=/etc/u-boot/$PLATFORM/u-boot.mmc
export UBOOT_RECOVERY=/etc/u-boot/$PLATFORM/u-boot.recovery

FS_CORRUPT=0

INTERFACE=eth0
WIFI_MODULE=dhd


export PLATFORM
export PRODUCT
export INTERFACE
export WIFI_MODULE

export NICKEL_HOME=/mnt/onboard/.kobo
export LD_LIBRARY_PATH=/usr/local/Kobo
export WIFI_MODULE_PATH=/drivers/$PLATFORM/wifi/$WIFI_MODULE.ko
export LANG=en_US.UTF-8

export DBUS_SESSION_BUS_ADDRESS=`/bin/dbus-daemon --session --print-address --fork`

/usr/local/Kobo/hindenburg &
/usr/local/Kobo/nickel -platform kobo -skipFontLoad &

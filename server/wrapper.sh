#! /bin/env bash

#DIR=$(dirname $0)
DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo "DIR /tmp from $DIR"
cd /tmp

echo "Staring chrome"
pkill chromium
/snap/bin/chromium --headless --hide-scrollbars --remote-debugging-port=9222 --disable-gpu &
CPID=$!

echo "Waiting 2s"
sleep 2

echo "Taking screenshots"
/usr/bin/node "$DIR/screenshot.js" --url "http://hass:8123/lovelace-kobo/temperature" --filename "weather1.png" 
echo "Waiting 1s"
/usr/bin/node "$DIR/screenshot.js" --url "http://hass:8123/lovelace-kobo/weather" --filename "weather0.png" 
echo "Waiting 1s"
sleep 1

echo "Killing chrome"
kill $CPID || kill -9 $CPID

echo "converting to 1-bit raw"
/usr/bin/convert weather0.png -gravity north -crop 600x800+0+56 -format png - | /usr/bin/ffmpeg -i - -vf transpose=2 -f rawvideo -pix_fmt rgb565 -s 800x600 -y "weather0.raw"
/usr/bin/convert weather1.png -gravity north -crop 600x800+0+56 -format png - | /usr/bin/ffmpeg -i - -vf transpose=2 -f rawvideo -pix_fmt rgb565 -s 800x600 -y "weather1.raw"

echo "copying image to static-www"
/usr/bin/scp weather{0,1}.{raw,png} static-www:/docker/static-www/html/kobo/


echo "DIR $DIR"
cd "$DIR"

echo "Done!"



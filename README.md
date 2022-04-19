# KOBO-YR2
This is work in progress. The state is `works on my machine` and if you find anything that could be improved please submit a PR.

## Server scripts
Scripts to be placed on a server and run via cron.

Configure `wrapper.sh` to add adress to Home-assistant dashboard and static webserver.

## Kobo scripts
Scripts to be placed on the Kobo reader, and also partly on a static web server.

Place all scripts in `/mnt/onboard` and configure `bootstrap.sh` and add it to `/etc/init.d/rcS`.
Place `main.sh` in the same directory as the uploaded images on the static webserver.

Good luck!

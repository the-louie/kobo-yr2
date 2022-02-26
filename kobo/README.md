# KOBO-YR2 Kobo scripts
This is work in progress. The state is `works on my machine` and if you find anything that could be improved please submit a PR.

## bootstrap.sh
Should be added to the end of `/etc/init.d/rcS`.

Kills the standard applications on the Kobo, downloads `main.sh` and starts the helper-script `buttons.sh` and then `main.sh`

## button.sh
Runs in the background and triggers on button-presses on the front button.
A short press advances the image-counter and downloads and displayes the next image.
A long press exists `main.sh` and restarts the standard applications.

## main.sh
The main script that downloads and redraws the image every five minutes.


# Possible improvements
There are a lot of things to improve, the current state is the result of experimenting until it works, and then don't touch it anymore.
It would be nice to reduce the scope of `bootstrap.sh` so it basically only downloads the other scripts (all of them instead of just main.sh).
Smarter redrawing would be nice also.

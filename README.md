# Service Monitor

These files are loaded onto the R-Pi and are responsible for checking the availability of the htg-display-server

To upload to pi, from this directory run:
> scp package.json run-chromium.sh serviceChecker.js pi@192.168.0.102:/home/pi/service-monitor

Edit .bashrc file:
> cd /home/pi \
> sudo nano .bashrc

Update with:
> nohup node /home/pi/service-monitor/serviceChecker.js &>/dev/null &

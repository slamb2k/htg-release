#!/bin/bash

export DISPLAY=:0.0
export XAUTHORITY=/home/htc/.Xauthority

xdotool search --onlyvisible --class chromium-browser windowactivate key ctrl+r

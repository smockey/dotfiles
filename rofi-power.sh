#!/bin/bash

# rofi-power
# Use rofi to call systemctl for shutdown, reboot, etc

# 2016 Oliver Kraitschy - http://okraits.de

LAUNCHER='rofi -width 30 -dmenu -i -p power:'
OPTIONS="Logout\nLock\nReboot\nPower-off\nSuspend\nHibernate"

# Show exit wm option if exit command is provided as an argument
if [ ${#1} -gt 0 ]; then
  OPTIONS="Exit window manager\n$OPTIONS"
fi

option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $1}' | tr -d '\r\n'`
if [ ${#option} -gt 0 ]; then
    case $option in
      Exit)
        eval $1
        ;;
      Logout)
        echo "awesome.quit()" | awesome-client
        ;;
      Lock)
        i3lock  -f -t -n \
          -i /home/tlarrieu/Pictures/wallpapers/wallhaven-244583.png
        ;;
      Reboot)
        systemctl reboot
        ;;
      Power-off)
        systemctl poweroff
        ;;
      Suspend)
        systemctl suspend
        ;;
      Hibernate)
        systemctl hibernate
        ;;
      *)
        ;;
    esac
fi

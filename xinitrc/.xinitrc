#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# read config from Xresources
[[ -f ~/.config/Xresources ]] && xrdb -merge ~/.config/Xresources

# set keyboard
setxkbmap -layout de -variant deadacute

# map caps to esc
setxkbmap -option caps:escape

# enable numlock
numlockx &

#load keyboard layout
xmodmap .Xmodmap

# monitor config
xrandr --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --off --output USB-C-0 --off

exec awesome # -c .config/awesome/rc.lua
#exec gala
#exec i3 
#exec openbox 
#exec openbox 
#exec xfwm4

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

exec awesome 

#!/bin/sh
intern=eDP-1
extern=HDMI-2
extern_wayland=HDMI-A-2

if xrandr | grep "$extern disconnected"; then
    xrandr --output "$extern" --off --output "$intern" --auto
else
    xrandr --output "$intern" --off --output "$extern" --auto
fi

if wlr-randr | grep "$extern_wayland"; then
    wlr-randr --output $intern --off
fi

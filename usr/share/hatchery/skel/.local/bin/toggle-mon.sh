#!/bin/sh
intern=eDP-1
extern=HDMI-2
extern_hyprland=HDMI-A-2

if xrandr | grep "$extern disconnected"; then
    xrandr --output "$extern" --off --output "$intern" --auto
else
    xrandr --output "$intern" --off --output "$extern" --auto
fi

if wlr-randr | grep "$extern_hyprland"; then
    wlr-randr --output $intern --off && hyprctl dispatch workspace 1
fi

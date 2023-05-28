#!/bin/bash

swaymsg input "*" xkb_layout $(localectl status | awk NR==3'{print $3}')

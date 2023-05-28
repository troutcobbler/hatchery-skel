#!/bin/bash

if [ "$(pidof conky)" ]; then
  pkill conky
else
  $1 $2 $3 -q &
fi

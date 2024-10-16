#!/usr/bin/env bash

AMIXER=$(amixer sget -M PCM | grep -i 'mono:')
REGEX='([0-9]+)%.+(off|on)'

[[ $AMIXER =~ $REGEX ]]
VOLUME=${BASH_REMATCH[1]};
MUTE=${BASH_REMATCH[2]};

if [ "$MUTE" = "off" ]; then
  echo "${VOLUME}% 󰖁"
elif (( $VOLUME == 0)); then
  echo "${VOLUME}% "
elif (( $VOLUME < 50)); then
  echo "${VOLUME}% "
else
  echo "${VOLUME}% "
fi

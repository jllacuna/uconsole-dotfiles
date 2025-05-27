#!/usr/bin/env sh


grep 'cpu' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf("#[fg=%s]%.2f%%", usage > 80 ? "#aa092c" : "#12a13a", usage)}'

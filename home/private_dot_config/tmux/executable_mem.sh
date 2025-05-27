#!/usr/bin/env sh

free | grep Mem | awk '{usage=$3/$2*100} END {printf("#[fg=%s]%.2f%%", usage > 80 ? "#aa092c" : "#12a13a", usage)}'

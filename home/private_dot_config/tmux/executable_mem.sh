#!/usr/bin/env sh

free | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}'

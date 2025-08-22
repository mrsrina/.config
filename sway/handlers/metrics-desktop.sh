#!/bin/sh

while true; do
  DT_INFO=$(date +'%Y-%m-%d %X')
  printf "| %s |\n" "$DT_INFO"
  sleep 60
done

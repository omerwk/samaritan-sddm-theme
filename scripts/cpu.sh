#!/bin/bash

lscpu | awk -F: '/Model name/ {
    gsub(/^[ \t]+/, "", $2)
    gsub(/  *[0-9]+-Core Processor/, "", $2)
    gsub(/\(R\)|\(TM\)/, "", $2)
    print $2
    exit
}'
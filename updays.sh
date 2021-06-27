#!/bin/bash
echo "scale=2;($(date +%s)-$(date +%s -d $(uptime -s | cut -d' ' -f1 | tr -d '-')))/(3600*24)" | bc

#!/bin/bash
echo "($(date +%s)-$(date +%s -d $(uptime -s | cut -d' ' -f1 | tr -d '-')))/(3600*24)" | bc

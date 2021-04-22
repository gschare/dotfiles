#!/bin/bash
free -h | grep "^Mem" | tr -d [:alpha:] | awk '{printf("%u%%", 100*$3/$2);}'

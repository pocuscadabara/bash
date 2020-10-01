#!/bin/bash

# See Brendan Gregg's LISA19 - Linux Sytems Performance presentation
# https://youtu.be/fhBHvsi0Ql0

echo -e "60 second performance snapshot...\n"

echo -e "\n\033[1muptime\033[0m for load averages"
uptime

echo -e "\n\033[1mdmesg -T\033[0m  for kernel errors"
dmesg -T|tail

echo -e "\n\033[1mvmstat 1 5\033[0m for overall stats by time"
vmstat 1 5

echo -e "\n\033[1mmpstat -P ALL 1 5\033[0m for CPU balance"
mpstat -P ALL 1 5

echo -e "\n\033[1mpidstat 1 5\033[0m for process usage"
pidstat 1 5

echo -e "\n\033[1miostat -xz 1 5\033[0m for disk I/O"
iostat -xz 1 5

echo -e "\n\033[1mfree -m\033[0m for memory usage"
free -m

echo -e "\n\033[1msar -n DEV 1 5\033[0m for network I/O"
sar -n DEV 1 5

echo -e "\n\033[1msar -n TCP,ETCP 1 5\033[0m for TCP stats"
sar -n TCP,ETCP 1 5

echo -e "\n\033[1mtop\033[0m is an option too. ;)"

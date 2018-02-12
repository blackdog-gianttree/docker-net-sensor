#!/bin/bash

# Variables:
# -e INTERFACE
# -e CLUSTER
# -e CORE_NUM
# -e RULES

[ -f /var/log/snort/barnyard2.waldo ] || touch /var/log/snort/barnyard2.waldo
[ -f /var/run/rsyslogd.pid ] && rm /var/run/rsyslogd.pid
/usr/sbin/rsyslogd

pulledpork () {
 run_pulledpork.sh
}

snort () {
 run_snort.sh
}

barnyard () {
 run_barnyard.sh
}

${@}

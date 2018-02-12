#!/bin/bash

[ -f /var/run/rsyslogd.pid ] && rm /var/run/rsyslogd.pid
/usr/sbin/rsyslogd

bro () {
 run_bro.sh
}

${@}

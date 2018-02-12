#!/bin/bash

barnyard2 -c /etc/snort/barnyard2.conf -S /etc/snort/rules/sid-msg.map -h ${HOSTNAME} -i ${N} -d /var/log/snort -f merged.log -w /var/log/snort/barnyard2.waldo

#!/bin/bash

snort -m 027 -d -l /var/log/snort -c /etc/snort/snort.conf -i ${I} --daq-var clusterid=${CL} --daq-var bindcpu=${CO}

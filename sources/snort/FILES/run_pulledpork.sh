#!/bin/sh

SET=/etc/snort/rules

/usr/local/bin/pulledpork.pl -P -v -T \
    -c ${SET}/pulledpork.conf \
    -m ${SET}/sid-msg.map \
    -s /usr/local/lib/snort_dynamicrules \
    -o ${SET}/snort.rules \
    -e ${SET}/enablesid.conf \
    -i ${SET}/disablesid.conf \
    -M ${SET}/modifysid.conf \
    -b ${SET}/dropsid.conf \
    -h ${SET}/pulledpork.log

#snort -c ${CONFDIR}/snort.conf -S RULE_PATH=${RULES} -i lo -T

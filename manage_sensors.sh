#!/bin/bash


build_host () {

 rm -rf /usr/src/PF_RING*
 tar -xzvf sources/pfring/FILES/PF_RING-6.6.0.tar.gz -C /usr/src/

 cd /usr/src/PF_RING-6.6.0 && sed -i 's/cd intel/\#cd intel/g' drivers/Makefile && make
 echo foo
 cd kernel && make install

 modprobe pf_ring
 echo pf_ring > /etc/modules-load.d/pfring.conf

}


build_cont () {
 docker build -t pfring ./sources/pfring
 docker build -t snort ./sources/snort
 docker build -t bro ./sources/bro
}


deploy_snort () {
 mkdir -p /var/log/network_sensor/snort
 for SENSOR in `cat conf/snort/worker_config | grep -v '\#'` ; do

  INTERFACE=`echo ${SENSOR} | awk -F',' '{print $1}'`
  CLUSTER=`echo ${SENSOR} | awk -F',' '{print $2}'`
  CORE_NUM=`echo ${SENSOR} | awk -F',' '{print $3}'`
  RULES=`echo ${SENSOR} | awk -F',' '{print $4}'`

  SNAME=${INTERFACE}_${CLUSTER}_${CORE_NUM}_${RULES}
  CONFDIR=${CWD}/conf/snort/interfaces/${INTERFACE}
  RULEDIR=${CWD}/conf/snort/rules/${RULES}
  LOGDIR=/var/log/network_sensor/snort/${SNAME}
  mkdir -p "${LOGDIR}" 
  
  docker run --privileged -v ${CONFDIR}:/etc/snort -v ${RULEDIR}:/etc/snort/rules -v ${LOGDIR}:/var/log/snort --net=host -e I=${INTERFACE} -e CL=${CLUSTER} -e CO=${CORE_NUM} --restart=always -d --name snort_${SNAME} -t snort snort
  docker run --privileged -v ${CONFDIR}:/etc/snort -v ${RULEDIR}:/etc/snort/rules -v ${LOGDIR}:/var/log/snort --net=host -e N=${SNAME} --restart=always -d --name barnyard_${SNAME} -t snort barnyard

 done
}

deploy_bro () {
 mkdir -p /var/log/network_sensor/bro
 for INTERFACE in `ls conf/bro/interfaces` ; do

  CONFDIR=${CWD}/conf/bro/interfaces/${INTERFACE}
  LOGDIR=/var/log/network_sensor/bro/${INTERFACE}
  mkdir -p "${LOGDIR}"

  docker run --privileged -v ${CONFDIR}:/usr/local/etc -v ${LOGDIR}:/var/log/bro --net=host --restart=always -d --name bro_${INTERFACE} -t bro bro

 done
}

update_snort () {
 for RULES in `ls ${CWD}/conf/snort/rules`; do
  docker run -v ${CWD}/conf/snort/rules/${RULES}:/etc/snort/rules --name rule_run -i -t snort pulledpork
  docker rm -f rule_run
 done
}


destroy_all () {
 list=`docker ps -a | grep -v CONT | awk '{print $1}'`
 docker rm -f ${list}
 rm -rf /var/log/network_sensor/*
}


CWD=`pwd`
${1}

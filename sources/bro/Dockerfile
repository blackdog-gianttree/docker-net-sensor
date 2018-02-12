FROM pfring

RUN apt-get -y update
RUN apt-get --no-install-recommends -y install cmake make gcc g++ \
    rsyslog flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev

# Untar source
ADD FILES/bro-2.5.2.tar.gz /usr/local/src

# Build bro
RUN cd /usr/local/src/bro-* && \
    ./configure --prefix=/usr/local \ 
        --with-pcap=/usr/local/lib && \
    make && \
    make install

# Setup Rsyslog
COPY FILES/syslog_forward.conf /etc/rsyslog.d/syslog_forward.conf
RUN mkdir -p /var/lib/rsyslog

# Add Scripts
COPY FILES/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY FILES/run_bro.sh /usr/local/bin/run_bro.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

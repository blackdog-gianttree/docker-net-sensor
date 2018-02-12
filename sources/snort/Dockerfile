FROM pfring

RUN apt-get -y update
RUN apt-get --no-install-recommends -y install perl libio-socket-ssl-perl \
    libcrypt-ssleay-perl rsyslog ca-certificates libwww-perl autoconf bison libtool

# Untar source
ADD FILES/snort-2.9.9.0.tar.gz /usr/local/src
ADD FILES/daq-2.0.6.tar.gz /usr/local/src 
ADD FILES/libdnet-1.12.tgz /usr/local/src
ADD FILES/barnyard2-2-1.14.tar.gz /usr/local/src
#ADD FILES/barnyard2-2-1.13.tar.gz /usr/local/src
ADD FILES/pulledpork-0.7.2.tar.gz /usr/local/src

# Build DAQ
RUN cd /usr/local/src/daq-* && \
    LIBS="-lrt -lnuma" ./configure --prefix=/usr/local \
        --disable-nfq-module \
        --disable-ipq-module \
        --with-libpcap-includes=/usr/local/include \
        --with-libpcap-libraries=/usr/local/lib && \
    make && \
    make install
RUN echo "/usr/local/lib/daq" > /etc/ld.so.conf.d/daq.conf
RUN ldconfig

# Build pfring-daq-module
RUN cd /usr/local/src/PF_RING/userland/snort/pfring-daq-module && \
    autoreconf -ivf
RUN cd /usr/local/src/PF_RING/userland/snort/pfring-daq-module && \
    LIBS="-lrt -lnuma" ./configure --prefix=/usr/local \
        --with-libdaq-includes=/usr/local/include \
        --with-libsfbpf-includes=/usr/local/include \
        --with-libsfbpf-libraries=/usr/local/lib \
        --with-libpfring-includes=/usr/local/include \
        --with-libpfring-libraries=/usr/local/lib && \
    make && \
    make install

# Build libdnet
RUN cd /usr/local/src/libdnet-* && \
    ./configure --prefix=/usr/local "CFLAGS=-fPIC" && \
    make && \
    make install
RUN cp /usr/local/lib/libdnet.1.0.1 /usr/local/lib/libdnet.so.1.0.1
RUN ldconfig

# Build snort
RUN cd /usr/local/src/snort-* && \
    ./configure --prefix=/usr/local \
        --enable-ipv6 \
        --enable-zlib \
        --enable-gre \
        --enable-mpls \
        --enable-targetbased \
        --enable-decoder-preprocessor-rules \
        --enable-pthread \
        --enable-dynamicplugin \
        --enable-normalizer \
        --disable-static-daq \
	--enable-perfprofiling \
        --with-daq-includes=/usr/local/include \
        --with-daq-libraries=/usr/local/lib \
        --with-dnet-includes=/usr/local/include \
        --with-dnet-libraries=/usr/local/lib \
        --with-libpcap-includes=/usr/local/include \
        --with-libpcap-libraries=/usr/local/lib \
        --with-libpfring-includes=/usr/local/include \
        --with-libpfring-libraries=/usr/local/lib && \
    make && \
    make install
RUN mkdir -p /usr/local/lib/snort_dynamicrules

# Install Barnyard
RUN cd /usr/local/src/barnyard2-* && \
    autoreconf -fvi -I ./m4 && \
    ./configure --prefix=/usr/local \
	--with-libpcap-includes=/usr/local/include \
        --with-libpcap-libraries=/usr/local/lib \
        --with-libpfring-includes=/usr/local/include \
        --with-libpfring-libraries=/usr/local/lib && \
    make && \
    make install
RUN mkdir -p /var/log/barnyard2

# Install pulledpork
RUN cp /usr/local/src/pulledpork-*/pulledpork.pl /usr/local/bin && \
    chmod 0755 /usr/local/bin/pulledpork.pl

# Setup Rsyslog
COPY FILES/syslog_forward.conf /etc/rsyslog.d/syslog_forward.conf
RUN mkdir -p /var/lib/rsyslog

# Add Scripts
COPY FILES/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY FILES/run_snort.sh /usr/local/bin/run_snort.sh
COPY FILES/run_barnyard.sh /usr/local/bin/run_barnyard.sh
COPY FILES/run_pulledpork.sh /usr/local/bin/run_pulledpork.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

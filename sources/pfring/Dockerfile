FROM ubuntu:16.04

RUN apt-get update
RUN apt-get --no-install-recommends -y install libpcre3 libpcre3-dbg libpcre3-dev \
    build-essential autoconf automake libtool libnet1-dev \
    libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 \
    make flex bison git wget libmagic-dev pkg-config libnuma-dev strace

ADD FILES/PF_RING-6.6.0.tar.gz /usr/local/src/
RUN mv /usr/local/src/PF_RING-6.6.0 /usr/local/src/PF_RING

# Build the userland library
RUN cd /usr/local/src/PF_RING/userland/lib && \
    LIBS="-L/opt/pf_ring/lib -lrt -lnuma" ./configure --prefix=/usr/local && \
    make && \
    make install

# Build libpcap
RUN cd /usr/local/src/PF_RING/userland/libpcap-* && \
    LIBS="-L/opt/pf_ring/lib -lpfring -lpthread -lrt -lnuma" ./configure --prefix=/usr/local && \
    make && \
    make install

# Build tcpdump against new libpcap
RUN cd /usr/local/src/PF_RING/userland/tcpdump-4.9.0 && \
    LIBS="-L/opt/pf_ring/lib -lrt -lnuma" ./configure --prefix=/usr/local && \
    make && \
    make install

# Build example userland tools
RUN cd /usr/local/src/PF_RING/userland/examples && \
    make

# Copy the pf_ring kernel source header
RUN cp /usr/local/src/PF_RING/kernel/linux/pf_ring.h /usr/include/linux/pf_ring.h

RUN ldconfig

ENTRYPOINT ["/bin/bash"]

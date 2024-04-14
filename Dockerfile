ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION}

ARG MONIT_DOWNLOAD_URL

ARG DEBIAN_FRONTEND=noninteractive

RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split \
    && ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb \
    && ln -s /bin/rm /usr/sbin/rm \
    && ln -s /bin/tar /usr/sbin/tar 

WORKDIR /opt
RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get -y install rsync xmlstarlet curl nmap wakeonlan snmp snmp-mibs-downloader bc tzdata tcptraceroute jq iperf3 ripgrep netcat-openbsd arping dnsutils \
    && apt-get clean \
    && ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/* /usr/share/snmp/mibs/ietf/SNMPv2-PDU 

COPY root/download_monit.sh /download_monit.sh
RUN /download_monit.sh $MONIT_DOWNLOAD_URL

EXPOSE 2812

VOLUME /config

COPY root/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

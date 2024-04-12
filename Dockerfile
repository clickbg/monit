ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION}

ARG MONIT_DOWNLOAD_URL

ARG DEBIAN_FRONTEND=noninteractive

RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split \
    && ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb \
    && ln -s /bin/rm /usr/sbin/rm \
    && ln -s /bin/tar /usr/sbin/tar 

RUN  ln -s /proc/1/fd/1 /var/log/monit.log

WORKDIR /opt
RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get -y install rsync xmlstarlet curl nmap wakeonlan \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY root/download_monit.sh /download_monit.sh
RUN /download_monit.sh $MONIT_DOWNLOAD_URL

EXPOSE 8080

VOLUME /config

COPY root/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

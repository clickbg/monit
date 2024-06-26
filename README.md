
# [Monit](https://mmonit.com/monit/) in Docker
Barking at daemons, from Docker
--
[![CICD](https://github.com/clickbg/monit/workflows/CICD/badge.svg?branch=main)](https://github.com/clickbg/monit/actions/workflows/cicd.yaml)
[![UPDATE](https://github.com/clickbg/monit/workflows/UPDATE/badge.svg?branch=main)](https://github.com/clickbg/monit/actions/workflows/update.yaml)
[![PUBLISH](https://github.com/clickbg/monit/workflows/PUBLISH/badge.svg)](https://github.com/clickbg/monit/actions/workflows/publish.yaml)

Monit monitoring in Docker container. 

Monit monitoring in Docker container. 
The container is based on the latest Ubuntu LTS with Monit compiled from https://mmonit.com/monit/ 

**Included tools**
--
- nmap
- rsync
- xmlstarlet
- curl
- wakeonlan
- snmp
- bc
- jq
- tcptraceroute
- iperf3
- ripgrep
- netcat-openbsd
- arping
- dnsutils

If you need some other utility please file a bug.

**Usage**
--
Run:

    docker run --rm -d -p 2812:2812 --name monit -v /home/git/monitrc.example:/config/monitrc clickbg/monit:latest

Compose:

    monit:
      image: "clickbg/monit"
      container_name: "monit"
      restart: always
      volumes:
        - ${CONFDIR}/monit:/config
      ports:
        - "2812:2812"
      environment:
        - PUID=1000
        - PGID=1000
        - TZ=Europe/Sofia
      security_opt:
        - no-new-privileges

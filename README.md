
# [Monit](https://mmonit.com/monit/) in Docker
Barking at daemons, from Docker
--
[![CICD](https://github.com/clickbg/monit/workflows/CICD/badge.svg?branch=main)](https://github.com/clickbg/homekit-monitord/actions/workflows/cicd.yaml)
[![UPDATE](https://github.com/clickbg/monit/workflows/UPDATE/badge.svg?branch=main)](https://github.com/clickbg/homekit-monitord/actions/workflows/update.yaml)
[![PUBLISH](https://github.com/clickbg/monit/workflows/PUBLISH/badge.svg)](https://github.com/clickbg/homekit-monitord/actions/workflows/publish.yaml)

Monit monitoring in Docker container. 

**Usage**
--
Run:

    docker run --rm -d -p 8080:8080 --name monit -v /home/git/monitrc.example:/config/monitrc clickbg/monit:latest

Compose:

    monit:
      image: "clickbg/monit"
      container_name: "monit"
      restart: always
      volumes:
        - ${CONFDIR}/monit:/config
      ports:
        - "8080:8080"
      environment:
        - PUID=1000
        - PGID=1000
        - TZ=Europe/Sofia



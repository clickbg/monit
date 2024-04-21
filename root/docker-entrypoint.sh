#!/bin/bash
set -a

# Exit with error function
die()
{
 echo "$@" >&2
 exit 1
}

### Test if monitrc exists
test -e /config/monitrc || die "Monit conf not found at: /config/monitrc"

### Timezon
TZ="${TZ:-UTC}"

### Add user to passwd since monit fails to start if its user isn't present
USERID="${PUID:-1000}"
GROUPID="${GUID:-1000}"
useradd -M -s /bin/bash -u $USERID -U -d /config/ monit >/dev/null 2>&1 || true

### Setup logging
rm -f /var/log/monit.log >/dev/null 2>&1 || true
ln -s /dev/stdout /var/log/monit.log
mkdir /config/eventqueue >/dev/null 2>&1 || true
chown monit:monit /proc/1/fd/1 /dev/stdout /var/log/monit.log /config/eventqueue

### Set perms
chown monit:monit /config/monitrc /usr/local/bin/monit
chmod 600 /config/monitrc
chmod 700 /usr/local/bin/monit

### Link monitrc to a known location
ln -s /config/monitrc /etc/monitrc

### Check monit conf
su monit --command '/usr/local/bin/monit -c /config/monitrc -t' || die "Monit conf verification failed"

### Run as non-root user
exec su monit --command '/usr/local/bin/monit -c /config/monitrc -p /tmp/monit.pid -I'

#!/bin/bash

# Exit with error function
die()
{
 echo "$@" >&2
 exit 1
}

### Test if monitrc exists
test -e /config/monitrc || die "Monit conf not found at: /config/monitrc"

### Add user to passwd since monit fails to start if its user isn't present
USERID="${PUID:-1000}"
GROUPID="${GUID:-1000}"
useradd -M -s /sbin/nologin -u $USERID -U -d /nonexistent monit >/dev/null 2>&1 || true

### Setup logging
ln -s /dev/stdout /var/log/monit.log

### Set perms
chown monit:monit /run /proc/1/fd/1 /dev/stdout /var/log/monit.log
chown monit:monit /config/monitrc
chmod 600 /config/monitrc
chown monit:monit /usr/local/bin/monit
chmod 700 /usr/local/bin/monit

### Check monit conf
su monit --shell /bin/bash  -c '/usr/local/bin/monit -c /config/monitrc -t' || die "Monit conf verification failed"

### Run as non-root user
su monit --shell /bin/bash  -c '/usr/local/bin/monit -c /config/monitrc -p /run/monit.pid -I'

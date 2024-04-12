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
useradd -M -s /sbin/nologin -u $USERID -g $GROUPID -U -d /nonexistent monit || die "Failed to add user monit with PUID:$USERID and GUID:$GROUPID"

### Setup logging
chown monit:monit /dev/stdout
ln -s /dev/stdout /var/log/monit.log

### Set perms
chown monit:monit /config/monitrc
chmod 600 /config/monitrc
chown monit:monit /usr/local/bin/monit
chmod 700 /usr/local/bin/monit

### Check monit conf
su monit --shell /bin/bash  -c '/usr/local/bin/monit -c /config/monitrc -t' || die "Monit conf verification failed"

### Run as non-root user
su monit --shell /bin/bash  -c '/usr/local/bin/monit -c /config/monitrc -I'

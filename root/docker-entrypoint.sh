#!/bin/bash

# Exit with error function
die()
{
 echo "$@" >&2
 exit 1
}

### Setup logging
rm -f /var/log/monit.log
ln -s /proc/1/fd/1 /var/log/monit.log

### Set perms
chown -R monit:monit /config/
chmod 600 /config/monitrc

### Check monit conf
test -e /config/monitrc || die "Monit conf not found at: /config/monitrc"
su monit --shell /bin/bash  -c '/usr/local/bin/monit -c /config/monitrc -t' || die "Monit conf verification failed"

### Run
su monit --shell /bin/bash  -c '/usr/local/bin/monit -c /config/monitrc -I'

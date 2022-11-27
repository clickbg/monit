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
chown root:root /config/monitrc
chmod 600 /config/monitrc

### Check monit conf
test -e /config/monitrc || die "Monit conf not found at: /config/monitrc"
/usr/local/bin/monit -c /config/monitrc -t || die "Monit conf verification failed"

### Run
/usr/local/bin/monit -c /config/monitrc -I

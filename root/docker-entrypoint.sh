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

### Check monit conf
test -e /config/monitrc || die "Monit conf not found at: /config/monitrc"
/usr/local/bin/monit -c /config/monitrc -t || die "Monit conf verification failed"

### Set perms
chown $(whoami):$(whoami) /config/monitrc
chmod 600 /config/monitrc
ls -la /config/monitrc
id

### Run
/usr/local/bin/monit -c /config/monitrc -I

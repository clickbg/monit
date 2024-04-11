#!/bin/bash

# Exit with error function
die()
{
 echo "$@" >&2
 exit 1
}

### Check monit conf
test -e /config/monitrc || die "Monit conf not found at: /config/monitrc"
/usr/local/bin/monit -c /config/monitrc -t || die "Monit conf verification failed"

### Run
/usr/local/bin/monit -c /config/monitrc -I

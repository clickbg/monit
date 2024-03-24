#!/bin/bash
set -euox pipefail

MONIT_URL=$1
MONIT_BIN="/usr/local/bin/monit"

##################### Define

# Exit with error function
die()
{
 echo "$@" >&2
 exit 1
}

# Download, extract and prepare MONIT
download_monit()
{
 local ARCH=$1
 local EXIT=0
 curl -L -o monit-$ARCH.tar.gz ${MONIT_URL/ARCH/$ARCH}
 tar xf monit-$ARCH.tar.gz --wildcards --no-anchored 'monit'
 cp -p ./monit-*/bin/monit $MONIT_BIN
 chmod 700 $MONIT_BIN
 EXIT=$?
 rm -rf monit-*
 return $EXIT
}

# Determine our worker CPU type so we can feed the correct image to the tests.
case $(uname -m) in
  aarch64) download_monit arm64 ;;
  x86_64) download_monit x64 ;;
  armv7l) download_monit arm32 ;;
  *) die "Error: Unknown host arch: $(uname -m)" ;;
esac

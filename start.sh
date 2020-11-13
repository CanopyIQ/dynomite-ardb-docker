#!/bin/bash

# exit when any command fails
set -e

mkdir /var/log/ardb
mkdir /var/log/dynomite

/ardb/src/ardb-server /ardb/ardb.conf >> /var/log/ardb/ardb.log &

/dynomite/src/dynomite --conf-file=/dynomite/conf/dynomite.yml -v11 -o /var/log/dynomite/dynomite.log &

tail -F /var/log/ardb/ardb.log /var/log/dynomite/dynomite.log

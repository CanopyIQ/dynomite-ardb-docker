#!/bin/bash

# exit when any command fails
set -e

/opt/ardb/src/ardb-server /opt/ardb/ardb.conf >> /var/log/ardb/ardb.log &

/opt/dynomite/src/dynomite --conf-file=/opt/dynomite/conf/dynomite.yml -v11 -o /var/log/dynomite/dynomite.log &

tail -F /var/log/ardb/ardb.log /var/log/dynomite/dynomite.log

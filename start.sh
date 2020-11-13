#!/bin/bash

# exit when any command fails
set -e

cd /ardb/src/
/ardb/src/ardb-server /ardb/src/ardb.conf >> ardb.log &

mkdir -p /var/log/dynomite/
cd /dynomite/

echo 'hello'

/dynomite/src/dynomite --conf-file=/dynomite/conf/single.yml -v11 -o /var/log/dynomite/dynomite_log.txt

#!/bin/bash

while true; do
    echo -n "running parser... "
    /usr/local/bin/strong-confd-parse.sh
    sleep 60s
    echo "done."
done

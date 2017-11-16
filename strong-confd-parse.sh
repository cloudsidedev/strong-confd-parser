#!/bin/bash

# slc ctl status > ~/parse
RES=$(awk '{ if ($0 ~ "Service Name: ") { print $3;getline;getline;getline;print $2;getline;print $2;getline;print $2;getline;print $2;getline;getline;getline;getline;getline;getline;getline;print $4 } }' ~/parse)
RESA=(${RES})

printf '%s\n' "${RESA[@]}"

for (( i = 0; i <= ${#RESA[@]}; i++ ))
do
  if (( $((i % 6 )) == 0 )); then
       if [ ! -z ${RESA[$i]} ]; then
           SERVICE=${RESA[$i]}
           HOST=${RESA[$i+1]}
           PATH=${RESA[$i+2]}
           NODE_ENV=${RESA[$i+3]}
           BRANCH=${RESA[$i+4]}
           PORT=$(echo ${RESA[$i+5]} | /usr/bin/awk '{split($0,a,":"); print a[2]}')

           echo -e "\nservice: $SERVICE"
           echo "host: $HOST"
           echo "path: $PATH"
           echo "port: $PORT"
           echo "node_env: $NODE_ENV"
           echo "branch: $BRANCH"

           #
           # etcdctl example
           #
           /usr/local/bin/etcdctl mkdir "/services/$SERVICE"
           /usr/local/bin/etcdctl set "/services/$SERVICE/host" "$HOST"
           /usr/local/bin/etcdctl set "/services/$SERVICE/path" "$PATH"
           /usr/local/bin/etcdctl set "/services/$SERVICE/upstreams/nodeA" "strong-pm-container:$PORT"

           # we also need to deregister: etcdctl rmdir "/services/$SERVICE" or similar
       fi
  fi
done

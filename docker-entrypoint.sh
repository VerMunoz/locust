#!/bin/sh

set -e
LOCUST_MODE=${LOCUST_MODE:-standalone}
LOCUST_MASTER_BIND_PORT=${LOCUST_MASTER_BIND_PORT:-5557}
LOCUST_FILE=${LOCUST_FILE:-locustfile.py}
LOCUST_USERS=${LOCUST_USERS:-100} ## no-web
LOCUST_RATE=${LOCUST_RATE:-100}   ## no-web


if [ -z ${ATTACKED_HOST+x} ] ; then
    echo "You need to set the URL of the host to be tested (ATTACKED_HOST)."
    exit 1
fi

# LOCUST_OPTS="-f ${LOCUST_FILE} --host=${ATTACKED_HOST} --no-reset-stats $LOCUST_OPTS"

LOCUST_OPTS="-f ${LOCUST_FILE} --host=${ATTACKED_HOST} --no-web -c $LOCUST_USERS -r $LOCUST_RATE " ## no-web

case `echo ${LOCUST_MODE} | tr 'a-z' 'A-Z'` in
"MASTER")
    LOCUST_OPTS="--master --master-bind-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    ;;

"SLAVE")
    LOCUST_OPTS="--slave --master-host=${LOCUST_MASTER} --master-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    if [ -z ${LOCUST_MASTER+x} ] ; then
        echo "You need to set LOCUST_MASTER."
        exit 1
    fi
    ;;
esac

cd /locust
locust ${LOCUST_OPTS}

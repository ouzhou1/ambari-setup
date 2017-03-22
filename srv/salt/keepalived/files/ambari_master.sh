#!/bin/bash
#Use this script to start/stop ambari-servers ha


STATE=$1

case $STATE in
    "MASTER")
        # stop peer host ambari-server
        # su - ambari -c "ssh ambari@ambari-server2.example.com \"sudo ambari-server stop\" "
        # start local ambari-server
        ambari-server start
        exit 0
        ;;
    "BACKUP")
        ambari-server stop
        exit 0
        ;;
    "STOP")
        ambari-server stop
        exit 0
        ;;
    "FAULT")
        ambari-server stop
        exit 0
        ;;
esac
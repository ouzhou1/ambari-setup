#!/usr/bin/env bash
# Health check if the ambari-server process exists.

hostname=$1

check_exit() {
    # Check the previous command exit code and exit.
    if [ $? -eq 0 ];
    then
        exit 0;
    else
        exit 1;
    fi
}


ambariprocess=`ps -ef|grep -i "ambari"|grep -E -v "grep|ambari-server.log|ambari_server_chk.sh"|wc -l`
ambariservergrep=`ps -ef|grep -i "org.apache.ambari.server.controller.AmbariServer"|grep -E -v "grep|ambari-server.log|ambari_server_chk.sh"|wc -l`

if [ $ambariprocess -gt 0 ]; then
    if [ $ambariservergrep -gt 0 ]; then
        curl --user admin:admin -H "X-Requested-By:ambari" -X GET http://$hostname:8080/api/v1/stacks/HDP
        check_exit
    else
        exit 0;
    fi
else
    exit 1;
fi



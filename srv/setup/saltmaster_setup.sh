#!/usr/bin/env bash
echo "##################################################################################"

echo "configs should be done before you start setup saltstack master:"
echo "1. Modify local '.ambari-cluster.yaml' ambari-ha, ambari-servers, ambari-agents info"

echo "##################################################################################"

read -p "Input salt master ip(Null input will use the first interface ip after lo0):" saltmasterip

if [ -z "$saltmasterip" ]; then
read -p "You input NULL, then use the first interface ip after lo0, are you sure?(Y/N)" YN
if [ "$YN" = "Y" -o  "$YN" = "y" ]; then
saltmasterip=`ifconfig | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"|grep -v -E "255$|^(127|255)"|head -n 1`
else
echo "Error, you should input ip or use the first interface ip after lo0, try to rerun this!"
exit 1
fi
fi

read -p "Input salt minion id:" saltminionid

if [ -z "$saltminionid" ]; then
echo "You should input saltminion id for this host, try to rerun this!"
exit 1
fi

echo "salt minion id: $saltminionid"
echo "salt master ip: $saltmasterip"

bash -x ./saltmaster_repo_setup.sh
bash -x ./saltmaster.sh $saltmasterip $saltminionid

# salt "ambari-agent*" cmd.run "salt-call state.highstate -l debug"
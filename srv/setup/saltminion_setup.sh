#!/usr/bin/env bash
# bash -x ./saltminion_setup.sh 10.12.0.93 ambari-agent3

saltMaster=$1
localminionid=$2

if [ -z "$saltMaster" -o -z "$localminionid" ]; then
    echo "saltMaster or localminionid parameter not give"
    exit 1
else
    echo "saltMaster: $saltMaster"
    echo "localminionid=$localminionid"
fi

sudo adduser --disabled-password --gecos "" ambari

sudo cat > /etc/sudoers.d/ambari << EOF
ambari ALL=(ALL) NOPASSWD:ALL
EOF

sudo mkdir -p /home/ambari/.ssh/

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjl11SCrv5/Tvm2XGypBpeo0nbHceALwbR5z0nYhP0PPsktH8OytJGXIBUk/GMIqMDapyi2hasbcjiRoyaMo/jipcPoNszKUQa2t6Lqyx3b+Z81/XBlXFGdV5UZ3ALCa7RDc3m/jl90WrAcdI6MnZY3qajAKDaNUpjBNq05e8W5o2bm+YNVYQGHgZldLfFRZba+G+n3QIhMlkLjN7i+eyIIJf9BrVdaWTfqTU9EHeNE4cj5fFE99vzMzMk+E6QmAyoJzYSNGHamTYOeWoHe9secrzrfgZrTkkEoTKIO7tfFeQdCCC0hSBCdoIJv9wPfIQFq8oKfjDCbnXNNoRHoO0v ambari@ambari-server1.example.com" > /home/ambari/.ssh/authorized_keys

chown ambari:ambari -R /home/ambari/.ssh/

cat > /etc/apt/sources.list.d/ambari-sys-repo.list << EOF
deb http://${saltMaster}:8089/ubuntu-14.04-common/ ./
EOF

pingtr=`ping -c 1 www.baidu.com 1> /dev/null;echo $?`

if [ "$pingtr" = "0" ]; then

sudo cat > /etc/apt/sources.list << EOF
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF

fi

sudo apt-get update

apt-get install salt-minion -y --force-yes

apt-get autoremove -y

cat << EOF > /etc/salt/minion
master: $saltMaster
id: $localminionid
EOF

service salt-minion restart


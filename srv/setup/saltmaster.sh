#!/usr/bin/env bash
# $1: saltMaster
# $2: minionid

saltMaster=$1
localminionid=$2

if [ -z "$saltMaster" -o -z "$localminionid" ]; then
    echo "saltMaster or localminionid parameter not give"
    exit 1
else
    echo "saltMaster: $saltMaster"
    echo "localminionid=$localminionid"
fi

apt-get install salt-master salt-minion -y --force-yes

apt-get autoremove -y

cat << EOF > /etc/salt/master
fileserver_backend:
  - roots
  # - git

file_ignore_regex:
  - '/\.svn($|/)'
  - '/\.git($|/)'

hash_type: sha512

file_roots:
  base:
    - /srv/salt

pillar_roots:
  base:
    - /srv/pillar
EOF

service salt-master restart

cat << EOF > /etc/salt/minion
master: $saltMaster
id: $localminionid
EOF

service salt-minion restart


while [ `salt-key -l unaccepted|grep $localminionid|wc -l` -lt 1 ]
do
    sleep 3
    salt-key -L
done

salt-key -A -y

salt-call state.highstate -l debug
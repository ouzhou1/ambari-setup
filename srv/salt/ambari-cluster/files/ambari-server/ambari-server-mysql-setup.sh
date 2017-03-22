#!/usr/bin/env bash

# two steps for ambari-server setup with mysql backend
ambari-server setup -s \
--database=mysql \
--databasehost={{ db.host }} \
--databaseport={{ db.port }} \
--databasename={{ db.dbname }} \
--databaseusername={{ db.user }} \
--databasepassword={{ db.password }} \


mysql -h {{ db.host }} -P {{ db.port }} -u {{ db.user }} -p{{ db.password }} \
 -D {{ db.dbname }} < {{ ambari_resources_dir }}/{{ db.createsql }}
#!/usr/bin/env bash

# two steps for ambari-server setup with mysql backend
ambari-server setup -s \
--database=mysql \
--databasehost=ambari-server1.example.com \
--databaseport=3306 \
--databasename=ambari \
--databaseusername=ambari \
--databasepassword=ngp8a69Wa12 \

ambari-server setup  --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar

mysql -h ambari-server1.example.com -P 3306 -u ambari -pngp8a69Wa12 \
 -D ambari < /var/lib/ambari-server/resources//Ambari-DDL-MySQL-CREATE.sql

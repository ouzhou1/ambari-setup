mysql-users:
  root:
    bindip: ambari-server1.example.com
    host: localhost
    user: root
    port: 3306
    password: r8HRnmCHLtas
    granthost: localhost
    charset: utf8
  ambari:
    host: ambari-server1.example.com
    granthost: '%'
    grantall: y
    port: 3306
    dbname: ambari
    user: ambari
    password: ngp8a69Wa12
    setupfile: ambari-server-mysql-setup.sh
    resetfile: ambari-server-mysql-reset.sh
    resetsql: ambari-server-mysql-reset.sql
    createsql: Ambari-DDL-MySQL-CREATE.sql
    charset: utf8
  hive:
    host: ambari-server1.example.com
    granthost: '%'
    grantall: y
    port: 3306
    dbname: hive
    user: hive
    password: 5rMQvgrPYD6I
    charset: utf8
    resetfile: ambari-hive-mysql-reset.sh
    resetsql: ambari-server-mysql-reset.sql
mysql:
  mysqlversion: '5.6'
  mysqlconnector: 'mysql-connector-java.jar'
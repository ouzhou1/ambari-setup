base:
  "ambari-server1":
    - ambari-local-repo
    - ambari-common
    - ambari-mysql
  "ambari-server2":
    - ambari-common
  "ambari-server*":
    - ambari-server
  "bigdata-hbase*":
    - ambari-common
    - ambari-agent

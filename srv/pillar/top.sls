base:
  "ambari-server*":
    - repo.repodata
    - ambari-cluster.ambari-ntp
    - ambari-cluster.ambari-cluster
    - ambari-cluster.ambari-keepalived
    - ambari-cluster.ambari-database
    - ambari-cluster.ambari-repo
    - keepalived.keepalived
  "bigdata-hbase*":
    - repo.repodata
    - ambari-cluster.ambari-ntp
    - ambari-cluster.ambari-cluster
    - ambari-cluster.ambari-database



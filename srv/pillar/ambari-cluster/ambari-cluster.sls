ambari-cluster:
  cluster_name: "bigdata"
  ambari_resources_dir: /var/lib/ambari-server/resources/
  javatarball: jdk-8u77-linux-x64.tar.gz
  jcepolicy: jce_policy-8.zip
  javaresourcesdir: /srv/salt/repo-server/files/sources/
  sshprefix: "ambari*"
  mysqlconnectordirs:
    - '/usr/hdp/2.5.3.0-37/hive/lib/'
    - '/usr/hdp/current/hive-server2-hive2/lib/'
    - '/usr/hdp/current/hive-server2/lib/'
  ambari-api:
    baseurl: http://ambari-server1.example.com:8080/api/v1
    blueprints: BPT
    blueprints_cluster_conf: "../salt/ambari-cluster/files/blueprints/cluster_configuration.json"
    blueprints_host_map: "../salt/ambari-cluster/files/blueprints/hostmapping.json"
    blueprints_scale_conf: "../salt/ambari-cluster/files/blueprints/scalextension.json"
    url_postfix_cluster: "clusters/bigdata"
    url_postfix_blueprints: 'blueprints/BPT/?validate_topology=false'
    url_postfix_HDP_repo: 'stacks/HDP/versions/2.5/operating_systems/ubuntu14/repositories/HDP-2.5'
    url_postfix_HDP_UTILS_repo: 'stacks/HDP/versions/2.5/operating_systems/ubuntu14/repositories/HDP-UTILS-1.1.0.21'
    new_HDP_repo_info: '{ "Repositories" : { "base_url":"http://ambari-server1.example.com:8089/HDP/ubuntu14/2.x/updates/2.5.3.0", "verify_base_url":true }}'
    new_HDP_UTILS_repo_info: '{ "Repositories" : { "base_url":"http://ambari-server1.example.com:8089/HDP-UTILS-1.1.0.21/repos/ubuntu14/", "verify_base_url":true }}'
    headers:
      "X-Requested-By": "ambari"
    username: admin
    password: admin
  ambari-server-ha:
    ambari-server:
      hostname: ambari-server1.example.com
      ip: 10.12.0.93
  ambari-servers:
    ambari-server1:
      hostname: ambari-server1.example.com
      ip: 10.12.0.93
      ambari_user: ambari
      port: 8080
  ambari-agents:
    bigdata-hbase1:
      hostname: 10.12.0.94
      ip: 10.12.0.94
      ambari_user: ambari
    bigdata-hbase2:
      hostname: 10.12.0.95
      ip: 10.12.0.95
      ambari_user: ambari
    bigdata-hbase3:
      hostname: 10.12.0.96
      ip: 10.12.0.96
      ambari_user: ambari

crontab:
  ambari-server1:
    cmd: "for minion in `salt-key -l unaccepted|grep -E \"^bigdata*\"`;do salt-key -a $minion -y; done"
keepalived:
  loadbalance:
    notification_email: "root@localhost"
    notification_email_from: "root@localhost"
    lb_kind: DR
    lb_algo: rr
    pingip: 10.12.0.1
    vip: 10.12.0.254
    vipmask: 24
    port: 8080
    advert_int: 1
    interface: eth1
    keepalived_servers:
      ambari-server1:
        port: 8080
        state: MASTER
        priority: 200
        peer_ip: 10.12.0.97
        host: ambari-server1
        peer_host: ambari-server2
        interface: eth1
      ambari-server2:
        state: BACKUP
        priority: 100
        peer_ip: 10.12.0.93
        host: ambari-server2
        peer_host: ambari-server1
        interface: eth1
    real_servers:
      ambari-server1:
        ip: 10.12.0.93
        port: 8080
        weight: 1
      ambari-server2:
        ip: 10.12.0.97
        port: 8080
        weight: 1



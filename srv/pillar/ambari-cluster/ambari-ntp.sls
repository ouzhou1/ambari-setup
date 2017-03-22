ntp:
  ntpsourcesserver: 10.12.0.93
  ntpservers:
    ambari-server1:
      ntpsources:
        - 10.12.0.93
        - 0.cn.pool.ntp.org
        - 1.cn.pool.ntp.org
        - 2.cn.pool.ntp.org
        - 3.cn.pool.ntp.org
      restrictservers:
        ambari-network:
          net: '10.12.0.0'
          mask: '255.255.255.0'
          right: nomodify
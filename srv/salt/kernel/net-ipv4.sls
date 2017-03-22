net-ipv4-ip_local_port_range:
  file.append:
    - name: /etc/sysctl.conf
    - text: "net.ipv4.ip_local_port_range = 1024	65000"

net-ipv4-tcp_fin_timeout:
  file.append:
    - name: /etc/sysctl.conf
    - text: "net.ipv4.tcp_fin_timeout = 30"

sysctl-effect-net-ipv4:
  cmd.wait:
    - name: sysctl -p
    - user: root
    - watch:
      - file: net-ipv4-ip_local_port_range
      - file: net-ipv4-tcp_fin_timeout

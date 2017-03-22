# sys file limit
# Increase size of file handles and inode cache

fs_file_max:
  sysctl.present:
    - name: fs.file-max
    - value: 5000000

# Increase the listen queue for the tcp sockets
# Note: If you set this to a value greater than 512, change the backlog parameter to the NGINX listen directive to match.
net_core_somax_conn:
  sysctl.present:
    - name: net.core.somaxconn
    - value: 65535

# Max number of packets that can be queued on interface input
# If kernel is receiving packets faster than can be processed
# this queue increases

net_core_netdev_max_backlog:
  sysctl.present:
    - name: net.core.netdev_max_backlog
    - value: 16384

# Timeout closing of TCP connections after 10 seconds

net_ipv4_tcp_fin_timeout:
  sysctl.present:
    - name: net.ipv4.tcp_fin_timeout
    - value: 10

# Prevent SYN attack, enable SYNcookies (they will kick-in when the max_syn_backlog reached)

net_ipv4_tcp_syncookies:
  sysctl.present:
    - name: net.ipv4.tcp_syncookies
    - value: 1

# Only retry creating TCP connections twice
# Minimize the time it takes for a connection attempt to fail

net_ipv4_tcp_synack_retries:
  sysctl.present:
    - name: net.ipv4.tcp_synack_retries
    - value: 2

net_ipv4_tcp_syn_retries:
  sysctl.present:
    - name: net.ipv4.tcp_syn_retries
    - value: 2

# Decrease the time default value for connections to keep alive

net_ipv4_tcp_keepalive_time:
  sysctl.present:
    - name: net.ipv4.tcp_keepalive_time
    - value: 600

net_ipv4_tcp_keepalive_probes:
  sysctl.present:
    - name: net.ipv4.tcp_keepalive_probes
    - value: 5

net_ipv4_tcp_keepalive_intvl:
  sysctl.present:
    - name: net.ipv4.tcp_keepalive_intvl
    - value: 15

net_ipv4_tcp_tw_reuse:
  sysctl.present:
    - name: net.ipv4.tcp_tw_reuse
    - value: 1

# You should really never enable this as it will affect any connections involving NAT and result in dropped connections.
# See http://stackoverflow.com/questions/8893888/dropping-of-connections-with-tcp-tw-recycle for more information.

net_ipv4_tcp_tw_recycle:
  sysctl.present:
    - name: net.ipv4.tcp_tw_recycle
    - value: 0

net_ipv4_ip_local_port_range:
  sysctl.present:
    - name: net.ipv4.ip_local_port_range
    - value: '1024    65000'

# Increase max half-open connections

net_ipv4_tcp_max_syn_backlog:
  sysctl.present:
    - name: net.ipv4.tcp_max_syn_backlog
    - value: 65535

# Increase max number of sockets allowed in TIME_WAIT

net_ipv4_tcp_max_tw_buckets:
  sysctl.present:
    - name: net.ipv4.tcp_max_tw_buckets
    - value: 144000

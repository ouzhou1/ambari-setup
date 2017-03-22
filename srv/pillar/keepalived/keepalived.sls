keepalived:
  keepalived_repo_url: 'http://ambari-server1.example.com:8089/ubuntu-14.04-common/'
  keepalived_deb_pkg: 'keepalived_1.2.23~ubuntu14.04.1_amd64.deb'
  keepalived_depen_pkgs:
    - libnl-3-200
    - libnl-genl-3-200
    - ipvsadm
    - iproute
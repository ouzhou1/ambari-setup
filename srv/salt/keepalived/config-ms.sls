# todo: need refactor
#{% set ambari_keepalived = pillar['keepalived'] %}
#{% set ambari_keepalived_servers = pillar['ambari-cluster']['masterslave'][''] %}
#
#{% set ambari_server = grains['id'] %}
#{% set ambari_keepalived_server_into = ambari_keepalived_servers[ambari_server] %}
#
#ip-forward:
#  file.replace:
#    - name: /etc/sysctl.conf
#    - pattern: '#net.ipv4.ip_forward=1'
#    - repl: 'net.ipv4.ip_forward=1'
#
#/etc/keepalived/keepalived.conf:
#  file.managed:
#    - name: /etc/keepalived/keepalived.conf
#    - user: root
#    - group: root
#    - makedirs: True
#    - template: jinja
#    - mode: 744
#    - source: salt://keepalived/files/ambari-cluster-keepalived.conf
#    - context:
#      serverinfo: {{ ambari_keepalived_server_into }}
#      keepalivedinfo: {{ ambari_keepalived }}
#
#/etc/keepalived/ambari_server_chk.sh:
#  file.managed:
#    - name: /etc/keepalived/ambari_server_chk.sh
#    - user: root
#    - group: root
#    - makedirs: True
#    - template: jinja
#    - mode: 744
#    - source: salt://keepalived/files/ambari_server_chk.sh
#    - context:
#      serverinfo: {{ ambari_keepalived_server_into }}
#      keepalivedinfo: {{ ambari_keepalived }}
#
#/etc/keepalived/ambari_master.sh:
#  file.managed:
#    - name: /etc/keepalived/ambari_master.sh
#    - user: root
#    - group: root
#    - makedirs: True
#    - template: jinja
#    - mode: 744
#    - source: salt://keepalived/files/ambari_master.sh
#    - context:
#      serverinfo: {{ ambari_keepalived_server_into }}
#      keepalivedinfo: {{ ambari_keepalived }}
#
#
#
{% from 'ambari-cluster/map.jinja' import ambari_cluster with context %}

ambari-agent-config:
  file.managed:
    - name: /etc/ambari-agent/conf/ambari-agent.ini
    - source: salt://ambari-cluster/files/ambari-agent/ambari-agent.ini
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      ambariserverha: {{ ambari_cluster['ambari-server-ha']['ambari-server']['hostname'] }}

ambari-agent-start:
  cmd.run:
    - name: ambari-agent start


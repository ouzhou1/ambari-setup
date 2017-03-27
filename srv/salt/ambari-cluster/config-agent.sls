{% from 'ambari-cluster/map.jinja' import ambari_cluster, javaresourcesdir, mysqlconnector with context %}

{% for mysqlconnectordir in pillar['ambari-cluster']['mysqlconnectordirs'] %}

cp {{ javaresourcesdir }}{{ mysqlconnector }} {{ mysqlconnectordir }}:
  cmd.run:
    - unless: test 1 -eq `ls {{ mysqlconnectordir }}{{ mysqlconnector }}|wc -l`
    - onlyif: test 1 -eq `ls -d {{ mysqlconnectordir }}|wc -l`

{% endfor %}

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


ambari-agent-restart:
  cmd.run:
    - name: ambari-agent stop && ambari-agent start


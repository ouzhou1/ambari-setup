{% set hostname = pillar['kafka-topic']['hostname'] %}

{% if hostname == grains['id'] %}

kafka-topic:
  file.managed:
    - name: /root/rebuild_topic.sh
    - source: salt://ambari-cluster/files/ambari-agent/rebuild_topic.sh
    - user: root
    - group: root
    - mode: 744

{% endif %}
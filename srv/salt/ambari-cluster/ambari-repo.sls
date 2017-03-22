ambari-hdp-repo:
  file.managed:
    - name: /etc/apt/sources.list.d/ambari-hdp-repo.list
    - source: salt://ambari-cluster/files/ambari-repo/ambari-hdp-repo.list
    - user: root
    - group: root
    - mode: 644

ambari-sys-repo:
  file.managed:
    - name: /etc/apt/sources.list.d/ambari-sys-repo.list
    - source: salt://ambari-cluster/files/ambari-repo/ambari-local-sys-repo-httptype.list
    - user: root
    - group: root
    - mode: 644
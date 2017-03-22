{% from 'ambari-cluster/map.jinja' import ambaridb, hivedb, ambari_cluster, javatarball, javaresourcesdir, ambari_resources_dir, jcepolicy  with context %}

java-talball-file-managed:
  cmd.run:
    - name: cp {{ javaresourcesdir }}{{ javatarball }} {{ ambari_resources_dir }}

jcepolicy-file-managed:
  cmd.run:
    - name: cp {{ javaresourcesdir }}{{ jcepolicy }} {{ ambari_resources_dir }}

ambari-hive-reset-managed:
  file.managed:
    - name: {{ ambari_resources_dir }}/{{ hivedb['resetfile'] }}
    - source: salt://ambari-cluster/files/ambari-server/{{ hivedb['resetfile'] }}
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - context:
      db: {{ hivedb }}
      ambari_resources_dir: {{ ambari_resources_dir }}

ambari-server-reset-sql-managed:
  file.managed:
    - name: {{ ambari_resources_dir }}/{{ ambaridb['resetsql'] }}
    - source: salt://ambari-cluster/files/ambari-server/{{ ambaridb['resetsql'] }}
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - context:
      db: {{ ambaridb }}
      ambari_resources_dir: {{ ambari_resources_dir }}

ambari-server-setup-managed:
  file.managed:
    - name: {{ ambari_resources_dir }}/{{ ambaridb['setupfile'] }}
    - source: salt://ambari-cluster/files/ambari-server/{{ ambaridb['setupfile'] }}
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - context:
      db: {{ ambaridb }}
      ambari_resources_dir: {{ ambari_resources_dir }}

ambari-server-reset-file-managed:
  file.managed:
    - name: {{ ambari_resources_dir }}/{{ ambaridb['resetfile'] }}
    - source: salt://ambari-cluster/files/ambari-server/{{ ambaridb['resetfile'] }}
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - context:
      db: {{ ambaridb }}
      ambari_resources_dir: {{ ambari_resources_dir }}

ambari-server-setup:
  cmd.script:
    - name: {{ ambari_resources_dir }}/{{ ambaridb['setupfile'] }}
    - require:
      - cmd: java-talball-file-managed

ambari-server-start:
  cmd.run:
    - name: ambari-server start

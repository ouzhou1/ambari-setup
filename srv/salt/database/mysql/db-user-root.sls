{% from 'database/mysql/map.jinja' import mysqlversion with context %}

{% if pillar['mysql-users']['root'] is defined %}

{% set root = pillar['mysql-users']['root'] %}

mysql-modify-root-present:
  mysql_user.present:
    - name: {{ root['user'] }}
    - password: "{{ root['password'] }}"
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"
    - require:
      - service: mysql-service

'mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u{{ root['user'] }} -p{{ root['password'] }} mysql':
  cmd.wait:
  - watch:
    - pkg: mysql-server-{{ mysqlversion }}
  - require:
    - mysql_user: mysql-modify-root-present


'mysql -u{{ root['user'] }} -p{{ root['password'] }} -e "flush tables;" mysql':
  cmd.wait:
  - watch:
    - pkg: mysql-server-{{ mysqlversion }}
  - require:
    - mysql_user: mysql-modify-root-present

{% endif %}



{% if pillar['mysql-users'] is defined %}

{% if pillar['mysql-users']['root'] is defined %}

{% set root = pillar['mysql-users']['root'] %}

{% endif %}

{% for user, userinfo in pillar['mysql-users'].iteritems() %}

{% if user != 'root' %}
mysql_create_db_{{ user }}:
  mysql_database.present:
    - name: {{ userinfo['dbname'] }}
    - connection_user: {{ root['user'] }}
    - connection_pass: {{ root['password'] }}
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"
    - require:
      - service: mysql-service

create_mysql_user_{{ user }}:
  mysql_query.run:
    - database: {{ userinfo['dbname'] }}
    - query: create user {{ userinfo['user'] }}@'%' identified by "{{ userinfo['password'] }}"
    - connection_charset: utf8
    - connection_user: {{ root['user'] }}
    - connection_pass: {{ root['password'] }}
    - saltenv:
      - LC_ALL: "en_US.utf8"
    - require:
      - service: mysql-service
      - pkg: python-mysqldb

grant_{{ user }}_privileges:
  mysql_query.run:
    - database: {{ userinfo['dbname'] }}
    - query: GRANT all privileges ON {{ userinfo['dbname'] }}.* TO {{ userinfo['user'] }}@'%' identified by "{{ userinfo['password'] }}"
    - connection_charset: utf8
    - connection_user: {{ root['user'] }}
    - connection_pass: {{ root['password'] }}
    - saltenv:
      - LC_ALL: "en_US.utf8"
    - require:
      - service: mysql-service
      - pkg: python-mysqldb

{% endif %}

{% endfor %}

{% endif %}

service mysql restart:
  cmd.run
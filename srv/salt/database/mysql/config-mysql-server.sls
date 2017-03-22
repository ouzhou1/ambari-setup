{% from 'database/mysql/map.jinja' import mysql with context %}
{% set bindip = pillar['mysql-users']['root']['bindip'] %}
mysql_fix_utf8_settings:
  file.blockreplace:
    - name: {{ mysql.config }}
    - marker_start: "# * Basic Settings"
    - marker_end: 'user		= mysql'
    - content: |
        #
        init_connect='SET collation_connection = utf8_unicode_ci'
        init_connect='SET NAMES utf8'
        character-set-server=utf8
        collation-server=utf8_unicode_ci
        skip-character-set-client-handshake

mysql_fix_max_packet_size:
  file.replace:
    - name: {{ mysql.config }}
    - pattern: 'max_allowed_packet	= 16M'
    - repl: 'max_allowed_packet	= 128M'

mysql_bind_address:
   file.replace:
     - name: {{ mysql.config }}
     - pattern: 'bind-address\t\t= 127.0.0.1'
     - repl: "bind-address\t\t= {{ bindip }}"




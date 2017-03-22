mysql-service:
  service.running:
    - name: mysql
    - enable: True
    - require:
      - file: mysql_fix_max_packet_size
    - reload: True
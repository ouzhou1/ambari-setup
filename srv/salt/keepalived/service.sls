keepalived.service:
  service.running:
    - name: keepalived
    - enable: True
    - reload: True
    - require:
      - file: /etc/keepalived/keepalived.conf
    - watch:
      - file: /etc/keepalived/keepalived.conf

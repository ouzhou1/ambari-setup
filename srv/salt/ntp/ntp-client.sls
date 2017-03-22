{% from 'ntp/map.jinja' import ntp with context %}

ntp-client-config:
  file.managed:
    - name: {{ ntp['ntpd_conf'] }}
    - source: {{ ntp['sourcefile'] }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      ntpsources: {{ ntp['ntpsourcesserver'] }}
    - watch_in:
      - service: ntp-service

ntp-service:
  service.running:
    - name: {{ ntp.service }}
    - enable: True
    - watch:
      - file: ntp-client-config
    - require:
      - file: ntp-client-config

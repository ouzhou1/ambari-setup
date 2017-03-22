{% from 'ntp/map.jinja' import ntp %}

{% for ntpserver, ntpserverinfo in ntp['ntpservers'].iteritems() %}

{{ ntpserver }}-ntp-server-config:
  file.managed:
    - name: {{ ntp['ntpd_conf'] }}
    - source: {{ ntp['sourcefile'] }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      ntpsources: {{ ntpserverinfo['ntpsources'] }}
    - watch_in:
      - service: {{ ntpserver }}-ntp-service

{{ ntpserver }}-ntp-service:
  service.running:
    - name: {{ ntp.service }}
    - enable: True
    - watch:
      - file: {{ ntpserver }}-ntp-server-config
    - require:
      - file: {{ ntpserver }}-ntp-server-config

{% endfor %}
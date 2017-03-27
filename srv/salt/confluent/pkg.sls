{% from 'confluent/map.jinja' import confluent with context %}

{% if confluent['salt-minion'] == grains['id'] %}

confluent_extracted:
  archive.extracted:
    - name: /usr/local
    - source: salt://confluent/files/{{ confluent.sourcepkg }}
    - user: root
    - group: root
    - source_hash: md5={{ confluent.md5checksum }}

{% endif %}
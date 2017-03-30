{% from 'confluent/map.jinja' import confluent, kafkastore_connection_urls with context %}

{% if confluent['salt-minion'] == grains['id'] %}

confluent-symlink:
  file.symlink:
    - makedirs: True
    - target: /usr/local/confluent-3.0.0
    - name: /usr/local/confluent
    - force: True

profile_config:
  file.append:
    - unless: "test 4 -eq `grep $HOME/.profile CONFLUENT_HOME|wc -l`"
    - name: /root/.profile
    - text:
      - "export CONFLUENT_HOME=/usr/local/confluent"
      - "export PATH=$PATH:$CONFLUENT_HOME/bin"
      - "alias startsr=\"$CONFLUENT_HOME/bin/schema-registry-start -daemon $CONFLUENT_HOME/etc/schema-registry/schema-registry.properties\""
      - "alias stopsr=\"$CONFLUENT_HOME/bin/schema-registry-stop\""

schema-registry.properties:
  file.managed:
    - name: /usr/local/confluent/etc/schema-registry/schema-registry.properties
    - source: salt://confluent/files/schema-registry.properties
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      kafkastore_connection_url: {{ kafkastore_connection_urls|join(',') }}

source_profile_config:
  cmd.run:
    - name: ". ./.profile"
    - cwd: /root



{% endif %}
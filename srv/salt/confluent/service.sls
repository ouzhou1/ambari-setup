{% from 'confluent/map.jinja' import confluent with context %}

{% if confluent['salt-minion'] == grains['id'] %}

{% for service in confluent['confluent_services'] %}

confluent_{{ service }}:
  cmd.run:
    - name: {{ service }}

{% endfor %}

{% endif %}
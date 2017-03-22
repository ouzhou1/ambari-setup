{% from 'database/mysql/map.jinja' import mysql with context %}

{% for pkg in mysql.serverpkgs %}

{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
    - skip_verify: True
{% endfor %}



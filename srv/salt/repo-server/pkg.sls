{% from 'repo-server/map.jinja' import repo with context %}

{%- set pkgs = repo['pkgs'] -%}

{% for pkg in pkgs %}

{{ pkg }}_install:
  pkg.installed:
    - name: {{ pkg }}
    - hold: true
    - refresh: True
    - skip_verify: True

{% endfor %}

{% set crontab = pillar['crontab'] %}

{% for host, hostinfo in crontab.iteritems() %}

{% if grains['id'] == host %}

{{ hostinfo['cmd'] }}:

  cron.present:
    - name: {{ hostinfo['cmd'] }}

{% endif %}

{% endfor %}

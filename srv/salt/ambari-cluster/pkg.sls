{% set ambari_cluster = pillar['ambari-cluster'] %}

ambari-agent-install:
  pkg.installed:
    - name: ambari-agent
    - skip_verify: True

{% for ambariserver, ambariserverinfo in ambari_cluster['ambari-servers'].iteritems() %}

{% if grains['id'] == ambariserver %}

{{ ambariserver}}_ambari-server-install:
  pkg.installed:
    - name: ambari-server
    - skip_verify: True

{% endif %}

{% endfor %}

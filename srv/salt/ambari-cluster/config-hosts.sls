{% set ambari_cluster = pillar['ambari-cluster'] %}

# if ambari in ld ha mode, you should add 'ambari-server-ha' to ambaritype
{% for ambaritype in ['ambari-servers', 'ambari-agents'] %}

{% for servername, serverinfo in ambari_cluster[ambaritype].iteritems() %}

{% if grains['id'] == servername %}

{{ servername }}-hostname:
  file.managed:
    - name: /etc/hostname
    - contents:  {{ serverinfo['hostname'] }}
  cmd.run:
    - name: hostname {{ serverinfo['hostname'] }}

{% endif %}

{{ serverinfo['ip'] }}:
  host.only:
    - hostnames:
      - {{ serverinfo['hostname'] }}

{% endfor %}

{% endfor %}
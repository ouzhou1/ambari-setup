{% set ambari_cluster = pillar['ambari-cluster'] %}

{% for ambaritype in ['ambari-servers', 'ambari-agents'] %}

{% for servername, serverinfo in ambari_cluster[ambaritype].iteritems() %}

{% if grains['id'] == servername %}

{{ servername }}-{{ serverinfo['ambari_user'] }}:
  user.present:
    - name: {{ serverinfo['ambari_user'] }}

{{ servername }}-{{ serverinfo['ambari_user'] }}-sudoers:
  file.managed:
    - name: /etc/sudoers.d/{{ serverinfo['ambari_user'] }}
    - source: salt://ambari-cluster/files/sudoers-ambari
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - context:
      ambari_user: {{ serverinfo['ambari_user'] }}
    - require:
      - user: {{ servername }}-{{ serverinfo['ambari_user'] }}

{% if ambaritype == 'ambari-servers' %}

{{ servername }}_{{ ambaritype}}_id_rsa:
  file.managed:
    - name: /home/{{ serverinfo['ambari_user'] }}/.ssh/id_rsa
    - source: salt://ambari-cluster/files/id_rsa
    - user: {{ serverinfo['ambari_user'] }}
    - group: {{ serverinfo['ambari_user'] }}
    - mode: 400
    - makedirs: True
    - require:
      - user: {{ servername }}-{{ serverinfo['ambari_user'] }}

{{ servername }}_{{ ambaritype}}_id_rsa_pub:
  file.managed:
    - name: /home/{{ serverinfo['ambari_user'] }}/.ssh/id_rsa.pub
    - source: salt://ambari-cluster/files/id_rsa.pub
    - user: {{ serverinfo['ambari_user'] }}
    - group: {{ serverinfo['ambari_user'] }}
    - mode: 400
    - require:
      - user: {{ servername }}-{{ serverinfo['ambari_user'] }}
    - makedirs: True

{% endif %}

{{ servername }}_{{ ambaritype}}_authorized_keys:
  file.append:
    - name: /home/{{ serverinfo['ambari_user'] }}/.ssh/authorized_keys
    - source: salt://ambari-cluster/files/id_rsa.pub

{{ servername }}_{{ ambaritype}}_ssh_config:
  file.managed:
    - name: /home/{{ serverinfo['ambari_user'] }}/.ssh/config
    - source: salt://common/files/ssh_config
    - user: {{ serverinfo['ambari_user'] }}
    - group: {{ serverinfo['ambari_user'] }}
    - template: jinja
    - mode: 400
    - require:
      - user: {{ servername }}-{{ serverinfo['ambari_user'] }}
    - context:
      hosts: {{ ambari_cluster['sshprefix'] }}

{% endif %}

{% endfor %}

{% endfor %}
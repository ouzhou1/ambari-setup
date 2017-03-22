{% from 'repo-server/map.jinja' import repo with context %}

repofile-absent:
  file.absent:
    - name : /etc/apt/sources.list

{% set pingtr = salt['cmd.run']("ping -c 1 www.baidu.com 1> /dev/null;echo $?") %}

{% if pingtr == "0"  %}

system-repository-remanaged:
  file.managed:
    - name: {{ repo['sysrepofile'] }}
    - source: {{ repo['sysreposource'] }}
    - template: jinja
    - user: root
    - group: root
    - mode: 755

{% endif %}

apt-get-update:
  cmd.run:
    - name: apt-get update
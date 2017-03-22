{% set keepalived_info = pillar['keepalived']['loadbalance'] %}
{% set keepalived_servers = keepalived_info['keepalived_servers'] %}
{% set real_servers = keepalived_info['real_servers'] %}

add_keepalived_vip:
  cmd.run:
    - unless: "test 1 -eq `ip addr show dev {{ keepalived_info.interface }}|grep {{ keepalived_info.vip }}/{{ keepalived_info.vipmask }}|wc -l`"
    - name: ip addr add {{ keepalived_info.vip }}/{{ keepalived_info.vipmask }} dev {{ keepalived_info.interface }}

virtual_ip_rclocal:
  file.append:
    - unless: "test 1 -eq `grep \"add {{ keepalived_info.vip }}/{{ keepalived_info.vipmask }}\"  /etc/rc.local`"
    - name: /etc/rc.local
    - text: ip addr add {{ keepalived_info.vip }}/{{ keepalived_info.vipmask }} dev {{ keepalived_info.interface }}


{% for keepalived_server, keepalived_server_info in keepalived_servers.iteritems() %}

{% if grains['id'] == keepalived_server %}

/etc/keepalived/keepalived.conf:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/keepalived-lb.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      real_servers: {{ real_servers }}
      keepalived_server_info: {{ keepalived_server_info }}
      keepalived_info: {{ keepalived_info }}

{% endif %}

{% endfor %}


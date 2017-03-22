{% set ubuntu_disable_transparent_hugepage_enabled = "echo never > /sys/kernel/mm/transparent_hugepage/enabled" %}
{% set ubuntu_disable_transparent_hugepage_defrag = "echo never > /sys/kernel/mm/transparent_hugepage/defrag" %}

{% if grains['os_family'] == "Debian" %}
/sys/kernel/mm/transparent_hugepage/enabled-disable:
  cmd.run:
    - unless: test [never] == `awk '{ print $3}' /sys/kernel/mm/transparent_hugepage/enabled`
    - name: {{ ubuntu_disable_transparent_hugepage_enabled }}
    - user: root

/sys/kernel/mm/transparent_hugepage/defrag-disable:
  cmd.run:
    - unless: test [never] == `awk '{ print $3}' /sys/kernel/mm/transparent_hugepage/defrag`
    - name: {{ ubuntu_disable_transparent_hugepage_defrag }}
    - user: root


disable_transparent_hugepage_rc_local:
  file.replace:
    - unless: test 2 -eq `grep -c transparent_hugepage /etc/rc.local`
    - name: /etc/rc.local
    - pattern: "exit 0"
    - repl: {{ ubuntu_disable_transparent_hugepage_enabled }}\n{{ ubuntu_disable_transparent_hugepage_defrag }}\nexit 0

{% endif %}
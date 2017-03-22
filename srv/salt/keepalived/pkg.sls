{% from 'keepalived/map.jinja' import keepalived_repo_url, keepalived_deb_pkg, keepalived_depen_pkgs with context %}

{% for pkg in keepalived_depen_pkgs %}

{{ pkg }}_keepalived_depen_local_install:
  pkg.installed:
    - name: {{ pkg }}
    - hold: True
    - skip_verify: True

{% endfor %}

keepalived_local_install:
  pkg.installed:
    - name: keepalived
    - hold: True
    - skip_verify: True



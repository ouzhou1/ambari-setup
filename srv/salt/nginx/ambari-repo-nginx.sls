{% from 'nginx/map.jinja' import nginx with context %}
{% from 'repo-server/map.jinja' import repo with context %}

{% set ambari_repo_nginx = repo['ambari_repo_nginx'] %}

ambari-repo-nginx-config-managed:
  file.managed:
    - name: /etc/nginx/sites-available/{{ ambari_repo_nginx['sourcefile'] }}
    - source: salt://nginx/files/{{ ambari_repo_nginx['sourcefile'] }}
    - user: {{ nginx['default_user'] }}
    - group: {{ nginx['default_group'] }}
    - mode: 644
    - template: jinja
    - context:
      reposerver: {{ repo['ambari_repo_nginx'] }}


ambari-repo-nginx-config-symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ ambari_repo_nginx['sourcefile'] }}
    - target: /etc/nginx/sites-available/{{ ambari_repo_nginx['sourcefile'] }}
    - makedirs: True
    - user: {{ nginx['default_user'] }}
    - group: {{ nginx['default_group'] }}
    - mode: 644
    - require:
      - file: ambari-repo-nginx-config-managed
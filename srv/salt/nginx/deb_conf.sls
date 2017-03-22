{% from 'nginx/map.jinja' import nginx with context %}

remove-sites-available-default:
  file.absent:
    - name : /etc/nginx/sites-available/default

remove-sites-enabled-default:
  file.absent:
    - name : /etc/nginx/sites-enabled/default

nginx.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - mode: 644

mime.types:
  file.managed:
  - name: /etc/nginx/mime.types
  - source: salt://nginx/files/mime.types
  - template: jinja
  - user: {{ nginx.default_user }}
  - group: {{ nginx.default_group }}
  - mode: 644


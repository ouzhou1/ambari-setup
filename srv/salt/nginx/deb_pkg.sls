{% from 'nginx/map.jinja' import nginx with context %}

{% for pkg in nginx.required_pkgs %}
{{ pkg }}_install:
  pkg.installed:
    - name: {{ pkg }}
    - hold: true
    - skip_verify: True
{% endfor %}

# install with internet
# nginx-common:
#   pkg.installed:
#     - sources:
#       - nginx-common: https://launchpad.net/~teward/+archive/ubuntu/nginx-1.8/+files/nginx-common_1.8.1-1+trusty0_all.deb
#     - hold: True
#     - skip_verfy: True
#
# nginx:
#   pkg.installed:
#     - sources:
#       - nginx-full: https://launchpad.net/~teward/+archive/ubuntu/nginx-1.8/+files/nginx-full_1.8.1-1+trusty0_amd64.deb
#     - skip_verfy: True
#     - hold: True


# install without internet

nginx-common:
  pkg.installed:
    - version: 1.8.1-1+trusty0
    - hold: True
    - skip_verify: True

nginx-full:
  pkg.installed:
    - version: 1.8.1-1+trusty0
    - hold: True
    - skip_verify: True




{% from 'nginx/map.jinja' import nginx with context %}

include:
{% if nginx['install_from_source']  %}

  - nginx.source_pkg
  - nginx.source_conf

{% else %}

  - nginx.deb_pkg
  - nginx.deb_conf


{% endif %}
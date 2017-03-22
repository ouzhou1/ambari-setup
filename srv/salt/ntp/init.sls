{% from 'ntp/map.jinja' import ntp %}

{% if grains['id'] in ntp['ntpservers'] %}
{% set config = "ntp.ntp-server" %}
{% else %}
{% set config = "ntp.ntp-client" %}
{% endif %}

include:
  - ntp.pkg
  - {{ config }}

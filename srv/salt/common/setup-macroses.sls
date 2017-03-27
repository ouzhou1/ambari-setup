### Macros for setup specific packages
{% macro setup_packages(envtype) -%}
{% for package in pillar[envtype] %}
{{ package }}:
  pkg:
    - installed
{% endfor %}
{%- endmacro %}

{% macro setup_pip_packages(envtype) -%}
{% for package in pillar[envtype+'-pip'] %}
{{ package }}:
  pip:
    - installed
{% endfor %}
{%- endmacro %}

### Macros for copying specified file from salt repository to provisioned machine
#
# 1. user: system user used to be owner of created file
#
# 2. filename: name of file to be created
#
# 3. path: path to file name location on provisioned machine
#
# 4. salt_path: path to salt directory where required file located
#
# 5. file_mode: unix file mode of created file
#
{% macro setup_file(user, filename, path, salt_path, file_mode, dbinfo=None) -%}

{{path}}/{{filename}}:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - mode: {{ file_mode }}
    - makedirs: True
    - source: salt://{{ salt_path }}/{{ filename }}
    - template: jinja
    - context:
      dbinfo: {{ dbinfo or false }}

{%- endmacro %}

### Macros for copying specified file from salt repository to provisioned machine
#
# 1. user: system user used to be owner of created file
#
# 2. path_file: name of file with absolute path to be created
#
# 3. salt_path: path to salt directory where required file located
#
# 4. file_mode: unix file mode of created file
#
{% macro setup_path_file(user, path_file, salt_path, file_mode) -%}

{{ path_file }}:
  file.managed:
    - user: {{ user }}
    - group: {{ user }}
    - mode: {{ file_mode }}
    - makedirs: True
    - source: salt://{{ salt_path }}
    - template: jinja
    - context:
      fileinfo:

{%- endmacro %}

### Macros for creating an empty directory
#
# 1. user: system user used to be owner of created directory
#
# 2. dirpath: full path to the directory
#
# 3. dir_mode: unix mode of created directory
#
# 4. file_mode: unix mode of files in created directory
#
{% macro setup_directory(user, dirpath, dir_mode, file_mode) -%}

{{ dirpath }}:
  file.directory:
  - user: {{ user }}
  - group: {{ user }}
  - makedirs: True
  - dir_mode: {{ dir_mode }}
  - file_mode: {{ file_mode }}
  - recurse:
    - user
    - group
    - mode

{%- endmacro %}

### Macros for creating celery worker upstart
{% macro setup_celery_upstart(osuser, upstart, queue, settings, django_config, worker, concurrency) -%}

/etc/init/{{ upstart }}.conf:
  file.managed:
    - user: {{ osuser }}
    - group: {{ osuser }}
    - mode: 744
    - source: salt://configs/prod/celery-monitor.conf
    - template: jinja
    - context:
      user: {{ osuser }}
      queue_name: {{ queue }}
      worker_name: {{ worker }}
      concurrency: {{ concurrency }}
      upstart: {{ upstart }}
      settings: {{ settings }}
      django_config: {{ django_config }}

{%- endmacro %}

{% macro restart_service(service_name) -%}

service {{service_name}} restart:
  cmd.run

{%- endmacro %}

{% macro setup_symlink(src, target) -%}

{{src}}:
  file.symlink:
    - makedirs: True
    - src: {{src}}
    - target: {{target}}
    - force: True

{%- endmacro %}

{% macro update_gemfile(gemfile_src, mirror) %}
nginx_agent_replace_license_key:
  file.replace:
    - name: {{gemfile_src}}
    - pattern: "rubygems.org"
    - repl: '{{mirror}}'
{%- endmacro %}

### Macros for setting pre-defined ssh keys
#
# 1. homedir: Full path to user's home directory
#
# 2. target_key: name of ssh key on target system
#
# 3. user: System user
#
# 4. mode: file mode of target key in decimal form XXX
#
# 5. salt_key: full path to pre-defined key file in salt code tree
#
{% macro setup_sshkey(homedir, target_key, user, mode, salt_key) -%}
{{ homedir }}/.ssh/{{ target_key }}:
  file.managed:
    - makedirs: True
    - user: {{ user }}
    - group: {{ user }}
    - mode: {{ mode }}
    - source: salt://{{ salt_key }}

{%- endmacro %}


{%- macro nginx_block(value, key=None, operator=' ', delim=';', ind=8) -%}
    {% set indent_increment = 4 %}
    {%- if value != None -%}
    {%- if value is number or value is string -%}
        {{ key|indent(ind, True) }}{{ operator }}{{ value }}{{ delim }}
    {%- elif value is mapping -%}
        {{ key|indent(ind, True) }}{{ operator }}{{ '{' }}
        {%- if 'add_header' in value.keys() %}
{{ nginx_block(value['add_header'], 'add_header', operator, delim, (ind + indent_increment)) }}
        {% else %}
        {%- for k, v in value.items() %}
{{ nginx_block(v, k, operator, delim, (ind + indent_increment)) }}
        {%- endfor %}
        {%- endif %}
{{ '}'|indent(ind, True) }}
    {%- elif value is iterable -%}
        {%- for v in value %}
{{ nginx_block(v, key, operator, delim, ind) }}
        {%- endfor -%}
    {%- else -%}
        {{ key|indent(ind, True) }}{{ operator }}{{ value }}{{ delim }}
    {%- endif -%}
    {%- else -%}
    {%- endif -%}
{%- endmacro -%}


{% macro setup_bakthat_config(home) -%}
bakthat-config:
  file.managed:
    - name: {{ home }}/.bakthat.yml
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - source:
      - salt://backup/files/bakthat-config-template.yml

{%- endmacro %}


{% macro setup_user(user, home_dir) -%}
create_user_group_{{ user }}:
  group.present:
    - name: {{ user }}
  user.present:
    - name: {{ user }}
    - shell: /bin/bash
    - home: {{ home_dir }}
    - createhome: True
    - groups:
       - {{ user }}

{%- endmacro %}


# Macros for combine config for hdp url/port config like: bigdata-hbase1:2181,bigdata-hbase2:2181,bigdata-hbase3:2181
#
# combine_config(item_name)
# item_name = list in python which is iterable, like kafkastore-connection-urls below:
#  kafkastore-connection-urls:
#    - "bigdata-hbase1:2181"
#    - "bigdata-hbase2:2181"
#    - "bigdata-hbase3:2181"

{%- macro combine_config(item_name) -%}
{%- if item_name is iterable -%}
{{ item_name | join(', ') }}
{%- else -%}
None
{%- endif -%}
{%- endmacro -%}
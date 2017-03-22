#!/usr/bin/env bash

mysql -h {{ db.host }} -P {{ db.port }} -u {{ db.user }} -D {{ db.dbname }} -p{{ db.password }} < {{ ambari_resources_dir }}/{{ db.resetsql }}
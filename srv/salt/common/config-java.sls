{% set java = pillar['java'] %}

{{ java['profile_homedir'] }}:
  file.append:
    - name: {{ java['profile_homedir'] }}
    - unless: test 2 -eq `grep JAVA_HOME /{{ java['profile_homedir'] }}/.profile|wc -l`
    - text:
      - "export JAVA_HOME={{ java['dir'] }}"
      - "export PATH=${JAVA_HOME}/bin:$PATH"

source_{{ java['profile_homedir'] }}:
  cmd.run:
    - name: source {{ java['profile_homedir'] }}
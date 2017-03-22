/etc/security/limits.conf:
  file.append:
    - text:
      - '* - nofile 500000'
      - '* - memlock 100000'

/root/.profile:
  file.append:
    - text:
      - ulimit -n 500000
      - ulimit -l 100000

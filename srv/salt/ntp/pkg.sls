ntp_install:
  pkg.installed:
    - name: ntp
    - skip_verify: True
    - refresh: True
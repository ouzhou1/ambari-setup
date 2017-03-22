Increase_open_files_limit:
  file.append:
    - name: /etc/security/limits.conf
    - text:
      - "*         hard    nofile      65535"
      - "*         soft    nofile      65535"
      - "root      hard    nofile      65535"
      - "root      soft    nofile      65535"

System_wide_limit:
  file.append:
    - name: /etc/sysctl.conf
    - text: "fs.file-max = 65535"

sysctl-ulimit:
  cmd.wait:
    - name: sysctl -p
    - user: root
    - watch:
      - file: Increase_open_files_limit
      - file: System_wide_limit

/root/.profile-kernel:
  file.append:
    - name: /root/.profile
    - text:
      - ulimit -Hn  65535
      - ulimit -Sn  65535

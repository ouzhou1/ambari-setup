# http://uwsgi-docs.readthedocs.org/en/latest/articles/TheArtOfGracefulReloading.html#the-listen-queue

# During uWSGI graceful reloads, we expect new clients to wait 10 seconds (best case) to start seeing contents,
# but, unfortunately, we have hundreds of concurrent requests, so first 100 customers will wait during the server warm-up,
# while the others will get an error from the proxy, by default.
# This happens because the default size of uWSGI’s listen queue is 100 slots.
# it is an average value choosen by the maximum value allowed by default by system kernel.
# Each operating system has a default limit (Linux has 128, for example),
# so before increasing it we need to increase our kernel limit too.

net-core-somaxconn:
  file.append:
    - name: /etc/sysctl.conf
    - text: "net.core.somaxconn = 65535"

sysctl-effect-net-core:
  cmd.wait:
    - name: sysctl -p
    - user: root
    - watch:
      - file: net-core-somaxconn

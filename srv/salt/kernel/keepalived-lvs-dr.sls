# ignore for vip request
net.ipv4.conf.eth0.arp_ignore:
  sysctl.present:
    - name: net.ipv4.conf.eth0.arp_ignore
    - value: 1


# do not response arp request
net.ipv4.conf.eth0.arp_announce:
  sysctl.present:
    - name: net.ipv4.conf.eth0.arp_announce
    - value: 2


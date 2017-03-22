vm_dirty_expire_centisecs:
  sysctl.present:
    - name: vm.dirty_expire_centisecs
    - value: 3000

vm_dirty_ratio:
  sysctl.present:
    - name: vm.dirty_ratio
    - value: 40

sysctl_effect_vm_dirty:
  cmd.wait:
    - name: sysctl -p
    - user: root
    - watch:
      - sysctl: vm_dirty_expire_centisecs
      - sysctl: vm_dirty_ratio

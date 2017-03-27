hdp-setup:
  cmd.run:
    - cwd: /srv/setup
    - name: "sleep 30 && python AmbariRequest.py -f hdp_setup"
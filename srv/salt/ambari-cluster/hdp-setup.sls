hdp-setup:
  cmd.run:
    - cwd: /srv/setup
    - name: "sleep 30 && python AmbariRequest.py -f hdp_setup"
    - onlyif: test 1 -eq `curl -I -H "X-Requested-By:ambari"  -X GET -u admin:admin http://ambari-server1:8080|grep "200 OK"|wc -l`

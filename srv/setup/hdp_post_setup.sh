#!/usr/bin/env bash
# Run this script after hdp cluster setup to normal state!!!

confluenthost="bigdata-hbase2"
topichost="bigdata-hbase2"


read -p "Ambari HDP cluster already setup and state is fine?[Y/N]" checkstate
if [ "$checkstate" = "Y" -o  "$checkstate" = "y" ]; then

  salt bigdata-hbase2 cmd.run "bash /root/rebuild_topic.sh" -l debug

  salt "bigdata*" cmd.run "su hdfs -c \"hdfs dfs -mkdir /user/root ;  hdfs dfs -chown root /user/root\""

  python AmbariRequest.py -t yarn-site -c "hadoop.registry.zk.quorum: 10.12.0.94:2181,10.12.0.95:2181,10.12.0.96:2181" \
  "yarn.resourcemanager.zk-address: 10.12.0.94:2181,10.12.0.95:2181,10.12.0.96:2181" \
  -f hdp_property_config

  python AmbariRequest.py -f hdp_service_stop -s YARN -d '{"RequestInfo": {"context": "Stop YARN"}, "ServiceInfo": {"state": "INSTALLED"}}'

  python AmbariRequest.py -t kafka-broker -c "zookeeper.connect: 10.12.0.94:2181,10.12.0.95:2181,10.12.0.96:2181" -f hdp_property_config

  python AmbariRequest.py -f hdp_service_stop -s KAFKA -d '{"RequestInfo": {"context": "Stop Kafka"}, "ServiceInfo": {"state": "INSTALLED"}}'

  sleep 40

  python AmbariRequest.py -f hdp_service_start -s YARN -d '{"RequestInfo": {"context": "Start YARN"}, "ServiceInfo": {"state": "STARTED"}}'
  python AmbariRequest.py -f hdp_service_start -s KAFKA -d '{"RequestInfo": {"context": "Start Kafka"}, "ServiceInfo": {"state": "STARTED"}}'

  salt bigdata-hbase2 cmd.run "apt-get install -y at" -l debug
  salt bigdata-hbase2 cmd.run cwd=/usr/local/confluent/bin env='{"JAVA_HOME": "/usr/jdk64/jdk1.8.0_77"}' "./schema-registry-stop;" -l debug
  salt bigdata-hbase2 cmd.run cwd=/usr/local/confluent/bin env='{"JAVA_HOME": "/usr/jdk64/jdk1.8.0_77"}' "./schema-registry-start -daemon ../etc/schema-registry/schema-registry.properties|at now + 1 minutes exit 1 >/dev/null 2>&1" >/dev/null 2>&1 -l debug

fi
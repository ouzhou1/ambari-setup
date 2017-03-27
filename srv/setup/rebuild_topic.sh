#!/usr/bin/env/ bash
echo "begin delete topic..."
kafka-topics.sh --zookeeper localhost:2181 --delete --topic CreateDataSetJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic CreateDataSetJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataInsightJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataInsightJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataPreprocessingJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataPreprocessingJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic FeatureProcessingJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic FeatureProcessingJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic TrainingJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic TrainingJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic ScoringJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic ScoringJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --delete --topic ModelRegisterTopic
sleep 1
echo "delete topic finished"
echo "list topic..."
kafka-topics.sh --zookeeper localhost:2181 --list

echo "create topic..."
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic CreateDataSetJobRequestT
opic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic CreateDataSetJobResponse
Topic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataInsightJobRequestTop
ic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataInsightJobResponseTo
pic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataPreprocessingJobRequ
estTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataPreprocessingJobResp
onseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic FeatureProcessingJobRequ
estTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic FeatureProcessingJobResp
onseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic TrainingJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic TrainingJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic ScoringJobRequestTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic ScoringJobResponseTopic
sleep 1
kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic ModelRegisterTopic
sleep 1
echo "create topic finished"
echo "list topic..."
kafka-topics.sh --zookeeper localhost:2181 --list
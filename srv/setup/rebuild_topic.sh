#!/usr/bin/env/ bash
echo "begin delete topic..."
cd /usr/hdp/2.5.3.0-37/kafka/bin/
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic CreateDataSetJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic CreateDataSetJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataInsightJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataInsightJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataPreprocessingJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic DataPreprocessingJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic FeatureProcessingJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic FeatureProcessingJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic TrainingJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic TrainingJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic ScoringJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic ScoringJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --delete --topic ModelRegisterTopic
sleep 1
echo "delete topic finished"
echo "list topic..."
bash kafka-topics.sh --zookeeper localhost:2181 --list

echo "create topic..."
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic CreateDataSetJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic CreateDataSetJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataInsightJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataInsightJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataPreprocessingJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic DataPreprocessingJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic FeatureProcessingJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic FeatureProcessingJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic TrainingJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic TrainingJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic ScoringJobRequestTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic ScoringJobResponseTopic
sleep 1
bash kafka-topics.sh --zookeeper localhost:2181 --create --partitions 3 --replication 2 --topic ModelRegisterTopic
sleep 1
echo "create topic finished"
echo "list topic..."
bash kafka-topics.sh --zookeeper localhost:2181 --list
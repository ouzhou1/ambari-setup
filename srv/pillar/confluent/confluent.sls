confluent:
  sourcepkg: confluent-oss-3.0.0-2.11.zip
  salt-minion: bigdata-hbase2
  md5checksum: b7c2d306c1a0aa1d77c584d3c1fd9856
  kafkastore-connection-urls:
    - "bigdata-hbase1:2181"
    - "bigdata-hbase2:2181"
    - "bigdata-hbase3:2181"
  confluent_services:
    - ""


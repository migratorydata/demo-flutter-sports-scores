## Install MigratoryData w/ or w/o Kafka (optional)

This app is configured to connect to a MigratoryData deployment available at `demo.migratorydata.com`, so you can run it without installing MigratoryData or Kafka. 

However, if you wish to run this demo with your MigratoryData deployment or your MigratoryData & Kafka deployment please install MigratoryData or MigratoryData & Kafka as detailed below. In this case reconfigure this app by changing in the file `configuration.dart` the following:

```bash
final server = 'demo.migratorydata.com';
final encryption = true;
```

into

```bash
final server = 'localhost:8800';
final encryption = false;
```

### Install MigratoryData

Make sure that you have Java version 8 installed. Download the [platform-independent tarball package](https://migratorydata.com/releases/migratorydata-6.0.8/migratorydata-6.0.8-build20211220.tar.gz) of MigratoryData and unzip it to any folder, change to that folder. Run the following command on Linux or MacOS (run the similar command with the .bat extension instead of the .sh extension on Windows):

```bash
$ ./start-migratorydata.sh
```

This will deploy a cluster of one instance of MigratoryData which will listen for client connections on `localhost`, on the default port `8800`.

### Install MigratoryData & Kafka

Make sure that you have Java version 8 installed. Download the [platform-independent tarball package](https://archive.apache.org/dist/kafka/2.6.0/kafka_2.12-2.6.0.tgz) of Apache Kafka and unzip it to any folder, change to that folder, and run the following two commands in two different terminals on Linux or MacOS (run the similar commands with the .bat extension instead of the .sh extension on Windows) to start it:

```bash
$ ./bin/zookeeper-server-start.sh config/zookeeper.properties
$ ./bin/kafka-server-start.sh config/server.properties
```

This will deploy a cluster of one instance of Apache Kafka which will listen for Kafka producers and consumers on `localhost`, on the default port `9092`.

Download the [platform-independent tarball package](https://migratorydata.com/releases/migratorydata-6.0.8/migratorydata-6.0.8-build20211220.tar.gz) of MigratoryData and unzip it to any folder, change to that folder, and and edit the main configuration file `migratorydata.conf` by adding the following line:

```bash
ClusterEngine = kafka
```

Because, this demo app uses the Kafka topic `matches`, configure the MigratoryData server to subscribe to this topic, by editing the file `addons/kafka/consumer.properties` as follows:

```
bootstrap.servers=localhost:9092
topics=matches
```

Finally, run the following command on Linux or MacOS (run the similar command with the .bat extension instead of the .sh extension on Windows):

```bash
$ ./start-migratorydata.sh
```

This will deploy a cluster of one instance of MigratoryData which will listen for client connections on `localhost`, on the default port `8800`.
#!/bin/bash

echo -e "Start NameNode daemon and DataNode daemon\n"

$HADOOP_HOME/sbin/start-dfs.sh

echo -e "Start ResourceManager daemon and NodeManager daemon\n"

$HADOOP_HOME/sbin/start-yarn.sh

echo -e "\n"


#echo "🚀 Starting HDFS daemons..."
#hdfs --daemon start namenode
#hdfs --daemon start datanode
#hdfs --daemon start secondarynamenode

#echo "🚀 Starting YARN daemons..."
#yarn --daemon start resourcemanager
#yarn --daemon start nodemanager

#echo "✅ Hadoop services started:"
jps
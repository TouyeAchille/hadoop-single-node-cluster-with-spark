#!/bin/bash

echo -e "Stop NameNode daemon and DataNode daemon\n"

$HADOOP_HOME/sbin/stop-dfs.sh

echo -e "Stop ResourceManager daemon and NodeManager daemon\n"

$HADOOP_HOME/sbin/stop-yarn.sh

echo -e "\n"


#echo "🚀 Stop HDFS daemons..."
#hdfs --daemon stop namenode
#hdfs --daemon stop datanode
#hdfs --daemon stop secondarynamenode

#echo "🚀 Starting YARN daemons..."
#yarn --daemon stop resourcemanager
#yarn --daemon stop nodemanager

#echo "Hadoop services stopped:"
jps
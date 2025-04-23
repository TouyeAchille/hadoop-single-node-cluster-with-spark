FROM ubuntu:20.04

LABEL maintainer="Mbogol Touye Achille"  \
      email="touyejunior@gmail.com" \
      description="Dockerfile for Hadoop and Spark with Jupyter Notebook" \
      version="1.0.0" \
      description="This Dockerfile sets up a Hadoop environment in a single-node installation with spark and Jupyter Notebook for data processing and analysis."

WORKDIR /root

# 0. Arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG HADOOP_VERSION=3.4.1
ARG SPARK_VERSION=3.5.5

# 1. Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server openjdk-8-jdk wget vim curl ssh pdsh \
    python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install Hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

# 3. Install Spark
RUN wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /usr/local/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

# 4. Python, pip, Jupyter, PySpark
RUN pip3 install --upgrade pip && \
    pip3 install pyspark jupyter findspark

# 5. ENV vars
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV SPARK_HOME=/usr/local/spark
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

# 6. SSH without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# 7. Hadoop directories
RUN mkdir -p ~/hdfs/namenode ~/hdfs/datanode && \
    mkdir -p $HADOOP_HOME/logs

# 8. Copy configuration files
COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/scripts/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/scripts/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf


# 9. Droits d’exécution
RUN chmod +x ~/start-hadoop.sh ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh $HADOOP_HOME/sbin/start-yarn.sh

# 10. Format HDFS
RUN $HADOOP_HOME/bin/hdfs namenode -format


# 12. Exécution du conteneur
CMD [ "sh", "-c", "service ssh start; bash"]

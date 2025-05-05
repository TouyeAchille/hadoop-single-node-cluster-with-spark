<<<<<<< HEAD
# -------------------------------------------------------------
# Base Image Arguments
# -------------------------------------------------------------
ARG BASE_IMAGE=ubuntu
ARG UBUNTU_VERSION=24.10

FROM ${BASE_IMAGE}:${UBUNTU_VERSION}

# -------------------------------------------------------------
# Metadata
# -------------------------------------------------------------
LABEL maintainer="Mbogol Touye Achille" \
    email="touyejunior@gmail.com" \
    version="1.0.0" \
    description="Single-node Hadoop + Spark + Jupyter environment for data processing"

# -------------------------------------------------------------
# Environment Arguments
# -------------------------------------------------------------
=======
FROM ubuntu:latest

LABEL maintainer="Mbogol Touye Achille"  \
      email="touyejunior@gmail.com" \
      description="Dockerfile for Hadoop and Spark with Jupyter Notebook" \
      version="1.0.0" \
      description="This Dockerfile sets up a Hadoop environment in a single-node installation with spark and Jupyter Notebook for data processing and analysis."

WORKDIR /root

# 0. Arguments
>>>>>>> d12d363e793a5991a40fa92dacb028f8ce044a5b
ARG DEBIAN_FRONTEND=noninteractive
ARG HADOOP_VERSION=3.4.1
ARG SPARK_VERSION=3.5.5

<<<<<<< HEAD
# -------------------------------------------------------------
# System Dependencies & User
# -------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server openssh-client \
    openjdk-11-jdk libbcprov-java \
    wget vim pdsh \
    python3 python3-pip sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
WORKDIR root/notebooks

# -------------------------------------------------------------
# Hadoop Installation
# -------------------------------------------------------------
=======
# 1. Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server openjdk-8-jdk wget vim ssh \
    python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install Hadoop
>>>>>>> d12d363e793a5991a40fa92dacb028f8ce044a5b
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

<<<<<<< HEAD
# -------------------------------------------------------------
# Spark Installation
# -------------------------------------------------------------
=======
# 3. Install Spark
>>>>>>> d12d363e793a5991a40fa92dacb028f8ce044a5b
RUN wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /usr/local/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

<<<<<<< HEAD
# -------------------------------------------------------------
# Python Packages
# -------------------------------------------------------------
RUN pip3 install --no-cache-dir --break-system-packages \
    pyspark jupyter findspark

# -------------------------------------------------------------
# Environment Variables
# -------------------------------------------------------------
ENV LANG=C.UTF-8 \
    HOME=/root \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    HADOOP_HOME=/usr/local/hadoop \
    SPARK_HOME=/usr/local/spark \
    HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    HADOOP_MAPRED_HOME=/usr/local/hadoop \
    HADOOP_COMMON_HOME=/usr/local/hadoop \
    HADOOP_HDFS_HOME=/usr/local/hadoop \
    HADOOP_YARN_HOME=/usr/local/hadoop \
    HADOOP_TOOLS_HOME=/usr/local/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/usr/local/hadoop/lib/native \
    PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/spark/bin:/usr/local/spark/sbin    

RUN echo "\
    alias mapreduce='hadoop jar \$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-${HADOOP_VERSION}.jar'\n\
    export JAVA_HOME=${JAVA_HOME}\n\
    export HADOOP_HOME=${HADOOP_HOME}\n\
    export SPARK_HOME=${SPARK_HOME}\n\
    export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}\n\
    export HADOOP_MAPRED_HOME=${HADOOP_MAPRED_HOME}\n\
    export HADOOP_COMMON_HOME=${HADOOP_COMMON_HOME}\n\
    export HADOOP_HDFS_HOME=${HADOOP_HDFS_HOME}\n\
    export HADOOP_YARN_HOME=${HADOOP_YARN_HOME}\n\
    export HADOOP_TOOLS_HOME=${HADOOP_TOOLS_HOME}\n\
    export PATH=${PATH}\n\
    export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_COMMON_LIB_NATIVE_DIR}" >> /root/.bashrc
=======

# 4. Python, pip, Jupyter, PySpark
RUN pip3 install pyspark jupyter findspark --break-system-packages

# 5. ENV vars
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV SPARK_HOME=/usr/local/spark
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

# 5 bis. Append ENV vars to /root/.bashrc for interactive shells
RUN echo "\
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\n\
    export HADOOP_HOME=/usr/local/hadoop\n\
    export HADOOP_MAPRED_HOME=\$HADOOP_HOME\n\
    export HADOOP_COMMON_HOME=\$HADOOP_HOME\n\
    export HADOOP_HDFS_HOME=\$HADOOP_HOME\n\
    export HADOOP_YARN_HOME=\$HADOOP_HOME\n\
    export SPARK_HOME=/usr/local/spark\n\
    export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop\n\
    export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$SPARK_HOME/bin:\$SPARK_HOME/sbin\n\
    export LD_LIBRARY_PATH=\$HADOOP_HOME/lib/native:\$LD_LIBRARY_PATH\n\
    " >> /root/.bashrc
>>>>>>> d12d363e793a5991a40fa92dacb028f8ce044a5b

RUN echo "\
    export HDFS_NAMENODE_USER=root\n\
    export HDFS_DATANODE_USER=root\n\
    export HDFS_SECONDARYNAMENODE_USER=root\n\
    export YARN_RESOURCEMANAGER_USER=root\n\
<<<<<<< HEAD
    export YARN_NODEMANAGER_USER=root"  > /etc/profile.d/hadoop.sh

# -------------------------------------------------------------
# SSH Configuration (passwordless)
# -------------------------------------------------------------  
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 700 ~/.ssh && \ 
    chmod 600 ~/.ssh/authorized_keys 

# -------------------------------------------------------------
# HDFS Directories
# -------------------------------------------------------------
RUN mkdir -p ~/hdfs/namenode ~/hdfs/datanode ${HADOOP_HOME}/logs

# -------------------------------------------------------------
# Configuration Files & Scripts
# -------------------------------------------------------------
COPY config/ /tmp/config/
COPY notebooks/ /root/notebooks/

RUN mv /tmp/config/ssh_config /root/.ssh/config && \
    mv /tmp/config/hadoop/hadoop-env.sh ${HADOOP_CONF_DIR}/hadoop-env.sh && \
    mv /tmp/config/hadoop/*.xml ${HADOOP_CONF_DIR}/ && \
    mv /tmp/config/spark/spark-defaults.conf ${SPARK_HOME}/conf/ && \
    chmod +x ${HADOOP_HOME}/sbin/*.sh && \
    chmod +x ${SPARK_HOME}/sbin/*.sh && \
    chmod +x ${HOME}/notebooks/code/*.py && \
    chmod +x ${HOME}/notebooks/scripts/*.sh

# -------------------------------------------------------------
# Format the Hadoop Filesystem
# -------------------------------------------------------------
RUN ${HADOOP_HOME}/bin/hdfs namenode -format

# -------------------------------------------------------------
# Container Startup Command
# -------------------------------------------------------------

CMD ["sh", "-c", "service ssh start && bash"]
=======
    export YARN_NODEMANAGER_USER=root" > /etc/profile.d/hadoop.sh


# 6. SSH without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# 7. Hadoop directories
RUN mkdir -p ~/hdfs/namenode ~/hdfs/datanode && \
    mkdir -p $HADOOP_HOME/logs

# 8. Copy configuration files
COPY config/ /tmp/
COPY scripts/ /tmp/scripts/

# copy dataset
COPY dataset/purchases.txt.gz /root/dataset/purchases.txt.gz


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
>>>>>>> d12d363e793a5991a40fa92dacb028f8ce044a5b

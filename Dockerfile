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
ARG DEBIAN_FRONTEND=noninteractive
ARG HADOOP_VERSION=3.4.1
ARG SPARK_VERSION=3.5.5

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
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

# -------------------------------------------------------------
# Spark Installation
# -------------------------------------------------------------
RUN wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /usr/local/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

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

RUN echo "\
    export HDFS_NAMENODE_USER=root\n\
    export HDFS_DATANODE_USER=root\n\
    export HDFS_SECONDARYNAMENODE_USER=root\n\
    export YARN_RESOURCEMANAGER_USER=root\n\
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

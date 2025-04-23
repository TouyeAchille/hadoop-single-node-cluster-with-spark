# hadoop-cluster-docker-with-spark

This project sets up a Hadoop environment in a Docker container. It also includes a Spark and Jupyter Notebook installation for data processing and analysis. Follow the instructions below to build and run the Hadoop cluster in a single-node Docker container.

🛠️ 1. Build Image and Create Hadoop Container
To start, build the Docker image and create the Hadoop container using Docker Compose.
  > docker compose up
2 - Open new terminal
  >  docker exec -it hadoop-single-node bash
3 - Start haoop cluster in single node
     > ./start_hadoop.sh
4 For pratical TP : unzip file below
  >  gunzip dataset/purchases.txt.gz 
 

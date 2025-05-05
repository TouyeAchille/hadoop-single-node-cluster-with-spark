# Hadoop Single Node Setup with Docker
This project sets up a Hadoop environment in a Docker container. It also includes a Spark and Jupyter Notebook installation for data processing and analysis. Follow the instructions below to build and run the Hadoop cluster in a single-node Docker container.

## 🛠️ 1. Build Image and Create Hadoop Container
To start, build the Docker image and create the Hadoop container using Docker Compose.

```bash
docker compose up

🖥️ 2. Open a New Terminal and Access the Container
Once the container is up and running, open a new terminal and execute the following command to access the container's shell:
 
docker exec -it hadoop-single-node bash

🚀 3. Start Hadoop Cluster in Single Node
Within the container's shell, execute the following command to start the Hadoop cluster in a single-node setup:

./start_hadoop.sh

📂 4. Unzip Dataset for Practical Work
For the practical exercises, you will need to unzip the provided dataset file. Use the following command to unzip purchases.txt.gz:

<<<<<<< HEAD
gunzip notebooks/dataset/purchases.txt.gz

✅ 5. run Jupyter Notebook from shell of container, execute the following command : 
 jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root

 or execute the following command 
 jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

 👉 "Access it from your browser (on your host machine) at http://localhost:8888 and paste the token displayed in the container terminal.


=======
gunzip dataset/purchases.txt.gz
>>>>>>> d12d363e793a5991a40fa92dacb028f8ce044a5b

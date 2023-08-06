## Table of Contents
- [General Description](#general-description)
    - [Overview](#overview)
    - [Customized PostgreSQL Image](#customized-postgresql-image)
    - [Using the Provided TPCH Database](#using-the-provided-tpch-database)
    - [Working with Your Own Data](#working-with-your-own-data)
- [Energy Consumption Tools](#energy-consumption-tools)
- [How to Use the Environment](#how-to-use-the-environment)
    - [Step 1: Clone the Repository](#step-1-clone-the-repository)
    - [Step 2: Set Up the Environment](#step-2-set-up-the-environment)
        - [Prerequisites](#prerequisites)
        - [Preparing the Environment](#preparing-the-environment)
        - [Using the Environment](#using-the-environment)
    - [Step 3: Accessing PostgreSQL and Running Queries](#step-3-accessing-postgresql-and-running-queries)
    - [Step 4: Experimenting with Energy Consumption Measurement](#step-4-experimenting-with-energy-consumption-measurement)
    - [Using Your Own Data](#using-your-own-data)
    - [Cleaning Up](#cleaning-up)

## General Description

### Overview

The Docker Compose environment provided here is designed for conducting reproducible benchmarking experiments to compare the energy consumption of PostgreSQL with and without the ProvSQL plugin. It allows users to measure the power consumption at the global and process levels using various energy measurement tools. The environment includes a custom PostgreSQL image with pre-loaded TPCH benchmark data and the ProvSQL extension enabled. Users can execute queries both with and without ProvSQL enabled. Additionally, users have the flexibility to use their own data for experimentation.

### Customized PostgreSQL Image

Our custom PostgreSQL image serves as the core component of this environment. It comes with the TPCH benchmark data pre-loaded, enabling users to perform benchmarking tasks without any additional setup. Moreover, it has the ProvSQL extension enabled, facilitating benchmarking experiments that utilize ProvSQL features. The custom image is equipped with two query scripts: `queries.sql` and `queries_supported.sql`. The former is for executing queries without ProvSQL, while the latter is for executing queries with ProvSQL enabled.

### Using the Provided TPCH Database

We understand the importance of readily available benchmark datasets for research and experimentation. Therefore, we have integrated the TPCH benchmark database into the PostgreSQL image. This allows users to instantly access and run experiments using TPCH queries.

> Note: For more details on the TPCH benchmark dataset, refer to the [TPC Benchmark™ H (TPC-H)](http://www.tpc.org/tpch/) website.

### Working with Your Own Data

We also acknowledge the need for flexibility, as users may have specific datasets they wish to analyze. To cater to this requirement, our Docker Compose environment supports the use of custom data. Users can simply mount their local data directory into the PostgreSQL container, enabling them to conduct experiments on their own datasets.

## Energy Consumption Tools

The environment includes several energy measurement tools that allow users to monitor and analyze power consumption metrics:

1. Scaphandre: A versatile tool for measuring power consumption on both bare metal hosts and virtual machines. It provides process-level power consumption metrics and can export data to various destinations, including Prometheus and JSON files.

2. Prometheus: A powerful time-series database and monitoring system that can collect, store, and query power consumption metrics exported by Scaphandre.

3. Grafana: A feature-rich data visualization tool that integrates with Prometheus. Users can create customizable dashboards to monitor PostgreSQL and other metrics in real-time.

## How to Use the Environment

In this section, we will guide you through the process of setting up and using the Docker Compose environment for energy consumption benchmarking and experimentation. Follow the steps below to get started:

### Step 1: Clone the Repository

Begin by cloning this GitHub repository, which contains all the necessary files and configurations for the Docker Compose environment.

```bash
git clone https://github.com/BelkisDjeffal/rbed.git
cd your-repo
```

### Step 2: Set Up the Environment
#### Prerequisites

Before using this tool, ensure that you have the following prerequisites installed:

1. Docker: The environment is orchestrated using Docker Compose, so you need to have Docker installed on your system.

2. Docker Compose: To simplify the setup process, make sure you have Docker Compose installed as well

#### Preparing the Environment

Before starting the Docker Compose environment, it is important to ensure that the ports `8080`, `9090`, and `3000` are not already in use. If any of these ports are in use by another process, it can cause conflicts and prevent the services in the Docker Compose environment from starting properly. Follow the steps below to check and free up these ports if they are in use:

   Check for if the port is already in use :
   Open a terminal and run the following command to check if the port is in use:
   ```
   sudo lsof -i :<port>
   ```
   If there is a process using the port, the command will show the process ID (PID) of the process. To free up the port, use the following command, replacing `<PID>` with the actual process ID:
   ```
   sudo kill <PID>
   ```
#### Using the Environment
With the ports freed up, you can now start the PostgreSQL Energy Consumption Benchmarking Environment using the following command:
```bash
docker-compose up -d
```
This will pull the required Docker images and launch the services specified in the `docker-compose.yaml` file. 

### Step 3: Accessing PostgreSQL and Running Queries
Once the environment is up and running, you can access the PostgreSQL container to interact with the database. There are two ways to achieve this:

1. Using `docker exec` to access the PostgreSQL container interactively:

   To access the PostgreSQL command-line interface, open a terminal and run the following command:

   ```bash
   docker exec -it docker-compose_postgresql_1 psql -U postgres
   ```

   This command allows you to directly interact with the PostgreSQL database as the `postgres` user. You can then execute SQL queries and perform administrative tasks.

2. Executing Queries from Host Machine:

   You can access the PostgreSQL container and execute the pre-loaded queries. To interact with the PostgreSQL database and execute the queries, use the following command:

```bash
docker exec -i postgres_with_provsql_and_tpch_4_container psql -U postgres -d tpch -f /queries/query-file.sql
```
This command allows you to execute the pre-loaded queries directly from your host machine. The queries are already available in the PostgreSQL container, replace `query-file.sql` with your desired query file. If you want to execute queries without ProvSQL, use `queries.sql`, or for queries with ProvSQL enabled, use `queries_supported.sql`.

Using either of these methods, you can interact with the PostgreSQL database and run queries as needed for your benchmarking and experimentation.

### Step 4: Experimenting with Energy Consumption Measurement

To measure energy consumption, Scaphandre is integrated into the environment. It exports power consumption metrics to Prometheus, allowing real-time monitoring and analysis.

Follow these steps to set up energy consumption measurement:

1. Access the Grafana dashboard at `http://localhost:3000` using your web browser. Log in with the default credentials (admin/admin).

2. Add Prometheus as a data source in Grafana. Use the URL `http://prometheus:9090` for the Prometheus server URL.

3. Create custom dashboards in Grafana to visualize the power consumption metrics. You can use the `scaph_process_power_consumption_microwatts` metric to monitor process-level power consumption.

4. Optionally, you can export power consumption metrics to JSON files for further analysis. Scaphandre allows storing power consumption metrics in JSON format.

> Note: For more details on using Scaphandre, Prometheus, and Grafana for energy consumption monitoring, refer to the respective documentation.


## Using Your Own Data

If you have your own PostgreSQL database that you want to use for experimentation, you can easily load it into the Docker Compose environment provided here. Follow the steps below to prepare and import your data:

### Step 1: Dump Your PostgreSQL Database

First, you need to create a dump of your PostgreSQL database using the `pg_dump` utility. Ensure you have the `pg_dump` tool installed on your local machine. Open a terminal and run the following command to create a dump of your database (replace `<your_database>` with the name of your database):

```bash
pg_dump -U <your_user> -d <your_database> > your_database_dump.pgdata
```

This command will create a dump file named `your_database_dump.pgdata` containing your database's data and schema.

### Step 2: Prepare Your Data Directory

Place the generated `your_database_dump.pgdata` file into a directory called `data` within your Docker Compose project directory. Your project structure should look like this:

```
your_project_directory/
|-- data/
|   |-- your_database_dump.pgdata
|-- docker-compose.yaml
|-- other_files_and_directories...
```

### Step 3: Modify the Docker Compose Configuration

Open the `docker-compose.yaml` file and update the `volumes` section to mount the `data` directory into the PostgreSQL container. Modify the `docker-compose.yaml` as follows:

```yaml
version: '3'

services:

  # The postgresql image
  postgresql:
    image: postgres_with_provsql_and_tpch_4:latest
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: tpch
    ports:
      - "5434:5434"
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./data:/data
    networks:
      - scaphandre-network

  # Energy_measurement_tools
  # ... (rest of the configuration remains unchanged)
```

### Step 4: Start the Docker Compose Environment

Now, start the Docker Compose environment with the following command:

```bash
docker-compose up -d
```

This will create and run the necessary containers, including PostgreSQL.

### Step 5: Import Your Data into PostgreSQL

With the Docker Compose environment up and running, you can now import your data into the PostgreSQL container. Open a terminal and run the following command to access the PostgreSQL container:

```bash
docker exec -it docker-compose_postgresql_1 psql -U postgres
```

This will open the PostgreSQL command-line prompt inside the container. Now, create a new database (e.g., "demo") using the following SQL command:

```sql
CREATE DATABASE demo;
```

Exit the PostgreSQL prompt by typing `\q`.

Next, import your data from the dump file `your_database_dump.pgdata` into the "demo" database using the following command:

```bash
docker exec -i docker-compose_postgresql_1 psql -U postgres -d demo < /data/your_database_dump.pgdata
```

Replace `your_database_dump.pgdata` with the actual name of your dump file.

### Step 6: Access and Query Your Database

Now, you have successfully imported your own database into the Docker Compose environment. To access and query your "demo" database, use the following command:

```bash
docker exec -it docker_compose_postgresql_1 psql -U postgres -d demo
```

You can now run queries and interact with your own data inside the "demo" database.

## Cleaning Up

When you have finished running benchmarking experiments, you can clean up the environment using the following command:

```bash
docker-compose down
```

This command will stop and remove all the containers and networks created by Docker Compose.


Congratulations! You now have a fully functional Docker Compose environment for energy consumption benchmarking of PostgreSQL. Happy experimenting!

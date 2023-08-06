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
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### Step 2: Set Up the Environment

Run the following command to start the Docker Compose environment:

```bash
docker-compose up -d
```

This will pull the required Docker images and launch the services specified in the `docker-compose.yml` file. Please note that you may need Docker and Docker Compose installed on your system to execute this command.

> Note: If you encounter any issues, ensure that Docker and Docker Compose are properly installed and running on your system. Refer to the official Docker documentation for installation instructions.

### Step 3: Accessing PostgreSQL and Running Queries

With the environment up and running, you can now access the PostgreSQL container to execute queries. By default, the PostgreSQL service is exposed on port 5432. Use the following command to connect to the PostgreSQL database:

```bash
psql -h localhost -p 5432 -U postgres -d tpch -f path/to/query-file.sql
```

Replace `path/to/query-file.sql` with the path to your desired query file. You can use `queries.sql` for queries without ProvSQL or `queries_supported.sql` for queries with ProvSQL enabled.

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
|-- docker-compose.yml
|-- other_files_and_directories...
```

### Step 3: Modify the Docker Compose Configuration

Open the `docker-compose.yml` file and update the `volumes` section to mount the `data` directory into the PostgreSQL container. Modify the `docker-compose.yml` as follows:

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
      - ./data:/data # Added this line to mount the 'data' directory
    networks:
      - app_net

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
docker exec -it task5_docker_compose_postgresql_1 psql -U postgres
```

This will open the PostgreSQL command-line prompt inside the container. Now, create a new database (e.g., "demo") using the following SQL command:

```sql
CREATE DATABASE demo;
```

Exit the PostgreSQL prompt by typing `\q`.

Next, import your data from the dump file `your_database_dump.pgdata` into the "demo" database using the following command:

```bash
docker exec -i task5_docker_compose_postgresql_1 psql -U postgres -d demo < /data/your_database_dump.pgdata
```

Replace `your_database_dump.pgdata` with the actual name of your dump file.

### Step 6: Access and Query Your Database

Now, you have successfully imported your own database into the Docker Compose environment. To access and query your "demo" database, use the following command:

```bash
docker exec -it task5_docker_compose_postgresql_1 psql -U postgres -d demo
```

You can now run queries and interact with your own data inside the "demo" database.

Congratulations! You now have a fully functional Docker Compose environment for energy consumption benchmarking with PostgreSQL. Happy experimenting!

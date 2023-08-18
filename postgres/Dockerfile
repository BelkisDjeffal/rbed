FROM postgres:14

# Set the environment variable for PostgreSQL superuser password
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB tpch

# Install ProvSQL
# Start by installind dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
	postgresql-server-dev-14 \
        libboost-dev \
        libgraph-easy-perl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy provsql source code to the docker build directory
RUN mkdir /provsql
COPY provsql /provsql
WORKDIR /provsql
RUN make \
    && make install

# Add the line to postgresql.conf
#RUN echo "shared_preload_libraries = 'provsql'" >> /var/lib/postgresql/data/postgresql.conf
RUN echo "shared_preload_libraries = 'provsql'" >> /usr/share/postgresql/14/postgresql.conf.sample

# Copy the initialization scripts into the container
COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

# Copy the queries scripts
RUN mkdir /queries
COPY ./queries/ /queries/

# Use the official entrypoint script of the PostgreSQL image


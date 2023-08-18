#!/bin/bash

file="/docker-entrypoint-initdb.d/tpch_with_provsql_dumpfile.pgdata"
dbname=tpch

echo "Creating database $dbname"
psql -U postgres  <<EOSQL
    CREATE DATABASE "$dbname";
    GRANT ALL PRIVILEGES ON DATABASE "$dbname" TO postgres;
EOSQL

#gosu postgres postgres --single -c "CREATE DATABASE $dbname;"

echo "Restoring DB using $file"

pg_restore -U postgres --dbname=$dbname --verbose --single-transaction < "$file" || exit 1

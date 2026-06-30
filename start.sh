#!/bin/sh
set -e

echo "Running database migrations..."
source /app/app.env
./migrate -path db/migration -database "$DB_SOURCE" -verbose up

echo "Starting the application..."
exec "$@"
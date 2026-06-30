#!/bin/sh
set -e

echo "Running database migrations..."
set -a
. /app/app.env
set +a
/app/migrate -path /app/db/migration -database "$DB_SOURCE" -verbose up

echo "Starting the application..."
exec /app/main
#!/bin/sh
echo "DB Connection --- Establishing . . ."

while ! nc -z "$POSTGRES_HOST" "$POSTGRES_PORT"; do
  sleep 1
done

echo "DB Connection --- Established"
exec "$@"

#!/bin/bash
set -e

echo "Waiting for Postgres to be ready..."

pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" /docker-entrypoint-initdb.d/softdepot_tar_utf8.sql

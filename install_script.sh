#!/usr/bin/env bash

set -euo pipefail

export PGPASSWORD=postgres

psql -U postgres -c "DROP DATABASE IF EXISTS imdb;"
psql -U postgres -c "create database imdb"
psql -U postgres -d imdb -f imdb.backup
psql -U postgres -d imdb -f omdb_data.backup
psql -U postgres -d imdb -f B2_build_movie_db.sql
psql -U postgres -d imdb -f C2_build_framework_db.sql


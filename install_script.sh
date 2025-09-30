#!/usr/bin/env bash

set -euo pipefail

export PGPASSWORD=postgres

psql -U postgres -c "DROP DATABASE IF EXISTS imdb;"
psql -U postgres -c "create database imdb"
psql -U postgres -d imdb -f imdb.backup
psql -U postgres -d imdb -f omdb_data.backup
psql -U postgres -d imdb -f wi.backup
psql -U postgres -d imdb -f B2_build_movie_db.sql
psql -U postgres -d imdb -f C2_build_framework_db.sql
psql -U postgres -d imdb -f D1_db.sql
psql -U postgres -d imdb -f D2_db.sql
psql -U postgres -d imdb -f D3_db.sql
psql -U postgres -d imdb -f D4_db.sql
psql -U postgres -d imdb -f D5_db.sql
psql -U postgres -d imdb -f D6_db.sql
psql -U postgres -d imdb -f D7_db.sql
psql -U postgres -d imdb -f D7_seed_after.sql
psql -U postgres -d imdb -f D8_db.sql
psql -U postgres -d imdb -f D9_db.sql
psql -U postgres -d imdb -f D10_db.sql
psql -U postgres -d imdb -f D11_db.sql
psql -U postgres -d imdb -f D12_db.sql
psql -U postgres -d imdb -f D13_db.sql


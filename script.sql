\set ON_ERROR_STOP
\echo '=== DEBUG RUN ==='

-- -----------------------------------------------------------------
-- 1️⃣ Set backup files with full paths
-- -----------------------------------------------------------------

\set db_name 'imdb'
-- Hardcoding postgres user to avoid variable issues
\echo 'Dropping and creating database...'
\! dropdb -U postgres :db_name 2>/dev/null || true
\! createdb -U postgres :db_name


\! psql -U postgres -d imdb -f imdb.backup
\! psql -U postgres -d imdb -f omdb_data.backup

--\echo 'Restoring dumps...'
-- \! pg_restore -U postgres -d :db_name ":imdb_backup"
-- \! pg_restore -U postgres -d :db_name ":omdb_backup"

\echo '=== RESTORE DONE ==='

-- -----------------------------------------------------------------
-- 4️⃣ List tables
-- -----------------------------------------------------------------
\connect :db_name
\dt

FROM cgr.dev/chainguard-private/postgres:18

COPY schema.sql /var/lib/postgres/initdb/01-schema.sql
COPY seed.sql   /var/lib/postgres/initdb/02-seed.sql

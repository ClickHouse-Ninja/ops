CREATE DATABASE IF NOT EXISTS ops;

CREATE VIEW ops.tables AS
SELECT
    database
    , table
    , partitions
    , parts
    , size
    , marks_size
    , pk_memory
    , pk_memory_allocated
    , rows
    , engine
FROM (
    SELECT
        database
        , table
        , COUNT(DISTINCT partition)                                      AS partitions
        , COUNT()                                                        AS parts
        , SUM(bytes)                                                     AS order_size
        , formatReadableSize(SUM(bytes))                                 AS size
        , formatReadableSize(SUM(marks_size))                            AS marks_size
        , formatReadableSize(SUM(primary_key_bytes_in_memory))           AS pk_memory
        , formatReadableSize(SUM(primary_key_bytes_in_memory_allocated)) AS pk_memory_allocated
        , SUM(rows)     AS rows
    FROM system.parts
    WHERE active
    GROUP BY
        database, table
        WITH TOTALS
    ORDER BY order_size DESC
)
ANY INNER JOIN (
    SELECT
        database
        , name AS table
        , engine
    FROM system.tables
) USING (database, table);

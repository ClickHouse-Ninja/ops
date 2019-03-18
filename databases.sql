CREATE DATABASE IF NOT EXISTS ops;

CREATE VIEW ops.databases AS
SELECT
    database
    , tables
    , size
    , marks_size
    , pk_memory
    , pk_memory_allocated
    , data_path
    , metadata_path
    , engine
FROM (
    SELECT
        database
        , COUNT(DISTINCT table)                                          AS tables
        , SUM(bytes)                                                     AS order_size
        , formatReadableSize(SUM(bytes))                                 AS size
        , formatReadableSize(SUM(marks_size))                            AS marks_size
        , formatReadableSize(SUM(primary_key_bytes_in_memory))           AS pk_memory
        , formatReadableSize(SUM(primary_key_bytes_in_memory_allocated)) AS pk_memory_allocated
    FROM system.parts
    WHERE active
    GROUP BY
        database
        WITH TOTALS
    ORDER BY order_size DESC
)
ANY INNER JOIN (
    SELECT
        name AS database
        , data_path
        , metadata_path
        , engine
    FROM system.databases
) USING (database);

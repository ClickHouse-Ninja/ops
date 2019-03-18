CREATE DATABASE IF NOT EXISTS ops;

CREATE VIEW ops.cache AS
SELECT
      MarkCacheHits
    , MarkCacheMisses
    , 100 - (MarkCacheMisses / (MarkCacheMisses + MarkCacheHits) * 100) AS MarkCacheHitRate
    , UncompressedCacheHits
    , UncompressedCacheMisses
    , 100 - (UncompressedCacheMisses / (UncompressedCacheMisses + UncompressedCacheHits) * 100) AS UncompressedCacheHitRate
FROM (
    SELECT
          sumIf(value, event = 'MarkCacheHits')           AS MarkCacheHits
        , sumIf(value, event = 'MarkCacheMisses')         AS MarkCacheMisses
        , sumIf(value, event = 'UncompressedCacheHits')   AS UncompressedCacheHits
        , sumIf(value, event = 'UncompressedCacheMisses') AS UncompressedCacheMisses
    FROM system.events
    WHERE event IN (
        'MarkCacheHits',
        'MarkCacheMisses',
        'UncompressedCacheHits',
        'UncompressedCacheMisses'
    )
);
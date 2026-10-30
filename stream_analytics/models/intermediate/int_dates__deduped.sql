SELECT 
    CONTENT_RELEASE_DATE AS DATE,
    YEAR(CONTENT_RELEASE_DATE) AS YEAR,
    MONTH (CONTENT_RELEASE_DATE) AS MONTH,
    DAY(CONTENT_RELEASE_DATE) AS DAY
FROM 
    {{ ref('stg_watch_events_flat__watch_events') }}

UNION 

SELECT 
    WATCH_DATE AS DATE,
    YEAR(WATCH_DATE) AS YEAR,
    MONTH(WATCH_DATE) AS MONTH, 
    DAY(WATCH_DATE)  AS DAY
FROM 
    {{ ref('stg_watch_events_flat__watch_events') }}
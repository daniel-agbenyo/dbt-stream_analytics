SELECT DISTINCT 
    CONTENT_ID,
    CONTENT_TITLE,
    CONTENT_GENRE,
    CONTENT_RELEASE_DATE,
    CONTENT_DURATION_MINUTES
FROM
    {{ ref('stg_watch_events_flat__watch_events') }}
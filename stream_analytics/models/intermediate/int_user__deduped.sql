SELECT 
    DISTINCT
    USER_ID,
    USER_NAME,
    USER_COUNTRY,
    USER_SUBSCRIPTION_TIER
FROM 
    {{ ref('stg_watch_events_flat__watch_events') }}
SELECT 
    EVENT_ID,
    {{ dbt_utils.generate_surrogate_key(['USER_ID', 'USER_NAME',  'USER_COUNTRY', 'USER_SUBSCRIPTION_TIER']) }} AS USER_KEY,
    {{ dbt_utils.generate_surrogate_key(['CONTENT_ID']) }} AS CONTENT_KEY,
    TO_CHAR(WATCH_DATE, 'YYYYMMDD') :: INT AS DATE_KEY,
    DEVICE_TYPE,
    MINUTES_WATCHED,
    WATCH_DATE,
    COMPLETED_FLAG,
    RATING_GIVEN
FROM {{ ref('int_events_watched__flagged') }}                       
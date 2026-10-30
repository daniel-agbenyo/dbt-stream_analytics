{{ config(incremental_strategy = 'merge',
          materialized = 'incremental',
          unique_key = 'EVENT_ID',
        )
        }}

{% set incremental_col = 'WATCH_DATE' %}

WITH CONTENT AS (
SELECT *
FROM {{ ref('dim_content') }}
),
USER AS (
    SELECT *
    FROM {{ ref('dim_user') }}
),
DATES AS (
    SELECT *
    FROM {{ ref('dim_dates') }}
),
ONLY_SURROGATES AS (
    SELECT *
    FROM {{ ref('fct_watch_events')}}
    
    {% if is_incremental() %}
       where {{ incremental_col }} >= coalesce((select max({{ incremental_col }}) from {{ this }}), '1900-01-01')
    {% endif %}
)
SELECT 
    S.EVENT_ID,
    U.USER_ID,
    U.USER_NAME,
    U.USER_COUNTRY,
    U.USER_SUBSCRIPTION_TIER,
    C.CONTENT_ID,
    C.CONTENT_TITLE,
    C.CONTENT_GENRE,
    C.CONTENT_RELEASE_DATE,
    C.CONTENT_DURATION_MINUTES,
    S.MINUTES_WATCHED,
    S.DEVICE_TYPE,
    S.RATING_GIVEN,
    S.COMPLETED_FLAG
FROM ONLY_SURROGATES S
JOIN CONTENT C ON C.CONTENT_KEY = S.CONTENT_KEY
JOIN USER U ON U.USER_KEY = S.USER_KEY
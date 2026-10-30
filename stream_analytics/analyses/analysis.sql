select 
    content_id,
    content_title,
    content_release_date
from {{ ref('stg_watch_events_flat__watch_events') }}
where content_id = 'C-0238'


select 
    content_title,
    content_duration_minutes,
    minutes_watched,
    completed_flag
from 
    {{ ref('stg_watch_events_flat__watch_events') }}
where minutes_watched < content_duration_minutes


with false_negative as(
select 
    content_title,
    content_duration_minutes,
    minutes_watched,
    completed_flag,
    content_duration_minutes - minutes_watched as diff_minutes
from 
    {{ ref('stg_watch_events_flat__watch_events') }}
where diff_minutes < 10 and completed_flag = 0
)
select 
    *
from false_negative


with false_positive as(
select 
    content_title,
    content_duration_minutes,
    minutes_watched,
    completed_flag,
    content_duration_minutes - minutes_watched as diff_minutes
from 
    {{ ref('stg_watch_events_flat__watch_events') }}
where diff_minutes > 20 and completed_flag = 1
)
select 
    *
from 
    false_positive


--Proof of slowly changing dimensions
select 
    user_id,
    user_name,
    user_country,
    user_subscription_tier
from {{ ref("int_user__deduped") }}
where user_id = 'U-0079' and user_subscription_tier != 'Premium'

--Test deduplicated user table
select 
    row_number() over(partition by user_id order by user_id) as rn, 
    user_id
from {{ ref('int_user__deduped') }}
where user_id = 'U-0003'
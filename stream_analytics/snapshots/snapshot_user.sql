{% snapshot user_snapshot %}
{{
    config(
        target_schema = 'snapshot',
        unique_key = 'USER_ID',
        strategy = 'check',
        check_cols = ['USER_NAME', 'USER_COUNTRY', 'USER_SUBSCRIPTION_TIER']
    )
}}

SELECT
    USER_ID,
    USER_NAME,
    USER_COUNTRY,
    USER_SUBSCRIPTION_TIER
FROM
    {{ ref('int_user__deduped') }}

{% endsnapshot %}
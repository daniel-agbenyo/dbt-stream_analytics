SELECT
    {{ dbt_utils.generate_surrogate_key(['USER_ID','USER_NAME', 'USER_COUNTRY', 'USER_SUBSCRIPTION_TIER']) }} AS USER_KEY,
    USER_ID,
    USER_NAME,
    USER_COUNTRY,
    USER_SUBSCRIPTION_TIER
FROM
    {{ ref('int_user__deduped') }}
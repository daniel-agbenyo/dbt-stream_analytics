SELECT 
    {{ dbt_utils.generate_surrogate_key(['CONTENT_ID']) }} AS CONTENT_KEY,
    CONTENT_ID,
    CONTENT_TITLE,
    CONTENT_GENRE,
    CONTENT_RELEASE_DATE,
    CONTENT_DURATION_MINUTES
FROM
    {{ ref('int_content__deduped') }}
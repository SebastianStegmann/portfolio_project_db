CREATE OR REPLACE FUNCTION best_match_query(
    keywords text[]
)
RETURNS TABLE (
    tconst text,
    primarytitle text,
    match_count int
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        tb.tconst::text,
        tb.primarytitle::text,
        COUNT(DISTINCT kw.keyword)::int AS match_count
    FROM title_basics tb
    CROSS JOIN unnest(keywords) AS kw(keyword)
    WHERE LOWER(tb.primarytitle) LIKE '%' || LOWER(kw.keyword) || '%'
       OR LOWER(tb.plot)         LIKE '%' || LOWER(kw.keyword) || '%'
    GROUP BY tb.tconst, tb.primarytitle
    ORDER BY match_count DESC;
END;
$$ LANGUAGE plpgsql;


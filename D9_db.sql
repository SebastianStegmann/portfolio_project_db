CREATE OR REPLACE FUNCTION get_related_movies(input_tconst CHAR(10))
RETURNS TABLE (tconst CHAR(10), similarity FLOAT) AS $$
BEGIN
    RETURN QUERY
    WITH input_genres AS (
        SELECT array_agg(tg.genre_id) AS genres
        FROM title_genre tg
        WHERE tg.tconst = input_tconst
    ),
    movie_genres AS (
        SELECT tg.tconst, array_agg(tg.genre_id) AS genres
        FROM title_genre tg
        GROUP BY tg.tconst
    ),
    similarities AS (
        SELECT 
            mg.tconst,
            CASE
                WHEN denom = 0 THEN 0::FLOAT
                ELSE (intersec / denom)::FLOAT
            END AS similarity
        FROM movie_genres mg,
        LATERAL (
            SELECT COUNT(*)::FLOAT AS intersec
            FROM unnest((SELECT genres FROM input_genres)) AS ig(genre_id)
            INNER JOIN unnest(mg.genres) AS mg_genre(genre_id)
            ON ig.genre_id = mg_genre.genre_id
        ) i,
        LATERAL (
            SELECT COUNT(*)::FLOAT AS denom
            FROM (
                SELECT unnest((SELECT genres FROM input_genres)) AS genre_id
                UNION
                SELECT unnest(mg.genres) AS genre_id
            ) u
        ) d
        WHERE mg.tconst != input_tconst
    )
    SELECT s.tconst, s.similarity
    FROM similarities s
    WHERE s.similarity > 0
    ORDER BY s.similarity DESC;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION word_to_words_query(
     keywords text[]
 )
 RETURNS TABLE (
     word text,
     frequency int
 ) AS $$
 BEGIN
     RETURN QUERY
     WITH document_matches AS (
         SELECT wi.tconst, COUNT(DISTINCT kw.keyword) AS weight
         FROM wi
         JOIN unnest(keywords) AS kw(keyword)
              ON LOWER(wi.word) = LOWER(kw.keyword)
         GROUP BY wi.tconst
     )
     SELECT
         wi.word,
         SUM(dm.weight)::int AS frequency
     FROM wi
     JOIN document_matches dm ON wi.tconst = dm.tconst
     GROUP BY wi.word
     ORDER BY frequency DESC;
 END;
 $$ LANGUAGE plpgsql;

CREATE OR replace FUNCTION find_coplayers(input_nconst VARCHAR(10), p_id BIGINT, limit_count int DEFAULT 10)
RETURNS TABLE(nconst VARCHAR(10), name VARCHAR(255), freq INT) as $$
 
BEGIN
INSERT INTO search_history(person_id, search_string, created_at)
   VALUES (p_id,
            jsonb_build_object(
              'coplayers', input_nconst 
            )::TEXT,
    now());
 
    RETURN query
 
   WITH actor_titles as (
      SELECT tp.tconst
      FROM title_principals tp
      WHERE tp.nconst = input_nconst
   )
 
  SELECT nb.nconst, nb.name, COUNT(*)::INT AS freq
  FROM title_principals tp2
   JOIN name_basics nb ON nb.nconst = tp2.nconst
   WHERE tp2.tconst in (SELECT tconst FROM actor_titles)
   AND tp2.nconst <> input_nconst
   GROUP BY nb.nconst, nb.name
   ORDER BY freq DESC
   LIMIT limit_count;
 
END;
$$
LANGUAGE plpgsql;

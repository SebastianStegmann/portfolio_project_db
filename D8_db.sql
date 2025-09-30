CREATE OR REPLACE FUNCTION popularactors(s_primarytitle VARCHAR(255))
  
  RETURNS TABLE(
  nconst VARCHAR(10),
  name VARCHAR(255),
  name_rating NUMERIC(3,1)
) AS $$
 
  BEGIN
  RETURN query
 
   SELECT nb.nconst::VARCHAR(10), nb.name::VARCHAR(255), nb.name_rating::NUMERIC(3,1)
   FROM title_principals tp
      JOIN name_basics nb ON nb.nconst = tp.nconst
      JOIN title_basics tb ON tb.tconst = tp.tconst
   WHERE tb.primarytitle ilike s_primarytitle
   ORDER BY nb.name_rating DESC NULLS LAST;
 
  END;
$$ LANGUAGE plpgsql;

 
CREATE OR REPLACE FUNCTION popularcoplayers(s_name VARCHAR(255))
  RETURNS TABLE(nconst VARCHAR(10), name VARCHAR(255), name_rating NUMERIC(3,1)) AS $$
BEGIN
  RETURN QUERY
  WITH cotitles AS (
    SELECT tp.tconst
    FROM title_principals tp
      JOIN name_basics nb ON nb.nconst = tp.nconst
    WHERE nb.name ILIKE '%' || s_name || '%'
  )
  SELECT 
    nb.nconst::VARCHAR(10),
    nb.name::VARCHAR(255),
    nb.name_rating::NUMERIC(3,1)
  FROM title_principals tp2
   JOIN name_basics nb ON nb.nconst = tp2.nconst
  WHERE tp2.tconst IN (SELECT tconst FROM cotitles)
    AND tp2.nconst NOT IN (
      SELECT n.nconst
      FROM name_basics n
      WHERE n.name ILIKE '%' || s_name || '%'
    )
  GROUP BY nb.nconst, nb.name, nb.name_rating
  ORDER BY nb.name_rating DESC NULLS LAST;
END;
$$ LANGUAGE plpgsql;












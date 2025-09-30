CREATE OR REPLACE FUNCTION freqpersonwords(s_name TEXT)
  RETURNS TABLE(word TEXT, freq int) AS $$
 
  BEGIN
  RETURN query
 
  SELECT w.word, COUNT(*)::INT AS freq
  FROM name_basics nb
      JOIN title_principals tp ON nb.nconst = tp.nconst
      JOIN wi w ON w.tconst = tp.tconst
   WHERE nb.name ilike '%' || s_name || '%'
   GROUP BY w.word
   ORDER BY freq DESC;
 
  END;
$$ LANGUAGE plpgsql;


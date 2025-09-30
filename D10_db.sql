CREATE OR REPLACE FUNCTION freqpersonwords(s_name TEXT, limit_count INT DEFAULT 10)
  RETURNS TABLE(word TEXT, freq int) AS $$
 
  begin
  return query
 
  select w.word, count(*)::int as freq
  from name_basics nb
      join title_principals tp on nb.nconst = tp.nconst
      join wi w on w.tconst = tp.tconst
   where nb.name ilike '%' || s_name || '%'
   group by w.word
   order by freq DESC
   LIMIT limit_count;
 
  END;
$$ LANGUAGE plpgsql;

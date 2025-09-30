CREATE OR REPLACE FUNCTION exactmatch(input TEXT)
  RETURNS TABLE(primarytitle TEXT) AS $$
 
  begin
  return query
 
  with search_input as (
   select unnest(STRING_TO_ARRAY(lower(input), ' ')) AS si
  )
 
  select tb.primarytitle
  from title_basics tb
      join wi w on w.tconst = tb.tconst
      join search_input s on lower(w.word) = s.si
   group by tb.tconst, tb.primarytitle
   having count(distinct w.word) = (
      select count(*)
      from search_input
   );
 
  END;
$$ LANGUAGE plpgsql;

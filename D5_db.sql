CREATE OR REPLACE FUNCTION find_names(
    p_name TEXT,
    p_id BIGINT
)
RETURNS TABLE (nconst text, primaryname text) AS $$
BEGIN
  insert into search_history(person_id, search_string, created_at)
   values (p_id,
             jsonb_build_object(
            'name', p_name 
        )::TEXT,
    now());
  
    RETURN QUERY
    SELECT nb.nconst::text, nb.name::text
    FROM name_basics nb
    WHERE LOWER(nb.name) LIKE LOWER('%' || p_name || '%');
END;
$$ LANGUAGE plpgsql;

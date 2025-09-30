CREATE OR REPLACE FUNCTION string_search(search_string text, person_id bigint)
RETURNS TABLE(tconst VARCHAR(10), primarytitle TEXT) AS $$
BEGIN
    -- Log the search
    INSERT INTO search_history(person_id, search_string, created_at)
    VALUES (person_id, search_string, NOW());
 
    -- Return matching movies and episodes
    RETURN QUERY
    SELECT tb.tconst, tb.primarytitle
    FROM title_basics tb
    WHERE tb.primarytitle ILIKE '%' || search_string || '%'
       OR tb.plot ILIKE '%' || search_string || '%'
   
    UNION
 
    SELECT te.tconst, te.primarytitle
    FROM title_episode te
    WHERE te.primarytitle ILIKE '%' || search_string || '%' --ILIKE er for at gøre case insensitive
       OR te.plot ILIKE '%' || search_string || '%';
END;
$$ LANGUAGE plpgsql;

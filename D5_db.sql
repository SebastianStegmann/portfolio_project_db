CREATE OR REPLACE FUNCTION find_names(
    p_name text
)
RETURNS TABLE (nconst text, primaryname text) AS $$
BEGIN
    RETURN QUERY
    SELECT nb.nconst::text, nb.name::text
    FROM name_basics nb
    WHERE LOWER(nb.name) LIKE LOWER('%' || p_name || '%');
END;
$$ LANGUAGE plpgsql;

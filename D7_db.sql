ALTER TABLE name_basics
   ADD COLUMN IF NOT EXISTS name_rating NUMERIC(3,1);

--
CREATE INDEX idx_name_basics_rating
  ON name_basics (name_rating);

CREATE INDEX idx_name_basics_name_lower
  ON name_basics (LOWER(name));
--


CREATE OR REPLACE FUNCTION namerating(input_nconst VARCHAR(10))
  RETURNS TABLE(nconst VARCHAR(10), name VARCHAR(255), name_rating NUMERIC(3,1)) AS $$
DECLARE
    p_nconst VARCHAR(10);
    p_name VARCHAR(255);
    weighted NUMERIC(3,1);
BEGIN
    SELECT nb.nconst, nb.name INTO p_nconst, p_name
    FROM name_basics nb
    WHERE nb.nconst = input_nconst
    LIMIT 1;
 
    IF p_nconst IS NULL THEN
        RAISE NOTICE 'No person found with the name %', input_nconst;
        RETURN;
    END IF;
 
    SELECT least(10, greatest(1,
             round(SUM(o.rating::NUMERIC) / NULLIF(SUM(o.votes),0), 1) ))
    INTO weighted
    FROM title_principals tp
    JOIN overall_rating o ON o.tconst = tp.tconst
    WHERE tp.nconst = p_nconst;
   
    UPDATE name_basics
    SET name_rating = weighted
    WHERE name_basics.nconst = p_nconst;
 
    RETURN QUERY
    SELECT p_nconst, p_name, weighted;
END;
$$
  LANGUAGE plpgsql

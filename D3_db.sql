CREATE OR REPLACE FUNCTION rate(
    title_id CHAR(10), -- Matches title.tconst and overall_rating.tconst
    person_id BIGINT,  -- Matches person.id and individual_rating.person_id
    rating INTEGER     -- Compatible with individual_rating.rating (SMALLINT)
) RETURNS TABLE (
    status TEXT
) AS $$
DECLARE
    old_rating INTEGER;
BEGIN
    -- Validate title_id
  --IF title_id IS NULL OR NOT EXISTS (
  --    SELECT 1 FROM title WHERE tconst = title_id
  --) THEN
  --    RETURN QUERY SELECT 'Error: Invalid title ID';
  --    RETURN;
  --END IF;

    -- Validate person_id (minimal)
  --IF person_id IS NULL THEN
  --    RETURN QUERY SELECT 'Error: Invalid user ID';
  --    RETURN;
  --END IF;

    -- Check for existing rating
    SELECT ir.rating INTO old_rating
    FROM individual_rating ir
    WHERE ir.person_id = rate.person_id AND ir.tconst = rate.title_id;

    -- Update or insert
    IF old_rating IS NOT NULL THEN
        UPDATE individual_rating ir
        SET rating = rate.rating, updated_at = NOW()
        WHERE ir.person_id = rate.person_id AND tconst = rate.title_id;

        UPDATE overall_rating orat
        SET rating = orat.rating - old_rating + rate.rating
        WHERE orat.tconst = rate.title_id;
    ELSE
        INSERT INTO individual_rating (person_id, tconst, rating, created_at)
        VALUES (person_id, title_id, rate.rating, NOW());

        IF EXISTS (SELECT 1 FROM overall_rating WHERE tconst = title_id) THEN
            UPDATE overall_rating orat
            SET rating = orat.rating + rate.rating,
                votes = orat.votes + 1
            WHERE orat.tconst = rate.title_id;
        ELSE
            INSERT INTO overall_rating (tconst, rating, votes)
            VALUES (title_id, rate.rating, 1);
        END IF;
    END IF;

    RETURN QUERY SELECT 'Success';
EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN QUERY SELECT 'Error: Invalid user or title ID';
    WHEN check_violation THEN
        RETURN QUERY SELECT 'Error: Rating must be between 1 and 10';
    WHEN others THEN
        RETURN QUERY SELECT 'Error: Rating failed - ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rate(
    title_id VARCHAR(10),
    person_id BIGINT,
    rating INTEGER
) RETURNS TABLE (
    status TEXT
) AS $$
DECLARE
    old_rating INTEGER;
BEGIN
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
-- EXCEPTION
--     WHEN foreign_key_violation THEN
--         RETURN QUERY SELECT 'Error: Invalid user or title ID';
--     WHEN check_violation THEN
--         RETURN QUERY SELECT 'Error: Rating must be between 1 and 10';
--     WHEN others THEN
--         RETURN QUERY SELECT 'Error: Rating failed - ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

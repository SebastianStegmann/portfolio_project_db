CREATE OR REPLACE FUNCTION register_user(
    p_name VARCHAR(255),
    p_birthday DATE,
    p_location VARCHAR(2),
    p_email email,
    p_password TEXT
) RETURNS TABLE (status TEXT, user_id BIGINT) AS $$
BEGIN
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM person WHERE email = p_email) THEN
        RETURN QUERY SELECT 'Error: Email already exists' AS status, NULL::BIGINT AS user_id;
    ELSE
        -- Insert new user with application-provided password (assumed hashed)
        INSERT INTO person (name, birthday, location, email, password, created_at)
        VALUES (
            NULLIF(TRIM(p_name), ''),
            p_birthday,
            UPPER(NULLIF(TRIM(p_location), '')),
            p_email,
            p_password,
            NOW()
        )
        RETURNING 'Success: User registered' AS status, person.id AS user_id INTO status, user_id;
        
        RETURN QUERY SELECT status, user_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_user(
    p_user_id BIGINT,
    p_name VARCHAR(255),
    p_birthday DATE,
    p_location VARCHAR(2),
    p_email email
) RETURNS TABLE (status TEXT) AS $$
BEGIN
    -- Check if user exists
    IF NOT EXISTS (SELECT 1 FROM person WHERE id = p_user_id) THEN
        RETURN QUERY SELECT 'Error: User not found' AS status;
    ELSIF EXISTS (SELECT 1 FROM person WHERE email = p_email AND id != p_user_id) THEN
        RETURN QUERY SELECT 'Error: Email already in use' AS status;
    ELSE
        -- Update user details
        UPDATE person
        SET
            name = COALESCE(NULLIF(TRIM(p_name), ''), name),
            birthday = COALESCE(p_birthday, birthday),
            location = COALESCE(UPPER(NULLIF(TRIM(p_location), '')), location),
            email = COALESCE(p_email, email)
        WHERE id = p_user_id;
        
        RETURN QUERY SELECT 'Success: User updated' AS status;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_user(
    p_user_id BIGINT
) RETURNS TABLE (status TEXT) AS $$
BEGIN
    -- Check if user exists
    IF NOT EXISTS (SELECT 1 FROM person WHERE person.id = p_user_id) THEN
        RETURN QUERY SELECT 'Error: User not found' AS status;
    ELSE
        -- Delete related data
        DELETE FROM search_history WHERE person_id = p_user_id;
        DELETE FROM bookmark WHERE person_id = p_user_id;
        DELETE FROM name_bookmark WHERE person_id = p_user_id;
        DELETE FROM individual_rating WHERE person_id = p_user_id;
        DELETE FROM person WHERE id = p_user_id;
        
        RETURN QUERY SELECT 'Success: User deleted' AS status;
    END IF;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION add_title_bookmark(
    p_user_id BIGINT,
    p_tconst TEXT
) RETURNS TABLE (status TEXT) AS $$
BEGIN
        INSERT INTO bookmark (person_id, tconst, created_at)
        VALUES (p_user_id, p_tconst, NOW());
        
        RETURN QUERY SELECT 'Success: Title bookmarked' AS status;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_name_bookmark(
    p_user_id BIGINT,
    p_nconst TEXT
) RETURNS TABLE (status TEXT) AS $$
BEGIN
        INSERT INTO name_bookmark (person_id, nconst, created_at)
        VALUES (p_user_id, p_nconst, NOW());
        
        RETURN QUERY SELECT 'Success: Name bookmarked' AS status;
END;
$$ LANGUAGE plpgsql;

--


CREATE OR REPLACE FUNCTION get_user_bookmarks(
    p_user_id BIGINT
) RETURNS TABLE (
    type TEXT,
    id TEXT,
    title_or_name TEXT,
    created_at TIMESTAMP
) AS $$
BEGIN
        RETURN QUERY
        SELECT 
            'Title' AS type,
            b.tconst AS id,
            tb.primarytitle AS title_or_name,
            b.created_at
        FROM bookmark b
        JOIN title_basics tb ON b.tconst = tb.tconst
        WHERE b.person_id = p_user_id
        UNION ALL
        SELECT 
            'Name' AS type,
            nb.nconst AS id,
            n.name AS title_or_name,
            nb.created_at
        FROM name_bookmark nb
        JOIN name_basics n ON nb.nconst = n.nconst
        WHERE nb.person_id = p_user_id
        ORDER BY created_at DESC;
END;
$$ LANGUAGE plpgsql;


--


CREATE OR REPLACE FUNCTION delete_title_bookmark(
    p_user_id BIGINT,
    p_tconst TEXT
) RETURNS TABLE (status TEXT) AS $$
BEGIN
        DELETE FROM bookmark WHERE person_id = p_user_id AND tconst = p_tconst;
        
        RETURN QUERY SELECT 'Success: Title bookmark removed' AS status;
END;
$$ LANGUAGE plpgsql;

--


CREATE OR REPLACE FUNCTION delete_name_bookmark(
    p_user_id BIGINT,
    p_nconst TEXT
) RETURNS TABLE (status TEXT) AS $$
BEGIN
        DELETE FROM name_bookmark WHERE person_id = p_user_id AND nconst = p_nconst;
        
        RETURN QUERY SELECT 'Success: Name bookmark removed' AS status;
END;
$$ LANGUAGE plpgsql;










CREATE OR REPLACE FUNCTION structured_string_search(
    title_text TEXT,
    plot_text TEXT,
    character_text TEXT,
    person_text TEXT,
    p_id BIGINT,
    limit_count int DEFAULT 10
) RETURNS TABLE (
    tconst VARCHAR(10),
    primarytitle TEXT
) AS $$
BEGIN
    INSERT INTO search_history (person_id, search_string, created_at)
    VALUES (
        p_id,
        jsonb_build_object(
            'title', COALESCE(title_text, ''),
            'plot', COALESCE(plot_text, ''),
            'character', COALESCE(character_text, ''),
            'person', COALESCE(person_text, '')
        )::TEXT,
        NOW()
    );

    RETURN QUERY
    SELECT DISTINCT t.tconst, tb.primarytitle
    FROM title t
    JOIN title_basics tb ON t.tconst = tb.tconst
    LEFT JOIN title_principals tp ON t.tconst = tp.tconst
    LEFT JOIN name_basics nb ON tp.nconst = nb.nconst
    WHERE (title_text IS NULL OR tb.primarytitle ILIKE '%' || title_text || '%')
      AND (plot_text IS NULL OR tb.plot ILIKE '%' || plot_text || '%')
      AND (character_text IS NULL OR tp.characters ILIKE '%' || character_text || '%')
      AND (person_text IS NULL OR nb.name ILIKE '%' || person_text || '%')
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;


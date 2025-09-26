
-- 1. file
DROP TABLE IF EXISTS title_genre;
DROP TABLE IF EXISTS name_title_role;
DROP TABLE IF EXISTS name_profession;
-- DROP TABLE IF EXISTS title_principals;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS profession;
DROP TABLE IF EXISTS new_title_episode;
DROP TABLE IF EXISTS award;
DROP TABLE IF EXISTS new_title_akas;
DROP TABLE IF EXISTS overall_rating;
DROP TABLE IF EXISTS known_for;
DROP TABLE IF EXISTS new_title_basics;
DROP TABLE IF EXISTS new_name_basics;
-- DROP TABLE IF EXISTS title;

-- 2. file
-- Step 1: Create super-type table
-- Super-type table
 CREATE TABLE title (
    tconst CHAR(10) PRIMARY KEY,
    title_type CHAR(1) NOT NULL,
     CONSTRAINT chk_type CHECK (title_type IN ('B', 'E'))
 );

INSERT INTO title (tconst, title_type)
 SELECT
tconst,
'B' as title_type
FROM title_basics;

 UPDATE title
 SET    title_type = 'E'
 WHERE  tconst IN (SELECT tconst FROM title_episode);

-- Step 2: Create other tables without FKs initially
CREATE TABLE profession (
    id SMALLSERIAL PRIMARY KEY,
    profession VARCHAR(30)
);

CREATE TABLE role (
    id SMALLSERIAL PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL
);

CREATE TABLE award (
    tconst CHAR(10) PRIMARY KEY,
    award_info TEXT
);

CREATE TABLE genre (
    id SMALLSERIAL PRIMARY KEY,
    genre VARCHAR(20)
);

CREATE TABLE new_title_basics (
    tconst CHAR(10) PRIMARY KEY,
    titletype VARCHAR(20),
    primarytitle TEXT,
    originaltitle TEXT,
    isadult BOOLEAN,
    releasedate VARCHAR(20),
    endyear CHAR(4),
    totalseasons SMALLINT,
    plot TEXT,
    poster VARCHAR(180),
    country VARCHAR(560),
    runtimeminutes INT
);

CREATE TABLE new_title_episode (
    tconst CHAR(10) PRIMARY KEY,
    parenttconst CHAR(10),
    primarytitle TEXT,
    originaltitle TEXT,
    isadult BOOLEAN,
    releasedate VARCHAR(20),
    runtimeminutes INTEGER,
    poster VARCHAR(180),
    plot TEXT,
    seasonnumber SMALLINT,
    episodenumber SMALLINT
);

CREATE TABLE new_name_basics (
    nconst CHAR(10) PRIMARY KEY,
    name VARCHAR(255),
    birthyear SMALLINT,
    deathyear SMALLINT
);

CREATE TABLE title_genre (
    tconst CHAR(10),
    genre_id SMALLINT,
    PRIMARY KEY (tconst, genre_id)
);

CREATE TABLE name_title_role (
    nconst CHAR(10),
    tconst CHAR(10),
    role_id SMALLINT,
    PRIMARY KEY (nconst, tconst, role_id)
);

CREATE TABLE new_title_akas (
    tconst CHAR(10),
    ordering SMALLINT,
    title TEXT,
    region VARCHAR(10),
    language VARCHAR(10),
    types VARCHAR(255),
    attributes VARCHAR(255),
    isoriginaltitle BOOLEAN,
    PRIMARY KEY (tconst, ordering)
);

CREATE TABLE overall_rating (
    tconst CHAR(10),
    rating INTEGER,
    votes INTEGER,
    PRIMARY KEY (tconst)
);

CREATE TABLE name_profession (
    nconst CHAR(10),
    profession_id SMALLINT,
    PRIMARY KEY (nconst, profession_id)
);

CREATE TABLE known_for (
    nconst CHAR(10),
    tconst CHAR(10),
    PRIMARY KEY (nconst, tconst)
);

-- 3. file
INSERT INTO new_title_basics
SELECT tb.tconst,
       tb.titletype, 
       tb.primarytitle, 
       tb.originaltitle, 
       tb.isadult, 
        CASE
        WHEN od.released IS NOT NULL
             AND od.released <> ''
             AND od.released <> 'N/A' THEN od.released
        WHEN tb.startyear IS NOT NULL
             AND tb.startyear <> ''      THEN tb.startyear
        ELSE NULL
        END,
       NULLIF(tb.endyear, ''),
       NULLIF(od.totalseasons, 'N/A')::int,
       nullif (od.plot, 'N/A'),
       nullif (od.poster, 'N/A'),
       od.country,
       tb.runtimeminutes::int
FROM title_basics tb
LEFT JOIN omdb_data od
ON tb.tconst = od.tconst;


-- 4. file
INSERT INTO new_title_episode
SELECT 
    te.tconst,
    te.parenttconst,
    tb.primarytitle,
    tb.originaltitle,
    tb.isadult,
    tb.releasedate,
    tb.runtimeminutes,
    tb.poster,
    tb.plot,
    te.seasonnumber,
    te.episodenumber
FROM title_episode te
JOIN new_title_basics tb
ON te.tconst = tb.tconst;

-- 5. file
-- SELECT COUNT(*)
-- FROM new_title_basics
-- JOIN new_title_episode ON new_title_basics.tconst = new_title_episode.tconst;

DELETE FROM new_title_basics
USING new_title_episode
WHERE new_title_basics.tconst = new_title_episode.tconst;

ALTER TABLE new_title_episode
ADD CONSTRAINT new_title_episode_parenttconst_fkey
FOREIGN KEY (parenttconst) REFERENCES new_title_basics(tconst);

-- SELECT COUNT(*)
-- FROM new_title_basics
-- JOIN new_title_episode ON new_title_basics.tconst = new_title_episode.tconst;

-- 6. file

INSERT INTO new_name_basics
SELECT 
  nb.nconst,
  nb.primaryname,
  NULLIF(nb.birthyear,'')::smallint,
  NULLIF(nb.deathyear,'')::smallint
FROM name_basics nb;

-- 7. file


-- Insert each distinct genre (trimmed of surrounding whitespace)
INSERT INTO genre (genre)
SELECT DISTINCT TRIM(g) AS genre
FROM   title_basics,
       UNNEST(STRING_TO_ARRAY(genres, ',')) AS g;

INSERT INTO title_genre (tconst, genre_id)
SELECT 
    t.tconst AS tconst,
    g.id AS genre_id
FROM title_basics t
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(t.genres, ',')) AS genre_name
JOIN genre g ON TRIM(genre_name) = g.genre;

INSERT INTO profession (profession)
SELECT DISTINCT TRIM(p) AS profession
FROM   name_basics,
       UNNEST(STRING_TO_ARRAY(primaryprofession, ',')) AS p;

INSERT INTO name_profession (nconst, profession_id)
SELECT 
    n.nconst AS nconst,
    p.id AS profession_id
FROM name_basics n
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(n.primaryprofession, ',')) AS profession_name
JOIN profession p ON TRIM(profession_name) = p.profession;

-- 8. file
INSERT INTO known_for (nconst, tconst)
SELECT
  nb.nconst,
  kf_tconst
FROM name_basics nb
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(nb.knownfortitles, ',')) AS kf_tconst
JOIN title ON kf_tconst = title.tconst;

-- 9. file
INSERT INTO role (id, role_name) VALUES (default, 'director'), (default, 'writer');

INSERT INTO name_title_role (nconst, tconst, role_id)
SELECT
    d.nconst,
    tc.tconst,
    1 AS role_id
FROM title_crew tc
CROSS JOIN LATERAL
    UNNEST(string_to_array(tc.directors, ',')) AS d(nconst)
JOIN name_basics nb ON nb.nconst = d.nconst

UNION ALL

SELECT
    w.nconst,
    tc.tconst,
    2 AS role_id
FROM title_crew tc
CROSS JOIN LATERAL
    UNNEST(string_to_array(tc.writers, ',')) AS w(nconst)
JOIN name_basics nb ON nb.nconst = w.nconst;

-- 10. file

ALTER TABLE title_principals
ALTER COLUMN ordering TYPE SMALLINT;


-- -- We choose to delete people who arent also in name_basics
-- SELECT *
-- FROM title_principals tp
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM new_name_basics nb
--     WHERE nb.nconst = tp.nconst
-- );

DELETE FROM title_principals tp
WHERE NOT EXISTS (
    SELECT 1
    FROM new_name_basics nb
    WHERE nb.nconst = tp.nconst
);

-- 11. file
INSERT INTO award (tconst, award_info)
SELECT 
od.tconst,
NULLIF(od.awards, 'N/A')
FROM omdb_data od;

-- 12. file
INSERT INTO overall_rating (tconst, rating, votes)
SELECT
  tr.tconst,
  ROUND(tr.averagerating * tr.numvotes) AS rating,
  tr.numvotes
FROM title_ratings tr;

-- SELECT
--     CASE
--         WHEN o.votes IS NULL OR o.votes = 0 THEN NULL
--         ELSE ROUND( (o.rating::numeric) / (o.votes::numeric), 2 )
--     END AS average_rating
-- FROM overall_rating AS o;

-- 13. file 
INSERT INTO new_title_akas (
    tconst,
    ordering,
    title,
    region,
    language,
    types,
    attributes,
    isoriginaltitle
)
SELECT
    src.titleid AS tconst,
    CASE
        WHEN src.ordering::text ~ '^\s*\d+\s*$' THEN src.ordering::SMALLINT
        ELSE NULL
    END AS ordering,
    NULLIF(src.title, '') AS title,
    NULLIF(src.region, '') AS region,
    NULLIF(src.language, '') AS language,
    NULLIF(src.types,    '') AS types,
    NULLIF(src.attributes, '') AS attributes,
    src.isoriginaltitle AS isoriginaltitle
FROM title_akas AS src;

-- 14. file
UPDATE title_principals
SET
    job        = NULLIF(job,        ''),
    characters = NULLIF(characters, '');


-- 15. file
-- Step 6: Add FK constraints
ALTER TABLE new_title_basics
    ADD CONSTRAINT fk_basics_title FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE new_title_episode
    ADD CONSTRAINT fk_episode_title FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED,
    ADD CONSTRAINT fk_episode_parenttconst FOREIGN KEY (parenttconst) REFERENCES new_title_basics(tconst) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE award
    ADD CONSTRAINT fk_award_title FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE title_genre
    ADD CONSTRAINT fk_title_genre_title FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED,
    ADD CONSTRAINT fk_title_genre_genre FOREIGN KEY (genre_id) REFERENCES genre(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE name_title_role
    ADD CONSTRAINT fk_name_title_role_nconst FOREIGN KEY (nconst) REFERENCES new_name_basics(nconst) DEFERRABLE INITIALLY DEFERRED,
    ADD CONSTRAINT fk_name_title_role_tconst FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED,
    ADD CONSTRAINT fk_name_title_role_role FOREIGN KEY (role_id) REFERENCES role(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE new_title_akas
    ADD CONSTRAINT fk_title_akas_title FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE overall_rating
    ADD CONSTRAINT fk_overall_rating_title FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE name_profession
    ADD CONSTRAINT fk_name_profession_nconst FOREIGN KEY (nconst) REFERENCES new_name_basics(nconst) DEFERRABLE INITIALLY DEFERRED,
    ADD CONSTRAINT fk_name_profession_profession FOREIGN KEY (profession_id) REFERENCES profession(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE known_for
    ADD CONSTRAINT fk_known_for_nconst FOREIGN KEY (nconst) REFERENCES new_name_basics(nconst) DEFERRABLE INITIALLY DEFERRED,
    ADD CONSTRAINT fk_known_for_tconst FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE overall_rating
    ADD CONSTRAINT fk_overall_rating_tconst FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE new_title_akas
    ADD CONSTRAINT fk_title_akas_tconst FOREIGN KEY (tconst) REFERENCES title(tconst) DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE title_principals
ADD CONSTRAINT title_princials_tconst FOREIGN KEY (tconst) REFERENCES title(tconst),
ADD CONSTRAINT title_principals_nconst FOREIGN KEY (nconst) REFERENCES new_name_basics(nconst);

-- 16. file

DROP TABLE IF EXISTS title_basics;
DROP TABLE IF EXISTS title_akas;
DROP TABLE IF EXISTS title_crew;
DROP TABLE IF EXISTS title_episode;
DROP TABLE IF EXISTS title_genre;
DROP TABLE IF EXISTS title_ratings;
DROP TABLE IF EXISTS name_basics;
DROP TABLE IF EXISTS omdb_data;

ALTER TABLE new_title_basics   RENAME TO title_basics;
ALTER TABLE new_title_episode  RENAME TO title_episode;
ALTER TABLE new_name_basics    RENAME TO name_basics;
ALTER TABLE new_title_akas     RENAME TO title_akas;













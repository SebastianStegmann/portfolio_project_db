\timing
-- D1 
-- Register user
SELECT * FROM register_user(
  'Karl',
  '2001-11-14',
  'DA',
  'karl@karlmail.dk',
  'password'
);

SELECT * FROM register_user(
  'Johanne',
  '2004-11-09',
  'DA',
  'johanne@karlmail.dk',
  'password'
);

-- Update user
SELECT * FROM update_user(1, 'Karlos', '2001-11-14', 'DA', 'karl@karlmail.dk');

-- Delete user
SELECT * FROM delete_user(1);

-- Add title bookmark
SELECT * FROM add_title_bookmark(2,'tt0167261');
SELECT * FROM add_title_bookmark(2,'tt0167260');


-- Add name bookmark
SELECT * FROM add_name_bookmark(2, 'nm0705356');

-- Get users bookmarks -- before delete
SELECT * FROM get_user_bookmarks(2);

-- Delete title bookmark
SELECT * FROM delete_title_bookmark(2, 'tt0167261');

-- Delete name bookmark
SELECT * FROM delete_name_bookmark(2,'nm0705356');

-- Get users bookmarks -- after delete
SELECT * FROM get_user_bookmarks(2);

-- D2
SELECT string_search('Lord', 2) LIMIT 10;

-- D3
SELECT * FROM rate('tt0167261', 2, 5);
SELECT * FROM rate('tt0167261', 2, 6);

-- D4
SELECT tconst, primarytitle
        FROM structured_string_search('Two Towers', NULL, NULL, NULL, 2) LIMIT 10;

-- D5
-- Test simple name search
SELECT * FROM find_names('radcliffe', 2) LIMIT 10;

-- D6
SELECT * FROM find_coplayers ('nm0705356', 2) LIMIT 10;

-- D7
SELECT * FROM namerating('nm0705356');

-- D8
SELECT * FROM popularactors('Iron man') LIMIT 10;
SELECT * FROM popularcoplayers('Robert Downey Jr.') LIMIT 10;

-- D9
SELECT * FROM get_related_movies('tt0098936') LIMIT 10;

-- D10
SELECT * FROM freqpersonwords('Keanu Reeves') LIMIT 10;

-- D11
SELECT * FROM exactmatch('harry potter') LIMIT 10;

-- D12
SELECT * FROM best_match_query(ARRAY['harry','wizard', 'magic', 'lego']) LIMIT 10;

-- D13
SELECT * FROM word_to_words_query(ARRAY['harry', 'potter', 'wand', 'magic']) LIMIT 10;

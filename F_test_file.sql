-- D1 

-- Register user
SELECT * FROM register_user(
  'Karl',
  2001-11-14,
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
SELECT string_search('Lord', 2);

-- D3
SELECT tconst, primarytitle
FROM structured_string_search('Return of the King', NULL, NULL, 'Ian')

-- D4
SELECT tconst, primarytitle
        FROM structured_string_search('Two Towers', NULL, NULL, NULL, 2)

-- D9
SELECT * FROM get_related_movies('tt0000001');
SELECT * FROM get_related_movies('tt0098936');


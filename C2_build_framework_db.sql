CREATE EXTENSION citext;
CREATE DOMAIN email AS citext
CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

DROP TABLE IF EXISTS person;
CREATE TABLE person (
  p_id SERIAL,
  name VARCHAR(255),
  birthday DATE,
  location VARCHAR(2),
  email email,
  password TEXT,
  last_login TIMESTAMP,
  created_at TIMESTAMP
);


DROP TABLE IF EXISTS search_history;
CREATE TABLE search_history (
  s_id SERIAL,
  p_id bigint REFERENCES person,
  search_string TEXT,
  created_at TIMESTAMP
);

DROP TABLE IF EXISTS bookmark;
CREATE TABLE bookmark (
  p_id bigint REFERENCES person,
  tconst text,
  created_at bigint,
  PRIMARY KEY (user_id, tconst)
);
-- created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT TIMESTAMP 'epoch';

--noqa: banDropTable
DROP TABLE IF EXISTS individual_rating;
CREATE TABLE individual_rating (
  u_id bigint,
  tconst text,
  created_at bigint,
  PRIMARY KEY (u_id, tconst)
);

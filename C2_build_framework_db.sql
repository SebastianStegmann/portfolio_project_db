CREATE EXTENSION citext;
CREATE DOMAIN email AS citext
CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

CREATE TABLE person (
  id SERIAL,
  name VARCHAR(255),
  birthday DATE,
  location VARCHAR(2),
  email email,
  password TEXT,
  last_login TIMESTAMP,
  created_at TIMESTAMP,
  PRIMARY KEY(id)
);


CREATE TABLE search_history (
  id SERIAL,
  person_id bigint REFERENCES person,
  search_string TEXT,
  created_at TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE bookmark (
  person_id bigint REFERENCES person,
  tconst text REFERENCES title,
  created_at bigint,
  PRIMARY KEY (person_id, tconst)
);

CREATE TABLE individual_rating (
  person_id bigint,
  tconst text REFERENCES title,
  created_at bigint,
  PRIMARY KEY (person_id, tconst)
);

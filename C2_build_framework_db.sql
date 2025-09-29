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
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY(id)
);


CREATE TABLE search_history (
  id SERIAL,
  person_id bigint REFERENCES person,
  search_string TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE TABLE bookmark (
  person_id bigint REFERENCES person,
  tconst VARCHAR(10) REFERENCES title,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (person_id, tconst)
);

CREATE TABLE name_bookmark (
    person_id BIGINT REFERENCES person,
    nconst VARCHAR(10) REFERENCES name_basics(nconst),
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (person_id, nconst)
);

CREATE TABLE individual_rating (
  person_id bigint REFERENCES person,
  tconst CHAR(10) REFERENCES title,
  rating SMALLINT CHECK (rating >= 1 AND rating <= 10) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP,
  PRIMARY KEY (person_id, tconst)
);

CREATE INDEX idx_bookmark_person_id ON bookmark(person_id);
CREATE INDEX idx_name_bookmark_person_id ON name_bookmark(person_id);

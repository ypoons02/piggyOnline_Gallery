-- relational database store things in tables

CREATE TABLE arts (
  id SERIAL4 PRIMARY KEY,
  image_url VARCHAR(400),
  name VARCHAR(200)
);

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(400),
  password_digest VARCHAR(400),
  country VARCHAR(400),
  birthDate date,
  gender VARCHAR(30)
);

CREATE TABLE likes (
  id SERIAL4 PRIMARY KEY,
  user_id integer REFERENCES users (id),
  artPiece_id integer REFERENCES arts (id)
);

--ALTER TABLE users ADD COLUMN password_digest VARCHAR(400);

INSERT INTO arts (name, image_url) VALUES ('deep into life','https://static.wixstatic.com/media/a4c579_8696ed9b0c7d40618732aa6389f616b2~mv2.jpg/v1/fill/w_804,h_812,al_c,q_90,usm_0.66_1.00_0.01/a4c579_8696ed9b0c7d40618732aa6389f616b2~mv2.webp');
INSERT INTO arts (name, image_url) VALUES ('city Riparian','https://static.wixstatic.com/media/a4c579_03e9297306044683906216c4e9e3958d.jpg/v1/fill/w_948,h_954,al_c,q_90,usm_0.66_1.00_0.01/a4c579_03e9297306044683906216c4e9e3958d.webp');
INSERT INTO arts (name, image_url) VALUES ('back alley','https://static.wixstatic.com/media/a4c579_c86dc0f37c13e3743b22a9c9b116096c.jpg/v1/fill/w_1071,h_812,al_c,q_90,usm_0.66_1.00_0.01/a4c579_c86dc0f37c13e3743b22a9c9b116096c.webp');
INSERT INTO arts (name, image_url) VALUES ('city-morphosis','https://static.wixstatic.com/media/a4c579_1dedf525f0613c27280980bb5168b1cc.jpg/v1/fill/w_1075,h_808,al_c,q_90,usm_0.66_1.00_0.01/a4c579_1dedf525f0613c27280980bb5168b1cc.webp');

INSERT INTO users (email, country, birthDate, gender) VALUES ('123@art.com','Australia', '10/10/1988','F');
INSERT INTO users (email, country, birthDate, gender) VALUES ('456@art.com','Australia', '10/10/1980','M');
INSERT INTO users (email, country, birthDate, gender) VALUES ('789@art.com','Australia', '10/10/1990','F');

INSERT INTO likes (user_id, artPiece_id) VALUES ('1','1');
INSERT INTO likes (user_id, artPiece_id) VALUES ('1','2');
INSERT INTO likes (user_id, artPiece_id) VALUES ('1','3');
INSERT INTO likes (user_id, artPiece_id) VALUES ('2','2');
INSERT INTO likes (user_id, artPiece_id) VALUES ('3','2');

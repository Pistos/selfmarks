CREATE TABLE users (
    id                 SERIAL         PRIMARY KEY,
    username           VARCHAR( 64 )  NOT NULL,
    encrypted_password VARCHAR( 512 ) NOT NULL,
    time_created       TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tags (
    id           SERIAL          PRIMARY KEY,
    name         VARCHAR( 128 )  NOT NULL
);

CREATE TABLE bookmarks (
    id           SERIAL          PRIMARY KEY,
    uri          VARCHAR( 1024 ) NOT NULL,
    time_created TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users_bookmarks (
    user_id      INTEGER         NOT NULL REFERENCES users( id ),
    bookmark_id  INTEGER         NOT NULL REFERENCES bookmarks( id ),
    title        VARCHAR( 256 )  NOT NULL,
    notes        VARCHAR( 4096 ),
    UNIQUE( user_id, bookmark_id )
);

CREATE TABLE bookmarks_tags (
    bookmark_id  INTEGER         NOT NULL REFERENCES bookmarks( id ),
    tag_id       INTEGER         NOT NULL REFERENCES tags( id ),
    UNIQUE( bookmark_id, tag_id )
);


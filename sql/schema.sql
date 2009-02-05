CREATE TABLE users (
    id                 SERIAL          PRIMARY KEY,
    username           VARCHAR( 64 )   UNIQUE,
    encrypted_password VARCHAR( 512 ),
    time_created       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    openid             VARCHAR( 1024 ) UNIQUE,
    import_total       INTEGER,
    import_done        INTEGER,
    CONSTRAINT identifiable CHECK (
        (
            username IS NOT NULL
            AND encrypted_password IS NOT NULL
        ) OR openid IS NOT NULL
    )
);

CREATE TABLE tags (
    id           SERIAL          PRIMARY KEY,
    name         VARCHAR( 128 )  NOT NULL
);

CREATE TABLE bookmarks (
    id           SERIAL          PRIMARY KEY,
    uri          VARCHAR( 2048 ) NOT NULL,
);

CREATE TABLE users_bookmarks (
    user_id      INTEGER         NOT NULL REFERENCES users( id ),
    bookmark_id  INTEGER         NOT NULL REFERENCES bookmarks( id ),
    time_created TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    title        VARCHAR( 256 )  NOT NULL,
    notes        VARCHAR( 4096 ),
    UNIQUE( user_id, bookmark_id )
);

CREATE TABLE users_bookmarks_tags (
    user_id      INTEGER         NOT NULL REFERENCES users( id ),
    bookmark_id  INTEGER         NOT NULL REFERENCES bookmarks( id ),
    tag_id       INTEGER         NOT NULL REFERENCES tags( id ),
    UNIQUE( user_id, bookmark_id, tag_id )
);


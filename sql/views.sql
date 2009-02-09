CREATE VIEW user_bookmarks AS
SELECT
    b.uri           AS uri,
    ub.bookmark_id  AS bookmark_id,
    ub.user_id      AS user_id,
    ub.time_created AS time_created,
    ub.title        AS title,
    ub.notes        AS notes
FROM
      bookmarks b
    , users_bookmarks ub
WHERE
    b.id = ub.bookmark_id
;

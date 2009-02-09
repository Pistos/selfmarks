CREATE VIEW user_bookmarks AS
SELECT
    b.uri,
    ub.bookmark_id,
    ub.user_id,
    ub.time_created,
    ub.title,
    ub.notes
FROM
      bookmarks b
    , users_bookmarks ub
WHERE
    b.id = ub.bookmark_id
;

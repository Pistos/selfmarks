class Bookmark < DBI::Model( :bookmarks )
  def tag_add( tag, user )
    $dbh.i(
      %{
        INSERT INTO users_bookmarks_tags (
          bookmark_id, tag_id, user_id
        ) VALUES (
          ?, ?, ?
        )
      },
      self.id,
      tag.id,
      user.id
    )
  end

  def title( user )
    $dbh.sc(
      %{
        SELECT title
        FROM users_bookmarks
        WHERE
          user_id = ?
          AND bookmark_id = ?
      },
      user.id,
      self.id
    )
  end
end

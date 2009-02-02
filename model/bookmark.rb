class Bookmark < DBI::Model( :bookmarks )
  def tag_add( tag )
    $dbh.i(
      %{
        INSERT INTO bookmarks_tags (
          bookmark_id, tag_id
        ) VALUES (
          ?, ?
        )
      },
      self.id, tag.id
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

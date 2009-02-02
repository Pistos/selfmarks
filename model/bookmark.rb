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
end

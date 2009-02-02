BookmarkStruct = Struct.new( :id, :uri, :uri_editable, :title, :tags, :notes )

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

  def tags( user )
    $dbh.s(
      %{
        SELECT
          tags.name
        FROM
            tags
          , users_bookmarks_tags ubt
        WHERE
          ubt.user_id = ?
          AND ubt.bookmark_id = ?
          AND tags.id = ubt.tag_id
      },
      user.id,
      self.id
    )
  end

  def notes( user )
    $dbh.sc(
      %{
        SELECT notes
        FROM users_bookmarks
        WHERE
          user_id = ?
          AND bookmark_id = ?
      },
      user.id,
      self.id
    )
  end

  def to_struct( user )
    struct = BookmarkStruct.new
    struct.id = self.id
    struct.uri = uri
    struct.title = title( user )
    struct.tags = tags( user ).join( ' ' )
    struct.notes = notes( user )
    struct
  end
end

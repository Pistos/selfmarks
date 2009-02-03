BookmarkStruct = Struct.new( :id, :uri, :uri_editable, :title, :tags, :notes, :time_created )

class Bookmark < DBI::Model( :bookmarks )
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

  def set_title( user, title )
    $dbh.u(
      %{
        UPDATE users_bookmarks
        SET title = ?
        WHERE
          user_id = ?
          AND bookmark_id = ?
      },
      title,
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

  def tag_ensure( tag, user )
    $dbh.i(
      %{
        INSERT INTO users_bookmarks_tags (
          bookmark_id, tag_id, user_id
        ) SELECT
          ?, ?, ?
        WHERE NOT EXISTS(
          SELECT 1
          FROM users_bookmarks_tags
          WHERE
            bookmark_id = ?
            AND tag_id = ?
            AND user_id = ?
          LIMIT 1
        )
      },
      self.id,
      tag.id,
      user.id,
      self.id,
      tag.id,
      user.id
    )
  end

  def tags_ensure( tags, user )
    tags.each do |tag|
      t = Tag.find_or_create( :name => tag )
      tag_ensure t, user
    end
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

  def set_notes( user, notes )
    $dbh.u(
      %{
        UPDATE users_bookmarks
        SET notes = ?
        WHERE
          user_id = ?
          AND bookmark_id = ?
      },
      notes,
      user.id,
      self.id
    )
  end

  def time_created( user )
    $dbh.sc(
      %{
        SELECT time_created
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
    struct.time_created = time_created( user )
    struct
  end
end

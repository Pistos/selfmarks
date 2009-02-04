class UserBookmark < DBI::Model( :user_bookmarks )
  def eql?( other )
    bookmark_id == other.bookmark_id && user_id == other.user_id
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
      self.bookmark_id
    )
  end

  def to_struct( user )
    struct = BookmarkStruct.new
    struct.id = self.bookmark_id
    struct.uri = uri
    struct.title = title
    struct.tags = tags( user )
    struct.notes = notes
    struct.time_created = time_created
    struct
  end
end
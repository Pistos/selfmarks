class Tag < DBI::Model( :tags )
  def to_s
    name
  end

  def bookmarks_of( user )
    UserBookmark.s(
      %{
        SELECT
          ub.*
        FROM
            user_bookmarks ub
          , users_bookmarks_tags ubt
        WHERE
          ubt.tag_id = ?
          AND ubt.user_id = ?
          AND ub.user_id = ubt.user_id
          AND ub.bookmark_id = ubt.bookmark_id
      },
      self.id,
      user.id
    )
  end
end
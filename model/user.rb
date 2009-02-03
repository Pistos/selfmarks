require 'digest/sha1'

class User < DBI::Model( :users )

  def self.authenticate( credentials )
    return nil  if credentials.nil? || credentials.empty?

    if credentials[ :openid ]
      User[ :openid => credentials[ :openid ] ]
    else
      encrypted_password = Digest::SHA1.hexdigest( credentials[ :password ] )
      User[
        :username => credentials[ :username ],
        :encrypted_password => encrypted_password
      ]
    end
  end

  def bookmark_ensure( bookmark, title, notes, time_created = nil )
    params = [ self.id, bookmark.id, title, notes, ]
    if time_created
      params << time_created
    end
    params += [ self.id, bookmark.id, ]

    $dbh.i(
      %{
        INSERT INTO users_bookmarks (
          user_id, bookmark_id, title, notes#{time_created ? ', time_created' : ''}
        ) SELECT
          ?, ?, ?, ?#{time_created ? ', ?' : ''}
        WHERE NOT EXISTS(
          SELECT 1
          FROM users_bookmarks
          WHERE
            user_id = ?
            AND bookmark_id = ?
          LIMIT 1
        )
      },
      *params
    )
  end

  def to_s
    username || openid
  end

  def bookmarks
    Bookmark.s(
      %{
        SELECT
          b.*
        FROM
            bookmarks b
          , users_bookmarks ub
        WHERE
          ub.user_id = ?
          AND b.id = ub.bookmark_id
        ORDER BY
          ub.time_created DESC
      },
      self.id
    )
  end
end
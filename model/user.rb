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

  def bookmark_ensure( bookmark, title, notes )
    $dbh.i(
      %{
        INSERT INTO users_bookmarks (
          user_id, bookmark_id, title, notes
        ) SELECT
          ?, ?, ?, ?
        WHERE NOT EXISTS(
          SELECT 1
          FROM users_bookmarks
          WHERE
            user_id = ?
            AND bookmark_id = ?
          LIMIT 1
        )
      },
      self.id, bookmark.id, title, notes,
      self.id, bookmark.id
    )
  end

  def to_s
    username || openid
  end
end
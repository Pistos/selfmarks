require 'digest/sha1'

class User < DBI::Model( :users )

  def self.authenticate( credentials )
    return nil  if credentials.nil? || credentials.empty?

    if credentials[ :openid ]
      User[ :openid => credentials[ :openid ] ]
    else
      encrypted_password = Digest::SHA1.hexdigest( credentials[ 'password' ] )
      User[
        :username => credentials[ 'username' ],
        :encrypted_password => encrypted_password
      ]
    end
  end

  def bookmark_add( bookmark, title, notes )
    $dbh.i(
      %{
        INSERT INTO users_bookmarks (
          user_id, bookmark_id, title, notes
        ) VALUES (
          ?, ?, ?, ?
        )
      },
      self.id, bookmark.id, title, notes
    )
  end
end
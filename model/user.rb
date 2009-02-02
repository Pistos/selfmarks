require 'digest/sha1'

class User < DBI::Model( :users )

  def self.authenticate( credentials )
    return nil  if credentials.nil? || credentials.empty?

    encrypted_password = Digest::SHA1.hexdigest( credentials[ 'password' ] )
    User.one_where(
      :username => credentials[ 'username' ],
      :encrypted_password => encrypted_password
    )
  end

  def bookmark_add( bookmark, notes )
    $dbh.i(
      %{
        INSERT INTO users_bookmarks (
          user_id, bookmark_id, notes
        ) VALUES (
          ?, ?, ?
        )
      },
      self.id, bookmark.id, notes
    )
  end
end
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

end
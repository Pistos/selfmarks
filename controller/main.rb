class MainController < Ramaze::Controller
  layout '/page' => [ :index, :login, :openid, :logout ]
  helper :identity, :stack, :user

  # ----------------------------------------------

  def index
    @bookmarklet_source = %{
      window.open( '#{SelfMarks::HOST}/uri/add?uri=' + encodeURIComponent( window.location.href ) + '&title=' + encodeURIComponent( document.title ) );
    }.strip
  end

  def login
    redirect_referrer  if logged_in?

    if request.post?
      user_login(
        :username => request[ 'username' ],
        :password => request[ 'password' ]
      )
      if logged_in?
        answer Rs( :/ )
      end
    end
  end

  def openid
    redirect_referrer  if logged_in?
    oid = session[ :openid ][ :identity ]
    if oid
      user_login( :openid => oid )
      if ! logged_in?
        flash[ :error ] = "There is no account with the OpenID #{oid}."
      else
        flash[ :success ] = "Logged in with OpenID."
        redirect_referrer
      end
    end
  end

  def logout
    user_logout
    redirect Rs( :/ )
  end
end
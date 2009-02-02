class MainController < Ramaze::Controller
  layout '/page' => [ :index, :login, :logout ]
  helper :user

  # ----------------------------------------------

  def index
    @bookmarklet_source = %{
      window.open( '#{SelfMarks::HOST}/uri/add?uri=' + encodeURIComponent( window.location.href ) + '&title=' + encodeURIComponent( document.title ) );
    }.strip
  end

  def login
    if request.post?
      user_login
      if logged_in?
        redirect Rs( :/ )
      end
    end
  end

  def logout
    user_logout
    redirect Rs( :/ )
  end
end
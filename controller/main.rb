class MainController < Ramaze::Controller
  layout '/page' => [ :index, :login, :logout ]
  helper :user

  # ----------------------------------------------

  def index

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
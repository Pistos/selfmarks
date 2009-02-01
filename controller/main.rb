class MainController < Ramaze::Controller
  layout '/page' => [ :index, :login, :logout ]
  helper :user

  # ----------------------------------------------

  def index

  end

  def login
    if request.post?
      user_login
    end
  end

  def logout
    user_logout
  end
end
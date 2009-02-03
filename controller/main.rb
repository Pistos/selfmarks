class MainController < Ramaze::Controller
  layout '/page' => [ :index, :login, :openid, :logout ]
  helper :identity, :paginate, :stack, :user

  trait :paginate => { :limit => 20, }

  # ----------------------------------------------

  def index
    @bookmarklet_source = render_template( './bookmarklet.js' ).gsub( /\s+/, ' ' ).strip

    if logged_in?
      @pager = paginate( user.bookmarks_structs )
      @pager.each do |bm|
        bm.tags = Bookmark[ bm.id ].tags( user ).join( ' ' )
      end
    end
  end

  define_method 'selfmarks.js' do
    @window_html = render_template( 'selfmarks_window.xhtml' ).gsub( /\s+/, ' ' ).strip
    render_template 'selfmarks.js'
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
    oid = session[ :openid ] ? session[ :openid ][ :identity ] : nil
    if oid
      user_login( :openid => oid )
      if ! logged_in?
        u = User.create( :openid => oid )
        if u
          flash[ :success ] = "Created account with OpenID #{oid}."
          user_login( :openid => u.openid )
        else
          flash[ :error ] = "There is no account with the OpenID #{oid}; failed to create one."
        end
      else
        flash[ :success ] = "Logged in with OpenID."
        redirect_referrer
      end
    end
  end

  def logout
    user_logout
    session[ :openid ] = nil
    redirect Rs( :/ )
  end
end
class MainController < Ramaze::Controller
  layout '/page' => [ :export, :import, :index, :login, :openid, :logout ]
  helper :identity, :paginate, :stack, :user

  trait :paginate => { :limit => 20, }

  # ----------------------------------------------

  def index
    @bookmarklet_source = render_template( './bookmarklet.js' ).gsub( /\s+/, ' ' ).strip

    if logged_in?
      bookmarks = user.bookmarks_structs
      @count = bookmarks.size
      @pager = paginate( bookmarks )
      @pager.each do |bm|
        bm.tags = Bookmark[ bm.id ].tags( user )
      end
    end
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

  def import( reset = nil )
    redirect Rs( :/ )  if ! logged_in?

    if user.importing?
      if user.import_done?
        flash[ :success ] = "Successfully imported #{user.import_done} bookmarks."
        reset = true
      end

      if reset
        user.import_total = nil
        user.import_done = nil
      else
        @progress = "%.1f" % ( user.import_progress * 100 )
        return
      end
    end

    return  if ! request.post?

    user.import_done = 0

    tempfile, filename, type =
      request[ 'file' ].values_at( :tempfile, :filename, :type )

    doc = Hpricot( tempfile.read )
    links = doc.search( '//dt' )
    if links.size == 0
      Ramaze::Log.warn "No links found in #{tempfile.inspect}."
      return
    end

    user.import_total = links.size

    Thread.new( links, user.dup ) do |links_,user_|
      Ramaze::Log.info "Starting import for #{user_}"
      begin
        progress = 0
        Timeout::timeout( 60 * 10 ) do
          links_.each do |dt|
            a = dt.at( 'a' )
            dd = dt.next_sibling
            if dd && dd.xpath !~ %r{^/dl/dd}
              dd = nil
            end

            bm = Bookmark.find_or_create( :uri => a[ 'href' ] )

            user_.bookmark_ensure(
              bm,
              a.inner_text,
              dd ? dd.inner_text : nil,
              Time.at( a[ 'add_date' ].to_i )
            )

            bm.tags_ensure( a[ 'tags' ].split( /,/u ), user_ )

            progress += 1
            if progress % 250 == 0
              user_.import_done = progress
            end
          end
        end
        user_.import_done = progress
        Ramaze::Log.info "Finished import for #{user_}; progress: #{user_.import_done}"
      rescue Timeout::Error => e
        Ramaze::Log.warn "Import for #{user_} timed out."
      end
    end

    redirect Rs( :import )
  end

  def export
    redirect_referrer  if ! logged_in?
  end

  def delicious
    redirect_referrer  if ! logged_in?

    @bookmarks_string = ''

    user.bookmarks_structs.each do |bm|
      t = Time.parse( bm.time_created.to_s ).to_i
      tags = bm.tags
      tags = tags ? tags.join( ',' ) : ''
      @bookmarks_string << %|<DT><A HREF="#{bm.uri}" LAST_VISIT="#{t}" ADD_DATE="#{t}" TAGS="#{tags}">#{bm.title}</A>\n|
      if bm.notes && bm.notes.any?
        @bookmarks_string << "<DD>#{bm.notes}\n"
      end
    end

    s = %{<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<!-- This is an automatically generated file.
It will be read and overwritten.
Do Not Edit! -->
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>#{@bookmarks_string}</DL><p>}

    today = Time.now.strftime( "%Y%m%d" )
    response[ 'content-disposition' ] =	"attachment; filename=\"delicious-#{today}.htm\""
    respond s, 200
  end
end
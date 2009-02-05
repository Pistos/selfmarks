require 'set'

class BookmarkController < Ramaze::Controller
  map '/uri'
  helper :stack, :user

  layout '/page' => [ :add, :edit, :search ]

  def add
    if ! logged_in?
      call R( MainController, :login )
    end

    @bookmark = BookmarkStruct.new
    @bookmark.uri_editable = true
    if request.post? or request[ 'jsoncallback' ]
      begin
        add_( request )
        redirect R( MainController, :/ )
      rescue DBI::ProgrammingError => e
        if e.message =~ /violates.*valid_uri/
          flash[ :error ] = "A URI must be provided."
        else
          raise e
        end
      end
    else
      uri = h( request[ 'uri' ] )

      bm = Bookmark[ :uri => uri ]
      if bm && user.bookmark( bm.id )
        redirect Rs( :edit, bm.id )
      end

      @bookmark.uri = uri
      @bookmark.title = h( request[ 'title' ] )
    end
  end

  def add_window_add
    if ! logged_in?
      json = { 'error' => 'Not logged in.' }.to_json
    else
      begin
        add_( request )
        json = { 'success' => 'success' }.to_json
      rescue DBI::ProgrammingError => e
        if e.message =~ /violates.*valid_uri/
          json = { 'error' => 'A URI must be provided.' }.to_json
        else
          raise e
        end
      end
    end

    response[ 'Content-Type' ] = 'application/json'
    "#{request['jsoncallback']}(#{json})"
  end

  def add_( request )
    bm = Bookmark.find_or_create( :uri => h( request[ 'uri' ] ) )
    user.bookmark_ensure(
      bm,
      h( request[ 'title' ] ),
      h( request[ 'notes' ] )
    )
    bm.tags_ensure( requested_tags, user )
  end
  private :add_

  define_method 'add_window.js' do
    if ! logged_in?
      @window_html = render_template( 'add_window_login.xhtml' ).gsub( /\s+/, ' ' ).strip
    else
      @bookmark = BookmarkStruct.new
      @bookmark.uri = h( request[ 'uri' ] )
      @bookmark.uri_editable = true
      @bookmark.title = h( request[ 'title' ] )

      @window_html = render_template( 'add_window.xhtml' ).gsub( /\s+/, ' ' ).strip
    end

    render_template 'add_window.js'
  end

  def edit( bookmark_id )
    if ! logged_in?
      call R( MainController, :login )
    end

    bm = Bookmark[ bookmark_id.to_i ]
    if bm.nil?
      redirect Rs( :add )
    end

    if request.post?
      title = h( request[ 'title' ] )
      notes = h( request[ 'notes' ] )
      user.bookmark_ensure( bm, title, notes )
      bm.set_title( user, title )
      bm.set_notes( user, notes )
      bm.tags_ensure( requested_tags, user )
      flash[ :success ] = "Updated #{bm.uri}."
    end

    @bookmark = bm.to_struct( user )
  end

  def search( *tags )
    if ! logged_in?
      call R( MainController, :login )
    end

    @bookmarks = Set.new
    actual_tags = Set.new
    tags_ = requested_tags
    if tags_.empty?
      tags_ = tags
    end
    tags_.each do |tagname|
      tag = Tag[ :name => tagname ]
      if tag
        actual_tags << tag
        tag_bookmarks = tag.bookmarks_of( user )
        if @bookmarks.empty?
          @bookmarks = tag_bookmarks
        else
          @bookmarks &= tag_bookmarks
        end
      end
    end
    @bookmarks = @bookmarks.sort { |a,b| b.time_created <=> a.time_created }
    @tags = actual_tags.to_a.join( ' ' )
  end

  def delete( bookmark_id )
    if ! logged_in?
      call R( MainController, :login )
    end

    bm_id = bookmark_id.to_i
    bm = user.bookmark( bm_id )
    if bm
      user.delete_bookmark( bm_id )
    end

    flash[ :success ] = "Deleted #{bm.uri}."
    redirect R( MainController, :/ )
  end

  def requested_tags
    tags_in = request[ 'tags' ]
    if tags_in && tags_in.any?
      tags_in.split( /[\s,+]+/ ).collect { |tag| h( tag ) }
    else
      []
    end
  end
  private :requested_tags
end
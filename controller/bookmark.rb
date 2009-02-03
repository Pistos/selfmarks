require 'set'

class BookmarkController < Ramaze::Controller
  map '/uri'
  helper :stack, :user

  layout '/page' => [ :add, :edit, :search ]

  def add
    if ! logged_in?
      call R( MainController, :login )
    end

    uri = h( request[ 'uri' ] )
    if request.post? or request[ 'jsoncallback' ]
      bm = Bookmark.find_or_create( :uri => uri )

      user.bookmark_ensure(
        bm,
        h( request[ 'title' ] ),
        h( request[ 'notes' ] )
      )

      bm.tags_ensure( requested_tags, user )

      redirect R( MainController, :/ )
    else
      bm = Bookmark[ :uri => uri ]
      if bm && user.bookmark( bm.id )
        redirect Rs( :edit, bm.id )
      end

      @bookmark = BookmarkStruct.new
      @bookmark.uri = uri
      @bookmark.uri_editable = true
      @bookmark.title = h( request[ 'title' ] )
    end
  end

  define_method 'add_window.js' do
    @bookmark = BookmarkStruct.new
    @bookmark.uri = h( request[ 'uri' ] )
    @bookmark.uri_editable = true
    @bookmark.title = h( request[ 'title' ] )

    @window_html = render_template( 'add_window.xhtml' ).gsub( /\s+/, ' ' ).strip
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
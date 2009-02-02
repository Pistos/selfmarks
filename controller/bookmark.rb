class BookmarkController < Ramaze::Controller
  map '/uri'
  helper :user

  layout '/page' => [ :add ]

  def add
    if logged_in? && request.post?
      bm = Bookmark.find_or_create( :uri => h( request[ 'uri' ] ) )

      user.bookmark_add(
        bm,
        h( request[ 'title' ] ),
        h( request[ 'notes' ] )
      )

      tags = request[ 'tags' ].split( /[\s,]+/ )
      tags.each do |tag|
        t = Tag.find_or_create( :name => h( tag ) )
        bm.tag_add t
      end
    end

    @uri = h( request[ 'uri' ] )
    @title = h( request[ 'title' ] )
  end
end
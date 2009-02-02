require 'set'

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

      tags.each do |tag|
        t = Tag.find_or_create( :name => h( tag ) )
        bm.tag_add t
      end
    end

    @uri = h( request[ 'uri' ] )
    @title = h( request[ 'title' ] )
  end

  def search
    @bookmarks = Set.new
    @tags = Set.new
    tags.each do |tagname|
      tag = Tag[ :name => tagname ]
      if tag
        @tags << tag
        tag.bookmarks.each do |bm|
          @bookmarks << bm
        end
      end
    end
  end

  def tags
    tags_in = request[ 'tags' ]
    if tags_in && tags_in.any?
      tags_in.split /[\s,+]+/
    else
      []
    end
  end
  private :tags
end
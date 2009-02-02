class BookmarkController < Ramaze::Controller
  map '/uri'
  helper :user

  layout '/page' => [ :add ]

  def add
    @uri = request[ 'uri' ]
  end
end
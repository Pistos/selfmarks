Ramaze::acquire 'model/*'

DBI::Model.many_to_many( User, Bookmark, :users, :bookmarks, :users_bookmarks, :user_id, :bookmark_id )
DBI::Model.one_to_many( Bookmark, Tag, :tags, :bookmark, :bookmark_id )

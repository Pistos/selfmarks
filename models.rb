Ramaze::acquire 'model/*'

DBI::Model.many_to_many( User, Bookmark, :users, :bookmarks, :users_bookmarks, :user_id, :bookmark_id )
DBI::Model.many_to_many( Bookmark, Tag, :bookmarks, :tags, :bookmarks_tags, :bookmark_id, :tag_id )


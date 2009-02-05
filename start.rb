require 'rubygems'
require 'ramaze'
require 'm4dbi'
require 'json'
require 'hpricot'

require './config'
$dbh = DBI.connect( "DBI:#{SelfMarks::DB_TYPE}:#{SelfMarks::DB_DATABASE}", SelfMarks::DB_USERNAME, SelfMarks::DB_PASSWORD )

require './models'
Ramaze::acquire 'controller/*'
Ramaze::acquire 'view/*'

if SelfMarks::USE_MEMCACHED
  Ramaze::Global.cache_alternative[ :sessions ] = Ramaze::MemcachedCache
end

Ramaze.start :port => SelfMarks::PORT, :adapter => :mongrel

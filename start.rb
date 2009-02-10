require 'rubygems'
require 'ramaze'
require 'm4dbi'
require 'json'
require 'hpricot'

require './config'
$dbh = DBI.connect( "DBI:#{Selfmarks::DB_TYPE}:#{Selfmarks::DB_DATABASE}", Selfmarks::DB_USERNAME, Selfmarks::DB_PASSWORD )

require './models'
Ramaze::acquire 'controller/*'
Ramaze::acquire 'view/*'

if Selfmarks::USE_MEMCACHED
  Ramaze::Global.cache_alternative[ :sessions ] = Ramaze::MemcachedCache
end

if Selfmarks::HOPTOAD_API_KEY
  require 'hoptoad-notifier'
  Ramaze::Helper::HoptoadNotifier.trait[ :api_key ] = Selfmarks::HOPTOAD_API_KEY
end

Ramaze.start :port => Selfmarks::PORT, :adapter => :mongrel

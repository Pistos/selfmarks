require 'rubygems'
require 'ramaze'

require 'm4dbi'
$dbh = DBI.connect( "DBI:#{SelfMarks::DB_TYPE}:#{SelfMarks::DB_DATABASE}", SelfMarks::DB_USERNAME, SelfMarks::DB_PASSWORD )

require './config'
require './models'
Ramaze::acquire 'controller/*'
Ramaze::acquire 'view/*'

Ramaze.start :port => SelfMarks::PORT, :adapter => :mongrel

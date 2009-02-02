require 'rubygems'
require 'ramaze'

require 'm4dbi'
$dbh = DBI.connect( 'DBI:Pg:selfmarks', 'selfmarks', 'selfmarks' )

require './config'
require './models'
Ramaze::acquire 'controller/*'
Ramaze::acquire 'view/*'

Ramaze.start :port => SelfMarks::PORT, :adapter => :mongrel

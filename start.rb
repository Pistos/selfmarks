require 'rubygems'
require 'ramaze'

require 'm4dbi'
$dbh = DBI.connect( 'DBI:Pg:selfmarks', 'selfmarks', 'selfmarks' )

require './models'
Ramaze::acquire 'controller/*'
Ramaze::acquire 'view/*'

Ramaze.start :port => 8011, :adapter => :mongrel

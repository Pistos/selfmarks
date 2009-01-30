require 'rubygems'
require 'ramaze'

Ramaze::acquire 'model/*'
Ramaze::acquire 'controller/*'
Ramaze::acquire 'view/*'

Ramaze.start :port => 8011, :adapter => :mongrel

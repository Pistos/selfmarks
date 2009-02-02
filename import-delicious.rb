#!/usr/bin/env ruby

# Input format is delicious.com export format (HTML).

$KCODE = 'UTF8'

username = nil
filename = nil

def print_help_and_exit
  puts "#{$0} <username> <HTML file>"
  exit 1
end

argv = ARGV.dup
while argv.length > 0
  arg = argv.shift
  case arg
  when '--help'
    print_help_and_exit
  else
    if username.nil?
      username = arg
    elsif filename.nil?
      filename = arg
    end
  end
end

if username.nil?
  print_help_and_exit
end
if filename.nil? or ! File.exist?( filename )
  print_help_and_exit
end

require 'hpricot'
require 'm4dbi'
require './config'
$dbh = DBI.connect( "DBI:#{SelfMarks::DB_TYPE}:#{SelfMarks::DB_DATABASE}", SelfMarks::DB_USERNAME, SelfMarks::DB_PASSWORD )
require 'ramaze'
require './models'

user = User[ :username => username ]
if user.nil?
  puts "No such user '#{username}'."
  exit 2
end

puts "Processing #{filename}..."

count = 0
doc = Hpricot( File.read( filename ) )

links = doc.search( '//dt' )
if links.size == 0
  puts "No links found in #{filename}."
  exit 3
end
links.each do |dt|
  a = dt.at( 'a' )
  dd = dt.next_sibling
  if dd && dd.xpath !~ %r{^/dl/dd}
    dd = nil
  end

  bm = Bookmark.find_or_create( :uri => a[ 'href' ] )
  bm.time_created = Time.at( a[ 'add_date' ].to_i )

  user.bookmark_ensure(
    bm,
    a.inner_text,
    dd ? dd.inner_text : nil
  )

  bm.tags_ensure( a[ 'tags' ].split( /,/u ), user )

  count += 1
  if count % 100 == 0
    puts "%.1f%%" % ( ( count.to_f / links.size ) * 100 )
  end
end

puts "Done."

#!/usr/bin/env ruby

# Input format is CSV with these fields:
# title,url,tags,comments,annotations

username = nil
filename = nil

def print_help_and_exit
  puts "#{$0} <username> <CSV file>"
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

require 'fastercsv'
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
total = `wc -l #{filename}`.to_i
FasterCSV.foreach( filename, :headers => true ) do |row|
  bm = Bookmark.find_or_create(
    :uri => row[ 'url' ]
  )

  user.bookmark_ensure(
    bm,
    row[ 'title' ],
    ( row[ 'annotations' ] + "\n" + row[ 'comments' ] ).strip
  )

  bm.tags_ensure( row[ 'tags' ].split( /\s+/ ), user )

  count += 1
  percent = ( count.to_f / total ) * 100
  if percent.to_i % 5 == 0
    puts "%.1f" % percent
  end
end

puts "Done."
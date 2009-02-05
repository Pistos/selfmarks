## SelfMarks Installation

So you think you're geek enough to install and run Selfmarks?  Good.
Here's what you'll need:

  * A server
  * Ruby
  * Gems: ramaze m4dbi dbd-pg json hpricot
  * Apache or nginx or the like
  * A domain or subdomain
  * PostgreSQL
  * memcached (optional)

### Steps

0. Point your domain to your server (DNS, yadda yadda).
0. Get Ruby (and RubyGems) onto your server.
1. gem install ramaze m4dbi dbd-pg json hpricot
2. Install and setup PostgreSQL.
3. Install and setup Apache/nginx/whatever.
4. cp config.rb.sample config.rb
5. ${EDITOR} config.rb
6. createuser the_db_username
7. createdb the_db_name -O the_db_username
8. cat sql/schema.sql | psql -U the_db_username the_db_name
9. ruby start.rb
10. Configure Apache/nginx to proxy your domain to the Ramaze app (http://wiki.ramaze.net/Deployment).
11. Browse to http://yourdomain.com
12. Login with OpenID, or
      INSERT INTO users ( username, encrypted_password )
      VALUES ( 'some_username', 'some_SHA1ed_password' );
13. Go to your old social bookmarking site; export bookmarks in Delicious-compatible format.
14. Import into SelfMarks.
15. Enjoy SelfMarks thoroughly.
16. Permit your most trusted acquaintances to also use your SelfMarks installation.  Or not.

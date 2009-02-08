## Selfmarks Installation

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
1. gem install ramaze m4dbi dbd-pg json hpricot ruby-openid
2. Install and setup PostgreSQL.
3. Install and setup Apache/nginx/whatever.
4. git clone git://github.com/Pistos/selfmarks.git && cd selfmarks
5. cp config.rb.sample config.rb
6. ${EDITOR} config.rb
7. createuser the_db_username
8. createdb the_db_name -O the_db_username
9. cat sql/schema.sql | psql -U the_db_username the_db_name
10. cat sql/views.sql | psql -U the_db_username the_db_name
11. ruby start.rb
12. Configure Apache/nginx to proxy your domain to the Ramaze app (http://wiki.ramaze.net/Deployment).
13. Browse to http://yourdomain.com
14. Login with OpenID, or
      INSERT INTO users ( username, encrypted_password )
      VALUES ( 'some_username', 'some_SHA1ed_password' );
15. Go to your old social bookmarking site; export bookmarks in Delicious-compatible format.
16. Import into Selfmarks.
17. Enjoy Selfmarks thoroughly.
18. Permit your most trusted acquaintances to also use your Selfmarks installation.  Or not.

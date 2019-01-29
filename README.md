HappyNel - About
================

See this [gist](https://gist.github.com/pedroaugusto/98fcc93cc3d80e089816) to get more info about this project.

* Ruby 2.2.1 e Rails 4.2.5

Database
========

* Postgresql 9.3

Use the following environment variables for your database credentials:

	$ export DB_USRNAME='database-role-name'
	$ export DB_PASSWD='database-role-password'

Mailing
=======

This app uses [Mailcatcher](http://mailcatcher.me/) to send emails on development environment. So you must install it on your local machine:

	$ gem install mailcatcher
	$ mailcatcher # Then access your localhost:1080 to see web interface with the received/sent emails

On production environment, unless you set your own configs, you will need [Sendgrid](https://sendgrid.com/) credentials.

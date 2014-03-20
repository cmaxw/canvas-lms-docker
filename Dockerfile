FROM ubuntu

RUN apt-get update
RUN apt-get -y upgrade

# PostgreSQL
RUN apt-get install -y postgresql-9.1
RUN sudo -u postgres createuser canvas --no-createdb --no-superuser --no-createrole --pwprompt
RUN sudo -u postgres createdb canvas_production --owner=canvas
RUN sudo -u postgres createdb canvas_queue_production --owner=canvas

# Git
RUN sudo apt-get install git-core

# Canvas User
RUN adduser canvas

# Copy Canvas
RUN git clone https://github.com/instructure/canvas-lms.git canvas
RUN mkdir -p /var/canvas
RUN chown -R sysadmin /var/canvas
RUN cp -av ./canvas/* /var/canvas

# Ruby
RUN apt-get install python-software-properties
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install ruby1.9.3 zlib1g-dev libxml2-dev libmysqlclient-dev libxslt1-dev imagemagick libpq-dev nodejs libxmlsec1-dev libcurl4-gnutls-dev libxmlsec1 build-essential openjdk-7-jre unzip

# Set Up Canvas
RUN gem install bundler
RUN sudo -u canvas bundle install --path vendor/bundle --without=sqlite

# NodeJS for Assets

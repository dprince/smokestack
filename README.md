# SmokeStack

WebUI to help smoke test the OpenStack

## Description

A web application with a REST based HTTP interface to help smoke test the OpenStack. SmokeStack is focused on integration testing of OpenStack services and currently supports Nova, Keystone, and Glance. SmokeStack is built on:

* Rails 3.1
* Resque: a redis backed job queue
* Job runner templates: The default VPC job runner uses openstack_vpc to spin up groups of servers in the cloud for smoke testing. A job runner for unit tests is included as well. (add more job runners for: PXE, Crowbar, etc.)
* Configuration management to install and configure everything (Chef!)
* Packages to install software (currently supports Ubuntu)

For more information and examples see the wiki: http://wiki.openstack.org/smokestack

## Installation

Requires Ruby, Rubygems, and Ruby on Rails 3.1+.

    gem install rails -v3.1.1

The application was developed with MySQL. The following gems are required:

    mysql
    json
    resque

Unpack the rails app and run the following commands to create the database.

    rake db:create
    rake db:migrate

Start some linux workers to configure Linux machines:

    mkdir tmp/pids
    rake resque:workers QUEUE=vpc COUNT=3

Start the API server:

    rails server

At this point the web application should be running at http://localhost:3000.

## Quickstart on Natty cloudserver

    # install ruby, gems & mysql
    sudo apt-get install -y rubygems ruby-dev mysql-server redis-server \
                         apt-getlibmysql-ruby libmysqlclient-dev

    # install bundler then install gems via bundle
    sudo gem install -y bundle --no-ri --no-rdoc
    sudo ln -s /var/lib/gems/1.8/bin/bundle /usr/local/bin
    bundle install

    # initialize the db
    cp config/database.yml.sample config/database.yml
    bundle exec rake db:create db:migrate

    # setup vpc
    ssh-keygen # don't use passphrase
    # FIXME - add details on creating .chef_vpc_toolkit.conf for running VPC jobs

    # run under screen
    sudo apt-get install screen

    # in tab 1: launch some workers
    bundle exec rake resque:workers QUEUE="*" COUNT=3

    # in tab 2: run rails
    bundle exec rails server

At this point you can view the website at http://localhost:3000 with
username/password of admin/cloud

### Serving via passenger

    sudo gem install passenger

    # install apache and libraries needed to run
    sudo apt-get install -y libcurl4-openssl-dev libssl-dev libapr1-dev \
                            apache2-mpm-prefork apache2-prefork-dev \
                            libaprutil1-dev

    sudo /var/lib/gems/1.8/bin/passenger-install-apache2-module

    # follow instuctions to create a module & site entry in apache:
    # sudo vi /etc/apache2/mods-enabled/passener.load
    # sudo vi /etc/apache2/sites-enabled/000-default

    # create a production db 
    RAILS_ENV=production bundle exec rake db:create db:migrate

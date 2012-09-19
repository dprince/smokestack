# SmokeStack

Smoke test the OpenStack

## Description

A web application with a REST based HTTP interface to help smoke test OpenStack. SmokeStack is focused on integration testing of OpenStack services and currently supports Nova, Keystone, and Glance, and Swift. SmokeStack is built on:

* Rails 3.1
* Resque: a redis backed job queue
* Job runner templates: The default job runner uses firestack to spin up groups of servers. A job runner for unit tests is included as well.
* Configuration management to install and configure everything (Puppet)
* Packages to install software (currently supports Fedora)

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
    rake resque:workers QUEUE=libvirt COUNT=3

Start the API server:

    rails server

At this point the web application should be running at http://localhost:3000.

## Quickstart on Fedora 16

    # install ruby, gems & mysql
    sudo yum install -y rubygems ruby-devel mysql-server redis mysql-devel gcc gcc-c++

    # install bundler then install gems via bundle
    sudo gem install -y bundle --no-ri --no-rdoc

    # cd to SmokeStack app installation directory
    cd /opt/smokestack
    bundle install

    # initialize the db
    cp config/database.yml.sample config/database.yml
    bundle exec rake db:create db:migrate

    # setup kytoon
    ssh-keygen # don't use passphrase
    # FIXME - add details on creating .kytoon.conf for running jobs
    # in tab 1: launch some workers
    bundle exec rake resque:workers QUEUE="libvirt" COUNT=3

    # in tab 2: run rails
    bundle exec rails server

At this point you can view the website at http://localhost:3000 with
username/password of admin/cloud

### Serving via Apache/Passenger

    sudo gem install passenger --no-ri --no-rdoc

    # install apache and libraries needed to run
    sudo yum install -y httpd openssl-devel curl-devel httpd-devel apr-devel

    sudo passenger-install-apache2-module

    # follow instuctions to configure modules & site for Apache...

    # create a production db 
    RAILS_ENV=production bundle exec rake db:create db:migrate

### Unit test workers (used to run unit tests, 1 instance per worker)

    #Install dependencies to run Nova, Glance, Keystone tests in a virtualenv
    sudo yum install -y rubygems ruby-devel mysql-devel git gcc python-devel libxslt-devel swig python-setuptools python-virtualenv zeromq-devel patch gcc-c++ openldap-devel

    # install bundler then install gems via bundle
    sudo gem install -y bundle --no-ri --no-rdoc

    # cd to SmokeStack app installation directory
    cd /opt/smokestack
    bundle install

    bundle exec rake resque:work QUEUE="unit"

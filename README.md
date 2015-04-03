APP-FACEBOOK
=======

##Getting Started##

###System dependencies

* [docker](https://www.docker.com) / [boot2docker (osx)](https://github.com/boot2docker/boot2docker)
* [docker-composer](https://github.com/docker/compose)
* [ngrok](https://ngrok.com/) 

**Facebook applications**

* [https://apps.facebook.com/mereveilleuse-dev](https://apps.facebook.com/mereveilleuse-dev)
* [https://apps.facebook.com/mereveilleuse-stage](https://apps.facebook.com/mereveilleuse-stage)
* [https://apps.facebook.com/mereveilleuse](https://apps.facebook.com/mereveilleuse)



###Development Environment

* Bring up boot2docker
* Start docker containers with docker-compose
* Open ngrok tunnel (for facebook frame)
  
**Non Interactive(no debug)**

    boot2docker start
    docker-compose up dev
    ngrok -subdomain=mereveilleuse `boot2docker ip`:80

**Interactive(for debug)**
    
    boot2docker start
    docker-compose up -d db
    docker-compose run --service-ports dev rails s
    ngrok -subdomain=mereveilleuse `boot2docker ip`:80





**Helpful Commands**

Get docker ip address

    boot2docker ip

Run bundler (rebuild container)
    
    docker-compose dev build

List all terminated containers

    docker ps -a

Remove all terminated containers

    docker rm `docker ps --no-trunc -aq`



###Configuration

**Environment Variables**

System conforms to a [12 factor application](http://12factor.net)

Configuration for application environment is located in ENV variables

    .env.development
    .env.test



###Database creation

**Create Database**

    docker-compose run dev rake db:create

###Database tasks

**Dump database**

    pg_dump -Fc -h $MEREVEILLEUSE_DATABASE_HOST -U $MEREVEILLEUSE_DATABASE_USER app_web_production > app_web_production.pg

**Restore database**
    
    pg_restore -h $MEREVEILLEUSE_DATABASE_HOST -U $MEREVEILLEUSE_DATABASE_USER -d app_web_development app_web_production.pg



###How to run the test suite

You can use the test container to run the tests

    docker-compose run test guard -p -l 2 -g rspec

Or if only acceptance tests

    docker-compose run test guard -g acceptance


###Services (job queues, cache servers, search engines, etc.)




###Deployment instructions

Deployment is done through circleci to staging.mereveilleuse.com via capistrano



## TODO ##

Create gem from http_status_matchers





### DEPRECIATED ###

Could still be potentially interesting

**Create Database user**

    sudo su postgres
    createuser mereveilleuse --interactive #Shall the new role be a superuser? (y/n) y
    psql template1
    ALTER user mereveilleuse password 'mereveilleuse';

**Log into database**

    su - postgres
    psql
    \c app_web_development
    \dt
    



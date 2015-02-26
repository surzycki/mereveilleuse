APP-WEB
=======

##Getting Started##


###System dependencies

###Configuration

**Environment Variables**

System conforms to a [12 factor application](http://12factor.net)

Configuration for application environment is located in ENV variables

    .env.development
    .env.test

###Database creation


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

###Database tasks

**Dump database**

    pg_dump -Fc -h $MEREVEILLEUSE_DATABASE_HOST -U $MEREVEILLEUSE_DATABASE_USER app_web_production > app_web_production.pg


**Restore database**
    
    pg_restore -h $MEREVEILLEUSE_DATABASE_HOST -U $MEREVEILLEUSE_DATABASE_USER -d app_web_development app_web_production.pg


###How to run the test suite

###Services (job queues, cache servers, search engines, etc.)

###Deployment instructions




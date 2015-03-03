# Mereveilleuse development
#
# VERSION               0.0.1

FROM appfacebook_dev
MAINTAINER Stefan Surzycki <stefan.surzycki@gmail.com>

# update
RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y nodejs 

# utilities
RUN apt-get install -y nano

# set environment vars
ENV APP_HOME /var/www/app_facebook
ENV COMPOSE_PROJECT_NAME mereveilleuse
ENV HOSTNAME app_facebook

RUN mkdir -p $APP_HOME

# copy the gemfile and gemfile.lock into the image. 
# this allows for caching to occur
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install 

# send deploy key to container for capistrano tasks
COPY deploy_id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host staging.therapeutes.com\n\tStrictHostKeyChecking no\n\tForwardAgent yes\n" >> /root/.ssh/config
RUN echo "IdentityFile /root/.ssh/id_rsa\n" >> /root/.ssh/config

# hook up source files
ADD . $APP_HOME
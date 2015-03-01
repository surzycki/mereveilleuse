FROM ruby:2.2.0

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

# send deploy key to container for capistrano tasks
COPY deploy_id_rsa /root/.ssh/id_rsa

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

ADD . $APP_HOME
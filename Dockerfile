# Mereveilleuse development
#
# VERSION               0.0.1
FROM surzycki/rails4.2.0-dev
MAINTAINER Stefan Surzycki <stefan.surzycki@gmail.com>

# set environment vars
ENV APP_HOME /var/www
ENV COMPOSE_PROJECT_NAME mereveilleuse
ENV HOSTNAME app_facebook

RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

# update gems
ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install 

# allow access to servers
RUN echo "Host staging.therapeutes.com\n\tStrictHostKeyChecking no\n\tForwardAgent yes\n" >> /root/.ssh/config
RUN echo "Host app002.therapeutes.com\n\tStrictHostKeyChecking no\n\tForwardAgent yes\n" >> /root/.ssh/config
RUN echo "IdentityFile /root/.ssh/id_rsa\n" >> /root/.ssh/config

# hook up source files
ADD . $APP_HOME#
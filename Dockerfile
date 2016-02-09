# Use phusion/passenger-full as base image.
FROM phusion/passenger-ruby22

# Set correct environment variables.
ENV APP_HOME /home/app

# Update
RUN apt-get update -qq
RUN apt-get install -y build-essential

# Install via bundler
WORKDIR $APP_HOME/
ADD Gemfile* $APP_HOME/
RUN bundle install

# Add app files
ADD . $APP_HOME/

# Grant permissions
RUN sudo chown -R app:app $APP_HOME

# Enable nginx and passenger
RUN rm /etc/nginx/sites-enabled/default
ADD /etc/nginx/sites-enabled/ /etc/nginx/sites-enabled/
RUN rm -f /etc/service/nginx/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]
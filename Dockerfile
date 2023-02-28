FROM ruby:2.6.3-buster
RUN apt update -qq \
 && apt install -y libssl1.1 ca-certificates \
 && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg \
 && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update -qq && apt-cache search postgresql | grep postgresql-client \
 && apt-get install -y postgresql-client-12 \
 && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
 && apt install nodejs -y \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log
RUN mkdir /kamp
WORKDIR /kamp
COPY Gemfile /kamp/Gemfile
COPY Gemfile.lock /kamp/Gemfile.lock
RUN bundle install
COPY . /kamp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
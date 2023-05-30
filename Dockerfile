FROM ruby:3.0.4-alpine3.14

# Minimal requirements to run a Rails app
RUN apk add --no-cache --virtual --update build-base \
  linux-headers \
  git \
  postgresql-dev \
  # Rails SQL schema format requires `pg_dump(1)` and `psql(1)`
  postgresql \
  # Install same version of pg_dump
  postgresql-client \
  nodejs \
  yarn \
  # Needed for nodejs / node-gyp
  python2 \
  tzdata \
  shared-mime-info

ENV BUNDLER_VERSION 2.2.33

RUN mkdir /kamp
WORKDIR /kamp
COPY Gemfile /kamp/Gemfile
COPY Gemfile.lock /kamp/Gemfile.lock
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle install
COPY . /kamp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
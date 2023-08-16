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
  shared-mime-info \
  # Needed for nokogiri to run on mac dev
  gcompat \
  # needed for paperclip/image processing
  file \
  php8-pecl-imagick

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 
ENV BUNDLER_VERSION 2.2.33
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV NODE_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT 80

RUN mkdir /kamp
WORKDIR /kamp
COPY Gemfile /kamp/Gemfile
COPY Gemfile.lock /kamp/Gemfile.lock
RUN gem update --system && gem install bundler -v $BUNDLER_VERSION
RUN bundle config frozen true \
 && bundle config jobs 4 \
 && bundle config deployment true \
 && bundle config without 'development test' \
 && bundle install

COPY . /kamp

# Precompile assets
RUN bin/rails assets:clobber && bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
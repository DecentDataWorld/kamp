FROM ruby:3.0.4-alpine3.14 AS builder

# Minimal requirements to run a Rails app
RUN apk add --no-cache --virtual --update build-base \
  linux-headers \
  git \
  postgresql-dev \
  nodejs \
  yarn \
  # Needed for nodejs / node-gyp
  python2 \
  tzdata \
  shared-mime-info \
  # Needed for nokogiri to run on mac dev
  gcompat \
  nano

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 
ENV BUNDLER_VERSION 2.2.33
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV NODE_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT=80
ENV APP_PATH /kamp

WORKDIR $APP_PATH

# Gems installation
COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v $BUNDLER_VERSION

RUN bundle config --global frozen 1 && \
  bundle install && \
  rm -rf /usr/local/bundle/cache/*.gem && \
  find /usr/local/bundle/gems/ -name "*.c" -delete && \
  find /usr/local/bundle/gems/ -name "*.o" -delete

# NPM packages installation
COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile --non-interactive --production

ADD . $APP_PATH

RUN yarn cache clean && \
  rm -rf node_modules tmp/cache vendor/assets test

RUN bin/rails assets:clobber && bundle exec rails assets:precompile


FROM ruby:3.0.4-alpine3.14

RUN mkdir -p /kamp
WORKDIR /kamp

ENV RACK_ENV production
ENV RAILS_ENV production
ENV NODE_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV PORT 80
# Some native extensions required by gems such as pg or mysql2.
COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /usr/bin /usr/bin

# Timezone data is required at runtime
COPY --from=builder /usr/share/zoneinfo/ /usr/share/zoneinfo/

# Ruby gems
COPY --from=builder /usr/local/bundle /usr/local/bundle

COPY --from=builder /kamp /kamp

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

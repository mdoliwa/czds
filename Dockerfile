FROM ruby:3.3.1-alpine

WORKDIR /czds

COPY Gemfile Gemfile.lock czds.gemspec ./
COPY lib/czds/version.rb /czds/lib/czds/version.rb

RUN apk add --no-cache --update build-base git \
    && gem install bundler --version=2.5.10 \
    && bundle install

COPY . .

RUN gem build czds.gemspec && \
    gem install ./czds-*.gem --no-document

WORKDIR /workdir

RUN git config --global --add safe.directory /workdir

ENTRYPOINT ["czds"]

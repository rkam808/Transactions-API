# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.5
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Install dependencies for the mysql2 gem
RUN apt-get update -qq && apt-get install -y build-essential default-libmysqlclient-dev

WORKDIR /rails-api

RUN gem install bundler -v 2.7.2

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Start the Rails server on port 8080 (standard for this test)
EXPOSE 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

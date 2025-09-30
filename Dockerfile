
FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app


COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install
RUN gem install rails
COPY . .


ENV RAILS_ENV=development
ENV PORT=3005

EXPOSE 3005
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p ${PORT}"]


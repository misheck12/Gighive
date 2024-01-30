FROM ruby:3.2.2 AS builder

WORKDIR /app

COPY Gemfile Gemfile.lock
RUN bundle install

COPY . .

FROM ruby:3.2.2

WORKDIR /app

COPY --from=builder /app/vendor/bundle /vendor/bundle
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["puma", "config.ru"]

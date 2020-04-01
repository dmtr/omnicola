FROM ruby:2.7.0-alpine3.11
RUN apk add build-base openssl-dev postgresql-dev
RUN mkdir /app/
WORKDIR /app/

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY Rakefile /app/Rakefile
COPY config.ru /app/config.ru
COPY db /app/db
COPY lib /app/lib
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["sh", "/app/entrypoint.sh"]
CMD [""]

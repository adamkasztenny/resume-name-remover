FROM ruby:2.7.0-alpine3.11

COPY . .

RUN apk add --no-cache build-base git
RUN bundle install --without development test

ENV APP_ENV=production

RUN addgroup -S resume-name-remover && adduser -S resume-name-remover -G resume-name-remover
USER resume-name-remover

EXPOSE 9000
ENTRYPOINT ["rake", "start"]

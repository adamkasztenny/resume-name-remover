FROM ruby:3.0.0-alpine3.13

COPY . .

RUN apk add --no-cache build-base git

RUN bundle config set --local without 'development test'
RUN bundle install

ENV APP_ENV=production

RUN addgroup -S resume-name-remover && adduser -S resume-name-remover -G resume-name-remover
USER resume-name-remover

EXPOSE 9000
ENTRYPOINT ["rake", "start"]

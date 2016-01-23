FROM joakimk/rpi-elixir:1.1.1
MAINTAINER Joakim Kolsjo <joakim.kolsjo<at>gmail.com>

ENV MIX_ENV=prod

USER deploy

EXPOSE 4000

COPY . /app

WORKDIR /app

RUN mix deps.get && mix compile

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["server"]

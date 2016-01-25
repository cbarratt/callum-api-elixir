FROM joakimk/rpi-elixir:1.1.1
MAINTAINER Joakim Kolsjo <joakim.kolsjo<at>gmail.com>

USER deploy

ENV MIX_ENV=prod

EXPOSE 4000

WORKDIR /home/deploy/app

ADD mix* /home/deploy/app/

RUN mix deps.get && mix compile

ADD . /home/deploy/app

ENTRYPOINT ["/home/deploy/app/docker-entrypoint.sh"]
CMD ["server"]

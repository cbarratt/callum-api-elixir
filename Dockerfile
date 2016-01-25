FROM joakimk/rpi-elixir:1.1.1
MAINTAINER Joakim Kolsjo <joakim.kolsjo<at>gmail.com>

USER deploy

ENV MIX_ENV=prod

EXPOSE 4000

RUN mkdir /home/deploy/app

WORKDIR /home/deploy/app

ADD mix* /home/deploy/app/

ADD . /home/deploy/app

RUN mix deps.get

ENTRYPOINT ["/home/deploy/app/docker-entrypoint.sh"]
CMD ["server"]

FROM joakimk/rpi-elixir:1.1.1
MAINTAINER Joakim Kolsjo <joakim.kolsjo<at>gmail.com>

ENV MIX_ENV=prod

USER deploy

EXPOSE 4000

WORKDIR /home/app

RUN cd /home/app && mix deps.get && mix compile

ADD . /home/app

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["server"]

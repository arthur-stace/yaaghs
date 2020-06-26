FROM backlog:latest

WORKDIR /data

COPY Makefile $WORKDIR

CMD make -e PROJECT=$PROJECT


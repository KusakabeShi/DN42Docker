# syntax = docker/dockerfile:experimental
FROM --platform=$TARGETPLATFORM debian as builder

COPY   runit-docker.c /tmp
COPY   install_builder_1.sh    /tmp/
RUN    bash /tmp/install_builder_1.sh
COPY   install_builder_2.sh    /tmp/
RUN    bash /tmp/install_builder_2.sh
COPY   install_builder_3.sh    /tmp/
RUN    bash /tmp/install_builder_3.sh

FROM --platform=$TARGETPLATFORM debian as main
VOLUME ["/home"]

COPY   install_main_1.sh    /tmp/
RUN    bash /tmp/install_main_1.sh
COPY   install_main_2.sh    /tmp/
RUN    bash /tmp/install_main_2.sh
COPY   install_main_3.sh    /tmp/
RUN    bash /tmp/install_main_3.sh
COPY   install_build_1.sh /tmp/
RUN    --mount=type=bind,from=builder,source=/,target=/buildroot /tmp/install_build_1.sh

RUN --mount=type=bind,source=move2docker,target=/tmp/move2docker rsync -a --no-owner --no-group --chown=root:root --keep-dirlinks /tmp/move2docker/* /;

ENV EDITOR vim \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

EXPOSE 23000-23200
ENTRYPOINT ["/sbin/runit-docker"]


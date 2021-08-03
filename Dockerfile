FROM 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_base:latest

ARG ARCH="amd64"
ARG OS="linux"
ARG VER="1.4.1"
ARG PKG="pushgateway"
ARG SRC="${PKG}-${VER}.${OS}-${ARCH}"
ARG UID="nobody"
ARG GID="nobody"

LABEL ORG="Armedia LLC"
LABEL MAINTAINER="Armedia LLC"
LABEL APP="Prometheus Push Gateway"
LABEL VERSION="${VER}"
LABEL IMAGE_SOURCE="https://github.com/ArkCase/ark_prometheus_pushgate"

# Modify to fetch from S3 ...
RUN curl \
        -L "https://github.com/prometheus/${PKG}/releases/download/v${VER}/${SRC}.tar.gz" \
        -o - | tar -xzvf -
RUN mkdir -pv \
        "/app/data"
RUN mv -vif \
        "${SRC}/LICENSE" \
        "/LICENSE"
RUN mv -vif \
        "${SRC}/NOTICE" \
        "/NOTICE"
RUN mv -vif \
        "${SRC}/pushgateway" \
        "/bin/pushgateway"
RUN chown -R "${UID}:${GID}" \
        "/app/data"
RUN chmod -R ug+rwX,o-rwx \
        "/app/data"
RUN rm -rvf \
        "${SRC}"

USER        ${UID}
EXPOSE      9091
VOLUME      [ "/app/data" ]
WORKDIR     /app/data
ENTRYPOINT  [ "/bin/pushgateway" ]

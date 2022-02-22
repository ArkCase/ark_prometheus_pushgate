FROM 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_base:latest

#
# Basic Parameters
#
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="1.4.2"
ARG PKG="pushgateway"
ARG SRC="${PKG}-${VER}.${OS}-${ARCH}"
ARG UID="prometheus"

#
# Some important labels
#
LABEL ORG="Armedia LLC"
LABEL MAINTAINER="Armedia Devops Team <devops@armedia.com>"
LABEL APP="Prometheus Push Gateway"
LABEL VERSION="${VER}"
LABEL IMAGE_SOURCE="https://github.com/ArkCase/ark_prometheus_pushgate"

#
# Create the required user
#
RUN useradd --system --user-group "${UID}"

#
# Download the primary artifact
#
RUN curl \
        -L "https://github.com/prometheus/${PKG}/releases/download/v${VER}/${SRC}.tar.gz" \
        -o - | tar -xzvf -

#
# Create the necessary directories
#
RUN mkdir -pv "/app/data"

#
# Deploy the extracted files
#
RUN mv -vif "${SRC}/LICENSE"     "/LICENSE"
RUN mv -vif "${SRC}/NOTICE"      "/NOTICE"
RUN mv -vif "${SRC}/pushgateway" "/usr/bin/pushgateway"

#
# Set ownership + permissions
#
RUN chown -R "${UID}:" "/app/data"
RUN chmod -R ug+rwX,o-rwx    "/app/data"

#
# Cleanup
#
RUN rm -rvf "${SRC}"

#
# Final parameters
#
USER        ${UID}
EXPOSE      9091
VOLUME      [ "/app/data" ]
WORKDIR     /app/data
ENTRYPOINT  [ "/usr/bin/pushgateway" ]

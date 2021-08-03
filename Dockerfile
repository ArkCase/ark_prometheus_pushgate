ARG ARCH="amd64"
ARG OS="linux"
ARG VER="1.4.1"
ARG PKG="pushgateway"
ARG SRC="${PKG}-${VER}.${OS}-${ARCH}"

FROM 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_base:latest

LABEL	ORG="Armedia LLC" \
		APP="Prometheus Push Gateway" \
		VERSION="${VER}" \
		IMAGE_SOURCE="https://github.com/ArkCase/ark_prometheus_pushgate" \
		MAINTAINER="Armedia LLC"

# Modify to fetch from S3 ...
RUN curl \
		-L "https://github.com/prometheus/${PKG}/releases/download/v${VER}/${SRC}.tar.gz" \
		-o "package.tar.gz" && \
	tar -xzvf "package.tar.gz" && \
	mkdir -pv "/app/data" && \
	mv -vif "${SRC}/LICENSE"					"/LICENSE" && \
	mv -vif "${SRC}/NOTICE"						"/NOTICE" && \
	mv -vif "${SRC}/pushgateway"				"/bin/pushgateway" && \
	chown -R nobody:nobody	"/app/data" && \
	chmod -R ug+rwX,o-rwx	"/app/data" && \
	rm -rvf "${SRC}" "package.tar.gz"

USER		nobody
EXPOSE		9091
VOLUME		[ "/app/data" ]
WORKDIR		/app/data
ENTRYPOINT	[ "/bin/pushgateway" ]

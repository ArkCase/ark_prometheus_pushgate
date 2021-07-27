ARG ARCH="amd64"
ARG OS="linux"
FROM 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_base:latest
LABEL maintainer="Armedia, LLC"

ARG ARCH="amd64"
ARG OS="linux"
ARG VER="1.4.1"
ARG PKG="pushgateway"
ARG SRC="${PKG}-${VER}.${OS}-${ARCH}"

RUN curl \
		-L "https://github.com/prometheus/${PKG}/releases/download/v${VER}/${SRC}.tar.gz" \
		-o package.tar.gz && \
	tar -xzvf "package.tar.gz" && \
	mkdir -p "/pushgateway" && \
	mv -vif "${SRC}/LICENSE"                     "/LICENSE" && \
	mv -vif "${SRC}/NOTICE"                      "/NOTICE" && \
	mv -vif "${SRC}/pushgateway"                 "/bin/pushgateway" && \
	chown nobody:nobody "/bin/pushgateway" "/pushgateway" && \
	rm -rvf "${SRC}" package.tar.gz

USER nobody
EXPOSE 9091
WORKDIR /pushgateway

ENTRYPOINT [ "/bin/pushgateway" ]

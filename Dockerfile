# DinD enabled Alpine image
FROM docker:20.10.23-dind-alpine3.17

# To be passed to proxychains
# ARG ARGS="-f /etc/proxychains.conf sh"

# Appended to proxychains.conf via envsubst
ARG TYPE="http"
ARG ADDR="127.0.0.1"
ARG PORT="7777"
ARG USER=""
ARG PASS=""

COPY . /build
WORKDIR /build

# Musl does not include cdefs.h as it is a legacy header
RUN apk update
RUN apk add --update-cache alpine-sdk musl-dev build-base bsd-compat-headers gettext bind-tools curl

# Ignore legacy header
# TODO: a more permanent solution
RUN CFLAGS=-Wno-error ./configure
RUN make
RUN make install

# NOTE: uses proxychains4, not proxychains
RUN rm -rf /etc/proxychains.conf
CMD envsubst < conf/template.conf > /etc/proxychains.conf && proxychains4 -f /etc/proxychains.conf sh

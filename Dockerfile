FROM docker:23.0.0-rc.1-cli-alpine3.17

# To be passed to proxychains
ARG ARGS="-f conf/proxychains.conf"

# Appended to proxychains.conf via envsubst
ARG PROXIES=""

COPY . /build
WORKDIR /build

# Musl does not include cdefs.h as it is a legacy header
RUN apk update
RUN apk add --update-cache alpine-sdk musl-dev build-base bsd-compat-headers gettext bind-tools

# Ignore legacy header
# TODO: a more permanent solution
RUN CFLAGS=-Wno-error ./configure
RUN make
RUN make install

# NOTE: uses proxychains4, not proxychains
RUN rm -rf /etc/proxychains.conf
CMD envsubst < conf/template.conf > /etc/proxychains.conf && proxychains4 $ARGS

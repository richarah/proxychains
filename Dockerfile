FROM alpine:3.16

RUN apk update
RUN apk add --update-cache build-base alpine-sdk

FROM alpine:3.18

RUN apk add --no-cache bash

WORKDIR /abc
COPY shared/bootnode /abc/bootnode

RUN chmod +x /abc/bootnode

RUN /abc/bootnode -genkey bootnode.key